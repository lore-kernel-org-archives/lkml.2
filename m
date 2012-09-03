Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2ICQ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:59:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab2ICQ7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:59:52 -0400
Date: Mon, 3 Sep 2012 19:02:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] semantics of singlestepping vs. tracer exiting
Message-ID: <20120903170215.GA13266@redhat.com>
References: <20120903001436.GG23464@ZenIV.linux.org.uk> <20120903160538.GA10114@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20120903160538.GA10114@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 09/03, Oleg Nesterov wrote:
>
> This is another reason to move enable/disable step into ptrace_stop().
> And in fact I had the patches a loong ago, but we need to cleanup
> the usage of PT_SINGLESTEP/PT_BLOCKSTEP first. The tracer should
> simply set/clear these PT_ flags and resume the tracee which should
> check them and do user_*_single_step() in response.

Found these patches, see the attachments.... And this also fixes the
problems with DEBUGCTLMSR_BTF.

The patches should be re-diffed, but I need to recall why I didn't
send them, perhaps I noticed some problem...

Oleg.

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1_use_PT_STEP.patch"

[PATCH 1/3] ptrace_resume: set/clear PT_SINGLESTEP/PT_BLOCKSTEP

Contrary to the comment in ptrace.h, PT_SINGLESTEP is only used on
arch/xtensa, and PT_BLOCKSTEP is not used at all.

Change the arch independent ptrace_resume() to set/clear these bits
before user_enable_*_step/user_disable_single_step() and remove this
this code from arch/xtensa/kernel/ptrace.c.

Also change ptrace_init_task() to prevent the copying of these bits.

This doesn't make any difference on xtensa, and other arches do not
use these flags so far.

But, thereafter we can check task->ptrace & PT_*STEP to figure out if
this tracer wants the stepping and unlike TIF_SINGLESTEP it is always
correct in this sense and it is not arch dependent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h      |    4 ++--
 kernel/ptrace.c             |    3 +++
 arch/xtensa/kernel/ptrace.c |    2 --
 3 files changed, 5 insertions(+), 4 deletions(-)

--- ptrace/include/linux/ptrace.h~1_use_PT_STEP	2011-06-28 17:50:27.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-07-03 21:55:17.000000000 +0200
@@ -104,7 +104,6 @@
 
 #define PT_TRACE_MASK	0x000003f4
 
-/* single stepping state bits (used on ARM and PA-RISC) */
 #define PT_SINGLESTEP_BIT	31
 #define PT_SINGLESTEP		(1<<PT_SINGLESTEP_BIT)
 #define PT_BLOCKSTEP_BIT	30
@@ -220,7 +219,8 @@ static inline void ptrace_init_task(stru
 	child->parent = child->real_parent;
 	child->ptrace = 0;
 	if (unlikely(ptrace) && (current->ptrace & PT_PTRACED)) {
-		child->ptrace = current->ptrace;
+		child->ptrace = current->ptrace &
+				~(PT_SINGLESTEP | PT_BLOCKSTEP);
 		__ptrace_link(child, current->parent);
 	}
 
--- ptrace/kernel/ptrace.c~1_use_PT_STEP	2011-06-28 17:50:27.000000000 +0200
+++ ptrace/kernel/ptrace.c	2011-07-03 21:55:17.000000000 +0200
@@ -599,13 +599,16 @@ static int ptrace_resume(struct task_str
 		clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
 
+	child->ptrace &= ~(PT_SINGLESTEP | PT_BLOCKSTEP);
 	if (is_singleblock(request)) {
 		if (unlikely(!arch_has_block_step()))
 			return -EIO;
+		child->ptrace |= PT_BLOCKSTEP;
 		user_enable_block_step(child);
 	} else if (is_singlestep(request) || is_sysemu_singlestep(request)) {
 		if (unlikely(!arch_has_single_step()))
 			return -EIO;
+		child->ptrace |= PT_SINGLESTEP;
 		user_enable_single_step(child);
 	} else {
 		user_disable_single_step(child);
--- ptrace/arch/xtensa/kernel/ptrace.c~1_use_PT_STEP	2011-04-06 21:33:43.000000000 +0200
+++ ptrace/arch/xtensa/kernel/ptrace.c	2011-07-03 20:30:57.000000000 +0200
@@ -33,12 +33,10 @@
 
 void user_enable_single_step(struct task_struct *child)
 {
-	child->ptrace |= PT_SINGLESTEP;
 }
 
 void user_disable_single_step(struct task_struct *child)
 {
-	child->ptrace &= ~PT_SINGLESTEP;
 }
 
 /*

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2_ptrace_finish_resume.patch"

[PATCH 2/3] ptrace: shift user_*_step() from ptrace_resume() to ptrace_stop() path

Ignoring the buggy PTRACE_KILL, ptrace_resume() calls user_*_step()
when the tracee sleeps in ptrace_stop(). Now that ptrace_resume()
sets PT_SINGLE* flags, we can reassign user_*_step() from the tracer
to the tracee.

Introduce ptrace_finish_stop(), it is called by ptrace_stop() after
schedule(). Move user_*_step() call sites from ptrace_resume() to
ptrace_finish_stop().

This way:

	- we can remove user_disable_single_step() from detach paths.
	
	  This is the main motivation, we can implement asynchronous
	  detach.

	- this makes the detach-on-exit more correct, we do not leak
	  TIF_SINGLESTEP if the tracer dies.

	- user_enable_*_step(tsk) can be implemented more efficiently
	  if tsk == current, we can avoid access_process_vm().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |    1 +
 kernel/signal.c        |    1 +
 kernel/ptrace.c        |   16 ++++++++++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

--- ptrace/include/linux/ptrace.h~2_ptrace_finish_resume	2011-07-03 21:55:17.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-07-03 21:55:37.000000000 +0200
@@ -112,6 +112,7 @@
 #include <linux/compiler.h>		/* For unlikely.  */
 #include <linux/sched.h>		/* For struct task_struct.  */
 
+extern void ptrace_finish_stop(void);
 
 extern long arch_ptrace(struct task_struct *child, long request,
 			unsigned long addr, unsigned long data);
--- ptrace/kernel/signal.c~2_ptrace_finish_resume	2011-07-03 21:55:17.000000000 +0200
+++ ptrace/kernel/signal.c	2011-07-03 21:55:37.000000000 +0200
@@ -1879,6 +1879,7 @@ static void ptrace_stop(int exit_code, i
 	 */
 	try_to_freeze();
 
+	ptrace_finish_stop();
 	/*
 	 * We are back.  Now reacquire the siglock before touching
 	 * last_siginfo, so that we are sure to have synchronized with
--- ptrace/kernel/ptrace.c~2_ptrace_finish_resume	2011-07-03 21:55:17.000000000 +0200
+++ ptrace/kernel/ptrace.c	2011-07-03 21:55:37.000000000 +0200
@@ -581,6 +581,18 @@ static int ptrace_setsiginfo(struct task
 #define is_sysemu_singlestep(request)	0
 #endif
 
+void ptrace_finish_stop(void)
+{
+	struct task_struct *task = current;
+
+	if (task->ptrace & PT_BLOCKSTEP)
+		user_enable_block_step(task);
+	else if (task->ptrace & PT_SINGLESTEP)
+		user_enable_single_step(task);
+	else
+		user_disable_single_step(task);
+}
+
 static int ptrace_resume(struct task_struct *child, long request,
 			 unsigned long data)
 {
@@ -604,14 +616,10 @@ static int ptrace_resume(struct task_str
 		if (unlikely(!arch_has_block_step()))
 			return -EIO;
 		child->ptrace |= PT_BLOCKSTEP;
-		user_enable_block_step(child);
 	} else if (is_singlestep(request) || is_sysemu_singlestep(request)) {
 		if (unlikely(!arch_has_single_step()))
 			return -EIO;
 		child->ptrace |= PT_SINGLESTEP;
-		user_enable_single_step(child);
-	} else {
-		user_disable_single_step(child);
 	}
 
 	child->exit_code = data;

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3_detach_dont_disable_step.patch"

[PATCH 3/3] x86: remove ptrace_disable()->user_disable_single_step()

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 arch/x86/kernel/ptrace.c |    1 -
 1 file changed, 1 deletion(-)

--- ptrace/arch/x86/kernel/ptrace.c~3_detach_dont_disable_step	2011-06-07 19:20:02.000000000 +0200
+++ ptrace/arch/x86/kernel/ptrace.c	2011-07-03 21:56:42.000000000 +0200
@@ -807,7 +807,6 @@ static int ioperm_get(struct task_struct
  */
 void ptrace_disable(struct task_struct *child)
 {
-	user_disable_single_step(child);
 #ifdef TIF_SYSCALL_EMU
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif

--h31gzZEtNLTqOjlF--

