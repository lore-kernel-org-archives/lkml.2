Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796Ab2EXQLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:11:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39947 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451Ab2EXQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:11:42 -0400
Date: Thu, 24 May 2012 17:11:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Drewry <wad@chromium.org>
Cc: wade_farnsworth@mentor.com, stevenrwalter@gmail.com, will.deacon@arm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: New ARM asm/syscall.h incompatible? (commit
	bf2c9f9866928df60157bc4f1ab39f93a32c754e)
Message-ID: <20120524161130.GE6908@n2100.arm.linux.org.uk>
References: <CABqD9hao8sYHimbs1SjT3uRiht2ACnS8TMPyUnPt7AMrM3kVGA@mail.gmail.com> <20120523185610.GB6908@n2100.arm.linux.org.uk> <CABqD9hah+26ZNJ8OsvSUFSx-dnxekTSLCkUf-8QXQqZ+mn6kmg@mail.gmail.com> <20120523191439.GC6908@n2100.arm.linux.org.uk> <CABqD9hbsnCL=vHpsE3HNmiB-Qv0DyhWpq5KCN0USWDm8m-6=RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABqD9hbsnCL=vHpsE3HNmiB-Qv0DyhWpq5KCN0USWDm8m-6=RA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:39:38AM -0500, Will Drewry wrote:
> On Wed, May 23, 2012 at 2:14 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Wed, May 23, 2012 at 02:04:20PM -0500, Will Drewry wrote:
> >> I'm still curious if it wouldn't make more sense to handle the
> >> sys_syscall special case prior to any cross-arch (slowpath) code
> >> involvement rather than truncating the 7th parameter making
> >> sys_syscall a second class citizen for those cross-arch paths.
> >
> > It would mean making sys_syscall an explicit special case in the fast
> > path of syscall entry, which we really don't want to do.  It _is_ a
> > standard syscall, it just happens to have 7 arguments which are
> > rewritten back to what the syscall actually expects.
> >
> > As I say, the alternative would be to explicitly test for the syscall
> > number in the fast path of system call entry and branch away to deal
> > with it.  Adding unnecessary instructions to this fast path for such
> > a special case when there's already a perfectly reasonable alternative
> > solution doesn't fill me with any joy.
> 
> I'd been picturing this as being done exclusively after the slow-path
> is triggered, in __sys_trace or syscall_trace(), but perhaps I'm
> missing something that makes that untenable.

Well, I think the first thing which can be done is to move the seccomp
stuff out of the fast path, and combine it with the tracing code - like
this:

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 0f04d84..5006374 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -148,24 +148,25 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
 #define TIF_SYSCALL_AUDIT	9
+#define TIF_SECCOMP		10
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
-#define TIF_SECCOMP		21
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
+#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-#define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 
 /* Checks for any syscall work in entry-common.S */
-#define _TIF_SYSCALL_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT)
+#define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT)
+#define _TIF_SYSCALL_SLOW	(_TIF_SYSCALL_WORK | _TIF_SECCOMP)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 54ee265..2fa4e85 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -442,19 +442,10 @@ ENTRY(vector_swi)
 	ldr	r10, [tsk, #TI_FLAGS]		@ check for syscall tracing
 	stmdb	sp!, {r4, r5}			@ push fifth and sixth args
 
-#ifdef CONFIG_SECCOMP
-	tst	r10, #_TIF_SECCOMP
-	beq	1f
-	mov	r0, scno
-	bl	__secure_computing	
-	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
-	ldmia	r0, {r0 - r3}			@ have to reload r0 - r3
-1:
-#endif
-
-	tst	r10, #_TIF_SYSCALL_WORK		@ are we tracing syscalls?
-	bne	__sys_trace
+	tst	r10, #_TIF_SYSCALL_SLOW
+	bne	__sys_slow			@ slow path for syscalls
 
+__sys_fast:
 	cmp	scno, #NR_syscalls		@ check upper syscall limit
 	adr	lr, BSYM(ret_fast_syscall)	@ return address
 	ldrcc	pc, [tbl, scno, lsl #2]		@ call sys_* routine
@@ -467,6 +458,18 @@ ENTRY(vector_swi)
 	b	sys_ni_syscall			@ not private func
 ENDPROC(vector_swi)
 
+
+__sys_slow:
+	tst	r10, #_TIF_SECCOMP
+	beq	__sys_trace
+
+	bl	__secure_computing
+	add	r0, sp, #S_R0 + S_OFF		@ pointer to regs
+	ldmia	r0, {r0 - r3}
+
+	tst	r10, #_TIF_SYSCALL_WORK
+	beq	__sys_fast
+
 	/*
 	 * This is the really slow path.  We're going to be doing
 	 * context switches, and waiting for our parent to respond.


Now, we could add code just after __sys_slow to check for __NR_syscall,
but to do that we need to first check whether it was an OABI syscall.
(EABI doesn't use __NR_syscall at all).  We currently don't have access
to that at this point in the processing.

Then we'd need to check whether scno told is that it was __NR_syscall.
And if it was, then we can read the system call number from r0 for
seccomp.  Great, that allows OABI programs to use sys_syscall() to
call the permitted seccomp syscalls.  (Was anyone complaining this
doesn't work?)

Now, at this point, we need to consider what to do about the the
syscall tracing code.  As you've realised, they read the registers
directly off the kernel stack as they were saved at entry.  To
"fix" this for __sys_syscall.

You couldn't pass a pt_regs pointer shifted by the appropriate amount,
because that makes things like ORIG_r0 and sp, lr, pc all wrong.  So,
you'd have to read all the existing stacked register state, and re-stack
it to create a faked pt_regs structure for the syscall.

You'd then have to undo all that when you exit the syscall, before you
start thinking about doing any signal handling...

And now consider what state a debugger is going to read through ptrace,
which would continue to accesses the as-stacked-at-entry register set,
not the hacked up set.  Things like ptrace will have lost the information
that it's a sys_syscall call to know that they have to shuffle the args.

So, all round, this is really not nice.

I really don't see the point of adding all this complexity to the kernel,
which makes the existing code paths _much_ more complex just to give
ftrace/tracehook an easier time.
