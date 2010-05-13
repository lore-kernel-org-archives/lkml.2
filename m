Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab0EMJ6b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:58:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44926 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab0EMJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Q0LqUgBhtOQU3Svk/z4ljGDYmm7xPoGztmLN8qUa0nWxEd+QHMx11Uvl2Tbq9j8kVy
         p48nxpfk7JMAECgfcONQrsXDRplb4f+vmZM2JlubUGjXrkkC8YiWiA4Dhny+0P2NjN2u
         /tS/1vRHdgWdyje9iQvMgI3n5YKCbbrnzKF+g=
From: Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 3/9] cgroup: use kvmalloc, kvrealloc and kvfree
Date: Thu, 13 May 2010 17:58:16 +0800
Message-Id: <1273744696-10119-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kvmalloc, kvrealloc and kvfree

use kvmalloc, kvrealloc and kvfree

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 kernel/cgroup.c |   47 +++++------------------------------------------
 1 file changed, 5 insertions(+), 42 deletions(-)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6d870f2..4a1dab7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -55,7 +55,6 @@
 #include <linux/smp_lock.h>
 #include <linux/pid_namespace.h>
 #include <linux/idr.h>
-#include <linux/vmalloc.h> /* TODO: replace with more sophisticated array */
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 
@@ -2553,42 +2552,6 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  */
 
 /*
- * The following two functions "fix" the issue where there are more pids
- * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
- * TODO: replace with a kernel-wide solution to this problem
- */
-#define PIDLIST_TOO_LARGE(c) ((c) * sizeof(pid_t) > (PAGE_SIZE * 2))
-static void *pidlist_allocate(int count)
-{
-	if (PIDLIST_TOO_LARGE(count))
-		return vmalloc(count * sizeof(pid_t));
-	else
-		return kmalloc(count * sizeof(pid_t), GFP_KERNEL);
-}
-static void pidlist_free(void *p)
-{
-	if (is_vmalloc_addr(p))
-		vfree(p);
-	else
-		kfree(p);
-}
-static void *pidlist_resize(void *p, int newcount)
-{
-	void *newlist;
-	/* note: if new alloc fails, old p will still be valid either way */
-	if (is_vmalloc_addr(p)) {
-		newlist = vmalloc(newcount * sizeof(pid_t));
-		if (!newlist)
-			return NULL;
-		memcpy(newlist, p, newcount * sizeof(pid_t));
-		vfree(p);
-	} else {
-		newlist = krealloc(p, newcount * sizeof(pid_t), GFP_KERNEL);
-	}
-	return newlist;
-}
-
-/*
  * pidlist_uniq - given a kmalloc()ed list, strip out all duplicate entries
  * If the new stripped list is sufficiently smaller and there's enough memory
  * to allocate a new buffer, will let go of the unneeded memory. Returns the
@@ -2627,7 +2590,7 @@ after:
 	 * we'll just stay with what we've got.
 	 */
 	if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
-		newlist = pidlist_resize(list, dest);
+		newlist = kvrealloc(list, dest * sizeof(pid_t));
 		if (newlist)
 			*p = newlist;
 	}
@@ -2705,7 +2668,7 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 	 * show up until sometime later on.
 	 */
 	length = cgroup_task_count(cgrp);
-	array = pidlist_allocate(length);
+	array = kvmalloc(length * sizeof(pid_t));
 	if (!array)
 		return -ENOMEM;
 	/* now, populate the array */
@@ -2729,11 +2692,11 @@ static int pidlist_array_load(struct cgroup *cgrp, enum cgroup_filetype type,
 		length = pidlist_uniq(&array, length);
 	l = cgroup_pidlist_find(cgrp, type);
 	if (!l) {
-		pidlist_free(array);
+		kvfree(array);
 		return -ENOMEM;
 	}
 	/* store array, freeing old if necessary - lock already held */
-	pidlist_free(l->list);
+	kvfree(l->list);
 	l->list = array;
 	l->length = length;
 	l->use_count++;
@@ -2894,7 +2857,7 @@ static void cgroup_release_pid_array(struct cgroup_pidlist *l)
 		/* we're the last user if refcount is 0; remove and free */
 		list_del(&l->links);
 		mutex_unlock(&l->owner->pidlist_mutex);
-		pidlist_free(l->list);
+		kvfree(l->list);
 		put_pid_ns(l->key.ns);
 		up_write(&l->mutex);
 		kfree(l);
