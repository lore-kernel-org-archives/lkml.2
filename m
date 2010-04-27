Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0D0O0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:26:02 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0D0OZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:25:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7/7] smbfs: push down BKL into ioctl function
Date: Tue, 27 Apr 2010 16:24:25 +0200
Message-Id: <1272378265-10909-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX18XZ43btrbSHIaCfItcgv6ayvm0XnlLYXtYg7O
 fHNdgI9aSgI7w6JhsVG7PrurfLoN6XB18Kr3O+FbT3r4OK4fj/
 IUrrklpx3nFsNe0qJxzWg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting from ->ioctl to ->unlocked_ioctl with explicit
lock_kernel lets us kill the ioctl operation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/smbfs/dir.c   |    2 +-
 fs/smbfs/file.c  |    2 +-
 fs/smbfs/ioctl.c |    8 +++++---
 fs/smbfs/proto.h |    2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

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
index 910215b..0721531 100644
--- a/fs/smbfs/ioctl.c
+++ b/fs/smbfs/ioctl.c
@@ -13,6 +13,7 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/highuid.h>
+#include <linux/smp_lock.h>
 #include <linux/net.h>
 
 #include <linux/smb_fs.h>
@@ -22,14 +23,14 @@
 
 #include "proto.h"
 
-int
-smb_ioctl(struct inode *inode, struct file *filp,
-	  unsigned int cmd, unsigned long arg)
+long
+smb_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct smb_sb_info *server = server_from_inode(filp->f_path.dentry->d_inode);
 	struct smb_conn_opt opt;
 	int result = -EINVAL;
 
+	lock_kernel();
 	switch (cmd) {
 		uid16_t uid16;
 		uid_t uid32;
@@ -62,6 +63,7 @@ smb_ioctl(struct inode *inode, struct file *filp,
 	default:
 		break;
 	}
+	unlock_kernel();
 
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
1.6.3.3

