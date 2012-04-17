Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2DQAdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 20:33:55 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37523 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2DQAdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 20:33:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-10.tower-127.messagelabs.com!1334622819!3267059!5
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/2] init: introduce private syscall wrappers for non-user space pointers
Date: Mon, 16 Apr 2012 17:33:36 -0700
User-Agent: KMail/1.9.9
CC: <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204161733.36380.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap the syscalls used by the init mount code so that the appropriate
__user markups are added for kernel pointers.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---

diff --git a/init/do_mounts.h b/init/do_mounts.h
index f5b978a..e7d36de 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -8,6 +8,109 @@
 #include <linux/major.h>
 #include <linux/root_dev.h>
 
+static inline long __sys_mount(char *dev_name, char *dir_name,
+			       char *type, unsigned long flags, void *data)
+{
+	return sys_mount((char __user __force *)dev_name,
+			 (char __user __force *)dir_name,
+			 (char __user __force *)type, flags,
+			 (void __user __force *)data);
+}
+
+static inline long __sys_umount(char *name, int flags)
+{
+	return sys_umount((char __user __force *)name, flags);
+}
+
+static inline long __sys_newlstat(const char *filename, struct stat *statbuf)
+{
+	return sys_newlstat((const char __user __force *)filename,
+			    (struct stat __user __force *)statbuf);
+}
+
+static inline long __sys_chroot(const char *filename)
+{
+	return sys_chroot((const char __user __force *)filename);
+}
+
+static inline long __sys_mknod(const char *filename, umode_t mode,
+			       unsigned dev)
+{
+	return sys_mknod((const char __user __force *)filename, mode, dev);
+}
+
+static inline long __sys_link(const char *oldname, const char *newname)
+{
+	return sys_link((const char __user __force *)oldname,
+			(const char __user __force *)newname);
+}
+
+static inline long __sys_symlink(const char *old, const char *new)
+{
+	return sys_symlink((const char __user __force *)old,
+			   (const char __user __force *)new);
+}
+
+static inline long __sys_unlink(const char *pathname)
+{
+	return sys_unlink((const char __user __force *)pathname);
+}
+
+static inline long __sys_chmod(const char *filename, umode_t mode)
+{
+	return sys_chmod((const char __user __force *)filename, mode);
+}
+
+static inline long __sys_open(const char *filename,
+				int flags, umode_t mode)
+{
+	return sys_open((const char __user __force *)filename, flags, mode);
+}
+
+static inline long __sys_chown(const char *filename, uid_t user, gid_t group)
+{
+	return sys_chown((const char __user __force *)filename, user, group);
+}
+
+static inline long __sys_lchown(const char *filename, uid_t user, gid_t group)
+{
+	return sys_lchown((const char __user __force *)filename, user, group);
+}
+
+static inline long __sys_read(unsigned int fd, char *buf, size_t count)
+{
+	return sys_read(fd, (char __user __force *)buf, count);
+}
+
+static inline long __sys_write(unsigned int fd, const char *buf, size_t count)
+{
+	return sys_write(fd, (const char __user __force *)buf, count);
+}
+
+static inline long __sys_mkdir(const char *pathname, umode_t mode)
+{
+	return sys_mkdir((const char __user __force *)pathname, mode);
+}
+
+static inline long __sys_chdir(const char *filename)
+{
+	return sys_chdir((const char __user __force *)filename);
+}
+
+static inline long __sys_rmdir(const char *pathname)
+{
+	return sys_rmdir((const char __user __force *)pathname);
+}
+
+static inline long __sys_getdents64(unsigned int fd,
+				    struct linux_dirent64 *dirent,
+				    unsigned int count)
+{
+	return sys_getdents64(fd,
+			      (struct linux_dirent64 __user __force *)dirent,
+			      count);
+}
+
 void  change_floppy(char *fmt, ...);
 void  mount_block_root(char *name, int flags);
 void  mount_root(void);
@@ -15,8 +118,8 @@ extern int root_mountflags;
 
 static inline int create_dev(char *name, dev_t dev)
 {
-	sys_unlink(name);
-	return sys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
+	__sys_unlink(name);
+	return __sys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
 }
 
 #if BITS_PER_LONG == 32
