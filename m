Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0CVOQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:16:48 -0400
Received: from www.tglx.de ([62.245.132.106]:50313 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab0CVOQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:16:47 -0400
Date: Mon, 22 Mar 2010 15:16:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] x86: use vector_desc instead of vector_irq
In-Reply-To: <m17hp4wiz0.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1003221506300.3147@localhost.localdomain>
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org> <1269221770-9667-6-git-send-email-yinghai@kernel.org> <alpine.LFD.2.00.1003221435480.3147@localhost.localdomain> <m17hp4wiz0.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> -typedef int vector_irq_t[NR_VECTORS];
> >> -DECLARE_PER_CPU(vector_irq_t, vector_irq);
> >> -extern void setup_vector_irq(int cpu);
> >> +typedef struct irq_desc *vector_desc_t[NR_VECTORS];
> >
> >   Why do we need that typedef ? Please use plain struct irq_desc *
> 
> Well at least originally DECLARE_PER_CPU chocked when given a complex
> type. Does:
> DECLARE_PER_CPU(struct irq_desc *[NR_VECTORS], vector_desc);
> work?

Hmm, I thought that was fixed, but I might be wrong as usual.
 
> 
> >> +DECLARE_PER_CPU(vector_desc_t, vector_desc);
> >> +extern void setup_vector_desc(int cpu);
> > ...
> >>  void destroy_irq(unsigned int irq)
> >>  {
> >>  	unsigned long flags;
> >> +	struct irq_desc *desc;
> >> +	struct irq_cfg *cfg;
> >>  
> >>  	dynamic_irq_cleanup_keep_chip_data(irq);
> >>  
> >>  	free_irte(irq);
> >>  	raw_spin_lock_irqsave(&vector_lock, flags);
> >> -	__clear_irq_vector(irq, get_irq_chip_data(irq));
> >> +	desc = irq_to_desc(irq);
> >> +	cfg = desc->chip_data;
> >> +	__clear_irq_vector(desc, cfg);
> >
> > 	__clear_irq_vector(desc, desc->chip_data);
> >
> >  should be sufficient, right ?
> 
> You want to deliberately loose a modicum of type safety?

I really have a hard time to see how assigning a void pointer to a
struct irq_cfg pointer is anymore type safe than using the void
pointer as for the function argument right away. 

> >>  		if (printk_ratelimit())
> >> -			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
> >> -				__func__, smp_processor_id(), vector, irq);
> >> +			pr_emerg("%s: %d.%d No irq handler for vector\n",
> >
> >   That printk is confusing. It's not lacking an irq handler. The
> >   vector is simply not assigned.
> 
> Long evolution.  Do you have a suggestion of better wording?

You mean hysterical raisins. Ok, how about:

    pr_emerg("irq: %d.d irq vector not assigned\n", ...);

Thanks,

	tglx
