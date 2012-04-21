Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2DUBFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:05:47 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:45703 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2DUBFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:05:46 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1334970344!3733282!2
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] init: disable sparse checking of the mount.o source files
Date: Fri, 20 Apr 2012 18:05:33 -0700
User-Agent: KMail/1.9.9
CC: <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201204201805.33654.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The init/mount.o source files produce a number of sparse warnings
of the type:
  
warning: incorrect type in argument 1 (different address spaces)
   expected char [noderef] <asn:1>*dev_name
   got char *name 

This is due to the syscalls expecting some of the arguments to be
user pointers but they are being passed as kernel pointers. This is
harmless but adds a lot of noise to a sparse build.

To limit the noise just disable the sparse checking in the relevant
source files, but still display a warning so that the user knows this
has been done.

Since the sparse checking has been disabled we can also remove
the __user __force casts that are scattered thru the source.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 0e93f92..8dfa0de 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/ctype.h>
@@ -330,7 +340,7 @@ static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 	if (err)
 		return err;
 
-	sys_chdir((const char __user __force *)"/root");
+	sys_chdir("/root");
 	s = current->fs->pwd.dentry->d_sb;
 	ROOT_DEV = s->s_dev;
 	printk(KERN_INFO
@@ -556,5 +566,5 @@ void __init prepare_namespace(void)
 out:
 	devtmpfs_mount("dev");
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot((const char __user __force *)".");
+	sys_chroot(".");
 }
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 9047330..135959a2 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/unistd.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 32c4799..8cb6db5 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/delay.h>
 #include <linux/raid/md_u.h>
 #include <linux/raid/md_p.h>
@@ -283,7 +293,7 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
+	fd = sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
 		sys_close(fd);
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 6212586..6be2879 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -1,3 +1,12 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
@@ -181,7 +190,7 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
+	out_fd = sys_open("/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
@@ -280,7 +289,7 @@ noclose_input:
 	sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink((const char __user __force *) "/dev/ram");
+	sys_unlink("/dev/ram");
 	return res;
 }
 
diff --git a/init/initramfs.c b/init/initramfs.c
index 8216c30..84c6bf1 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -1,3 +1,13 @@
+/*
+ * Many of the syscalls used in this file expect some of the arguments
+ * to be __user pointers not __kernel pointers.  To limit the sparse
+ * noise, turn off sparse checking for this file.
+ */
+#ifdef __CHECKER__
+#undef __CHECKER__
+#warning "Sparse checking disabled for this file"
+#endif
+
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -74,7 +84,7 @@ static void __init free_hash(void)
 	}
 }
 
-static long __init do_utime(char __user *filename, time_t mtime)
+static long __init do_utime(char *filename, time_t mtime)
 {
 	struct timespec t[2];
 
@@ -529,7 +539,7 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
+	fd = sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
@@ -589,7 +599,7 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open((const char __user __force *) "/initrd.image",
+		fd = sys_open("/initrd.image",
 			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
 			sys_write(fd, (char *)initrd_start,
