Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab2HAM3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:29:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2HAM3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:29:34 -0400
Date: Wed, 1 Aug 2012 14:26:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, a.p.zijlstra@chello.nl,
        mingo@redhat.com, srikar@linux.vnet.ibm.com, roland@hack.frob.com
Subject: Re: [PATCH 2/2] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120801122616.GA32705@redhat.com>
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de> <20120731175108.GC14576@redhat.com> <50183273.9070304@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50183273.9070304@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31, Sebastian Andrzej Siewior wrote:
>
> On 07/31/2012 07:51 PM, Oleg Nesterov wrote:
>> However, honestly I do not like it. I think we should change this
>> step-by-step, that is why I suggested to use TIF_SINGLESTEP and
>> user_enable_single_step() like your initial patch did. With this
>> patch at least the debugger doesn't lose the control over the tracee
>> if it steps over the probed insn, and this is the main (and known ;)
>> problem to me.
>
> I thought you did not like the nesting with TIF_SIGNLESTEP and the
> _FORCE and suggested to handle the complete state within uprobe.

Yes, but I suggested to do this in a separate patch.

In particular, because even if we do not care about DEBUGCTLMSR_BTF
after _disable, _enable has to clear it. See below.

>> Every change needs the discussion. For example, _enable should
>> clear DEBUGCTLMSR_BTF, this is obvious. But it is not clear to
>> me if _disable should restore it. What if the probed insn was
>> "jmp"? We need the additional complications to handle this case
>> really correctly, and for what? OK, gdb can get the extra SIGTRAP
>> from the tracee, but this is fine. And uprobes can confuse gdb
>> in many ways.
>
> I don't know if it is worth to have correct behavior here or rather go
> for the easy way which is either always do the wakeup or delay until
> the next jump.

This is debatable, personally I think it is fine to lose DEBUGCTLMSR_BTF.
Otherwise we need much more complications, not sure if it worth a trouble.
And an extra SIGTRAP for gdb is certainly better than the lost SIGTRAP.

However, once again, at least we should clear DEBUGCTLMSR_BTF
before the step. And I strongly believe we should not copy-and-paste
this code from step.c. This means we need something like the patch
below, before we teach uprobes to play with _TF directly, imho.

And btw, this is offtopic, but the usage of update_debugctlmsr()
doesn't look right to me (I can be easily wrong though). I'll write
another email.

Oleg.

--- x/arch/x86/kernel/step.c
+++ x/arch/x86/kernel/step.c
@@ -157,6 +157,21 @@ static int enable_single_step(struct tas
 	return 1;
 }
 
+void enable_block_step(struct task_struct *child, bool on)
+{
+	unsigned long debugctl = get_debugctlmsr();
+
+	if (on) {
+		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
+		debugctl |= DEBUGCTLMSR_BTF;
+	} else {
+		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
+		debugctl &= ~DEBUGCTLMSR_BTF;
+	}
+
+	update_debugctlmsr(debugctl);
+}
+
 /*
  * Enable single or block step.
  */
@@ -169,19 +184,10 @@ static void enable_step(struct task_stru
 	 * So no one should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
-	if (enable_single_step(child) && block) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl |= DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	} else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl &= ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (enable_single_step(child) && block)
+		enable_block_step(true);
+	else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		enable_block_step(false);
 }
 
 void user_enable_single_step(struct task_struct *child)
@@ -199,13 +205,8 @@ void user_disable_single_step(struct tas
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl = get_debugctlmsr();
-
-		debugctl &= ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		enable_block_step(false);
 
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);

