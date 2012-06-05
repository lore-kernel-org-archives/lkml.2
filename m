Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2FEN4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 09:56:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:46548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2FEN4e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 09:56:34 -0400
Message-ID: <1338904586.28282.183.camel@twins>
Subject: Re: [PATCH] perf, x86: Fix Intel shared extra MSR allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 15:56:26 +0200
In-Reply-To: <1338903031.28282.175.camel@twins>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	 <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
	 <1338891271.28282.155.camel@twins>
	 <CABPqkBSv8CbMzUiRsN2uOF1v6rFTpzhQqNbo7OKe-nzsus0GDg@mail.gmail.com>
	 <1338892071.28282.157.camel@twins>
	 <CABPqkBSqLpa4X-WbR0PkouYvhODT78r3pxWq70=PTj1j=a307Q@mail.gmail.com>
	 <1338898024.28282.160.camel@twins> <1338899999.28282.164.camel@twins>
	 <CABPqkBRCMAnPH3UW0=afMw4-YXgwQ5D-NLMEtnNWde_Tzh3aew@mail.gmail.com>
	 <1338901490.28282.167.camel@twins> <1338903031.28282.175.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 15:30 +0200, Peter Zijlstra wrote:

> @@ -1157,14 +1163,14 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>  	struct event_constraint *c = &emptyconstraint;
>  	struct er_account *era;
>  	unsigned long flags;
> -	int orig_idx = reg->idx;
> +	int idx = reg->idx;
>  
>  	/* already allocated shared msr */
>  	if (reg->alloc)
>  		return NULL; /* call x86_get_event_constraint() */

I'm afraid that needs to be:

	/*
	 * reg->alloc can be set due to existing state, so for fake cpuc
	 * we need to ignore this, otherwise we might fail to allocate
	 * proper fake state for this extra reg constraint. Also see
	 * the comment below.
	 */
	if (reg->alloc && !cpuc->is_fake)
		return NULL; /* call x86_get_event_constraints() */

>  
>  again:
> -	era = &cpuc->shared_regs->regs[reg->idx];
> +	era = &cpuc->shared_regs->regs[idx];
>  	/*
>  	 * we use spin_lock_irqsave() to avoid lockdep issues when
>  	 * passing a fake cpuc
> @@ -1173,6 +1179,29 @@ __intel_shared_reg_get_constraints(struct cpu_hw_events *cpuc,
>  
>  	if (!atomic_read(&era->ref) || era->config == reg->config) {
>  
> +		/*
> +		 * If its a fake cpuc -- as per validate_{group,event}() we
> +		 * shouldn't touch event state and we can avoid doing so
> +		 * since both will only call get_event_constraints() once
> +		 * on each event, this avoids the need for reg->alloc.
> +		 *
> +		 * Not doing the ER fixup will only result in era->reg being
> +		 * wrong, but since we won't actually try and program hardware
> +		 * this isn't a problem either.
> +		 */
> +		if (!cpuc->is_fake) {
> +			if (idx != reg->idx)
> +				intel_fixup_er(event, idx);
> +
> +			/* 
> +			 * x86_schedule_events() can call get_event_constraints()
> +			 * multiple times on events in the case of incremental
> +			 * scheduling(). reg->alloc ensures we only do the ER
> +			 * allocation once.
> +			 */
> +			reg->alloc = 1;
> +		}
> +
>  		/* lock in msr value */
>  		era->config = reg->config;
>  		era->reg = reg->reg;

