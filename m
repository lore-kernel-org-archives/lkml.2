Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2IYN3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:29:50 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:34152 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab2IYN3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:29:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWQTH-02-CYF-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 15:29:41 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 15/19] x86, irq: Move irq_remapped() check into
 free_remapped_irq
Message-ID: <20120925132941.GA2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-16-git-send-email-joerg.roedel@amd.com>
 <20120826182755.GG3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826182755.GG3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 08:27:55PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:56:01PM +0200, Joerg Roedel wrote:
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -2981,8 +2981,8 @@ void destroy_irq(unsigned int irq)
> >  
> >  	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
> >  
> > -	if (irq_remapped(cfg))
> > -		free_remapped_irq(irq);
> > +	free_remapped_irq(irq);
> > +
> >  	raw_spin_lock_irqsave(&vector_lock, flags);
> >  	__clear_irq_vector(irq, cfg);
> >  	raw_spin_unlock_irqrestore(&vector_lock, flags);
> > diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> > index 3957fb2..f2affc7 100644
> > --- a/drivers/iommu/irq_remapping.c
> > +++ b/drivers/iommu/irq_remapping.c
> > @@ -229,10 +229,13 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
> >  
> >  void free_remapped_irq(int irq)
> >  {
> > +	struct irq_cfg *cfg = irq_get_chip_data(irq);
> > +
> >  	if (!remap_ops || !remap_ops->free_irq)
> >  		return;
> >  
> > -	remap_ops->free_irq(irq);
> > +	if (cfg && irq_remapped(cfg))
> 
> You shuffle code with the exception that you now check for cfg. Why?

Just to be sure it is not NULL, but looking again at the previous code
it is not necessary. I remove the check for cfg.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

