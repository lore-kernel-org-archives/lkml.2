Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab0K3Qb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:31:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0K3Qb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:31:56 -0500
Date: Tue, 30 Nov 2010 11:31:50 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 2.6.37
Message-ID: <20101130163150.GA25668@bombadil.infradead.org>
References: <20101022012302.GA7487@havoc.gtf.org>
 <20101129180755.GK15818@bombadil.infradead.org>
 <4CF506A6.4020200@kernel.org>
 <20101130153839.GM15818@bombadil.infradead.org>
 <4CF52652.4030802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF52652.4030802@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:29:06PM +0100, Tejun Heo wrote:
> > Be happy to apply any debug patches, but I plan on replacing the drive
> > with a faster one at some point in the next few weeks.
> 
> Can you please apply the following patch and report the resulting
> kernel log?  You're on ahci, right?
> 

Yup, building now.

> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index ebc08d6..b1c39db 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -1560,6 +1560,10 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
>  	}
> 
>  	/* okay, let's hand over to EH */
> +	if (active_qc && ata_tag_internal(active_qc->tag))
> +		ata_dev_printk(active_qc->dev, KERN_WARNING,
> +			       "ahci: internal command failure, irq_stat=0x%x\n",
> +			       irq_stat);
> 
>  	if (irq_stat & PORT_IRQ_FREEZE)
>  		ata_port_freeze(ap);
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 7f77c67..7cf236b 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -1668,6 +1668,10 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
> 
>  	/* perform minimal error analysis */
>  	if (qc->flags & ATA_QCFLAG_FAILED) {
> +		ata_dev_printk(dev, KERN_WARNING,
> +			       "internal command failure: stat=0x%x ehi_desc=\"%s\"\n",
> +			       qc->tf.command, dev->link->eh_info.desc);
> +
>  		if (qc->result_tf.command & (ATA_ERR | ATA_DF))
>  			qc->err_mask |= AC_ERR_DEV;
> 
> 
