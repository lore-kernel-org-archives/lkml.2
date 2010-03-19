Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0CSNQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 09:16:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab0CSNQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 09:16:29 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v5] tracepoint: Add signal coredump tracepoint
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 19 Mar 2010 09:23:46 -0400
Message-ID: <20100319132346.31144.40337.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add signal coredump tracepoint which shows signal number,
mm->flags, core file size limitation, the result of
coredump, and core file name.

This tracepoint requirement comes mainly from the viewpoint of
administrators. Since now we have introduced many coredump
configurations (e.g. dumpable, coredump_filter, core_pattern,
etc) and some of them can be modified by users, it will be hard
to know what was actually dumped (or not dumped) after some
problem happened on the system. For example, a process didn't
generated core, coredump doesn't have some sections, etc.
In those cases, the coredump tracepoint can help us to know
why the core file is so big or small, or not generated, by
recording all configurations for all processes on the system.
That will reduce system-administration cost.

Changes in v5:
 - Just update against the latest -tip.

Changes in v4:
 - Rename limit trace-argument to core_size_limit.

Changes in v3:
 - Move tracepoint at the end of do_coredump() for tracing
   the result of coredump.
 - Use retval to record error-code at every failure points
   for passing the result of coredump to tracepoint.
 - Trace retval instead of cprm->file for recording the
   result of coredump.

Changes in v2:
 - Fix a bug to clear file local variable when
   call_usermodehelper_pipe() is failed.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---

 fs/exec.c                     |   58 ++++++++++++++++++++++++++++++-----------
 include/trace/events/signal.h |   48 ++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 49cdaa1..b6bdf00 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/fsnotify.h>
 #include <linux/fs_struct.h>
 #include <linux/pipe_fs_i.h>
+#include <trace/events/signal.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1787,7 +1788,7 @@ static void wait_for_dump_helpers(struct file *file)
 void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 {
 	struct core_state core_state;
-	char corename[CORENAME_MAX_SIZE + 1];
+	char corename[CORENAME_MAX_SIZE + 1] = "";
 	struct mm_struct *mm = current->mm;
 	struct linux_binfmt * binfmt;
 	struct inode * inode;
@@ -1802,6 +1803,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.signr = signr,
+		.file = NULL,
 		.regs = regs,
 		.limit = rlimit(RLIMIT_CORE),
 		/*
@@ -1815,8 +1817,10 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	audit_core_dumps(signr);
 
 	binfmt = mm->binfmt;
-	if (!binfmt || !binfmt->core_dump)
+	if (!binfmt || !binfmt->core_dump) {
+		retval = -ENOSYS;
 		goto fail;
+	}
 
 	cred = prepare_creds();
 	if (!cred) {
@@ -1829,6 +1833,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	 * If another thread got here first, or we are not dumpable, bail out.
 	 */
 	if (mm->core_state || !__get_dumpable(cprm.mm_flags)) {
+		/* This is not an error. retval should be 0 */
 		up_write(&mm->mmap_sem);
 		put_cred(cred);
 		goto fail;
@@ -1867,11 +1872,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 	ispipe = format_corename(corename, signr);
 	unlock_kernel();
 
-	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
+	if ((!ispipe) && (cprm.limit < binfmt->min_coredump)) {
+		retval = -EFBIG;
 		goto fail_unlock;
+	}
 
  	if (ispipe) {
 		if (cprm.limit == 0) {
+			retval = -EINVAL;
 			/*
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
@@ -1895,6 +1903,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 		dump_count = atomic_inc_return(&core_dump_count);
 		if (core_pipe_limit && (core_pipe_limit < dump_count)) {
+			retval = -EFBIG;
 			printk(KERN_WARNING "Pid %d(%s) over core_pipe_limit\n",
 			       task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Skipping core dump\n");
@@ -1903,6 +1912,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 
 		helper_argv = argv_split(GFP_KERNEL, corename+1, &helper_argc);
 		if (!helper_argv) {
+			retval = -ENOMEM;
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_dropcount;
@@ -1911,8 +1921,9 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		cprm.limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
-		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
-				&cprm.file)) {
+		retval = call_usermodehelper_pipe(helper_argv[0], helper_argv,
+						  NULL, &cprm.file);
+		if (retval < 0) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
 			goto fail_dropcount;
@@ -1921,32 +1932,44 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
 		cprm.file = filp_open(corename,
 				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
 				 0600);
-	if (IS_ERR(cprm.file))
+	if (IS_ERR(cprm.file)) {
+		retval = (int)PTR_ERR(cprm.file);
 		goto fail_dropcount;
+	}
 	inode = cprm.file->f_path.dentry->d_inode;
-	if (inode->i_nlink > 1)
+	if (inode->i_nlink > 1) {
+		retval = -EMLINK;
 		goto close_fail;	/* multiple links - don't dump */
-	if (!ispipe && d_unhashed(cprm.file->f_path.dentry))
+	}
+	if (!ispipe && d_unhashed(cprm.file->f_path.dentry)) {
+		retval = -EBADF;
 		goto close_fail;
+	}
 
 	/* AK: actually i see no reason to not allow this for named pipes etc.,
 	   but keep the previous behaviour for now. */
-	if (!ispipe && !S_ISREG(inode->i_mode))
+	if (!ispipe && !S_ISREG(inode->i_mode)) {
+		retval = -EBADF;
 		goto close_fail;
+	}
 	/*
 	 * Dont allow local users get cute and trick others to coredump
 	 * into their pre-created files:
 	 * Note, this is not relevant for pipes
 	 */
-	if (!ispipe && (inode->i_uid != current_fsuid()))
+	if (!ispipe && (inode->i_uid != current_fsuid())) {
+		retval = -EPERM;
 		goto close_fail;
-	if (!cprm.file->f_op)
-		goto close_fail;
-	if (!cprm.file->f_op->write)
-		goto close_fail;
-	if (!ispipe &&
-	    do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file) != 0)
+	}
+	if (!cprm.file->f_op || !cprm.file->f_op->write) {
+		retval = -EINVAL;
 		goto close_fail;
+	}
+	if (!ispipe) {
+		retval = do_truncate(cprm.file->f_path.dentry, 0, 0, cprm.file);
+		if (retval != 0)
+			goto close_fail;
+	}
 
 	retval = binfmt->core_dump(&cprm);
 
@@ -1967,5 +1990,8 @@ fail_unlock:
 	put_cred(cred);
 	coredump_finish(mm);
 fail:
+	/* Trace coredump parameters and return value */
+	trace_signal_coredump(&cprm, corename, retval);
+
 	return;
 }
diff --git a/include/trace/events/signal.h b/include/trace/events/signal.h
index a510b75..6dbc856 100644
--- a/include/trace/events/signal.h
+++ b/include/trace/events/signal.h
@@ -4,8 +4,10 @@
 #if !defined(_TRACE_SIGNAL_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_SIGNAL_H
 
+#include <linux/err.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/binfmts.h>
 #include <linux/tracepoint.h>
 
 #define TP_STORE_SIGINFO(__entry, info)				\
@@ -167,6 +169,52 @@ TRACE_EVENT(signal_lose_info,
 	TP_printk("sig=%d group=%d errno=%d code=%d",
 		  __entry->sig, __entry->group, __entry->errno, __entry->code)
 );
+
+/**
+ * signal_coredump - called when dumping core by signal
+ * @cprm: pointer to struct coredump_params
+ * @core_name: core-name string
+ * @retval: return value of binfmt->coredump or error-code
+ *
+ * Current process dumps core file to 'core_name' file, because 'cprm->signr'
+ * signal is delivered.
+ * 'retval' is an error code or 0/1. retval == 1 means the core file was
+ * dumped successfully and retval == 0 means binfmt->coredump failed to dump.
+ * If retval < 0, this means do_coredump() failed to dump core file before
+ * calling binfmt->coredump.
+ */
+TRACE_EVENT(signal_coredump,
+
+	TP_PROTO(struct coredump_params *cprm, const char *core_name,
+		 int retval),
+
+	TP_ARGS(cprm, core_name, retval),
+
+	TP_STRUCT__entry(
+		__field(	int,		sig		)
+		__field(	unsigned long,	core_size_limit	)
+		__field(	unsigned long,	flags		)
+		__field(	int,		retval		)
+		__string(	name,		core_name	)
+	),
+
+
+	TP_fast_assign(
+		__entry->sig			= (int)cprm->signr;
+		__entry->core_size_limit	= cprm->limit;
+		__entry->flags			= cprm->mm_flags;
+		__entry->retval			= retval;
+		__assign_str(name,		core_name);
+	),
+
+	TP_printk("sig=%d core_size_limit=%lu dumpable=0x%lx dump_filter=0x%lx"
+		  " corename=\"%s\" retval=%d",
+		  __entry->sig, __entry->core_size_limit,
+		  __entry->flags & MMF_DUMPABLE_MASK,
+		  (__entry->flags & MMF_DUMP_FILTER_MASK) >>
+		  MMF_DUMP_FILTER_SHIFT,
+		  __get_str(name), __entry->retval)
+);
 #endif /* _TRACE_SIGNAL_H */
 
 /* This part must be outside protection */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
