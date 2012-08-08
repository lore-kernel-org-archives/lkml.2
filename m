Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268Ab2HHNNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 09:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019Ab2HHNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 09:13:12 -0400
Date: Wed, 8 Aug 2012 14:57:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakaynahalli <ananth@in.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH 2/5] x86/uprobes: implement x86 specific
	arch_uprobe_*_step
Message-ID: <20120808125709.GA4504@redhat.com>
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-3-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344355952-2382-3-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Sebastian Andrzej Siewior wrote:
>
> The arch specific implementation behaves like user_enable_single_step()
> except that it does not disable single stepping if it was already
> enabled. This allows the debugger to single step over an uprobe.
> The state of block stepping is not restored. It makes only sense
> together with TF and if that was enabled then the debugger is notified.

I'll try to read this series later, just one nit for now...

> +static int insn_changes_flags(struct arch_uprobe *auprobe)
> +{
> +	/* popf reads flags from stack */
> +	if (auprobe->insn[0] == 0x9d)
> +		return 1;

Ah, somehow I didn't think about this before.

->insn[0] doesn't look right, we should skip the prefixes.

Srikar, could you help? Perhaps validate_insn_bits() paths can
detect "popf" and do auprobe->fixups |= UPROBE_FIX_TF ?

This way we also do not need the new member in utask.

> +void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
> +{
> +	struct uprobe_task	*utask		= current->utask;
> +	struct arch_uprobe_task	*autask		= &utask->autask;
> +
> +	autask->restore_flags = 0;
> +	if (!test_tsk_thread_flag(current, TIF_SINGLESTEP) &&
> +			!insn_changes_flags(auprobe))
> +		autask->restore_flags |= UPROBE_CLEAR_TF;
> +	/*
> +	 * The state of TIF_BLOCKSTEP is not saved. With the TF flag set we
> +	 * would to examine the opcode and the flags to make it right. Without
> +	 * TF block stepping makes no sense. Instead we wakeup the debugger via
> +	 * SIGTRAP in case TF was set. This has the side effect that the
> +	 * debugger gets woken up even if the opcode normally wouldn't do so.
> +	 */
> +	user_enable_single_step(current);

OK, once we have set_task_blockstep() we can change this.

Oleg.

