Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082Ab2IYMGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:06:12 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42319 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab2IYMGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:06:09 -0400
Date: Tue, 25 Sep 2012 14:06:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120925120549.GC2310@somewhere.redhat.com>
References: <20120922155613.GB2934@linux.vnet.ibm.com>
 <505DFA65.3080805@gmail.com>
 <20120922212735.GG2934@linux.vnet.ibm.com>
 <20120923002105.GA1112@linux.vnet.ibm.com>
 <505EA09B.6040105@gmail.com>
 <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
 <5060E31B.3070203@gmail.com>
 <5060E498.7030003@gmail.com>
 <CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
 <5060E863.6020006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5060E863.6020006@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:10:27AM +0200, Sasha Levin wrote:
> On 09/25/2012 01:06 AM, Frederic Weisbecker wrote:
> > 2012/9/25 Sasha Levin <levinsasha928@gmail.com>:
> >> On 09/25/2012 12:47 AM, Sasha Levin wrote:
> >>>  - While I no longer see the warnings I've originally noticed, if I run with Paul's last debug patch I see the following warning:
> >>
> >> Correction: Original warnings are still there, they just got buried in the huge spew that was caused by additional debug warnings
> >> so I've missed them initially.
> > 
> > Are they the same? Could you send me your dmesg?
> > 
> > Thanks.
> > 
> 
> Log is attached, you can go directly to 168.703017 when the warnings begin.

Sasha, sorry to burden you with more testing request.
Could you please try out this new branch? It includes some fixes after Wu Fenguang and
Dan Carpenter reports (not related to your warnings though) and a patch on the top
of the pile to ensure I diagnosed well the problem, which return immediately from
rcu_user_*() APIs if we are in an interrupt.

This way we'll have a clearer view. I also would like to know if there are other
problems with the rcu user mode.

Thanks!

Branch is:

git://github.com/fweisbec/linux-dynticks.git
	rcu/idle-for-v3.7-take4

Diff is:

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index cb20776..3789675 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -232,8 +232,8 @@ DO_ERROR_INFO(X86_TRAP_AC, SIGBUS, "alignment check", alignment_check,
 dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
 {
 	exception_enter(regs);
-	if (!notify_die(DIE_TRAP, "stack segment", regs, error_code,
-		       X86_TRAP_SS, SIGBUS) == NOTIFY_STOP) {
+	if (notify_die(DIE_TRAP, "stack segment", regs, error_code,
+		       X86_TRAP_SS, SIGBUS) != NOTIFY_STOP) {
 		preempt_conditional_sti(regs);
 		do_trap(X86_TRAP_SS, SIGBUS, "stack segment", regs, error_code, NULL);
 		preempt_conditional_cli(regs);
@@ -285,8 +285,8 @@ do_general_protection(struct pt_regs *regs, long error_code)
 
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
-		if (!notify_die(DIE_GPF, "general protection fault", regs, error_code,
-			       X86_TRAP_GP, SIGSEGV) == NOTIFY_STOP)
+		if (notify_die(DIE_GPF, "general protection fault", regs, error_code,
+			       X86_TRAP_GP, SIGSEGV) != NOTIFY_STOP)
 			die("general protection fault", regs, error_code);
 		goto exit;
 	}
@@ -678,8 +678,8 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	info.si_errno = 0;
 	info.si_code = ILL_BADSTK;
 	info.si_addr = NULL;
-	if (!notify_die(DIE_TRAP, "iret exception", regs, error_code,
-			X86_TRAP_IRET, SIGILL) == NOTIFY_STOP) {
+	if (notify_die(DIE_TRAP, "iret exception", regs, error_code,
+			X86_TRAP_IRET, SIGILL) != NOTIFY_STOP) {
 		do_trap(X86_TRAP_IRET, SIGILL, "iret exception", regs, error_code,
 			&info);
 	}
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index d249719..e0500c6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -446,6 +446,9 @@ void rcu_user_enter(void)
 
 	WARN_ON_ONCE(!current->mm);
 
+	if (in_interrupt())
+		return;
+
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
@@ -592,6 +595,9 @@ void rcu_user_exit(void)
 	unsigned long flags;
 	struct rcu_dynticks *rdtp;
 
+	if (in_interrupt())
+		return;
+
 	local_irq_save(flags);
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	if (rdtp->in_user) {

