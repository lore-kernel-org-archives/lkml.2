Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965022Ab2JWUgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:36:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60441 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964982Ab2JWUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:36:23 -0400
Date: Tue, 23 Oct 2012 21:36:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and
 GENERIC_KERNEL_EXECVE
Message-ID: <20121023203620.GA2616@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
 <20121019213548.GR2616@ZenIV.linux.org.uk>
 <5082A1F1.3080303@tilera.com>
 <20121020153401.GT2616@ZenIV.linux.org.uk>
 <20121020171643.GU2616@ZenIV.linux.org.uk>
 <5086D432.4070008@tilera.com>
 <20121023184122.GZ2616@ZenIV.linux.org.uk>
 <5086EE7C.2080608@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5086EE7C.2080608@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:22:36PM -0400, Chris Metcalf wrote:
> On 10/23/2012 2:41 PM, Al Viro wrote:
> > On Tue, Oct 23, 2012 at 01:30:26PM -0400, Chris Metcalf wrote:
> >> As you had suggested in an earlier email, I went ahead and eliminated the
> >> special pt_regs handling for sigaltstack, rt_sigreturn, and clone.  (Also a
> >> tilepro-specific syscall that was also using PTREG_SYSCALL.)  I'll send it
> >> separately and you can include it in your tree if you like.
> > OK by me...  Or just pull this arch-tile into a separate branch in your
> > tree, add commit on top of it and I'll pull that.
> 
> Done in 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git viro-signal-tile

Argh...  That's exactly the reason why I would like to get amending commits -
you've done that commit on top of the identical tree, but without your
Acked-by on the last commit.  Result: merge conflict ;-/

Could you test the following on top of your patch?  It gets rid of
regs use in sys_clone() *and* of the regs argument in copy_thread().
If that work (including SMP - note that it changes the path taken
by copy_thread() when called by fork_idle()), that should be all
we'll need in arch/tile for killing idle_regs() and killing the pt_regs
passing to do_fork()/copy_process()/copy_thread().

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 6e7fb4e..1c20029 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -158,7 +158,7 @@ static void save_arch_state(struct thread_struct *t);
 
 int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long arg,
-		struct task_struct *p, struct pt_regs *regs)
+		struct task_struct *p, struct pt_regs *unused)
 {
 	struct pt_regs *childregs = task_pt_regs(p);
 	unsigned long ksp;
@@ -184,7 +184,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	/* Record the pid of the task that created this one. */
 	p->thread.creator_pid = current->pid;
 
-	if (unlikely(!regs)) {
+	if (unlikely(p->flags & PF_KTHREAD)) {
 		/* kernel thread */
 		memset(childregs, 0, sizeof(struct pt_regs));
 		memset(&callee_regs[2], 0,
@@ -208,25 +208,26 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	 */
 	task_thread_info(p)->step_state = NULL;
 
-	/* Save user stack top pointer so we can ID the stack vm area later. */
-	p->thread.usp0 = sp;
-
 	/*
 	 * Copy the registers onto the kernel stack so the
 	 * return-from-interrupt code will reload it into registers.
 	 */
-	*childregs = *regs;
+	*childregs = *current_pt_regs();
 	childregs->regs[0] = 0;         /* return value is zero */
-	childregs->sp = sp;  /* override with new user stack pointer */
-	memcpy(callee_regs, &regs->regs[CALLEE_SAVED_FIRST_REG],
+	if (sp)
+		childregs->sp = sp;  /* override with new user stack pointer */
+	memcpy(callee_regs, &childregs->regs[CALLEE_SAVED_FIRST_REG],
 	       CALLEE_SAVED_REGS_COUNT * sizeof(unsigned long));
 
+	/* Save user stack top pointer so we can ID the stack vm area later. */
+	p->thread.usp0 = childregs->sp;
+
 	/*
 	 * If CLONE_SETTLS is set, set "tp" in the new task to "r4",
 	 * which is passed in as arg #5 to sys_clone().
 	 */
 	if (clone_flags & CLONE_SETTLS)
-		childregs->tp = regs->regs[4];
+		childregs->tp = childregs->regs[4];
 
 
 #if CHIP_HAS_TILE_DMA()
@@ -587,10 +588,7 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 SYSCALL_DEFINE4(clone, unsigned long, clone_flags, unsigned long, newsp,
 		void __user *, parent_tidptr, void __user *, child_tidptr)
 {
-	struct pt_regs *regs = current_pt_regs();
-	if (!newsp)
-		newsp = regs->sp;
-	return do_fork(clone_flags, newsp, regs, 0,
+	return do_fork(clone_flags, newsp, current_pt_regs(), 0,
 		       parent_tidptr, child_tidptr);
 }
 
