Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2HANq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 09:46:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab2HANqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 09:46:55 -0400
Date: Wed, 1 Aug 2012 15:43:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, a.p.zijlstra@chello.nl,
        mingo@redhat.com, srikar@linux.vnet.ibm.com, roland@hack.frob.com
Subject: Re: [PATCH 2/2] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120801134337.GA3923@redhat.com>
References: <20120730141638.GA5306@redhat.com> <1343735548-18101-1-git-send-email-bigeasy@linutronix.de> <1343735548-18101-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343735548-18101-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See my previous emails... and a couple of other nits.

On 07/31, Sebastian Andrzej Siewior wrote:
>
> +static int insn_is_popf(const u8 *insn)
> +{
> +	/* popf */
> +	if (insn[0] == 0x9d)
> +		return 1;
> +	return 0;
> +}

I can't believe I am going to blame the naming ;)

But "insn_is_popf" looks confusing, imho. Yes, currently "iret" can't
be probed, so (afaics) we only need to check "popf". Still I think the
name should be generic, and the comment should explain that only "popf"
can be probed. And I think it would be better to pass auprobe, not
->insn. But this all is cosmetic.

> +void arch_uprobe_enable_step(struct task_struct *child,
> +		struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task	*utask		= child->utask;
> +	struct arch_uprobe_task	*autask		= &utask->autask;
> +	struct pt_regs		*regs		= task_pt_regs(child);
> +	unsigned long		debugctl;
> +
> +	autask->restore_flags = 0;
> +	if (!(regs->flags & X86_EFLAGS_TF) &&
> +			!insn_is_popf(auprobe->insn)) {
> +		autask->restore_flags |= UPROBE_CLEAR_TF;

This looks correct, but

> +		debugctl = get_debugctlmsr();
> +		if (debugctl & DEBUGCTLMSR_BTF) {

No, I don't think "X86_EFLAGS_TF && !insn_is_popf" is right. I guess
this mimics "enable_single_step(child) && block" in enable_step(), but
we can't trust insn_is_popf(), we should check/clear DEBUGCTLMSR_BTF
unconditionally.

And get_debugctlmsr() is another reason why arch_uprobe_enable_step()
should not have "struct task_struct *child" argument, otherwise the
code looks confusing.

However, I am not sure we can trust it. We are in kernel mode,
DEBUGCTLMSR_BTF can be cleared by kprobes (Ananth, please correct me).
I think we need to check TIF_BLOCKSTEP.

Oleg.

