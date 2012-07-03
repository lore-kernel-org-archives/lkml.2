Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab2GCAjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:39:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56595 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab2GCAjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:39:43 -0400
From: Alex Kelly <alex.page.kelly@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Josh Triplett <josh@joshtriplett.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, WANG Cong <amwang@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Nikhil Rao <ncrao@google.com>,
        Dan Ballard <dan@mindstab.net>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alex <eshink@gmail.com>
Subject: [PATCH 2/2] Made core dump functionality optional
Date: Mon,  2 Jul 2012 17:38:14 -0700
Message-Id: <1341275894-9737-2-git-send-email-alex.page.kelly@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
References: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex <eshink@gmail.com>

Adds an expert Kconfig option, CONFIG_COREDUMP, which allows disabling of core dump.
This saves approximately 2.6k in the compiled kernel, and complements CONFIG_ELF_CORE,
which now depends on it.

CONFIG_COREDUMP also disables coredump-related sysctls, except for suid_dumpable and
related functions, which are necessary for ptrace.

Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/Kconfig.binfmt       |    8 ++++++++
 fs/Makefile             |    3 ++-
 include/linux/binfmts.h |    4 ++++
 init/Kconfig            |    1 +
 kernel/sysctl.c         |    6 +++++-
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index e95d1b6..9393950 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -164,3 +164,11 @@ config BINFMT_MISC
 	  You may say M here for module support and later load the module when
 	  you have use for it; the module is called binfmt_misc. If you
 	  don't know what to answer at this point, say Y.
+
+config COREDUMP
+	bool "Enable core dump support" if EXPERT
+	default y
+	help
+	  This option enables support for performing core dumps. You almost
+	  certainly want to say Y here. Not necessary on systems that never
+	  need debugging or only ever run flawless code.
diff --git a/fs/Makefile b/fs/Makefile
index 6b73194..7114734 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o coredump.o
+		stack.o fs_struct.o statfs.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
@@ -48,6 +48,7 @@ obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
+obj-$(CONFIG_COREDUMP)		+= coredump.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 0092102..9a9d0cb 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -132,7 +132,11 @@ extern int copy_strings_kernel(int argc, const char *const *argv,
 			       struct linux_binprm *bprm);
 extern int prepare_bprm_creds(struct linux_binprm *bprm);
 extern void install_exec_creds(struct linux_binprm *bprm);
+#ifdef CONFIG_COREDUMP
 extern void do_coredump(long signr, int exit_code, struct pt_regs *regs);
+#else
+static inline void do_coredump(long signr, int exit_code, struct pt_regs *regs) {}
+#endif
 extern void set_binfmt(struct linux_binfmt *new);
 extern void free_bprm(struct linux_binprm *);
 
diff --git a/init/Kconfig b/init/Kconfig
index 3f42cd6..0562422 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1051,6 +1051,7 @@ config BUG
           Just say Y.
 
 config ELF_CORE
+	depends on COREDUMP
 	default y
 	bool "Enable ELF core dumps" if EXPERT
 	help
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f03a6ef..3cd5b75 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -91,10 +91,12 @@
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
 extern int max_threads;
-extern int core_uses_pid;
 extern int suid_dumpable;
+#ifdef CONFIG_COREDUMP
+extern int core_uses_pid;
 extern char core_pattern[];
 extern unsigned int core_pipe_limit;
+#endif
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
@@ -408,6 +410,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#ifdef CONFIG_COREDUMP
 	{
 		.procname	= "core_uses_pid",
 		.data		= &core_uses_pid,
@@ -429,6 +432,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#endif
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
-- 
1.7.10.2

