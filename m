Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2DQAeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:34:05 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37719 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2DQAeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:34:00 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1334622819!3267059!12
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/2] init: use private syscall wrappers for non-user space pointers
Date: Mon, 16 Apr 2012 17:33:41 -0700
User-Agent: KMail/1.9.9
CC: <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204161733.41424.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the private syscall wrappers to handle casting kernel pointers
to user pointers.

Note, do_utime has also been modified to take a kernel pointer
instead of a user pointer because the data being passed is actually
a kernel pointer. The final cast to a user pointer is done in the
call to do_utimes. This function is not wrapped because it is not
normal syscall service.

This also removes a couple of casts to __user pointers in favor of
using the wrappers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 0e93f92..d9661d3 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -326,11 +326,11 @@ static void __init get_fs_names(char *page)
 static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 {
 	struct super_block *s;
-	int err = sys_mount(name, "/root", fs, flags, data);
+	int err = __sys_mount(name, "/root", fs, flags, data);
 	if (err)
 		return err;
 
-	sys_chdir((const char __user __force *)"/root");
+	__sys_chdir("/root");
 	s = current->fs->pwd.dentry->d_sb;
 	ROOT_DEV = s->s_dev;
 	printk(KERN_INFO
@@ -450,18 +450,18 @@ void __init change_floppy(char *fmt, ...)
 	va_start(args, fmt);
 	vsprintf(buf, fmt, args);
 	va_end(args);
-	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
+	fd = __sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, FDEJECT, 0);
 		sys_close(fd);
 	}
 	printk(KERN_NOTICE "VFS: Insert %s and press ENTER\n", buf);
-	fd = sys_open("/dev/console", O_RDWR, 0);
+	fd = __sys_open("/dev/console", O_RDWR, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, TCGETS, (long)&termios);
 		termios.c_lflag &= ~ICANON;
 		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_read(fd, &c, 1);
+		__sys_read(fd, &c, 1);
 		termios.c_lflag |= ICANON;
 		sys_ioctl(fd, TCSETSF, (long)&termios);
 		sys_close(fd);
@@ -555,6 +555,6 @@ void __init prepare_namespace(void)
 	mount_root();
 out:
 	devtmpfs_mount("dev");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot((const char __user __force *)".");
+	__sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	__sys_chroot(".");
 }
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 9047330..04d9fde 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -43,13 +43,13 @@ static void __init handle_initrd(void)
 	create_dev("/dev/root.old", Root_RAM0);
 	/* mount initrd on rootfs' /root */
 	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
-	sys_mkdir("/old", 0700);
-	root_fd = sys_open("/", 0, 0);
-	old_fd = sys_open("/old", 0, 0);
+	__sys_mkdir("/old", 0700);
+	root_fd = __sys_open("/", 0, 0);
+	old_fd = __sys_open("/old", 0, 0);
 	/* move initrd over / and chdir/chroot in initrd root */
-	sys_chdir("/root");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	__sys_chdir("/root");
+	__sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	__sys_chroot(".");
 
 	/*
 	 * In case that a resume from disk is carried out by linuxrc or one of
@@ -66,15 +66,15 @@ static void __init handle_initrd(void)
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
-	sys_mount("/", ".", NULL, MS_MOVE, NULL);
+	__sys_mount("/", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
 	sys_fchdir(root_fd);
-	sys_chroot(".");
+	__sys_chroot(".");
 	sys_close(old_fd);
 	sys_close(root_fd);
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
-		sys_chdir("/old");
+		__sys_chdir("/old");
 		return;
 	}
 
@@ -82,17 +82,17 @@ static void __init handle_initrd(void)
 	mount_root();
 
 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = __sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
-		int fd = sys_open("/dev/root.old", O_RDWR, 0);
+		int fd = __sys_open("/dev/root.old", O_RDWR, 0);
 		if (error == -ENOENT)
 			printk("/initrd does not exist. Ignored.\n");
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		sys_umount("/old", MNT_DETACH);
+		__sys_umount("/old", MNT_DETACH);
 		printk(KERN_NOTICE "Trying to free ramdisk memory ... ");
 		if (fd < 0) {
 			error = fd;
@@ -115,11 +115,11 @@ int __init initrd_load(void)
 		 * mounted in the normal path.
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
-			sys_unlink("/initrd.image");
+			__sys_unlink("/initrd.image");
 			handle_initrd();
 			return 1;
 		}
 	}
-	sys_unlink("/initrd.image");
+	__sys_unlink("/initrd.image");
 	return 0;
 }
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 32c4799..69b3ddd 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -170,7 +170,7 @@ static void __init md_setup_drive(void)
 			partitioned ? "_d" : "", minor,
 			md_setup_args[ent].device_names);
 
-		fd = sys_open(name, 0, 0);
+		fd = __sys_open(name, 0, 0);
 		if (fd < 0) {
 			printk(KERN_ERR "md: open failed - cannot start "
 					"array %s\n", name);
@@ -233,7 +233,7 @@ static void __init md_setup_drive(void)
 			 * array without it
 			 */
 			sys_close(fd);
-			fd = sys_open(name, 0, 0);
+			fd = __sys_open(name, 0, 0);
 			sys_ioctl(fd, BLKRRPART, 0);
 		}
 		sys_close(fd);
@@ -283,7 +283,7 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
+	fd = __sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
 		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
 		sys_close(fd);
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 6212586..4dfa4d2 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -76,7 +76,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	 * Read block 0 to test for compressed kernel
 	 */
 	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	__sys_read(fd, buf, size);
 
 	*decompressor = decompress_method(buf, size, &compress_name);
 	if (compress_name) {
@@ -122,7 +122,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	 * Read 512 bytes further to check if cramfs is padded
 	 */
 	sys_lseek(fd, start_block * BLOCK_SIZE + 0x200, 0);
-	sys_read(fd, buf, size);
+	__sys_read(fd, buf, size);
 
 	if (cramfsb->magic == CRAMFS_MAGIC) {
 		printk(KERN_NOTICE
@@ -136,7 +136,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
 	sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	__sys_read(fd, buf, size);
 
 	/* Try minix */
 	if (minixsb->s_magic == MINIX_SUPER_MAGIC ||
@@ -181,11 +181,11 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
+	out_fd = __sys_open("/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
-	in_fd = sys_open(from, O_RDONLY, 0);
+	in_fd = __sys_open(from, O_RDONLY, 0);
 	if (in_fd < 0)
 		goto noclose_input;
 
@@ -254,15 +254,15 @@ int __init rd_load_image(char *from)
 				goto noclose_input;
 			}
 			change_floppy("disk #%d", disk);
-			in_fd = sys_open(from, O_RDONLY, 0);
+			in_fd = __sys_open(from, O_RDONLY, 0);
 			if (in_fd < 0)  {
 				printk("Error opening disk.\n");
 				goto noclose_input;
 			}
 			printk("Loading disk #%d... ", disk);
 		}
-		sys_read(in_fd, buf, BLOCK_SIZE);
-		sys_write(out_fd, buf, BLOCK_SIZE);
+		__sys_read(in_fd, buf, BLOCK_SIZE);
+		__sys_write(out_fd, buf, BLOCK_SIZE);
 #if !defined(CONFIG_S390)
 		if (!(i % 16)) {
 			printk("%c\b", rotator[rotate & 0x3]);
@@ -280,7 +280,7 @@ noclose_input:
 	sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink((const char __user __force *) "/dev/ram");
+	__sys_unlink("/dev/ram");
 	return res;
 }
 
@@ -299,7 +299,7 @@ static int crd_infd, crd_outfd;
 
 static int __init compr_fill(void *buf, unsigned int len)
 {
-	int r = sys_read(crd_infd, buf, len);
+	int r = __sys_read(crd_infd, buf, len);
 	if (r < 0)
 		printk(KERN_ERR "RAMDISK: error while reading compressed data");
 	else if (r == 0)
@@ -309,7 +309,7 @@ static int __init compr_fill(void *buf, unsigned int len)
 
 static int __init compr_flush(void *window, unsigned int outcnt)
 {
-	int written = sys_write(crd_outfd, window, outcnt);
+	int written = __sys_write(crd_outfd, window, outcnt);
 	if (written != outcnt) {
 		if (decompress_error == 0)
 			printk(KERN_ERR
diff --git a/init/initramfs.c b/init/initramfs.c
index 8216c30..ec59b4e 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -9,6 +9,8 @@
 #include <linux/syscalls.h>
 #include <linux/utime.h>
 
+#include "do_mounts.h"
+
 static __initdata char *message;
 static void __init error(char *x)
 {
@@ -74,7 +76,7 @@ static void __init free_hash(void)
 	}
 }
 
-static long __init do_utime(char __user *filename, time_t mtime)
+static long __init do_utime(char *filename, time_t mtime)
 {
 	struct timespec t[2];
 
@@ -83,7 +85,8 @@ static long __init do_utime(char __user *filename, time_t mtime)
 	t[1].tv_sec = mtime;
 	t[1].tv_nsec = 0;
 
-	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
+	return do_utimes(AT_FDCWD, (char __user __force *)filename, t,
+			AT_SYMLINK_NOFOLLOW);
 }
 
 static __initdata LIST_HEAD(dir_list);
@@ -271,7 +274,7 @@ static int __init maybe_link(void)
 	if (nlink >= 2) {
 		char *old = find_link(major, minor, ino, mode, collected);
 		if (old)
-			return (sys_link(old, collected) < 0) ? -1 : 1;
+			return (__sys_link(old, collected) < 0) ? -1 : 1;
 	}
 	return 0;
 }
@@ -280,11 +283,11 @@ static void __init clean_path(char *path, umode_t mode)
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!__sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
-			sys_rmdir(path);
+			__sys_rmdir(path);
 		else
-			sys_unlink(path);
+			__sys_unlink(path);
 	}
 }
 
@@ -305,7 +308,7 @@ static int __init do_name(void)
 			int openflags = O_WRONLY|O_CREAT;
 			if (ml != 1)
 				openflags |= O_TRUNC;
-			wfd = sys_open(collected, openflags, mode);
+			wfd = __sys_open(collected, openflags, mode);
 
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
@@ -317,16 +320,16 @@ static int __init do_name(void)
 			}
 		}
 	} else if (S_ISDIR(mode)) {
-		sys_mkdir(collected, mode);
-		sys_chown(collected, uid, gid);
-		sys_chmod(collected, mode);
+		__sys_mkdir(collected, mode);
+		__sys_chown(collected, uid, gid);
+		__sys_chmod(collected, mode);
 		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
-			sys_mknod(collected, mode, rdev);
-			sys_chown(collected, uid, gid);
-			sys_chmod(collected, mode);
+			__sys_mknod(collected, mode, rdev);
+			__sys_chown(collected, uid, gid);
+			__sys_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
 	}
@@ -336,7 +339,7 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
+		__sys_write(wfd, victim, body_len);
 		sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
@@ -344,7 +347,7 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		__sys_write(wfd, victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -355,8 +358,8 @@ static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	sys_symlink(collected + N_ALIGN(name_len), collected);
-	sys_lchown(collected, uid, gid);
+	__sys_symlink(collected + N_ALIGN(name_len), collected);
+	__sys_lchown(collected, uid, gid);
 	do_utime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
@@ -529,7 +532,7 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
+	fd = __sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
@@ -541,19 +544,19 @@ static void __init clean_rootfs(void)
 	}
 
 	dirp = buf;
-	num = sys_getdents64(fd, dirp, BUF_SIZE);
+	num = __sys_getdents64(fd, dirp, BUF_SIZE);
 	while (num > 0) {
 		while (num > 0) {
 			struct stat st;
 			int ret;
 
-			ret = sys_newlstat(dirp->d_name, &st);
+			ret = __sys_newlstat(dirp->d_name, &st);
 			WARN_ON_ONCE(ret);
 			if (!ret) {
 				if (S_ISDIR(st.st_mode))
-					sys_rmdir(dirp->d_name);
+					__sys_rmdir(dirp->d_name);
 				else
-					sys_unlink(dirp->d_name);
+					__sys_unlink(dirp->d_name);
 			}
 
 			num -= dirp->d_reclen;
@@ -561,7 +564,7 @@ static void __init clean_rootfs(void)
 		}
 		dirp = buf;
 		memset(buf, 0, BUF_SIZE);
-		num = sys_getdents64(fd, dirp, BUF_SIZE);
+		num = __sys_getdents64(fd, dirp, BUF_SIZE);
 	}
 
 	sys_close(fd);
@@ -589,10 +592,9 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open((const char __user __force *) "/initrd.image",
-			      O_WRONLY|O_CREAT, 0700);
+		fd = __sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
+			__sys_write(fd, (char *)initrd_start,
 					initrd_end - initrd_start);
 			sys_close(fd);
 			free_initrd();
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index 267739d..5b4c3c4 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -22,6 +22,8 @@
 #include <linux/kdev_t.h>
 #include <linux/syscalls.h>
 
+#include "do_mounts.h"
+
 /*
  * Create a simple rootfs that is similar to the default initramfs
  */
@@ -29,17 +31,16 @@ static int __init default_rootfs(void)
 {
 	int err;
 
-	err = sys_mkdir((const char __user __force *) "/dev", 0755);
+	err = __sys_mkdir("/dev", 0755);
 	if (err < 0)
 		goto out;
 
-	err = sys_mknod((const char __user __force *) "/dev/console",
-			S_IFCHR | S_IRUSR | S_IWUSR,
+	err = __sys_mknod("/dev/console", S_IFCHR | S_IRUSR | S_IWUSR,
 			new_encode_dev(MKDEV(5, 1)));
 	if (err < 0)
 		goto out;
 
-	err = sys_mkdir((const char __user __force *) "/root", 0700);
+	err = __sys_mkdir("/root", 0700);
 	if (err < 0)
 		goto out;
 
