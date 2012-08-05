Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2HESml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 14:42:41 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34117 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab2HESmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 14:42:38 -0400
Date: Sun, 5 Aug 2012 11:39:56 -0700
From: Kees Cook <keescook@chromium.org>
To: Alex Kelly <alex.page.kelly@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [NAK] Re: [PATCHv3 1/4] fs: Move core dump functionality into its
 own file
Message-ID: <20120805183956.GE28340@outflux.net>
References: <1344027800-8270-1-git-send-email-eshink@gmail.com>
 <1344165521-14200-1-git-send-email-alex.page.kelly@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344165521-14200-1-git-send-email-alex.page.kelly@gmail.com>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Overall, this seems like a fine idea. However, I think the code move
has gone very badly. Comments are mismatched, there are typos added,
formatting changed, case changed, trailing white space added, and
punctuation dropped.

NAKed-by: Kees Cook <keescook@chromium.org>

On Sun, Aug 05, 2012 at 04:18:38AM -0700, Alex Kelly wrote:
> +/* The maximal length of core_pattern is also specified in sysctl.c */
> +static int zap_process(struct task_struct *start, int exit_code)

These two lines have nothing to do with each other. This comment belongs
with "char core_pattern[CORENAME_MAX_SIZE] = "core";", IIUC.

Why is zap_process not with the zap_threads helpers?

> +void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> +[...]
> +	 * so we dump it as root in mode 2, and onlt into a controlled

"onlt"? The removed code didn't have this typo. Was the moved code
not cut/pasted? That got my attention. In fact, I went and compared
all the code that was moved, and this was not the only change -- what
happened here?

--- /tmp/del.code	2012-08-05 11:32:36.602881193 -0700
+++ /tmp/add.code	2012-08-05 11:33:06.615270285 -0700
@@ -327,7 +328,7 @@
 		core_waiters = zap_threads(tsk, mm, core_state, exit_code);
 	up_write(&mm->mmap_sem);
 
-	if (core_waiters > 0) {
+	if (core_waiters > 0){
 		struct core_thread *ptr;
 
 		wait_for_completion(&core_state->startup);
@@ -466,8 +467,8 @@
 	/*
 	 * We cannot trust fsuid as being the "true" uid of the process
 	 * nor do we know its entire history. We only know it was tainted
-	 * so we dump it as root in mode 2, and only into a controlled
-	 * environment (pipe handler or fully qualified path).
+	 * so we dump it as root in mode 2, and onlt into a controlled
+	 * environment (pipe handler or fully qualified path)
 	 */
 	if (__get_dumpable(cprm.mm_flags) == SUID_DUMPABLE_SAFE) {
 		/* Setuid core dump mode */
@@ -505,11 +506,11 @@
 			 *
 			 * Normally core limits are irrelevant to pipes, since
 			 * we're not writing to the file system, but we use
-			 * cprm.limit of 1 here as a speacial value, this is a
+			 * cprm.limit of 1 here as a speacial value, this is a 
 			 * consistent way to catch recursive crashes.
 			 * We can still crash if the core_pattern binary sets
 			 * RLIM_CORE = !1, but it runs as root, and can do
-			 * lots of stupid things.
+			 * lots of stupid things
 			 *
 			 * Note that we use task_tgid_vnr here to grab the pid
 			 * of the process group leader.  That way we get the
@@ -556,7 +557,7 @@
 
 		if (need_nonrelative && cn.corename[0] != '/') {
 			printk(KERN_WARNING "Pid %d(%s) can only dump core "\
-				"to fully qualified path!\n",
+				"To fully qualified path!\n",
 				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Skipping core dump\n");
 			goto fail_unlock;


-Kees

-- 
Kees Cook                                            @outflux.net
