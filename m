Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934756Ab0EENQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:16:49 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:61180 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808Ab0EENQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:16:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AwcajZywmpTjYLfqAGXLQjxNA2r2hQ0joAMHBi2Y9c70jKhksYdHbdV2CIxJm+W07Z
         jeOWqLVZd6Wjgldyq9Uh+leW3d9/vKutbgt09dHMv/LrnmY6iNbP0cloUN/OBLxgJPfN
         4owNXDRp7CcTNUveoTgDyORCyCkIfnq9siNes=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Kacur <jkacur@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/6] smbfs: BKL ioctl pushdown
Date: Wed,  5 May 2010 15:15:38 +0200
Message-Id: <1273065339-21669-6-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert smb_ioctl to an unlocked ioctl and push down the bkl into it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 fs/smbfs/dir.c   |    2 +-
 fs/smbfs/file.c  |    2 +-
 fs/smbfs/ioctl.c |   10 +++++++---
 fs/smbfs/proto.h |    2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smbfs/dir.c b/fs/smbfs/dir.c
index 3e4803b..6c97842 100644
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -39,7 +39,7 @@ const struct file_operations smb_dir_operations =
 {
 	.read		= generic_read_dir,
 	.readdir	= smb_readdir,
-	.ioctl		= smb_ioctl,
+	.unlocked_ioctl	= smb_ioctl,
 	.open		= smb_dir_open,
 };
 
diff --git a/fs/smbfs/file.c b/fs/smbfs/file.c
index dbf6548..84ecf0e 100644
--- a/fs/smbfs/file.c
+++ b/fs/smbfs/file.c
@@ -437,7 +437,7 @@ const struct file_operations smb_file_operations =
 	.aio_read	= smb_file_aio_read,
 	.write		= do_sync_write,
 	.aio_write	= smb_file_aio_write,
-	.ioctl		= smb_ioctl,
+	.unlocked_ioctl	= smb_ioctl,
 	.mmap		= smb_file_mmap,
 	.open		= smb_file_open,
 	.release	= smb_file_release,
diff --git a/fs/smbfs/ioctl.c b/fs/smbfs/ioctl.c
index dbae1f8..dfc3a94 100644
--- a/fs/smbfs/ioctl.c
+++ b/fs/smbfs/ioctl.c
@@ -19,17 +19,19 @@
 #include <linux/smb_mount.h>
 
 #include <asm/uaccess.h>
+#include <linux/smp_lock.h>
 
 #include "proto.h"
 
-int
-smb_ioctl(struct inode *inode, struct file *filp,
-	  unsigned int cmd, unsigned long arg)
+long smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
+	struct inode *inode = filp->f_dentry->d_inode;
 	struct smb_sb_info *server = server_from_inode(inode);
 	struct smb_conn_opt opt;
 	int result = -EINVAL;
 
+	lock_kernel();
+
 	switch (cmd) {
 		uid16_t uid16;
 		uid_t uid32;
@@ -63,5 +65,7 @@ smb_ioctl(struct inode *inode, struct file *filp,
 		break;
 	}
 
+	unlock_kernel();
+
 	return result;
 }
diff --git a/fs/smbfs/proto.h b/fs/smbfs/proto.h
index 03f456c..05939a6 100644
--- a/fs/smbfs/proto.h
+++ b/fs/smbfs/proto.h
@@ -67,7 +67,7 @@ extern const struct address_space_operations smb_file_aops;
 extern const struct file_operations smb_file_operations;
 extern const struct inode_operations smb_file_inode_operations;
 /* ioctl.c */
-extern int smb_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);
+extern long smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 /* smbiod.c */
 extern void smbiod_wake_up(void);
 extern int smbiod_register_server(struct smb_sb_info *server);
-- 
1.6.6.1

