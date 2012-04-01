Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2DAM5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:57:53 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63938 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2DAM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:57:47 -0400
Date: Sun, 1 Apr 2012 15:57:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, viro@zeniv.linux.org.uk
Cc: torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] nextfd(2)
Message-ID: <20120401125741.GA7484@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no reliable way to close all opened file descriptors
(which daemons need and like to do):

* dumb close(fd) loop is slow, upper bound is unknown and
  can be arbitrary large,

* /proc/self/fd is unreliable:
  proc may be unconfigured or not mounted at expected place.
  Looking at /proc/self/fd requires opening directory
  which may not be available due to malicious rlimit drop or ENOMEM situations.
  Not opening directory is equivalent to dumb close(2) loop except slower.

BSD added closefrom(fd) which is OK for this exact purpose but suboptimal
on the bigger scale. closefrom(2) does only close(2) (obviously :-)
closefrom(2) siletly ignores errors from close(2) which in theory is not OK
for userspace.

So, don't add closefrom(2), add nextfd(2).

	int nextfd(int fd)

returns next opened file descriptor which is >= than fd or -1/ESRCH
if there aren't any descriptors >= than fd.

Thus closefrom(3) can be rewritten through it in userspace:

	void closefrom(int fd)
	{
		while (1) {
			fd = nextfd(fd);
			if (fd == -1 && errno == ESRCH)
				break;
			(void)close(fd);
			fd++;
		}
	}

Maybe it will grow other smart uses.

nextfd(2) doesn't change kernel state and thus can't fail
which is why it should go in. Other means may fail or
may not be available or require linear time with only guessed
upper boundaries (1024, getrlimit(RLIM_NOFILE), sysconf(_SC_OPEN_MAX).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/syscalls/syscall_32.tbl |    1 +
 arch/x86/syscalls/syscall_64.tbl |    1 +
 fs/Makefile                      |    1 +
 fs/nextfd.c                      |   27 +++++++++++++++++++++++++++
 include/linux/syscalls.h         |    1 +
 5 files changed, 31 insertions(+)

--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -355,3 +355,4 @@
 346	i386	setns			sys_setns
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+349	i386	nextfd			sys_nextfd
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -318,6 +318,7 @@
 309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+312	64	nextfd			sys_nextfd
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
 # for native 64-bit operation.
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -12,6 +12,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
 		stack.o fs_struct.o statfs.o
+obj-y += nextfd.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
--- /dev/null
+++ b/fs/nextfd.c
@@ -0,0 +1,27 @@
+#include <linux/errno.h>
+#include <linux/fdtable.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/syscalls.h>
+
+/* Return first opened file descriptor which is >= than the argument. */
+SYSCALL_DEFINE1(nextfd, unsigned int, fd)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+
+	rcu_read_lock();
+	fdt = files_fdtable(files);
+	while (fd < fdt->max_fds) {
+		struct file *file;
+
+		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
+		if (file) {
+			rcu_read_unlock();
+			return fd;
+		}
+		fd++;
+	}
+	rcu_read_unlock();
+	return -ESRCH;
+}
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -857,5 +857,6 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 				      const struct iovec __user *rvec,
 				      unsigned long riovcnt,
 				      unsigned long flags);
+asmlinkage long sys_nextfd(unsigned int fd);
 
 #endif
