Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494Ab0EMKB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:01:27 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45684 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453Ab0EMKBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wMdWNDnI+lmMJf5A7PYUAnTBImTKOOQPacJ12gZ5qFzjYG7k5MQECv+JAITzPp9TdE
         TcWqpGIREA7hkFudSjzlkLK5TGpeYTBYS1IRjBsSXSZejpQfDVv7sQ1kyD4KzVoZ8LJV
         KwwMHYxG1bXR4quUlEQwefAp3WkWXg9FvlQDg=
From: Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 4/9] file: use kvmalloc, kvfree and kvfree_inatomic
Date: Thu, 13 May 2010 18:01:13 +0800
Message-Id: <1273744873-10243-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kvmalloc, kvfree and kvfree_inatomic

use kvmalloc, kvfree and kvfree_inatomic

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/file.c |  109 +++++++++-----------------------------------------------------
 1 file changed, 16 insertions(+), 93 deletions(-)
diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..54e70b6 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -12,7 +12,6 @@
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
 #include <linux/bitops.h>
@@ -31,61 +30,16 @@ int sysctl_nr_open __read_mostly = 1024*1024;
 int sysctl_nr_open_min = BITS_PER_LONG;
 int sysctl_nr_open_max = 1024 * 1024; /* raised later */
 
-/*
- * We use this list to defer free fdtables that have vmalloced
- * sets/arrays. By keeping a per-cpu list, we avoid having to embed
- * the work_struct in fdtable itself which avoids a 64 byte (i386) increase in
- * this per-task structure.
- */
-static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
-
-static inline void * alloc_fdmem(unsigned int size)
-{
-	if (size <= PAGE_SIZE)
-		return kmalloc(size, GFP_KERNEL);
-	else
-		return vmalloc(size);
-}
-
-static inline void free_fdarr(struct fdtable *fdt)
+static void __free_fdtable(struct fdtable *fdt)
 {
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
-		kfree(fdt->fd);
-	else
-		vfree(fdt->fd);
-}
-
-static inline void free_fdset(struct fdtable *fdt)
-{
-	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
-		kfree(fdt->open_fds);
-	else
-		vfree(fdt->open_fds);
-}
-
-static void free_fdtable_work(struct work_struct *work)
-{
-	struct fdtable_defer *f =
-		container_of(work, struct fdtable_defer, wq);
-	struct fdtable *fdt;
-
-	spin_lock_bh(&f->lock);
-	fdt = f->next;
-	f->next = NULL;
-	spin_unlock_bh(&f->lock);
-	while(fdt) {
-		struct fdtable *next = fdt->next;
-		vfree(fdt->fd);
-		free_fdset(fdt);
-		kfree(fdt);
-		fdt = next;
-	}
+	kvfree(fdt->fd);
+	kvfree(fdt->open_fds);
+	kfree(fdt);
 }
 
 void free_fdtable_rcu(struct rcu_head *rcu)
 {
 	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
-	struct fdtable_defer *fddef;
 
 	BUG_ON(!fdt);
 
@@ -98,20 +52,9 @@ void free_fdtable_rcu(struct rcu_head *rcu)
 				container_of(fdt, struct files_struct, fdtab));
 		return;
 	}
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *))) {
-		kfree(fdt->fd);
-		kfree(fdt->open_fds);
-		kfree(fdt);
-	} else {
-		fddef = &get_cpu_var(fdtable_defer_list);
-		spin_lock(&fddef->lock);
-		fdt->next = fddef->next;
-		fddef->next = fdt;
-		/* vmallocs are handled from the workqueue context */
-		schedule_work(&fddef->wq);
-		spin_unlock(&fddef->lock);
-		put_cpu_var(fdtable_defer_list);
-	}
+	kvfree_inatomic(fdt->fd);
+	kvfree_inatomic(fdt->open_fds);
+	kfree(fdt);
 }
 
 /*
@@ -167,12 +110,12 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	if (!fdt)
 		goto out;
 	fdt->max_fds = nr;
-	data = alloc_fdmem(nr * sizeof(struct file *));
+	data = kvmalloc(nr * sizeof(struct file *));
 	if (!data)
 		goto out_fdt;
 	fdt->fd = (struct file **)data;
-	data = alloc_fdmem(max_t(unsigned int,
-				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
+	data = kvmalloc(max_t(unsigned int,
+			2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = (fd_set *)data;
@@ -184,7 +127,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	return fdt;
 
 out_arr:
-	free_fdarr(fdt);
+	kvfree(fdt->fd);
 out_fdt:
 	kfree(fdt);
 out:
@@ -214,9 +157,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
 	 * caller and alloc_fdtable().  Cheaper to catch it here...
 	 */
 	if (unlikely(new_fdt->max_fds <= nr)) {
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+		__free_fdtable(new_fdt);
 		return -EMFILE;
 	}
 	/*
@@ -232,9 +173,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
 			free_fdtable(cur_fdt);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
-		free_fdarr(new_fdt);
-		free_fdset(new_fdt);
-		kfree(new_fdt);
+		__free_fdtable(new_fdt);
 	}
 	return 1;
 }
@@ -325,11 +264,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	while (unlikely(open_files > new_fdt->max_fds)) {
 		spin_unlock(&oldf->file_lock);
 
-		if (new_fdt != &newf->fdtab) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
-		}
+		if (new_fdt != &newf->fdtab)
+			__free_fdtable(new_fdt);
 
 		new_fdt = alloc_fdtable(open_files - 1);
 		if (!new_fdt) {
@@ -339,9 +275,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 
 		/* beyond sysctl_nr_open; nothing to do */
 		if (unlikely(new_fdt->max_fds < open_files)) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
+			__free_fdtable(new_fdt);
 			*errorp = -EMFILE;
 			goto out_release;
 		}
@@ -405,19 +339,8 @@ out:
 	return NULL;
 }
 
-static void __devinit fdtable_defer_list_init(int cpu)
-{
-	struct fdtable_defer *fddef = &per_cpu(fdtable_defer_list, cpu);
-	spin_lock_init(&fddef->lock);
-	INIT_WORK(&fddef->wq, free_fdtable_work);
-	fddef->next = NULL;
-}
-
 void __init files_defer_init(void)
 {
-	int i;
-	for_each_possible_cpu(i)
-		fdtable_defer_list_init(i);
 	sysctl_nr_open_max = min((size_t)INT_MAX, ~(size_t)0/sizeof(void *)) &
 			     -BITS_PER_LONG;
 }
