Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab0CPUzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:55:36 -0400
Received: from mail-bw0-f211.google.com ([209.85.218.211]:65282 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab0CPUzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=NGYMYMkLIfiJA95X0Kv0TqbqV6k4OU8QmorhkJNSJ+Jp6fiqcDOr2Y2GqqshHNunU0
         iZOxHH2W3QH3RABhVG+jXYAY02ggTuUqgvKxaUtdgiArkpJK6l5gxvpCx08bPK2+d239
         P2MtpahNR34mtOSq3l7S+XC+zJGUZYPai0yCE=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: gregkh@suse.de, kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH-V2] devtmpfs: support !CONFIG_TMPFS
Date: Tue, 16 Mar 2010 21:55:21 +0100
Message-Id: <1268772921-31908-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100316201720.GA11832@kroah.com>
References: <20100316201720.GA11832@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make devtmpfs available on (embedded) configurations without SHMEM/TMPFS,
using ramfs instead.

Saves ~15KB.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
---
Changes since v1:
 - Added Kay's ack
 - Added comment about it using ramfs if CONFIG_TMPFS isn't enabled as
   requested by Greg

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
index dac478c..6927262 100644
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
@@ -44,7 +45,11 @@ __setup("devtmpfs.mount=", mount_param);
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
index a6090aa..1a5259a 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -213,7 +213,7 @@ static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
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
1.7.0

