Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0H3R2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:28:09 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:43051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab0H3R2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:28:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZfMMs/Hle3YOK7WvTXIA/1uWi8xXUTzbdH+kuM8/77NMxOhFdyDb/hBsTIroTfjcBQ
         8Ucs+e2R6p9BkbOn/nq7ebNgW17/eaA9Qx7xA5Y0AllCNP/+KkLbo9wIBEN9Ce4XuWeI
         UpKRbQj+l/CwdFf6sKibZQ0VjAVg62lu+39rg=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] init: use kern_sys_* wrappers instead of syscall
Date: Tue, 31 Aug 2010 02:27:50 +0900
Message-Id: <1283189270-7274-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
References: <1283189270-7274-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace direct syscall invocations to its wrapper functions defined
in init/sys-wrapper.h

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/do_mounts.c        |   29 +++++++++++----------
 init/do_mounts_initrd.c |   48 +++++++++++++++++++-----------------
 init/do_mounts_md.c     |   29 +++++++++++----------
 init/do_mounts_rd.c     |   37 ++++++++++++++--------------
 init/initramfs.c        |   61 ++++++++++++++++++++++++-----------------------
 init/main.c             |    9 ++++---
 init/noinitramfs.c      |   10 ++++----
 7 files changed, 115 insertions(+), 108 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 529581f..7ce3eb3 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -22,6 +22,7 @@
 #include <linux/nfs_mount.h>
 
 #include "do_mounts.h"
+#include "sys-wrapper.h"
 
 int __initdata rd_doload;	/* 1 = load RAM disk, 0 = don't load */
 
@@ -217,11 +218,11 @@ static void __init get_fs_names(char *page)
 
 static int __init do_mount_root(char *name, char *fs, int flags, void *data)
 {
-	int err = sys_mount(name, "/root", fs, flags, data);
+	int err = kern_sys_mount(name, "/root", fs, flags, data);
 	if (err)
 		return err;
 
-	sys_chdir((const char __user __force *)"/root");
+	kern_sys_chdir("/root");
 	ROOT_DEV = current->fs->pwd.mnt->mnt_sb->s_dev;
 	printk("VFS: Mounted root (%s filesystem)%s on device %u:%u.\n",
 	       current->fs->pwd.mnt->mnt_sb->s_type->name,
@@ -287,7 +288,7 @@ retry:
 out:
 	putname(fs_names);
 }
- 
+
 #ifdef CONFIG_ROOT_NFS
 static int __init mount_nfs_root(void)
 {
@@ -312,21 +313,21 @@ void __init change_floppy(char *fmt, ...)
 	va_start(args, fmt);
 	vsprintf(buf, fmt, args);
 	va_end(args);
-	fd = sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
+	fd = kern_sys_open("/dev/root", O_RDWR | O_NDELAY, 0);
 	if (fd >= 0) {
-		sys_ioctl(fd, FDEJECT, 0);
-		sys_close(fd);
+		kern_sys_ioctl(fd, FDEJECT, 0);
+		kern_sys_close(fd);
 	}
 	printk(KERN_NOTICE "VFS: Insert %s and press ENTER\n", buf);
-	fd = sys_open("/dev/console", O_RDWR, 0);
+	fd = kern_sys_open("/dev/console", O_RDWR, 0);
 	if (fd >= 0) {
-		sys_ioctl(fd, TCGETS, (long)&termios);
+		kern_sys_ioctl(fd, TCGETS, (long)&termios);
 		termios.c_lflag &= ~ICANON;
-		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_read(fd, &c, 1);
+		kern_sys_ioctl(fd, TCSETSF, (long)&termios);
+		kern_sys_read(fd, &c, 1);
 		termios.c_lflag |= ICANON;
-		sys_ioctl(fd, TCSETSF, (long)&termios);
-		sys_close(fd);
+		kern_sys_ioctl(fd, TCSETSF, (long)&termios);
+		kern_sys_close(fd);
 	}
 }
 #endif
@@ -417,6 +418,6 @@ void __init prepare_namespace(void)
 	mount_root();
 out:
 	devtmpfs_mount("dev");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot((const char __user __force *)".");
+	kern_sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	kern_sys_chroot(".");
 }
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 3098a38..6ca18b8 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -9,6 +9,7 @@
 #include <linux/freezer.h>
 
 #include "do_mounts.h"
+#include "sys-wrapper.h"
 
 unsigned long initrd_start, initrd_end;
 int initrd_below_start_ok;
@@ -30,8 +31,9 @@ static int __init do_linuxrc(void *_shell)
 	extern const char *envp_init[];
 	const char *shell = _shell;
 
-	sys_close(old_fd);sys_close(root_fd);
-	sys_setsid();
+	kern_sys_close(old_fd);
+	kern_sys_close(root_fd);
+	kern_sys_setsid();
 	return kernel_execve(shell, argv, envp_init);
 }
 
@@ -44,13 +46,13 @@ static void __init handle_initrd(void)
 	create_dev("/dev/root.old", Root_RAM0);
 	/* mount initrd on rootfs' /root */
 	mount_block_root("/dev/root.old", root_mountflags & ~MS_RDONLY);
-	sys_mkdir("/old", 0700);
-	root_fd = sys_open("/", 0, 0);
-	old_fd = sys_open("/old", 0, 0);
+	kern_sys_mkdir("/old", 0700);
+	root_fd = kern_sys_open("/", 0, 0);
+	old_fd = kern_sys_open("/old", 0, 0);
 	/* move initrd over / and chdir/chroot in initrd root */
-	sys_chdir("/root");
-	sys_mount(".", "/", NULL, MS_MOVE, NULL);
-	sys_chroot(".");
+	kern_sys_chdir("/root");
+	kern_sys_mount(".", "/", NULL, MS_MOVE, NULL);
+	kern_sys_chroot(".");
 
 	/*
 	 * In case that a resume from disk is carried out by linuxrc or one of
@@ -60,22 +62,22 @@ static void __init handle_initrd(void)
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != kern_sys_wait4(-1, NULL, 0, NULL))
 			yield();
 
 	current->flags &= ~PF_FREEZER_SKIP;
 
 	/* move initrd to rootfs' /old */
-	sys_fchdir(old_fd);
-	sys_mount("/", ".", NULL, MS_MOVE, NULL);
+	kern_sys_fchdir(old_fd);
+	kern_sys_mount("/", ".", NULL, MS_MOVE, NULL);
 	/* switch root and cwd back to / of rootfs */
-	sys_fchdir(root_fd);
-	sys_chroot(".");
-	sys_close(old_fd);
-	sys_close(root_fd);
+	kern_sys_fchdir(root_fd);
+	kern_sys_chroot(".");
+	kern_sys_close(old_fd);
+	kern_sys_close(root_fd);
 
 	if (new_decode_dev(real_root_dev) == Root_RAM0) {
-		sys_chdir("/old");
+		kern_sys_chdir("/old");
 		return;
 	}
 
@@ -83,23 +85,23 @@ static void __init handle_initrd(void)
 	mount_root();
 
 	printk(KERN_NOTICE "Trying to move old root to /initrd ... ");
-	error = sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
+	error = kern_sys_mount("/old", "/root/initrd", NULL, MS_MOVE, NULL);
 	if (!error)
 		printk("okay\n");
 	else {
-		int fd = sys_open("/dev/root.old", O_RDWR, 0);
+		int fd = kern_sys_open("/dev/root.old", O_RDWR, 0);
 		if (error == -ENOENT)
 			printk("/initrd does not exist. Ignored.\n");
 		else
 			printk("failed\n");
 		printk(KERN_NOTICE "Unmounting old root\n");
-		sys_umount("/old", MNT_DETACH);
+		kern_sys_umount("/old", MNT_DETACH);
 		printk(KERN_NOTICE "Trying to free ramdisk memory ... ");
 		if (fd < 0) {
 			error = fd;
 		} else {
-			error = sys_ioctl(fd, BLKFLSBUF, 0);
-			sys_close(fd);
+			error = kern_sys_ioctl(fd, BLKFLSBUF, 0);
+			kern_sys_close(fd);
 		}
 		printk(!error ? "okay\n" : "failed\n");
 	}
@@ -116,11 +118,11 @@ int __init initrd_load(void)
 		 * mounted in the normal path.
 		 */
 		if (rd_load_image("/initrd.image") && ROOT_DEV != Root_RAM0) {
-			sys_unlink("/initrd.image");
+			kern_sys_unlink("/initrd.image");
 			handle_initrd();
 			return 1;
 		}
 	}
-	sys_unlink("/initrd.image");
+	kern_sys_unlink("/initrd.image");
 	return 0;
 }
diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
index 32c4799..7ac2db1 100644
--- a/init/do_mounts_md.c
+++ b/init/do_mounts_md.c
@@ -3,6 +3,7 @@
 #include <linux/raid/md_p.h>
 
 #include "do_mounts.h"
+#include "sys-wrapper.h"
 
 /*
  * When md (and any require personalities) are compiled into the kernel
@@ -170,17 +171,17 @@ static void __init md_setup_drive(void)
 			partitioned ? "_d" : "", minor,
 			md_setup_args[ent].device_names);
 
-		fd = sys_open(name, 0, 0);
+		fd = kern_sys_open(name, 0, 0);
 		if (fd < 0) {
 			printk(KERN_ERR "md: open failed - cannot start "
 					"array %s\n", name);
 			continue;
 		}
-		if (sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
+		if (kern_sys_ioctl(fd, SET_ARRAY_INFO, 0) == -EBUSY) {
 			printk(KERN_WARNING
 			       "md: Ignoring md=%d, already autodetected. (Use raid=noautodetect)\n",
 			       minor);
-			sys_close(fd);
+			kern_sys_close(fd);
 			continue;
 		}
 
@@ -199,7 +200,7 @@ static void __init md_setup_drive(void)
 			ainfo.state = (1 << MD_SB_CLEAN);
 			ainfo.layout = 0;
 			ainfo.chunk_size = md_setup_args[ent].chunk;
-			err = sys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
+			err = kern_sys_ioctl(fd, SET_ARRAY_INFO, (long)&ainfo);
 			for (i = 0; !err && i <= MD_SB_DISKS; i++) {
 				dev = devices[i];
 				if (!dev)
@@ -209,7 +210,7 @@ static void __init md_setup_drive(void)
 				dinfo.state = (1<<MD_DISK_ACTIVE)|(1<<MD_DISK_SYNC);
 				dinfo.major = MAJOR(dev);
 				dinfo.minor = MINOR(dev);
-				err = sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
+				err = kern_sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
 			}
 		} else {
 			/* persistent */
@@ -219,11 +220,11 @@ static void __init md_setup_drive(void)
 					break;
 				dinfo.major = MAJOR(dev);
 				dinfo.minor = MINOR(dev);
-				sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
+				kern_sys_ioctl(fd, ADD_NEW_DISK, (long)&dinfo);
 			}
 		}
 		if (!err)
-			err = sys_ioctl(fd, RUN_ARRAY, 0);
+			err = kern_sys_ioctl(fd, RUN_ARRAY, 0);
 		if (err)
 			printk(KERN_WARNING "md: starting md%d failed\n", minor);
 		else {
@@ -232,11 +233,11 @@ static void __init md_setup_drive(void)
 			 * boot a kernel with devfs compiled in from partitioned md
 			 * array without it
 			 */
-			sys_close(fd);
-			fd = sys_open(name, 0, 0);
-			sys_ioctl(fd, BLKRRPART, 0);
+			kern_sys_close(fd);
+			fd = kern_sys_open(name, 0, 0);
+			kern_sys_ioctl(fd, BLKRRPART, 0);
 		}
-		sys_close(fd);
+		kern_sys_close(fd);
 	}
 }
 
@@ -283,10 +284,10 @@ static void __init autodetect_raid(void)
 
 	wait_for_device_probe();
 
-	fd = sys_open((const char __user __force *) "/dev/md0", 0, 0);
+	fd = kern_sys_open("/dev/md0", 0, 0);
 	if (fd >= 0) {
-		sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
-		sys_close(fd);
+		kern_sys_ioctl(fd, RAID_AUTORUN, raid_autopart);
+		kern_sys_close(fd);
 	}
 }
 
diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index 6e1ee69..a622033 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -10,6 +10,7 @@
 #include <linux/slab.h>
 
 #include "do_mounts.h"
+#include "sys-wrapper.h"
 #include "../fs/squashfs/squashfs_fs.h"
 
 #include <linux/decompress/generic.h>
@@ -76,8 +77,8 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	/*
 	 * Read block 0 to test for compressed kernel
 	 */
-	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	kern_sys_lseek(fd, start_block * BLOCK_SIZE, 0);
+	kern_sys_read(fd, buf, size);
 
 	*decompressor = decompress_method(buf, size, &compress_name);
 	if (compress_name) {
@@ -122,8 +123,8 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	/*
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
-	sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
-	sys_read(fd, buf, size);
+	kern_sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
+	kern_sys_read(fd, buf, size);
 
 	/* Try minix */
 	if (minixsb->s_magic == MINIX_SUPER_MAGIC ||
@@ -150,7 +151,7 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	       start_block);
 
 done:
-	sys_lseek(fd, start_block * BLOCK_SIZE, 0);
+	kern_sys_lseek(fd, start_block * BLOCK_SIZE, 0);
 	kfree(buf);
 	return nblocks;
 }
@@ -168,11 +169,11 @@ int __init rd_load_image(char *from)
 	char rotator[4] = { '|' , '/' , '-' , '\\' };
 #endif
 
-	out_fd = sys_open((const char __user __force *) "/dev/ram", O_RDWR, 0);
+	out_fd = kern_sys_open("/dev/ram", O_RDWR, 0);
 	if (out_fd < 0)
 		goto out;
 
-	in_fd = sys_open(from, O_RDONLY, 0);
+	in_fd = kern_sys_open(from, O_RDONLY, 0);
 	if (in_fd < 0)
 		goto noclose_input;
 
@@ -197,7 +198,7 @@ int __init rd_load_image(char *from)
 	 * silly to use anything else, so make sure to use 1KiB
 	 * blocksize while generating ext2fs ramdisk-images.
 	 */
-	if (sys_ioctl(out_fd, BLKGETSIZE, (unsigned long)&rd_blocks) < 0)
+	if (kern_sys_ioctl(out_fd, BLKGETSIZE, (unsigned long)&rd_blocks) < 0)
 		rd_blocks = 0;
 	else
 		rd_blocks >>= 1;
@@ -211,7 +212,7 @@ int __init rd_load_image(char *from)
 	/*
 	 * OK, time to copy in the data
 	 */
-	if (sys_ioctl(in_fd, BLKGETSIZE, (unsigned long)&devblocks) < 0)
+	if (kern_sys_ioctl(in_fd, BLKGETSIZE, (unsigned long)&devblocks) < 0)
 		devblocks = 0;
 	else
 		devblocks >>= 1;
@@ -236,20 +237,20 @@ int __init rd_load_image(char *from)
 		if (i && (i % devblocks == 0)) {
 			printk("done disk #%d.\n", disk++);
 			rotate = 0;
-			if (sys_close(in_fd)) {
+			if (kern_sys_close(in_fd)) {
 				printk("Error closing the disk.\n");
 				goto noclose_input;
 			}
 			change_floppy("disk #%d", disk);
-			in_fd = sys_open(from, O_RDONLY, 0);
+			in_fd = kern_sys_open(from, O_RDONLY, 0);
 			if (in_fd < 0)  {
 				printk("Error opening disk.\n");
 				goto noclose_input;
 			}
 			printk("Loading disk #%d... ", disk);
 		}
-		sys_read(in_fd, buf, BLOCK_SIZE);
-		sys_write(out_fd, buf, BLOCK_SIZE);
+		kern_sys_read(in_fd, buf, BLOCK_SIZE);
+		kern_sys_write(out_fd, buf, BLOCK_SIZE);
 #if !defined(CONFIG_S390) && !defined(CONFIG_PPC_ISERIES)
 		if (!(i % 16)) {
 			printk("%c\b", rotator[rotate & 0x3]);
@@ -262,12 +263,12 @@ int __init rd_load_image(char *from)
 successful_load:
 	res = 1;
 done:
-	sys_close(in_fd);
+	kern_sys_close(in_fd);
 noclose_input:
-	sys_close(out_fd);
+	kern_sys_close(out_fd);
 out:
 	kfree(buf);
-	sys_unlink((const char __user __force *) "/dev/ram");
+	kern_sys_unlink("/dev/ram");
 	return res;
 }
 
@@ -286,7 +287,7 @@ static int crd_infd, crd_outfd;
 
 static int __init compr_fill(void *buf, unsigned int len)
 {
-	int r = sys_read(crd_infd, buf, len);
+	int r = kern_sys_read(crd_infd, buf, len);
 	if (r < 0)
 		printk(KERN_ERR "RAMDISK: error while reading compressed data");
 	else if (r == 0)
@@ -296,7 +297,7 @@ static int __init compr_fill(void *buf, unsigned int len)
 
 static int __init compr_flush(void *window, unsigned int outcnt)
 {
-	int written = sys_write(crd_outfd, window, outcnt);
+	int written = kern_sys_write(crd_outfd, window, outcnt);
 	if (written != outcnt) {
 		if (decompress_error == 0)
 			printk(KERN_ERR
diff --git a/init/initramfs.c b/init/initramfs.c
index d9c6e78..4a07af2 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -8,6 +8,7 @@
 #include <linux/dirent.h>
 #include <linux/syscalls.h>
 #include <linux/utime.h>
+#include "sys-wrapper.h"
 
 static __initdata char *message;
 static void __init error(char *x)
@@ -271,7 +272,7 @@ static int __init maybe_link(void)
 	if (nlink >= 2) {
 		char *old = find_link(major, minor, ino, mode, collected);
 		if (old)
-			return (sys_link(old, collected) < 0) ? -1 : 1;
+			return (kern_sys_link(old, collected) < 0) ? -1 : 1;
 	}
 	return 0;
 }
@@ -280,11 +281,11 @@ static void __init clean_path(char *path, mode_t mode)
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!kern_sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
-			sys_rmdir(path);
+			kern_sys_rmdir(path);
 		else
-			sys_unlink(path);
+			kern_sys_unlink(path);
 	}
 }
 
@@ -305,28 +306,28 @@ static int __init do_name(void)
 			int openflags = O_WRONLY|O_CREAT;
 			if (ml != 1)
 				openflags |= O_TRUNC;
-			wfd = sys_open(collected, openflags, mode);
+			wfd = kern_sys_open(collected, openflags, mode);
 
 			if (wfd >= 0) {
-				sys_fchown(wfd, uid, gid);
-				sys_fchmod(wfd, mode);
+				kern_sys_fchown(wfd, uid, gid);
+				kern_sys_fchmod(wfd, mode);
 				if (body_len)
-					sys_ftruncate(wfd, body_len);
+					kern_sys_ftruncate(wfd, body_len);
 				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
 		}
 	} else if (S_ISDIR(mode)) {
-		sys_mkdir(collected, mode);
-		sys_chown(collected, uid, gid);
-		sys_chmod(collected, mode);
+		kern_sys_mkdir(collected, mode);
+		kern_sys_chown(collected, uid, gid);
+		kern_sys_chmod(collected, mode);
 		dir_add(collected, mtime);
 	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
 		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
 		if (maybe_link() == 0) {
-			sys_mknod(collected, mode, rdev);
-			sys_chown(collected, uid, gid);
-			sys_chmod(collected, mode);
+			kern_sys_mknod(collected, mode, rdev);
+			kern_sys_chown(collected, uid, gid);
+			kern_sys_chmod(collected, mode);
 			do_utime(collected, mtime);
 		}
 	}
@@ -336,15 +337,15 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
-		sys_close(wfd);
+		kern_sys_write(wfd, victim, body_len);
+		kern_sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
 		eat(body_len);
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		kern_sys_write(wfd, victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -355,8 +356,8 @@ static int __init do_symlink(void)
 {
 	collected[N_ALIGN(name_len) + body_len] = '\0';
 	clean_path(collected, 0);
-	sys_symlink(collected + N_ALIGN(name_len), collected);
-	sys_lchown(collected, uid, gid);
+	kern_sys_symlink(collected + N_ALIGN(name_len), collected);
+	kern_sys_lchown(collected, uid, gid);
 	do_utime(collected, mtime);
 	state = SkipIt;
 	next_state = Reset;
@@ -528,31 +529,31 @@ static void __init clean_rootfs(void)
 	struct linux_dirent64 *dirp;
 	int num;
 
-	fd = sys_open((const char __user __force *) "/", O_RDONLY, 0);
+	fd = kern_sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
 	if (fd < 0)
 		return;
 	buf = kzalloc(BUF_SIZE, GFP_KERNEL);
 	WARN_ON(!buf);
 	if (!buf) {
-		sys_close(fd);
+		kern_sys_close(fd);
 		return;
 	}
 
 	dirp = buf;
-	num = sys_getdents64(fd, dirp, BUF_SIZE);
+	num = kern_sys_getdents64(fd, dirp, BUF_SIZE);
 	while (num > 0) {
 		while (num > 0) {
 			struct stat st;
 			int ret;
 
-			ret = sys_newlstat(dirp->d_name, &st);
+			ret = kern_sys_newlstat(dirp->d_name, &st);
 			WARN_ON_ONCE(ret);
 			if (!ret) {
 				if (S_ISDIR(st.st_mode))
-					sys_rmdir(dirp->d_name);
+					kern_sys_rmdir(dirp->d_name);
 				else
-					sys_unlink(dirp->d_name);
+					kern_sys_unlink(dirp->d_name);
 			}
 
 			num -= dirp->d_reclen;
@@ -560,10 +561,10 @@ static void __init clean_rootfs(void)
 		}
 		dirp = buf;
 		memset(buf, 0, BUF_SIZE);
-		num = sys_getdents64(fd, dirp, BUF_SIZE);
+		num = kern_sys_getdents64(fd, dirp, BUF_SIZE);
 	}
 
-	sys_close(fd);
+	kern_sys_close(fd);
 	kfree(buf);
 }
 #endif
@@ -590,12 +591,12 @@ static int __init populate_rootfs(void)
 		}
 		printk(KERN_INFO "rootfs image is not initramfs (%s)"
 				"; looks like an initrd\n", err);
-		fd = sys_open((const char __user __force *) "/initrd.image",
+		fd = kern_sys_open("/initrd.image",
 			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
+			kern_sys_write(fd, (char *)initrd_start,
 					initrd_end - initrd_start);
-			sys_close(fd);
+			kern_sys_close(fd);
 			free_initrd();
 		}
 #else
diff --git a/init/main.c b/init/main.c
index 94ab488..6d53cfa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -68,6 +68,7 @@
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
+#include "sys-wrapper.h"
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -893,11 +894,11 @@ static int __init kernel_init(void * unused)
 	do_basic_setup();
 
 	/* Open the /dev/console on the rootfs, this should never fail */
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+	if (kern_sys_open("/dev/console", O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
 
-	(void) sys_dup(0);
-	(void) sys_dup(0);
+	(void) kern_sys_dup(0);
+	(void) kern_sys_dup(0);
 	/*
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
@@ -906,7 +907,7 @@ static int __init kernel_init(void * unused)
 	if (!ramdisk_execute_command)
 		ramdisk_execute_command = "/init";
 
-	if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
+	if (kern_sys_access(ramdisk_execute_command, 0) != 0) {
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index 267739d..f75ae08 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -29,17 +29,17 @@ static int __init default_rootfs(void)
 {
 	int err;
 
-	err = sys_mkdir((const char __user __force *) "/dev", 0755);
+	err = kern_sys_mkdir("/dev", 0755);
 	if (err < 0)
 		goto out;
 
-	err = sys_mknod((const char __user __force *) "/dev/console",
-			S_IFCHR | S_IRUSR | S_IWUSR,
-			new_encode_dev(MKDEV(5, 1)));
+	err = kern_sys_mknod("/dev/console",
+			     S_IFCHR | S_IRUSR | S_IWUSR,
+			     new_encode_dev(MKDEV(5, 1)));
 	if (err < 0)
 		goto out;
 
-	err = sys_mkdir((const char __user __force *) "/root", 0700);
+	err = kern_sys_mkdir("/root", 0700);
 	if (err < 0)
 		goto out;
 
-- 
1.7.2.2

