Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934354Ab0EURBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:01:36 -0400
Received: from kroah.org ([198.145.64.141]:39087 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934220Ab0EUQyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:54:16 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/38] devtmpfs: support !CONFIG_TMPFS
Date: Fri, 21 May 2010 09:53:38 -0700
Message-Id: <1274460848-11377-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165106.GA11216@kroah.com>
References: <20100521165106.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <jacmet@sunsite.dk>

Make devtmpfs available on (embedded) configurations without SHMEM/TMPFS,
using ramfs instead.

Saves ~15KB.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Kconfig    |    7 +++++--
 drivers/base/devtmpfs.c |    5 +++++
 fs/ramfs/inode.c        |    2 +-
 include/linux/ramfs.h   |    2 ++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index fd52c48..ef38aff 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -18,9 +18,9 @@ config UEVENT_HELPER_PATH
 
 config DEVTMPFS
 	bool "Maintain a devtmpfs filesystem to mount at /dev"
-	depends on HOTPLUG && SHMEM && TMPFS
+	depends on HOTPLUG
 	help
-	  This creates a tmpfs filesystem instance early at bootup.
+	  This creates a tmpfs/ramfs filesystem instance early at bootup.
 	  In this filesystem, the kernel driver core maintains device
 	  nodes with their default names and permissions for all
 	  registered devices with an assigned major/minor number.
@@ -33,6 +33,9 @@ config DEVTMPFS
 	  functional /dev without any further help. It also allows simple
 	  rescue systems, and reliably handles dynamic major/minor numbers.
 
+	  Notice: if CONFIG_TMPFS isn't enabled, the simpler ramfs
+	  file system will be used instead.
+
 config DEVTMPFS_MOUNT
 	bool "Automount devtmpfs at /dev, after the kernel mounted the rootfs"
 	depends on DEVTMPFS
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 057cf11..af06001 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -20,6 +20,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/shmem_fs.h>
+#include <linux/ramfs.h>
 #include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/init_task.h>
@@ -45,7 +46,11 @@ __setup("devtmpfs.mount=", mount_param);
 static int dev_get_sb(struct file_system_type *fs_type, int flags,
 		      const char *dev_name, void *data, struct vfsmount *mnt)
 {
+#ifdef CONFIG_TMPFS
 	return get_sb_single(fs_type, flags, data, shmem_fill_super, mnt);
+#else
+	return get_sb_single(fs_type, flags, data, ramfs_fill_super, mnt);
+#endif
 }
 
 static struct file_system_type dev_fs_type = {
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index c948534..f47cd21 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -214,7 +214,7 @@ static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
 	return 0;
 }
 
-static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
+int ramfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct ramfs_fs_info *fsi;
 	struct inode *inode = NULL;
diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index 4e768dd..8600508 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -20,4 +20,6 @@ extern const struct file_operations ramfs_file_operations;
 extern const struct vm_operations_struct generic_file_vm_ops;
 extern int __init init_rootfs(void);
 
+int ramfs_fill_super(struct super_block *sb, void *data, int silent);
+
 #endif
-- 
1.7.0.3

