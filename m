Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2HZSlp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:41:45 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60924 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753495Ab2HZSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:41:44 -0400
Date: Sun, 26 Aug 2012 20:41:40 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 17/19] x86, msi: Introduce x86_msi.compose_msi_msg
 call-back
Message-ID: <20120826184140.GI3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-18-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-18-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:56:03PM +0200, Joerg Roedel wrote:
> This call-back points to the right function for initializing
> the msi_msg structure.

So you pull out the compose_remapped_msi_msg() out of msi_compose_msg() and
put this in a callback. Such information is good since you don't see this in
diff and even --patience does not help here.

> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -242,10 +243,12 @@ void compose_remapped_msi_msg(struct pci_dev *pdev,
>  			      unsigned int irq, unsigned int dest,
>  			      struct msi_msg *msg, u8 hpet_id)
>  {
> -	if (!remap_ops || !remap_ops->compose_msi_msg)
> -		return;
> +	struct irq_cfg *cfg = irq_get_chip_data(irq);
>  
> -	remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);
> +	if (cfg && !irq_remapped(cfg))
> +		native_compose_msi_msg(pdev, irq, dest, msg, hpet_id);
> +	else if (remap_ops && remap_ops->compose_msi_msg)
> +		remap_ops->compose_msi_msg(pdev, irq, dest, msg, hpet_id);

cfg _has_ to be valid here and if it is not than you shouldn't assume that
this irq is remapped.
Also remap_ops has to be set here. And ->compose_msi_msg() should be set
here as well. Would it make sense if it is not set?

>  }
>  
>  static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec)

Sebastian
