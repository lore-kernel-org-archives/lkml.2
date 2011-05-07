Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1EGEtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 00:49:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62121 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1EGEtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 00:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e8MRH7C+oNaC3WoOp+pc1TKywqygEYkmjhS8sWDRDLoj6+4/sC35kVL5HJGvl/I9rE
         QtZvMLhreRGkshkb1vzhbHFi0KbiA1+kjn7USv+tTipYWQbM8fCmBFIb3X46RnhHzwVY
         2DVWyatwWFkj7iIE0bDG+Styul02C/4pK3/qY=
From: Changli Gao <xiaosuo@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <matthew@wil.cx>, Arnd Bergmann <arnd@arndb.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] fs: add FD_CLOFORK and O_CLOFORK
Date: Sat,  7 May 2011 12:49:00 +0800
Message-Id: <1304743740-3405-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If FD_CLOFORK is 1, when a fork occurs, the corresponding file descriptor
will be closed for the child process. IOW, the file descriptor isn't
inheritable.

FD_CLOFORK is used as IBM does.

O_CLOFORK is also added to avoid the additional fcntl(2) after open(2).

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 fs/fcntl.c                  |   27 +++++++++++++++++++++++++++
 fs/file.c                   |   22 ++++++++++++++++++++--
 include/asm-generic/fcntl.h |    5 +++++
 include/linux/fdtable.h     |    2 ++
 include/linux/file.h        |    1 +
 5 files changed, 55 insertions(+), 2 deletions(-)
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22764c7..8127744 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -50,6 +50,31 @@ static int get_close_on_exec(unsigned int fd)
 	return res;
 }
 
+void set_close_on_fork(unsigned int fd, int flag)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	spin_lock(&files->file_lock);
+	fdt = files_fdtable(files);
+	if (flag)
+		FD_SET(fd, fdt->close_on_fork);
+	else
+		FD_CLR(fd, fdt->close_on_fork);
+	spin_unlock(&files->file_lock);
+}
+
+static int get_close_on_fork(unsigned int fd)
+{
+	struct files_struct *files = current->files;
+	struct fdtable *fdt;
+	int res;
+	rcu_read_lock();
+	fdt = files_fdtable(files);
+	res = FD_ISSET(fd, fdt->close_on_fork);
+	rcu_read_unlock();
+	return res;
+}
+
 SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 {
 	int err = -EBADF;
@@ -358,10 +383,12 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		break;
 	case F_GETFD:
 		err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
+		err |= get_close_on_fork(fd) ? FD_CLOFORK : 0;
 		break;
 	case F_SETFD:
 		err = 0;
 		set_close_on_exec(fd, arg & FD_CLOEXEC);
+		set_close_on_fork(fd, arg & FD_CLOFORK);
 		break;
 	case F_GETFL:
 		err = filp->f_flags;
diff --git a/fs/file.c b/fs/file.c
index 0be3447..ef79197 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -133,6 +133,8 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 	memset((char *)(nfdt->open_fds) + cpy, 0, set);
 	memcpy(nfdt->close_on_exec, ofdt->close_on_exec, cpy);
 	memset((char *)(nfdt->close_on_exec) + cpy, 0, set);
+	memcpy(nfdt->close_on_fork, ofdt->close_on_fork, cpy);
+	memset((char *)(nfdt->close_on_fork) + cpy, 0, set);
 }
 
 static struct fdtable * alloc_fdtable(unsigned int nr)
@@ -170,12 +172,14 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 		goto out_fdt;
 	fdt->fd = (struct file **)data;
 	data = alloc_fdmem(max_t(unsigned int,
-				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
+				 3 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = (fd_set *)data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = (fd_set *)data;
+	data += nr / BITS_PER_BYTE;
+	fdt->close_on_fork = (fd_set *)data;
 	fdt->next = NULL;
 
 	return fdt;
@@ -303,6 +307,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
 	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
+	new_fdt->close_on_fork = (fd_set *)&newf->close_on_fork_init;
 	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
 	new_fdt->next = NULL;
@@ -350,11 +355,18 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 		old_fdt->open_fds->fds_bits, open_files/8);
 	memcpy(new_fdt->close_on_exec->fds_bits,
 		old_fdt->close_on_exec->fds_bits, open_files/8);
+	memcpy(new_fdt->close_on_fork->fds_bits,
+		old_fdt->close_on_fork->fds_bits, open_files/8);
 
 	for (i = open_files; i != 0; i--) {
 		struct file *f = *old_fds++;
 		if (f) {
-			get_file(f);
+			if (FD_ISSET(open_files - i, new_fdt->close_on_fork)) {
+				FD_CLR(open_files - i, new_fdt->open_fds);
+				f = NULL;
+			} else {
+				get_file(f);
+			}
 		} else {
 			/*
 			 * The fd may be claimed in the fd bitmap but not yet
@@ -380,6 +392,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 
 		memset(&new_fdt->open_fds->fds_bits[start], 0, left);
 		memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
+		memset(&new_fdt->close_on_fork->fds_bits[start], 0, left);
 	}
 
 	rcu_assign_pointer(newf->fdt, new_fdt);
@@ -416,6 +429,7 @@ struct files_struct init_files = {
 		.max_fds	= NR_OPEN_DEFAULT,
 		.fd		= &init_files.fd_array[0],
 		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
+		.close_on_fork	= (fd_set *)&init_files.close_on_fork_init,
 		.open_fds	= (fd_set *)&init_files.open_fds_init,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
@@ -461,6 +475,10 @@ repeat:
 		FD_SET(fd, fdt->close_on_exec);
 	else
 		FD_CLR(fd, fdt->close_on_exec);
+	if (flags & O_CLOFORK)
+		FD_SET(fd, fdt->close_on_fork);
+	else
+		FD_CLR(fd, fdt->close_on_fork);
 	error = fd;
 #if 1
 	/* Sanity check */
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 84793c7..2a7c474 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -88,6 +88,10 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+#ifndef O_CLOFORK
+#define O_CLOFORK	020000000	/* set close_on_fork */
+#endif
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
@@ -131,6 +135,7 @@ struct f_owner_ex {
 
 /* for F_[GET|SET]FL */
 #define FD_CLOEXEC	1	/* actually anything with low bit set goes */
+#define FD_CLOFORK	2
 
 /* for posix fcntl() and lockf() */
 #ifndef F_RDLCK
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 133c0ba..bb9f0be 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -33,6 +33,7 @@ struct fdtable {
 	unsigned int max_fds;
 	struct file __rcu **fd;      /* current fd array */
 	fd_set *close_on_exec;
+	fd_set *close_on_fork;
 	fd_set *open_fds;
 	struct rcu_head rcu;
 	struct fdtable *next;
@@ -54,6 +55,7 @@ struct files_struct {
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	int next_fd;
 	struct embedded_fd_set close_on_exec_init;
+	struct embedded_fd_set close_on_fork_init;
 	struct embedded_fd_set open_fds_init;
 	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
 };
diff --git a/include/linux/file.h b/include/linux/file.h
index 21a7995..c592d1f 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -32,6 +32,7 @@ extern struct file *fget_light(unsigned int fd, int *fput_needed);
 extern struct file *fget_raw(unsigned int fd);
 extern struct file *fget_raw_light(unsigned int fd, int *fput_needed);
 extern void set_close_on_exec(unsigned int fd, int flag);
+extern void set_close_on_fork(unsigned int fd, int flag);
 extern void put_filp(struct file *);
 extern int alloc_fd(unsigned start, unsigned flags);
 extern int get_unused_fd(void);
