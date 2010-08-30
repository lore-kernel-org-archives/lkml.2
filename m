Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab0H3RS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:18:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:28095 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756050Ab0H3RS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:18:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,293,1280732400"; 
   d="scan'208";a="318804301"
Subject: Re: [patch 1/3] x86, intr-remap: set redirection hint in the IRTE
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Han, Weidong" <weidong.han@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <4C7B0DA6.2070204@intel.com>
References: <20100827181049.013051492@sbsiddha-MOBL3.sc.intel.com>
	 <4C7B0DA6.2070204@intel.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 30 Aug 2010 10:17:50 -0700
Message-Id: <1283188670.2695.13.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-29 at 18:47 -0700, Han, Weidong wrote:
> Siddha, Suresh B wrote:
> > Currently the redirection hint in the interrupt-remapping table entry
> > is set to 0, which means the remapped interrupt is directed to the
> > processors listed in the destination. So in logical flat mode
> > in the presence of intr-remapping, this results in a single
> > interrupt multi-casted to multiple cpu's as specified by the destination
> > bit mask. But what we really want is to send that interrupt to one of the cpus
> > based on the lowest priority delivery mode.
> >
> > Set the redirection hint in the IRTE to '1' to indicate that we want
> > the remapped interrupt to be directed to only one of the processors
> > listed in the destination.
> >
> > This fixes the issue of same interrupt getting delivered to multiple cpu's
> > in the logical flat mode in the presence of interrupt-remapping. While
> > there is no functional issue observed with this behavior, this will
> > impact performance of such configurations (<=8 cpu's using logical flat
> > mode in the presence of interrupt-remapping)
> >
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > Cc: Weidong Han <weidong.han@intel.com>
> > Cc: <stable@kernel.org> # [v2.6.32+]
> > ---
> >
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index f1efeba..90f8a75 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -1392,6 +1392,7 @@ int setup_ioapic_entry(int apic_id, int irq,
> >  		irte.dlvry_mode = apic->irq_delivery_mode;
> >  		irte.vector = vector;
> >  		irte.dest_id = IRTE_DEST(destination);
> > +		irte.redir_hint = 1;
> >  
> >  		/* Set source-id of interrupt request */
> >  		set_ioapic_sid(&irte, apic_id);
> > @@ -3343,6 +3344,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq,
> >  		irte.dlvry_mode = apic->irq_delivery_mode;
> >  		irte.vector = cfg->vector;
> >  		irte.dest_id = IRTE_DEST(dest);
> > +		irte.redir_hint = 1;
> >  
> >  		/* Set source-id of interrupt request */
> >  		if (pdev)
> >
> >
> >   
> hi Suresh,
> 
> I think it needs to set redir_hint only for lowest priority delivery 
> mode. Why set it for all delivery modes?

Weidong, For all the IRQ types (irrespective of lowest priority/fixed
mode etc) x86 linux kernel doesn't use irq multi-cast model (which is
what irte.redir_hint == 0 means). So as it is not particularly tied with
lowest priority mode (irte.redir_hint is equally applicable for fixed
mode though we don't use it currently), it makes sense to set it
unconditionally for the current usages.

thanks,
suresh

