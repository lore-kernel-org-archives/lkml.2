Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2HZSae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:30:34 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60913 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab2HZSad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:30:33 -0400
Date: Sun, 26 Aug 2012 20:30:30 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 16/19] x86, irq: Introduce setup_remapped_irq()
Message-ID: <20120826183030.GH3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-17-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-17-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:56:02PM +0200, Joerg Roedel wrote:
> --- a/arch/x86/include/asm/irq_remapping.h
> +++ b/arch/x86/include/asm/irq_remapping.h
> @@ -44,6 +44,9 @@ extern void compose_remapped_msi_msg(struct pci_dev *pdev,
>  				     struct msi_msg *msg, u8 hpet_id);
>  extern int setup_hpet_msi_remapped(unsigned int irq, unsigned int id);
>  extern void panic_if_irq_remap(const char *msg);
> +extern bool setup_remapped_irq(int irq,
> +			       struct irq_cfg *cfg,
> +			       struct irq_chip *chip);
here and in the next definition, is it possible to fit it in one line or
alteast in two?

>  
>  static inline bool irq_remapped(struct irq_cfg *cfg)
>  {
> @@ -93,6 +96,12 @@ static inline void irq_remap_modify_chip_defaults(struct irq_chip *chip)

> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -302,3 +302,14 @@ void irq_remap_modify_chip_defaults(struct irq_chip *chip)
>  	chip->irq_eoi = ir_ack_apic_level;
>  	chip->irq_set_affinity = x86_io_apic_ops.set_affinity;
>  }
> +
> +bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
> +{
> +	if (irq_remapped(cfg)) {
> +		irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
> +		irq_remap_modify_chip_defaults(chip);
> +		return true;
> +	} else {
> +		return false;
> +	}
> +}

What about

bool setup_remapped_irq(int irq, struct irq_cfg *cfg, struct irq_chip *chip)
{
	if (!irq_remapped(cfg))
		return false;
	irq_set_status_flags(irq, IRQ_MOVE_PCNTXT);
	irq_remap_modify_chip_defaults(chip);
	return true;
}

Sebastian
