Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab0KATqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:46:09 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39002 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0KATqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:46:07 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.1 5/5] IMA: making i_readcount a first class inode citizen
Date: Mon,  1 Nov 2010 15:45:39 -0400
Message-Id: <1288640739-3246-6-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, remove the ifdef's around i_readcount, making it a full
inode citizen so that other subsystems, such as leases, could use it.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 fs/file_table.c                        |   11 +++++++++++
 include/linux/fs.h                     |   13 -------------
 security/integrity/ima/Makefile        |    2 +-
 security/integrity/ima/ima_readcount.c |   25 -------------------------
 4 files changed, 12 insertions(+), 39 deletions(-)
 delete mode 100644 security/integrity/ima/ima_readcount.c

diff --git a/fs/file_table.c b/fs/file_table.c
index e575e78..a658adb 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -92,6 +92,17 @@ int proc_nr_files(ctl_table *table, int write,
 }
 #endif
 
+void iput_readcount(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	if (unlikely((atomic_read(&inode->i_readcount) == 0)))
+		printk(KERN_INFO "i_readcount: imbalance ino %ld\n",
+		       inode->i_ino);
+	else
+		atomic_dec(&inode->i_readcount);
+	spin_unlock(&inode->i_lock);
+}
+
 /* Find an unused file structure and return a pointer to it.
  * Returns NULL, if there are no more free file structures or
  * we run out of memory.
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7f5939d..9e296b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -786,10 +786,8 @@ struct inode {
 
 	unsigned int		i_flags;
 
-#ifdef CONFIG_IMA
 	/* protected by i_lock */
 	atomic_t		i_readcount; /* struct files open RO */
-#endif
 	atomic_t		i_writecount;
 #ifdef CONFIG_SECURITY
 	void			*i_security;
@@ -2178,22 +2176,11 @@ static inline void allow_write_access(struct file *file)
 	if (file)
 		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 }
-#ifdef CONFIG_IMA
 extern void iput_readcount(struct inode *inode);
 static inline void iget_readcount(struct inode *inode)
 {
 	atomic_inc(&inode->i_readcount);
 }
-#else
-static inline void iput_readcount(struct inode *inode)
-{
-	return;
-}
-static inline void iget_readcount(struct inode *inode)
-{
-	return;
-}
-#endif
 extern int do_pipe_flags(int *, int);
 extern struct file *create_read_pipe(struct file *f, int flags);
 extern struct file *create_write_pipe(int flags);
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 131eb1f..787c4cb 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
-	 ima_policy.o ima_iint.o ima_audit.o ima_readcount.o
+	 ima_policy.o ima_iint.o ima_audit.o
diff --git a/security/integrity/ima/ima_readcount.c b/security/integrity/ima/ima_readcount.c
deleted file mode 100644
index d139e2a9..0000000
--- a/security/integrity/ima/ima_readcount.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * Copyright (C) 2010 IBM Corporation
- *
- * Authors:
- * Mimi Zohar <zohar@us.ibm.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation, version 2 of the
- * License.
- */
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/fs.h>
-
-void iput_readcount(struct inode *inode)
-{
-	spin_lock(&inode->i_lock);
-	if (unlikely((atomic_read(&inode->i_readcount) == 0)))
-		printk(KERN_INFO "i_readcount: imbalance ino %ld\n",
-		       inode->i_ino);
-	else
-		atomic_dec(&inode->i_readcount);
-	spin_unlock(&inode->i_lock);
-}
-- 
1.7.2.2

