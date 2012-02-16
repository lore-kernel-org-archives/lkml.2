Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2BPSJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:09:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab2BPSJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:09:49 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] Replace the fd_sets in struct fdtable with an array of
 unsigned longs
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: hpa@zytor.com, torvalds@osdl.org, arnd@arndb.de, dhowells@redhat.com
Date: Thu, 16 Feb 2012 17:49:54 +0000
Message-ID: <20120216174954.23314.48147.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
References: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the fd_sets in struct fdtable with an array of unsigned longs and then
use the standard non-atomic bit operations rather than the FD_* macros.

This:

 (1) Removes the abuses of struct fd_set:

     (a) Since we don't want to allocate a full fd_set the vast majority of the
     	 time, we actually, in effect, just allocate a just-big-enough array of
     	 unsigned longs and cast it to an fd_set type - so why bother with the
     	 fd_set at all?

     (b) Some places outside of the core fdtable handling code (such as
     	 SELinux) want to look inside the array of unsigned longs hidden inside
     	 the fd_set struct for more efficient iteration over the entire set.

 (2) Eliminates the use of FD_*() macros in the kernel completely.

 (3) Permits the __FD_*() macros to be deleted entirely where not exposed to
     userspace.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/exec.c                |    4 ++--
 fs/file.c                |   46 ++++++++++++++++++++++------------------------
 fs/select.c              |    2 +-
 include/linux/fdtable.h  |   28 ++++++++++------------------
 kernel/exit.c            |    2 +-
 security/selinux/hooks.c |    2 +-
 6 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 22cc38d..cfd5e30 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1026,10 +1026,10 @@ static void flush_old_files(struct files_struct * files)
 		fdt = files_fdtable(files);
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->close_on_exec->fds_bits[j];
+		set = fdt->close_on_exec[j];
 		if (!set)
 			continue;
-		fdt->close_on_exec->fds_bits[j] = 0;
+		fdt->close_on_exec[j] = 0;
 		spin_unlock(&files->file_lock);
 		for ( ; set ; i++,set >>= 1) {
 			if (set & 1) {
diff --git a/fs/file.c b/fs/file.c
index 114fea0..2d479dd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -40,7 +40,7 @@ int sysctl_nr_open_max = 1024 * 1024; /* raised later */
  */
 static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
 
-static void *alloc_fdmem(unsigned int size)
+static void *alloc_fdmem(size_t size)
 {
 	/*
 	 * Very large allocations can stress page reclaim, so fall back to
@@ -142,7 +142,7 @@ static void copy_fdtable(struct fdtable *nfdt, struct fdtable *ofdt)
 static struct fdtable * alloc_fdtable(unsigned int nr)
 {
 	struct fdtable *fdt;
-	char *data;
+	void *data;
 
 	/*
 	 * Figure out how many fds we actually want to support in this fdtable.
@@ -172,14 +172,15 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	data = alloc_fdmem(nr * sizeof(struct file *));
 	if (!data)
 		goto out_fdt;
-	fdt->fd = (struct file **)data;
-	data = alloc_fdmem(max_t(unsigned int,
+	fdt->fd = data;
+
+	data = alloc_fdmem(max_t(size_t,
 				 2 * nr / BITS_PER_BYTE, L1_CACHE_BYTES));
 	if (!data)
 		goto out_arr;
-	fdt->open_fds = (fd_set *)data;
-	data += nr / BITS_PER_BYTE;
-	fdt->close_on_exec = (fd_set *)data;
+	fdt->open_fds = data;
+	data += nr / BITS_PER_LONG;
+	fdt->close_on_exec = data;
 	fdt->next = NULL;
 
 	return fdt;
@@ -275,11 +276,11 @@ static int count_open_files(struct fdtable *fdt)
 	int i;
 
 	/* Find the last open fd */
-	for (i = size/(8*sizeof(long)); i > 0; ) {
-		if (fdt->open_fds->fds_bits[--i])
+	for (i = size / BITS_PER_LONG; i > 0; ) {
+		if (fdt->open_fds[--i])
 			break;
 	}
-	i = (i+1) * 8 * sizeof(long);
+	i = (i + 1) * BITS_PER_LONG;
 	return i;
 }
 
@@ -306,8 +307,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	newf->next_fd = 0;
 	new_fdt = &newf->fdtab;
 	new_fdt->max_fds = NR_OPEN_DEFAULT;
-	new_fdt->close_on_exec = (fd_set *)&newf->close_on_exec_init;
-	new_fdt->open_fds = (fd_set *)&newf->open_fds_init;
+	new_fdt->close_on_exec = newf->close_on_exec_init;
+	new_fdt->open_fds = newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
 	new_fdt->next = NULL;
 
@@ -350,10 +351,8 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	old_fds = old_fdt->fd;
 	new_fds = new_fdt->fd;
 
-	memcpy(new_fdt->open_fds->fds_bits,
-		old_fdt->open_fds->fds_bits, open_files/8);
-	memcpy(new_fdt->close_on_exec->fds_bits,
-		old_fdt->close_on_exec->fds_bits, open_files/8);
+	memcpy(new_fdt->open_fds, old_fdt->open_fds, open_files / 8);
+	memcpy(new_fdt->close_on_exec, old_fdt->close_on_exec, open_files / 8);
 
 	for (i = open_files; i != 0; i--) {
 		struct file *f = *old_fds++;
@@ -379,11 +378,11 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	memset(new_fds, 0, size);
 
 	if (new_fdt->max_fds > open_files) {
-		int left = (new_fdt->max_fds-open_files)/8;
-		int start = open_files / (8 * sizeof(unsigned long));
+		int left = (new_fdt->max_fds - open_files) / 8;
+		int start = open_files / BITS_PER_LONG;
 
-		memset(&new_fdt->open_fds->fds_bits[start], 0, left);
-		memset(&new_fdt->close_on_exec->fds_bits[start], 0, left);
+		memset(&new_fdt->open_fds[start], 0, left);
+		memset(&new_fdt->close_on_exec[start], 0, left);
 	}
 
 	rcu_assign_pointer(newf->fdt, new_fdt);
@@ -419,8 +418,8 @@ struct files_struct init_files = {
 	.fdtab		= {
 		.max_fds	= NR_OPEN_DEFAULT,
 		.fd		= &init_files.fd_array[0],
-		.close_on_exec	= (fd_set *)&init_files.close_on_exec_init,
-		.open_fds	= (fd_set *)&init_files.open_fds_init,
+		.close_on_exec	= init_files.close_on_exec_init,
+		.open_fds	= init_files.open_fds_init,
 	},
 	.file_lock	= __SPIN_LOCK_UNLOCKED(init_task.file_lock),
 };
@@ -443,8 +442,7 @@ repeat:
 		fd = files->next_fd;
 
 	if (fd < fdt->max_fds)
-		fd = find_next_zero_bit(fdt->open_fds->fds_bits,
-					   fdt->max_fds, fd);
+		fd = find_next_zero_bit(fdt->open_fds, fdt->max_fds, fd);
 
 	error = expand_files(files, fd);
 	if (error < 0)
diff --git a/fs/select.c b/fs/select.c
index d33418f..2e7fbe8 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -348,7 +348,7 @@ static int max_select_fd(unsigned long n, fd_set_bits *fds)
 	set = ~(~0UL << (n & (__NFDBITS-1)));
 	n /= __NFDBITS;
 	fdt = files_fdtable(current->files);
-	open_fds = fdt->open_fds->fds_bits+n;
+	open_fds = fdt->open_fds + n;
 	max = 0;
 	if (set) {
 		set &= BITS(fds, n);
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 7675da2..158a41e 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -21,51 +21,43 @@
  */
 #define NR_OPEN_DEFAULT BITS_PER_LONG
 
-/*
- * The embedded_fd_set is a small fd_set,
- * suitable for most tasks (which open <= BITS_PER_LONG files)
- */
-struct embedded_fd_set {
-	unsigned long fds_bits[1];
-};
-
 struct fdtable {
 	unsigned int max_fds;
 	struct file __rcu **fd;      /* current fd array */
-	fd_set *close_on_exec;
-	fd_set *open_fds;
+	unsigned long *close_on_exec;
+	unsigned long *open_fds;
 	struct rcu_head rcu;
 	struct fdtable *next;
 };
 
 static inline void __set_close_on_exec(int fd, struct fdtable *fdt)
 {
-	FD_SET(fd, fdt->close_on_exec);
+	__set_bit(fd, fdt->close_on_exec);
 }
 
 static inline void __clear_close_on_exec(int fd, struct fdtable *fdt)
 {
-	FD_CLR(fd, fdt->close_on_exec);
+	__clear_bit(fd, fdt->close_on_exec);
 }
 
 static inline bool close_on_exec(int fd, const struct fdtable *fdt)
 {
-	return FD_ISSET(fd, fdt->close_on_exec);
+	return test_bit(fd, fdt->close_on_exec);
 }
 
 static inline void __set_open_fd(int fd, struct fdtable *fdt)
 {
-	FD_SET(fd, fdt->open_fds);
+	__set_bit(fd, fdt->open_fds);
 }
 
 static inline void __clear_open_fd(int fd, struct fdtable *fdt)
 {
-	FD_CLR(fd, fdt->open_fds);
+	__clear_bit(fd, fdt->open_fds);
 }
 
 static inline bool fd_is_open(int fd, const struct fdtable *fdt)
 {
-	return FD_ISSET(fd, fdt->open_fds);
+	return test_bit(fd, fdt->open_fds);
 }
 
 /*
@@ -83,8 +75,8 @@ struct files_struct {
    */
 	spinlock_t file_lock ____cacheline_aligned_in_smp;
 	int next_fd;
-	struct embedded_fd_set close_on_exec_init;
-	struct embedded_fd_set open_fds_init;
+	unsigned long close_on_exec_init[1];
+	unsigned long open_fds_init[1];
 	struct file __rcu * fd_array[NR_OPEN_DEFAULT];
 };
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 4b4042f..4db0200 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -473,7 +473,7 @@ static void close_files(struct files_struct * files)
 		i = j * __NFDBITS;
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j++];
+		set = fdt->open_fds[j++];
 		while (set) {
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6a3683e..421c990 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2145,7 +2145,7 @@ static inline void flush_unauthorized_files(const struct cred *cred,
 		fdt = files_fdtable(files);
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j];
+		set = fdt->open_fds[j];
 		if (!set)
 			continue;
 		spin_unlock(&files->file_lock);

