Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab0I1VgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:36:05 -0400
Received: from www.tglx.de ([62.245.132.106]:60433 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab0I1VgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:36:03 -0400
Date: Tue, 28 Sep 2010 23:35:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86: Plug memory leak in sparse irq
In-Reply-To: <4CA25E5C.2020203@kernel.org>
Message-ID: <alpine.LFD.2.00.1009282333440.2416@localhost6.localdomain6>
References: <alpine.LFD.2.00.1009282052570.2416@localhost6.localdomain6> <AANLkTi=940qOigieOHd_cBcocBAb4AtYnm2v60i9CSmp@mail.gmail.com> <4CA25E5C.2020203@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010, Yinghai Lu wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Tue, Sep 28, 2010 at 11:57 AM
> > Subject: [PATCH] x86: Plug memory leak in sparse irq
> > To: LKML <linux-kernel@vger.kernel.org>
> > Cc: x86@kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
> > 
> > 
> > free_irq_cfg() is not freeing the cpumask_vars in irq_cfg.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: stable@kernel.org
> > ---
> >  arch/x86/kernel/apic/io_apic.c |    6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
> > +++ linux-2.6/arch/x86/kernel/apic/io_apic.c
> > @@ -311,9 +311,11 @@ void arch_init_copy_chip_data(struct irq
> >        init_copy_irq_2_pin(old_cfg, cfg, node);
> >  }
> > 
> > -static void free_irq_cfg(struct irq_cfg *old_cfg)
> > +static void free_irq_cfg(struct irq_cfg *cfg)
> >  {
> > -       kfree(old_cfg);
> > +       free_cpumask_var(cfg->domain);
> > +       free_cpumask_var(cfg->old_domain);
> > +       kfree(cfg);
> >  }
> > 
> >  void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
> 
> yes. still need

Was about to send that out next.
 
> [PATCH] x86: copy cpumask while copying chip_data for offstack cpumask
> 
> While looking Thomas's
> |	x86: Plug memory leak in sparse irq
> 
> found copy_chip_data() could copy the cpumask pointers instead of real data.
> Need to use cpumask_copy there.

Sigh. That code should just depend on CONFIG_BROKEN, really.

Thanks,

	tglx
