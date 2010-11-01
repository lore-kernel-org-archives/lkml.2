Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0KATp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 15:45:58 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41206 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0KATpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 15:45:55 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jmorris@namei.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v1.1 2/5] IMA: define readcount functions
Date: Mon,  1 Nov 2010 15:45:36 -0400
Message-Id: <1288640739-3246-3-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define iget/iput_readcount() functions to be called from the VFS layer.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 include/linux/fs.h                     |   16 ++++++++++++++++
 security/integrity/ima/Makefile        |    2 +-
 security/integrity/ima/ima_readcount.c |   25 +++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletions(-)
 create mode 100644 security/integrity/ima/ima_readcount.c

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 18d677c..7f5939d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2178,6 +2178,22 @@ static inline void allow_write_access(struct file *file)
 	if (file)
 		atomic_inc(&file->f_path.dentry->d_inode->i_writecount);
 }
+#ifdef CONFIG_IMA
+extern void iput_readcount(struct inode *inode);
+static inline void iget_readcount(struct inode *inode)
+{
+	atomic_inc(&inode->i_readcount);
+}
+#else
+static inline void iput_readcount(struct inode *inode)
+{
+	return;
+}
+static inline void iget_readcount(struct inode *inode)
+{
+	return;
+}
+#endif
 extern int do_pipe_flags(int *, int);
 extern struct file *create_read_pipe(struct file *f, int flags);
 extern struct file *create_write_pipe(int flags);
diff --git a/security/integrity/ima/Makefile b/security/integrity/ima/Makefile
index 787c4cb..131eb1f 100644
--- a/security/integrity/ima/Makefile
+++ b/security/integrity/ima/Makefile
@@ -6,4 +6,4 @@
 obj-$(CONFIG_IMA) += ima.o
 
 ima-y := ima_fs.o ima_queue.o ima_init.o ima_main.o ima_crypto.o ima_api.o \
-	 ima_policy.o ima_iint.o ima_audit.o
+	 ima_policy.o ima_iint.o ima_audit.o ima_readcount.o
diff --git a/security/integrity/ima/ima_readcount.c b/security/integrity/ima/ima_readcount.c
new file mode 100644
index 0000000..d139e2a9
--- /dev/null
+++ b/security/integrity/ima/ima_readcount.c
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2010 IBM Corporation
+ *
+ * Authors:
+ * Mimi Zohar <zohar@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+
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
-- 
1.7.2.2

