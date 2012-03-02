Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2CBJkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:40:19 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46604 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab2CBJkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:40:15 -0500
Date: Fri, 2 Mar 2012 10:40:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: io_apic: Move and reenable irq only when
 CONFIG_GENERIC_PENDING_IRQ=y
Message-ID: <20120302094001.GA462@elte.hu>
References: <20120302093034.GE8350@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302093034.GE8350@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> When CONFIG_GENERIC_PENDING_IRQ=n irq move and reenable code is never get
> executed, nor do_unmask_irq variable updates its init value. Move both the
> code and do_unmask_irq under CONFIG_GENERIC_PENDING_IRQ macro.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index fb07275..57dec14 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2515,8 +2515,11 @@ atomic_t irq_mis_count;
>  static void ack_apic_level(struct irq_data *data)
>  {
>  	struct irq_cfg *cfg = data->chip_data;
> -	int i, do_unmask_irq = 0, irq = data->irq;
> +	int i, irq = data->irq;
>  	unsigned long v;
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
> +	int do_unmask_irq = 0;
> +#endif
>  
>  	irq_complete_move(cfg);
>  #ifdef CONFIG_GENERIC_PENDING_IRQ
> @@ -2581,6 +2584,7 @@ static void ack_apic_level(struct irq_data *data)
>  		eoi_ioapic_irq(irq, cfg);
>  	}
>  
> +#ifdef CONFIG_GENERIC_PENDING_IRQ
>  	/* Now we can move and renable the irq */
>  	if (unlikely(do_unmask_irq)) {
>  		/* Only migrate the irq if the ack has been received.
> @@ -2613,6 +2617,7 @@ static void ack_apic_level(struct irq_data *data)
>  			irq_move_masked_irq(data);
>  		unmask_ioapic(cfg);
>  	}
> +#endif

The two CONFIG_GENERIC_PENDING_IRQ blocks should be moved out 
into two helper inline functions right in front of 
ack_apic_level() so that we do not complicate ack_apic_level() 
with so many #ifdefs.

They'd have the form of:

	int masked = 0;

	masked = ioapic_irqd_mask(data, cfg);

	...

	ioapic_irqd_unmask(data, cfg, masked);

or so.

Thanks,

	Ingo
