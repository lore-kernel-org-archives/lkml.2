Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab0HRNY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:24:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32858 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0HRNYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=Z92j2YIJpjwMRIMubBJhWNGBASWVmRu8yh+Jf4JhvT0kRbDxSxWOzDtkQCdELg59cl
         kFfNKZn4ays8Npov7bZUKuNmRTwjldVD/tgopPUI1VH5RGeef/VxVLBRLpoqLIHs+5pV
         w3RGzB4AOjgoXTPJmzfwCP41ii8r/Y4dw8kEQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] init: mark __user address space on string literals
Date: Wed, 18 Aug 2010 22:24:49 +0900
Message-Id: <1282137889-2284-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling syscall service routines in kernel, some of arguments should be
user pointers but were missing __user markup on string literals. Add it.

Impact: remove sparse warnings

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/do_mounts.c    |    4 ++--
 init/do_mounts_md.c |    2 +-
 init/do_mounts_rd.c |    4 ++--
 init/initramfs.c    |    5 +++--
 init/noinitramfs.c  |    6 +++---
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 8eabff6..91fc443 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -235,7 +235,7 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 	if (err)
 		return err;
 
-	sys_chdir("/root");
+	sys_chdir((const char __user __force *)"/root");
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
@@ -432,5 +432,5 @@ void __init prepare_namespace(void)
 out:
 	devtmpfs_mount("dev");
 	do_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	sys_chroot((const char __user __force *)".");
 }
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 69aebbf..32c4799 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -283,7 +283,7 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open("/dev/md0", 0, 0);
+	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
 		sys_close(fd);
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index bf3ef66..6e1ee69 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -168,7 +168,7 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open("/dev/ram", O_RDWR, 0);
+	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
@@ -267,7 +267,7 @@ noclose_input:
 	sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink("/dev/ram");
+	sys_unlink((const char __user __force *) "/dev/ram");
 	return res;
 }
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 4b9c202..d9c6e78 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -528,7 +528,7 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open("/", O_RDONLY, 0);
+	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
@@ -590,7 +590,8 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
+		fd = sys_open((const char __user __force *) "/initrd.image",
+			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
 			sys_write(fd, (char *)initrd_start,
 					initrd_end - initrd_start);
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index f4c1a3a..267739d 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -29,17 +29,17 @@ static int __init default_rootfs(void)
 {
 	int err;
 
-	err = sys_mkdir("/dev", 0755);
+	err = sys_mkdir((const char __user __force *) "/dev", 0755);
 	if (err < 0)
 		goto out;
 
-	err = sys_mknod((const char __user *) "/dev/console",
+	err = sys_mknod((const char __user __force *) "/dev/console",
 			S_IFCHR | S_IRUSR | S_IWUSR,
 			new_encode_dev(MKDEV(5, 1)));
 	if (err < 0)
 		goto out;
 
-	err = sys_mkdir("/root", 0700);
+	err = sys_mkdir((const char __user __force *) "/root", 0700);
 	if (err < 0)
 		goto out;
 
-- 
1.7.0.4

