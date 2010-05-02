Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0ECDZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 23:25:34 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49024 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0ECDZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 23:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nO+XralP9Iap3XYvJ4efficjmurMC/cbxxoMhQKmsYg27un3MGIsNgQ4Kp7i52ZEXZ
         kY8oazFL+EOnFUmKZhOrh8GZ2H0MZTnk2T/k2dYDIBDLV0AO+MuH+723CEC49M0eQ1Uw
         UxP/AV3m6IYUR8EdF1UZCebJVTdQWn0mIvT4Y=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2] fs: use kmalloc() to allocate fdmem if possible
Date: Mon,  3 May 2010 03:02:00 +0800
Message-Id: <1272826920-8899-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kmalloc() to allocate fdmem if possible.

vmalloc() is used as a fallback solution for fdmem allocation. A new helper
function __free_fdtable() is introduced to reduce the lines of code.

A potential bug, vfree() a memory allocated by kmalloc(), is fixed.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/file.c |   55 ++++++++++++++++++++++---------------------------------
 1 file changed, 22 insertions(+), 33 deletions(-)
diff --git a/fs/file.c b/fs/file.c
index 34bb7f7..9af31ae 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -39,28 +39,27 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static inline void * alloc_fdmem(unsigned int size)
+static inline void *alloc_fdmem(unsigned int size)
 {
-	if (size <= PAGE_SIZE)
-		return kmalloc(size, GFP_KERNEL);
-	else
-		return vmalloc(size);
+	void *data;
+
+	data = kmalloc(size, GFP_KERNEL);
+	if (data != NULL)
+		return data;
+
+	return vmalloc(size);
 }
 
-static inline void free_fdarr(struct fdtable *fdt)
+static inline void free_fdmem(void *ptr)
 {
-	if (fdt->max_fds <= (PAGE_SIZE / sizeof(struct file *)))
-		kfree(fdt->fd);
-	else
-		vfree(fdt->fd);
+	is_vmalloc_addr(ptr) ? vfree(ptr) : kfree(ptr);
 }
 
-static inline void free_fdset(struct fdtable *fdt)
+static inline void __free_fdtable(struct fdtable *fdt)
 {
-	if (fdt->max_fds <= (PAGE_SIZE * BITS_PER_BYTE / 2))
-		kfree(fdt->open_fds);
-	else
-		vfree(fdt->open_fds);
+	free_fdmem(fdt->fd);
+	free_fdmem(fdt->open_fds);
+	kfree(fdt);
 }
 
 static void free_fdtable_work(struct work_struct *work)
@@ -75,9 +74,8 @@ static void free_fdtable_work(struct work_struct *work)
 	spin_unlock_bh(&f->lock);
 	while(fdt) {
 		struct fdtable *next = fdt->next;
-		vfree(fdt->fd);
-		free_fdset(fdt);
-		kfree(fdt);
+
+		__free_fdtable(fdt);
 		fdt = next;
 	}
 }
@@ -184,7 +182,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	return fdt;
 
 out_arr:
-	free_fdarr(fdt);
+	free_fdmem(fdt->fd);
 out_fdt:
 	kfree(fdt);
 out:
@@ -214,9 +212,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
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
@@ -232,9 +228,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
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
@@ -325,11 +319,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
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
@@ -339,9 +330,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 
 		/* beyond sysctl_nr_open; nothing to do */
 		if (unlikely(new_fdt->max_fds < open_files)) {
-			free_fdarr(new_fdt);
-			free_fdset(new_fdt);
-			kfree(new_fdt);
+			__free_fdtable(new_fdt);
 			*errorp = -EMFILE;
 			goto out_release;
 		}
