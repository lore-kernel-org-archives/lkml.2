Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2IYOAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:00:05 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:32894
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751791Ab2IYOAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:00:03 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432Izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWS6I-01-K1R-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 15:59:05 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 17/19] x86, msi: Introduce x86_msi.compose_msi_msg
 call-back
Message-ID: <20120925135905.GC2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-18-git-send-email-joerg.roedel@amd.com>
 <20120826184140.GI3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826184140.GI3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 08:41:40PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:56:03PM +0200, Joerg Roedel wrote:
> > This call-back points to the right function for initializing
> > the msi_msg structure.
> 
> So you pull out the compose_remapped_msi_msg() out of msi_compose_msg() and
> put this in a callback. Such information is good since you don't see this in
> diff and even --patience does not help here.

Added that to the commit message.

> 
> > --- a/drivers/iommu/irq_remapping.c
> > +++ b/drivers/iommu/irq_remapping.c
> > @@ -242,10 +243,12 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
> >  			      unsigned int irq, unsigned int dest,
> >  			      struct msi_msg *msg, u8 hpet_id)
> >  {
> > -	if (!remap_ops || !remap_ops->compose_msi_msg)
> > -		return;
> > +	struct irq_cfg *cfg = irq_get_chip_data(irq);
> >  
> > -	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
> > +	if (cfg && !irq_remapped(cfg))
> > +		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
> > +	else if (remap_ops && remap_ops->compose_msi_msg)
> > +		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
> 
> cfg _has_ to be valid here and if it is not than you shouldn't assume that
> this irq is remapped.
> Also remap_ops has to be set here. And ->compose_msi_msg() should be set
> here as well. Would it make sense if it is not set?

I removed the check for cfg, but I am still conservative on calling
function pointers without checking them first.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

