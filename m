Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1C1HIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab1C1HIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:08:23 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
        Mike Frysinger <vapier@gentoo.org>,
        David Howells <dhowells@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/2] proc: Use IS_ERR_OR_NULL() helper
Date: Mon, 28 Mar 2011 15:07:31 +0800
Message-Id: <1301296053-23589-1-git-send-email-amwang@redhat.com>
In-Reply-To: <4D90206E.1090307@redhat.com>
References: <4D90206E.1090307@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use IS_ERR_OR_NULL() helper

Signed-off-by: Amerigo Wang <amwang@redhat.com>
---
 fs/proc/task_mmu.c   |   10 ++++++----
 fs/proc/task_nommu.c |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2e7addf..3c06570 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -124,7 +124,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_for_maps(priv->task);
-	if (!mm || IS_ERR(mm))
+	if (IS_ERR_OR_NULL(mm))
 		return mm;
 	down_read(&mm->mmap_sem);
 
@@ -182,7 +182,7 @@ static void m_stop(struct seq_file *m, void *v)
 	struct proc_maps_private *priv = m->private;
 	struct vm_area_struct *vma = v;
 
-	if (!IS_ERR(vma))
+	if (!IS_ERR_OR_NULL(vma))
 		vma_stop(priv, vma);
 	if (priv->task)
 		put_task_struct(priv->task);
@@ -768,9 +768,11 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 		goto out;
 
 	mm = mm_for_maps(task);
-	ret = PTR_ERR(mm);
-	if (!mm || IS_ERR(mm))
+	if (IS_ERR_OR_NULL(mm)) {
+		if (mm)
+			ret = PTR_ERR(mm);
 		goto out_task;
+	}
 
 	ret = -EINVAL;
 	/* file position must be aligned */
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 980de54..35e8b2a 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -202,7 +202,7 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 		return ERR_PTR(-ESRCH);
 
 	mm = mm_for_maps(priv->task);
-	if (!mm || IS_ERR(mm)) {
+	if (IS_ERR_OR_NULL(mm)) {
 		put_task_struct(priv->task);
 		priv->task = NULL;
 		return mm;
-- 
1.7.4

