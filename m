Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2BPTII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:08:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab2BPTIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:08:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] Wrap accesses to the fd_sets in struct fdtable
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: hpa@zytor.com, torvalds@osdl.org, arnd@arndb.de, dhowells@redhat.com
Date: Thu, 16 Feb 2012 17:49:42 +0000
Message-ID: <20120216174942.23314.1364.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
References: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap accesses to the fd_sets in struct fdtable (for recording open files and
close-on-exec flags) so that we can move away from using fd_sets since we
abuse the fd_set structs by not allocating the full-sized structure under
normal circumstances and by non-core code looking at the internals of the
fd_sets.

The first abuse means that use of FD_ZERO() on these fd_sets is not permitted,
since that cannot be told about their abnormal lengths.

This introduces six wrapper functions for setting, clearing and testing
close-on-exec flags and fd-is-open flags:

	void __set_close_on_exec(int fd, struct fdtable *fdt);
	void __clear_close_on_exec(int fd, struct fdtable *fdt);
	bool close_on_exec(int fd, const struct fdtable *fdt);
	void __set_open_fd(int fd, struct fdtable *fdt);
	void __clear_open_fd(int fd, struct fdtable *fdt);
	bool fd_is_open(int fd, const struct fdtable *fdt);

Note that I've prepended '__' to the names of the set/clear functions because
they require the caller to hold a lock to use them.

Note also that I haven't added wrappers for looking behind the scenes at the
the array.  Possibly that should exist too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/files.txt          |    4 ++-
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 +-
 drivers/staging/android/binder.c             |   10 ++++-----
 fs/autofs4/dev-ioctl.c                       |    2 +-
 fs/exec.c                                    |    4 ++-
 fs/fcntl.c                                   |   18 ++++++++--------
 fs/file.c                                    |    8 +++----
 fs/open.c                                    |    4 ++-
 fs/proc/base.c                               |    2 +-
 include/linux/fdtable.h                      |   30 ++++++++++++++++++++++++++
 10 files changed, 57 insertions(+), 27 deletions(-)

diff --git a/Documentation/filesystems/files.txt b/Documentation/filesystems/files.txt
index ac2facc..46dfc6b 100644
--- a/Documentation/filesystems/files.txt
+++ b/Documentation/filesystems/files.txt
@@ -113,8 +113,8 @@ the fdtable structure -
 	if (fd >= 0) {
 		/* locate_fd() may have expanded fdtable, load the ptr */
 		fdt = files_fdtable(files);
-		FD_SET(fd, fdt->open_fds);
-		FD_CLR(fd, fdt->close_on_exec);
+		__set_open_fd(fd, fdt);
+		__clear_close_on_exec(fd, fdt);
 		spin_unlock(&files->file_lock);
 	.....
 
diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index 03c5fce..c2c5b07 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -122,7 +122,7 @@ static struct spu_context *coredump_next_context(int *fd)
 	struct spu_context *ctx = NULL;
 
 	for (; *fd < fdt->max_fds; (*fd)++) {
-		if (!FD_ISSET(*fd, fdt->open_fds))
+		if (!fd_is_open(*fd, fdt))
 			continue;
 
 		file = fcheck(*fd);
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index f0b7e66..347bd6e 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -409,11 +409,11 @@ repeat:
 		goto repeat;
 	}
 
-	FD_SET(fd, fdt->open_fds);
+	__set_open_fd(fd, fdt);
 	if (flags & O_CLOEXEC)
-		FD_SET(fd, fdt->close_on_exec);
+		__set_close_on_exec(fd, fdt);
 	else
-		FD_CLR(fd, fdt->close_on_exec);
+		__clear_close_on_exec(fd, fdt);
 	files->next_fd = fd + 1;
 #if 1
 	/* Sanity check */
@@ -454,7 +454,7 @@ static void task_fd_install(
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
-	__FD_CLR(fd, fdt->open_fds);
+	__clear_open_fd(fd, fdt);
 	if (fd < files->next_fd)
 		files->next_fd = fd;
 }
@@ -480,7 +480,7 @@ static long task_close_fd(struct binder_proc *proc, unsigned int fd)
 	if (!filp)
 		goto out_unlock;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
-	FD_CLR(fd, fdt->close_on_exec);
+	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 	retval = filp_close(filp, files);
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 76741d8..3dfd615 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -230,7 +230,7 @@ static void autofs_dev_ioctl_fd_install(unsigned int fd, struct file *file)
 	fdt = files_fdtable(files);
 	BUG_ON(fdt->fd[fd] != NULL);
 	rcu_assign_pointer(fdt->fd[fd], file);
-	FD_SET(fd, fdt->close_on_exec);
+	__set_close_on_exec(fd, fdt);
 	spin_unlock(&files->file_lock);
 }
 
diff --git a/fs/exec.c b/fs/exec.c
index 92ce83a..22cc38d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2078,8 +2078,8 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
 	fd_install(0, rp);
 	spin_lock(&cf->file_lock);
 	fdt = files_fdtable(cf);
-	FD_SET(0, fdt->open_fds);
-	FD_CLR(0, fdt->close_on_exec);
+	__set_open_fd(0, fdt);
+	__clear_close_on_exec(0, fdt);
 	spin_unlock(&cf->file_lock);
 
 	/* and disallow core files too */
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 22764c7..75e7c1f 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -32,20 +32,20 @@ void set_close_on_exec(unsigned int fd, int flag)
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
 	if (flag)
-		FD_SET(fd, fdt->close_on_exec);
+		__set_close_on_exec(fd, fdt);
 	else
-		FD_CLR(fd, fdt->close_on_exec);
+		__clear_close_on_exec(fd, fdt);
 	spin_unlock(&files->file_lock);
 }
 
-static int get_close_on_exec(unsigned int fd)
+static bool get_close_on_exec(unsigned int fd)
 {
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
-	int res;
+	bool res;
 	rcu_read_lock();
 	fdt = files_fdtable(files);
-	res = FD_ISSET(fd, fdt->close_on_exec);
+	res = close_on_exec(fd, fdt);
 	rcu_read_unlock();
 	return res;
 }
@@ -90,15 +90,15 @@ SYSCALL_DEFINE3(dup3, unsigned int, oldfd, unsigned int, newfd, int, flags)
 	err = -EBUSY;
 	fdt = files_fdtable(files);
 	tofree = fdt->fd[newfd];
-	if (!tofree && FD_ISSET(newfd, fdt->open_fds))
+	if (!tofree && fd_is_open(newfd, fdt))
 		goto out_unlock;
 	get_file(file);
 	rcu_assign_pointer(fdt->fd[newfd], file);
-	FD_SET(newfd, fdt->open_fds);
+	__set_open_fd(newfd, fdt);
 	if (flags & O_CLOEXEC)
-		FD_SET(newfd, fdt->close_on_exec);
+		__set_close_on_exec(newfd, fdt);
 	else
-		FD_CLR(newfd, fdt->close_on_exec);
+		__clear_close_on_exec(newfd, fdt);
 	spin_unlock(&files->file_lock);
 
 	if (tofree)
diff --git a/fs/file.c b/fs/file.c
index 4c6992d..114fea0 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -366,7 +366,7 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 			 * is partway through open().  So make sure that this
 			 * fd is available to the new process.
 			 */
-			FD_CLR(open_files - i, new_fdt->open_fds);
+			__clear_open_fd(open_files - i, new_fdt);
 		}
 		rcu_assign_pointer(*new_fds++, f);
 	}
@@ -460,11 +460,11 @@ repeat:
 	if (start <= files->next_fd)
 		files->next_fd = fd + 1;
 
-	FD_SET(fd, fdt->open_fds);
+	__set_open_fd(fd, fdt);
 	if (flags & O_CLOEXEC)
-		FD_SET(fd, fdt->close_on_exec);
+		__set_close_on_exec(fd, fdt);
 	else
-		FD_CLR(fd, fdt->close_on_exec);
+		__clear_close_on_exec(fd, fdt);
 	error = fd;
 #if 1
 	/* Sanity check */
diff --git a/fs/open.c b/fs/open.c
index 77becc0..5720854 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -836,7 +836,7 @@ EXPORT_SYMBOL(dentry_open);
 static void __put_unused_fd(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = files_fdtable(files);
-	__FD_CLR(fd, fdt->open_fds);
+	__clear_open_fd(fd, fdt);
 	if (fd < files->next_fd)
 		files->next_fd = fd;
 }
@@ -1080,7 +1080,7 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 	if (!filp)
 		goto out_unlock;
 	rcu_assign_pointer(fdt->fd[fd], NULL);
-	FD_CLR(fd, fdt->close_on_exec);
+	__clear_close_on_exec(fd, fdt);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
 	retval = filp_close(filp, files);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d4548dd..db6ab4b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1754,7 +1754,7 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 
 			fdt = files_fdtable(files);
 			f_flags = file->f_flags & ~O_CLOEXEC;
-			if (FD_ISSET(fd, fdt->close_on_exec))
+			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
 
 			if (path) {
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 82163c4..7675da2 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -38,6 +38,36 @@ struct fdtable {
 	struct fdtable *next;
 };
 
+static inline void __set_close_on_exec(int fd, struct fdtable *fdt)
+{
+	FD_SET(fd, fdt->close_on_exec);
+}
+
+static inline void __clear_close_on_exec(int fd, struct fdtable *fdt)
+{
+	FD_CLR(fd, fdt->close_on_exec);
+}
+
+static inline bool close_on_exec(int fd, const struct fdtable *fdt)
+{
+	return FD_ISSET(fd, fdt->close_on_exec);
+}
+
+static inline void __set_open_fd(int fd, struct fdtable *fdt)
+{
+	FD_SET(fd, fdt->open_fds);
+}
+
+static inline void __clear_open_fd(int fd, struct fdtable *fdt)
+{
+	FD_CLR(fd, fdt->open_fds);
+}
+
+static inline bool fd_is_open(int fd, const struct fdtable *fdt)
+{
+	return FD_ISSET(fd, fdt->open_fds);
+}
+
 /*
  * Open file table structure
  */

