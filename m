Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2HZS16 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:27:58 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60904 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab2HZS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:27:57 -0400
Date: Sun, 26 Aug 2012 20:27:55 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 15/19] x86, irq: Move irq_remapped() check into
 free_remapped_irq
Message-ID: <20120826182755.GG3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-16-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-16-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:56:01PM +0200, Joerg Roedel wrote:
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2981,8 +2981,8 @@ void destroy_irq(unsigned int irq)
>  
>  	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
>  
> -	if (irq_remapped(cfg))
> -		free_remapped_irq(irq);
> +	free_remapped_irq(irq);
> +
>  	raw_spin_lock_irqsave(&vector_lock, flags);
>  	__clear_irq_vector(irq, cfg);
>  	raw_spin_unlock_irqrestore(&vector_lock, flags);
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 3957fb2..f2affc7 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -229,10 +229,13 @@ int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
>  
>  void free_remapped_irq(int irq)
>  {
> +	struct irq_cfg *cfg = irq_get_chip_data(irq);
> +
>  	if (!remap_ops || !remap_ops->free_irq)
>  		return;
>  
> -	remap_ops->free_irq(irq);
> +	if (cfg && irq_remapped(cfg))

You shuffle code with the exception that you now check for cfg. Why?

> +		remap_ops->free_irq(irq);
>  }
>  
>  void compose_remapped_msi_msg(struct pci_dev *pdev,

Sebastian
