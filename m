Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2H2Rft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab2H2Rfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:35:48 -0400
Date: Wed, 29 Aug 2012 19:37:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v3] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120829173748.GA1121@redhat.com>
References: <20120808145345.GA8171@redhat.com> <20120809044356.GA3163@in.ibm.com> <20120809170953.GA27835@linutronix.de> <20120813132443.GB5269@redhat.com> <502A0C43.2000906@linutronix.de> <20120814142736.GA8123@redhat.com> <20120820104734.GA17034@linutronix.de> <20120822140337.GB28878@redhat.com> <5034E8A5.2060701@linutronix.de> <20120822155943.GA4237@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822155943.GA4237@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22, Oleg Nesterov wrote:
>
> > Ehm. Is there anything I missed to do? Or are you speculating on
> > changes which will clash with these here?
>
> If we have task_set_blockstep(), then perhaps it mmakes sense to
> avoid user_enable_singlestep()/TIF_SINGLESTEP from the start.
> We will see.

But it is not clear when we will have task_set_blockstep.

So I am starting to think it would be better to apply your 1-2 and
change the code later. Still not correct, but better than nothing.



But. The more I think about the current code, the more I dislike it.
And I am starting to think we do not need yet another "weak arch*"
hook for single-stepping. Yes, it was me who suggested it, but this
is because I didn't want to complicate the merging of powerpc port.

However.

Ananth, Sebastian, what if we start with the patch below? Then
we can change arch/x86/kernel/uprobes.c to use the static
uprobe_*_step() helpers from the 2nd patch.

If we agree this code should be per-arch, then why do need other
hooks? This is just ugly, we already have arch_pre/post_xol.

The only problem is the pending powerpc patches, the change below
obviously breaks them. Were they already applied? If not, then
probably Ananth can do v6 on top of the patch below ;) The necessary
fixup is trivial.

What do you think?

Oleg.


--- x/kernel/events/uprobes.c
+++ x/kernel/events/uprobes.c
@@ -1440,10 +1440,8 @@ static void handle_swbp(struct pt_regs *
 		goto cleanup_ret;
 
 	utask->state = UTASK_SSTEP;
-	if (!pre_ssout(uprobe, regs, bp_vaddr)) {
-		user_enable_single_step(current);
+	if (!pre_ssout(uprobe, regs, bp_vaddr))
 		return;
-	}
 
 cleanup_ret:
 	if (utask) {
@@ -1480,7 +1478,6 @@ static void handle_singlestep(struct upr
 	put_uprobe(uprobe);
 	utask->active_uprobe = NULL;
 	utask->state = UTASK_RUNNING;
-	user_disable_single_step(current);
 	xol_free_insn_slot(current);
 
 	spin_lock_irq(&current->sighand->siglock);
--- x/arch/x86/kernel/uprobes.c
+++ x/arch/x86/kernel/uprobes.c
@@ -471,6 +471,7 @@ int arch_uprobe_pre_xol(struct arch_upro
 	regs->ip = current->utask->xol_vaddr;
 	pre_xol_rip_insn(auprobe, regs, autask);
 
+	user_enable_single_step(current);
 	return 0;
 }
 
@@ -596,6 +597,7 @@ int arch_uprobe_post_xol(struct arch_upr
 	if (auprobe->fixups & UPROBE_FIX_CALL)
 		result = adjust_ret_addr(regs->sp, correction);
 
+	user_disable_single_step(current);
 	return result;
 }
 
@@ -640,6 +642,7 @@ void arch_uprobe_abort_xol(struct arch_u
 	current->thread.trap_nr = utask->autask.saved_trap_nr;
 	handle_riprel_post_xol(auprobe, regs, NULL);
 	instruction_pointer_set(regs, utask->vaddr);
+	user_disable_single_step(current);
 }
 
 /*

