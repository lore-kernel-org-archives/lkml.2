Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2DHThY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 15:37:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49574 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2DHThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 15:37:22 -0400
Message-ID: <4F81E887.8000000@mvista.com>
Date: Sun, 08 Apr 2012 23:35:35 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Thang Q. Nguyen" <tqnguyen@apm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeff Garzik <jgarzik@pobox.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Phong Vo <pvo@apm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] [v3] Add support 2 SATA ports for Maui and change
 filename from sata_dwc_460ex.c to sata_dwc_4xx.c
References: <1333690265-27857-1-git-send-email-tqnguyen@apm.com>
In-Reply-To: <1333690265-27857-1-git-send-email-tqnguyen@apm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06-04-2012 9:31, Thang Q. Nguyen wrote:

> Signed-off-by: Thang Q. Nguyen<tqnguyen@apm.com>
[...]

> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_4xx.c
> similarity index 73%
> rename from drivers/ata/sata_dwc_460ex.c
> rename to drivers/ata/sata_dwc_4xx.c
> index 69f7cde..07e9b36 100644
> --- a/drivers/ata/sata_dwc_460ex.c
> +++ b/drivers/ata/sata_dwc_4xx.c
[...]
> @@ -268,22 +276,25 @@ enum {
>  						 << 16)
>  struct sata_dwc_device {
>  	struct device		*dev;		/* generic device struct */
> -	struct ata_probe_ent	*pe;		/* ptr to probe-ent */
>  	struct ata_host		*host;
>  	u8			*reg_base;
>  	struct sata_dwc_regs	*sata_dwc_regs;	/* DW Synopsys SATA specific */
>  	int			irq_dma;
> +	u8			*scr_base;

    Why not 'void __iomem *scr_base'? You have to cast to it anyway everytime. 
And 'u8 *' is just not the right type.

> +	int			dma_channel;	/* DWC SATA DMA channel */
> +	int			hostID;
>  };
хюююъ
> +/* This is used for easier trace back when having DMA channel */
> +static struct sata_dwc_device *dwc_dev_list[DMA_NUM_CHANS];

    I don't quite understand: isn't this dual channel device? But you declare 
a device per DMA channel...

> +/*
> + * As we have only one DMA controller, this will be set static and global
> + * for easier to access

    "to" not needed here.

> @@ -372,15 +381,15 @@ static const char *get_dma_dir_descript(int dma_dir)
>   	}
>   }
>
> -static void sata_dwc_tf_dump(struct ata_taskfile *tf)
> +static void sata_dwc_tf_dump(struct device *dwc_dev, struct ata_taskfile *tf)
>   {
> -	dev_vdbg(host_pvt.dwc_dev, "taskfile cmd: 0x%02x protocol: %s flags:"
> +	dev_vdbg(dwc_dev, "taskfile cmd: 0x%02x protocol: %s flags:"

    Space missing after colon, BTW.

>   		"0x%lx device: %x\n", tf->command,
>   		get_prot_descript(tf->protocol), tf->flags, tf->device);
[...]

>  /*
>   * Function: dma_request_channel

    BTW, it would be good if you changed the function comments to the 
kernel-doc format (in another patch).

> - * arguments: None
> + * arguments: ap
>   * returns channel number if available else -1
>   * This function assigns the next available DMA channel from the list to the
>   * requester
>   */
> -static int dma_request_channel(void)
> +static int dma_request_channel(struct ata_port *ap)
>   {
> -	int i;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
>
[...]
> +	/* Check if the channel is not currently in use */
> +	if (!(in_le32(&(sata_dma_regs->dma_chan_en.low)) &\

    \ not needed. () with & not needed.

> +		DMA_CHANNEL(hsdev->dma_channel)))
> +		return hsdev->dma_channel;
> +
> +	dev_err(ap->dev, "%s Channel %d is currently in use\n", __func__,
> +		hsdev->dma_channel);
>   	return -1;
>   }
>
>   /*
> + * Check if the selected DMA channel is currently enabled.
> + */
> +static int sata_dwc_dma_chk_en(int ch)
> +{
> +	u32 dma_chan_reg;

    Empty line here please.

> +	/* Read the DMA channel register */
> +	dma_chan_reg = in_le32(&(sata_dma_regs->dma_chan_en.low));

    () with & not needed.

> +/*
> + * Handle DMA transfer complete interrupt. This checks and passes the
> + * processing to the appropriate ATA port.
> + */
> +static irqreturn_t dma_dwc_handler(int irq, void *hsdev_instance)
> +{
> +	u32 tfr_reg, err_reg;
> +	int chan;
> +
> +	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr.low));
> +	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));

    () with & not needed.

> @@ -471,41 +517,25 @@ static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
>   	spin_lock_irqsave(&host->lock, flags);
>   	ap = host->ports[port];
>   	hsdevp = HSDEVP_FROM_AP(ap);
> -	tag = ap->link.active_tag;
>
> -	tfr_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.tfr\
> +	if (ap->link.active_tag != ATA_TAG_POISON)
> +		tag = ap->link.active_tag;
> +
> +	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr\

     \ not needed. () with & not needed. And the line is too short to break it 
anyway.

>   			.low));
> -	err_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error\
> +	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error\

    Same coments.

> +			out_le32(&(sata_dma_regs->interrupt_clear.tfr.low),

    () with & not needed.

> @@ -516,11 +546,16 @@ static irqreturn_t dma_dwc_interrupt(int irq, void *hsdev_instance)
>   				err_reg);
>
>   			/* Clear the interrupt. */
> -			out_le32(&(host_pvt.sata_dma_regs->interrupt_clear\
> +			out_le32(&(sata_dma_regs->interrupt_clear\

     \ not needed. () with & not needed. And the line is too short to break it 
anyway.

>   				.error.low),
[...]
> @@ -629,14 +667,22 @@ static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
>   			 * Set DMA addresses and lower half of control register
>   			 * based on direction.
>   			 */
> +			if (hsdevp->hsdev->hostID == APM_821XX_SATA) {
> +				sms_val = 1+hsdevp->hsdev->dma_channel;

    Spaces around + please.

> +				dms_val = 0;
> +			} else {
> +				sms_val = 0;
> +				dms_val = 1+hsdevp->hsdev->dma_channel;

    Same here.

> @@ -714,70 +766,49 @@ static int map_sg_to_lli(struct scatterlist *sg, int num_elems,
>   static void dma_dwc_xfer_start(int dma_ch)
>   {
>   	/* Enable the DMA channel */
> -	out_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low),
> -		 in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)) |
> +	out_le32(&(sata_dma_regs->dma_chan_en.low),
> +		 in_le32(&(sata_dma_regs->dma_chan_en.low)) |

    () with & not needed.

>   		 DMA_ENABLE_CHAN(dma_ch));
>   }
>
> -static int dma_dwc_xfer_setup(struct scatterlist *sg, int num_elems,
> -			      struct lli *lli, dma_addr_t dma_lli,
> -			      void __iomem *addr, int dir)
> +

    Empty line not needed...

> +static int dma_dwc_xfer_setup(struct ata_port *ap, dma_addr_t dma_lli)
[...]
> -	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.high),
> +	out_le32(&(sata_dma_regs->chan_regs[dma_ch].cfg.high),

    () with & not needed.

> +		 DMA_CFG_HW_HS_SRC(dma_ch) | DMA_CFG_HW_HS_DEST(dma_ch) | \
>   		 DMA_CFG_PROTCTL | DMA_CFG_FCMOD_REQ);
> -	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].cfg.low), 0);
> +
> +	out_le32(&(sata_dma_regs->chan_regs[dma_ch].cfg.low),

    () with & not needed.

> +		DMA_CFG_HW_CH_PRIOR(dma_ch));
>
>   	/* Program the address of the linked list */
> -	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].llp.low),
> +	if (hsdev->hostID == APM_460EX_SATA) {
> +		out_le32(&(sata_dma_regs->chan_regs[dma_ch].llp.low),

    () with & not needed.

>   		 DMA_LLP_LMS(dma_lli, DMA_LLP_AHBMASTER2));

    Please indent this like more to the right.

> +	} else {
> +		out_le32(&(sata_dma_regs->chan_regs[dma_ch].llp.low),

    () with & not needed.

> +			DMA_LLP_LMS(dma_lli, DMA_LLP_AHBMASTER1));
> +	}
>
>   	/* Program the CTL register with src enable / dst enable */
> -	out_le32(&(host_pvt.sata_dma_regs->chan_regs[dma_ch].ctl.low),
> +	out_le32(&(sata_dma_regs->chan_regs[dma_ch].ctl.low),

    () with & not needed.

> @@ -789,24 +820,18 @@ static int dma_dwc_init(struct sata_dwc_device *hsdev, int irq)
[...]
>   	/* Enabe DMA */

    Enable.

> -	out_le32(&(host_pvt.sata_dma_regs->dma_cfg.low), DMA_EN);
> +	out_le32(&(sata_dma_regs->dma_cfg.low), DMA_EN);

    () with & not needed.

> @@ -838,23 +863,27 @@ static int sata_dwc_scr_write(struct ata_link *link, unsigned int scr, u32 val)
>   	return 0;
>   }
>
> -static u32 core_scr_read(unsigned int scr)
> +static u32 core_scr_read(struct ata_port *ap, unsigned int scr)
>   {
> -	return in_le32((void __iomem *)(host_pvt.scr_addr_sstatus) +\
> -			(scr * 4));
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	return in_le32((void __iomem *)hsdev->scr_base + (scr * 4));

    () around * not needed.

>   }
>
> -static void core_scr_write(unsigned int scr, u32 val)
> +
> +static void core_scr_write(struct ata_port *ap, unsigned int scr, u32 val)
>   {
> -	out_le32((void __iomem *)(host_pvt.scr_addr_sstatus) + (scr * 4),
> -		val);
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	out_le32((void __iomem *)hsdev->scr_base + (scr * 4), val);

    Same here.

> @@ -869,7 +898,6 @@ static u32 qcmd_tag_to_mask(u8 tag)
>   	return 0x00000001<<  (tag&  0x1f);
>   }
>
> -/* See ahci.c */

    Don't think this is a legal change in this patch...

>   static void sata_dwc_error_intr(struct ata_port *ap,
>   				struct sata_dwc_device *hsdev, uint intpr)
>   {
> @@ -883,24 +911,23 @@ static void sata_dwc_error_intr(struct ata_port *ap,
>
>   	ata_ehi_clear_desc(ehi);
>
> -	serror = core_scr_read(SCR_ERROR);
> +	serror = core_scr_read(ap, SCR_ERROR);
>   	status = ap->ops->sff_check_status(ap);
>
> -	err_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error.\
> +	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.\

    \ not needed. () with & not needed. And the line is too short to be broken.

>   			low));
>   	tag = ap->link.active_tag;
>
>   	dev_err(ap->dev, "%s SCR_ERROR=0x%08x intpr=0x%08x status=0x%08x "
> -		"dma_intp=%d pending=%d issued=%d dma_err_status=0x%08x\n",
> -		__func__, serror, intpr, status, host_pvt.dma_interrupt_count,
> -		hsdevp->dma_pending[tag], hsdevp->cmd_issued[tag], err_reg);
> +		" pending=%d dma_err_status=0x%08x\n",

    Space not needed before "pending".

> @@ -930,14 +957,14 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
>   	struct sata_dwc_device *hsdev = HSDEV_FROM_HOST(host);
>   	struct ata_port *ap;
>   	struct ata_queued_cmd *qc;
> -	unsigned long flags;
>   	u8 status, tag;
> -	int handled, num_processed, port = 0;
> -	uint intpr, sactive, sactive2, tag_mask;
> +	int handled, port = 0;
> +	int num_lli;
> +	uint intpr, sactive, tag_mask;
>   	struct sata_dwc_device_port *hsdevp;
> -	host_pvt.sata_dwc_sactive_issued = 0;
> +	u32 mask;
>
> -	spin_lock_irqsave(&host->lock, flags);
> +	spin_lock(&host->lock);

    Is this change related?

> +		if (qc) {
> +			hsdevp->sactive_issued |= mask;
> +			/* Prevent to issue more commands */
> +			qc->ap->link.active_tag = tag;
> +			qc->dev->link->sactive |= (1 << qc->tag);

    () not needed around <<.

> +			num_lli = map_sg_to_lli(ap, qc->sg, qc->n_elem, \
> +				hsdevp->llit[tag], hsdevp->llit_dma[tag], \
> +				(void *__iomem)(&hsdev->sata_dwc_regs->dmadr), \

    You don't need \ to break the lines in C, unless this is in macro definition.

> @@ -1012,28 +1051,12 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
>   		dev_dbg(ap->dev, "%s non-NCQ cmd interrupt, protocol: %s\n",
>   			__func__, get_prot_descript(qc->tf.protocol));
>   DRVSTILLBUSY:
> +		/* Do complete action for the current QC */
>   		if (ata_is_dma(qc->tf.protocol)) {
[...]
> +			sata_dwc_qc_complete(ap, qc, 1);
> +		} else if ((ata_is_pio(qc->tf.protocol)) ||
> +			(ata_is_nodata(qc->tf.protocol))) {

    () not needed around the operands of ||.

> @@ -1049,23 +1072,18 @@ DRVSTILLBUSY:
[...]
> -	if ((tag_mask | (host_pvt.sata_dwc_sactive_issued)) != \
> -					(host_pvt.sata_dwc_sactive_issued)) {
> +	if ((tag_mask | hsdevp->sactive_issued) != \
> +					hsdevp->sactive_issued) {
>   		dev_warn(ap->dev, "Bad tag mask?  sactive=0x%08x "
> -			 "(host_pvt.sata_dwc_sactive_issued)=0x%08x  tag_mask"
> -			 "=0x%08x\n", sactive, host_pvt.sata_dwc_sactive_issued,
> +			 "sactive_issued=0x%08x  tag_mask"

    There's no need to break the string literal here anymore.

> +			 "=0x%08x\n", sactive, hsdevp->sactive_issued,
>   			  tag_mask);
>   	}
>
> @@ -1073,70 +1091,21 @@ DRVSTILLBUSY:
>   	status = ap->ops->sff_check_status(ap);
>   	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
>
> -	tag = 0;
> -	num_processed = 0;
> -	while (tag_mask) {
> -		num_processed++;
> -		while (!(tag_mask&  0x00000001)) {
> -			tag++;
> -			tag_mask<<= 1;
> -		}
> -
> -		tag_mask&= (~0x00000001);
> -		qc = ata_qc_from_tag(ap, tag);
> -
> -		/* To be picked up by completion functions */
> -		qc->ap->link.active_tag = tag;
> -		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
> -
> -		/* Let libata/scsi layers handle error */
> -		if (status & ATA_ERR) {
> -			dev_dbg(ap->dev, "%s ATA_ERR (0x%x)\n", __func__,
> -				status);
> +	for (tag = 0; tag<  32; tag++) {
> +		if (tag_mask&  qcmd_tag_to_mask(tag)) {
> +			qc = ata_qc_from_tag(ap, tag);
> +			if (!qc) {
> +				dev_info(ap->dev, "error: Tag %d is set but " \
> +					"not available\n", tag);
> +				continue;
> +			}
>   			sata_dwc_qc_complete(ap, qc, 1);
> -			handled = 1;
> -			goto DONE;
>   		}
> -
> -		/* Process completed command */
> -		dev_dbg(ap->dev, "%s NCQ command, protocol: %s\n", __func__,
> -			get_prot_descript(qc->tf.protocol));
> -		if (ata_is_dma(qc->tf.protocol)) {
> -			host_pvt.dma_interrupt_count++;
> -			if (hsdevp->dma_pending[tag] == \
> -					SATA_DWC_DMA_PENDING_NONE)
> -				dev_warn(ap->dev, "%s: DMA not pending?\n",
> -					__func__);
> -			if ((host_pvt.dma_interrupt_count % 2) == 0)
> -				sata_dwc_dma_xfer_complete(ap, 1);
> -		} else {
> -			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
> -				goto STILLBUSY;
> -		}
> -		continue;
> -
> -STILLBUSY:
> -		ap->stats.idle_irq++;
> -		dev_warn(ap->dev, "STILL BUSY IRQ ata%d: irq trap\n",
> -			ap->print_id);
> -	} /* while tag_mask */
> -
> -	/*
> -	 * Check to see if any commands completed while we were processing our
> -	 * initial set of completed commands (read status clears interrupts,
> -	 * so we might miss a completed command interrupt if one came in while
> -	 * we were processing --we read status as part of processing a completed
> -	 * command).
> -	 */
> -	sactive2 = core_scr_read(SCR_ACTIVE);
> -	if (sactive2 != sactive) {
> -		dev_dbg(ap->dev, "More completed - sactive=0x%x sactive2"
> -			"=0x%x\n", sactive, sactive2);

    You're changing the algorithm of handling command here. Is it necessary to 
support 2 ports?

> @@ -1167,44 +1136,6 @@ static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag)
>   	}
>   }
>
> -static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32 check_status)
> -{
> -	struct ata_queued_cmd *qc;
> -	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> -	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> -	u8 tag = 0;
> -
> -	tag = ap->link.active_tag;
> -	qc = ata_qc_from_tag(ap, tag);
> -	if (!qc) {
> -		dev_err(ap->dev, "failed to get qc");
> -		return;
> -	}
> -
> -#ifdef DEBUG_NCQ
> -	if (tag > 0) {
> -		dev_info(ap->dev, "%s tag=%u cmd=0x%02x dma dir=%s proto=%s "
> -			 "dmacr=0x%08x\n", __func__, qc->tag, qc->tf.command,
> -			 get_dma_dir_descript(qc->dma_dir),
> -			 get_prot_descript(qc->tf.protocol),
> -			 in_le32(&(hsdev->sata_dwc_regs->dmacr)));
> -	}
> -#endif
> -
> -	if (ata_is_dma(qc->tf.protocol)) {
> -		if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_NONE) {
> -			dev_err(ap->dev, "%s DMA protocol RX and TX DMA not "
> -				"pending dmacr: 0x%08x\n", __func__,
> -				in_le32(&(hsdev->sata_dwc_regs->dmacr)));
> -		}
> -
> -		hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;
> -		sata_dwc_qc_complete(ap, qc, check_status);
> -		ap->link.active_tag = ATA_TAG_POISON;
> -	} else {
> -		sata_dwc_qc_complete(ap, qc, check_status);
> -	}
> -}

    Is this change related to dual port support?

> @@ -1213,24 +1144,39 @@ static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
>   	u32 mask = 0x0;
>   	u8 tag = qc->tag;
>   	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> -	host_pvt.sata_dwc_sactive_queued = 0;
> +	int i;
> +
>   	dev_dbg(ap->dev, "%s checkstatus? %x\n", __func__, check_status);
>
> -	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX)
> -		dev_err(ap->dev, "TX DMA PENDING\n");
> -	else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX)
> -		dev_err(ap->dev, "RX DMA PENDING\n");
> +	/* Check main status, clearing INTRQ */
> +	status = ap->ops->sff_check_status(ap);
> +
> +	if (check_status) {
> +		/* Make sure SATA port is not in BUSY state */
> +		i = 0;
> +		while (status & ATA_BUSY) {
> +			if (++i > 10)
> +				break;
> +			status = ap->ops->sff_check_altstatus(ap);
> +		};
> +
> +		if (unlikely(status & ATA_BUSY))
> +			dev_err(ap->dev, "QC complete cmd=0x%02x STATUS BUSY "
> +				"(0x%02x) [%d]\n", qc->tf.command, status, i);
> +	}

    Is this related to dual port support?

> @@ -1437,28 +1377,37 @@ static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag)
>   	struct ata_port *ap = qc->ap;
>   	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
>   	int dir = qc->dma_dir;
> -	dma_chan = hsdevp->dma_chan[tag];
>
> -	if (hsdevp->cmd_issued[tag] != SATA_DWC_CMD_ISSUED_NOT) {
> +	/* Configure DMA before starting data transfer */
> +	dma_chan = dma_dwc_xfer_setup(ap, hsdevp->llit_dma[tag]);
> +	if (unlikely(dma_chan < 0)) {
> +		dev_err(ap->dev, "%s: dma channel unavailable\n", __func__);
> +		/* Offending this QC as no channel available for transfer */
> +		qc->err_mask |= AC_ERR_TIMEOUT;

    Hm, is this good error code?

> +		return;
> +	}
> +
> +	/* Check if DMA should be started */
> +	hsdevp->dma_chan[tag] = dma_chan;
> +	if (hsdevp->sactive_queued & qcmd_tag_to_mask(tag)) {
>   		start_dma = 1;
>   		if (dir == DMA_TO_DEVICE)
>   			hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_TX;
>   		else
>   			hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_RX;
[...]
> @@ -1490,6 +1440,49 @@ static void sata_dwc_bmdma_start(struct ata_queued_cmd *qc)
>   	sata_dwc_bmdma_start_by_tag(qc, tag);
>   }
>
> +static void sata_dwc_bmdma_stop(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +	int dma_ch, enabled;
> +
> +	dma_ch = hsdev->dma_channel;
> +	enabled = sata_dwc_dma_chk_en(dma_ch);
> +
> +	if (enabled) {
> +		dev_dbg(ap->dev,
> +			"%s terminate DMA on channel=%d (mask=0x%08x) ...",
> +			__func__, dma_ch, DMA_DISABLE_CHAN(dma_ch));
> +		/* Disable the selected channel */
> +		out_le32(&(sata_dma_regs->dma_chan_en.low),

    () with & not needed.

> +			DMA_DISABLE_CHAN(dma_ch));
> +
> +		/* Wait for the channel is disabled */
> +		do {
> +			enabled = sata_dwc_dma_chk_en(dma_ch);
> +			ndelay(1000);
> +		} while (enabled);
> +		dev_dbg(ap->dev, "done\n");
> +	}
> +}
> +

    Wasn't this function necessary before dual port support?

> +static u8 sata_dwc_bmdma_status(struct ata_port *ap)
> +{
> +	u32 status = 0;
> +	u32 tfr_reg, err_reg;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	/* Check DMA register for status */
> +	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr.low));
> +	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));
> +
> +	if (unlikely(err_reg & DMA_CHANNEL(hsdev->dma_channel)))
> +		status = ATA_DMA_ERR;
> +	else if (tfr_reg & DMA_CHANNEL(hsdev->dma_channel))
> +		status = ATA_DMA_INTR;
> +	return status;
> +}
> +

    Is the above really related to dual port support? Wasn't it necessary before?

> @@ -1500,24 +1493,22 @@ static void sata_dwc_qc_prep_by_tag(struct ata_queued_cmd *qc, u8 tag)
>   {
>   	struct scatterlist *sg = qc->sg;
>   	struct ata_port *ap = qc->ap;
> -	int dma_chan;
> +	int num_lli;
>   	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
>   	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
>
> +	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))

    () not neecessary around ==.

> +		return;

    Wasn't this check necessary before dual port support?

>   	dev_dbg(ap->dev, "%s: port=%d dma dir=%s n_elem=%d\n",
>   		__func__, ap->port_no, get_dma_dir_descript(qc->dma_dir),
>   		 qc->n_elem);
>
> -	dma_chan = dma_dwc_xfer_setup(sg, qc->n_elem, hsdevp->llit[tag],
> -				      hsdevp->llit_dma[tag],
> -				      (void *__iomem)(&hsdev->sata_dwc_regs->\
> -				      dmadr), qc->dma_dir);
> -	if (dma_chan < 0) {
> -		dev_err(ap->dev, "%s: dma_dwc_xfer_setup returns err %d\n",
> -			__func__, dma_chan);
> -		return;
> +	if (!ata_is_ncq(qc->tf.protocol)) {
> +		num_lli = map_sg_to_lli(qc->ap, sg, qc->n_elem,
> +			hsdevp->llit[tag], hsdevp->llit_dma[tag],
> +			(void *__iomem)(&hsdev->sata_dwc_regs->dmadr),
> +			qc->dma_dir);
>   	}

    And what if the protocol is NCQ?

> -	hsdevp->dma_chan[tag] = dma_chan;
>   }
>
>   static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
> @@ -1541,19 +1532,18 @@ static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
>   	sata_dwc_qc_prep_by_tag(qc, tag);
>
>   	if (ata_is_ncq(qc->tf.protocol)) {
> -		sactive = core_scr_read(SCR_ACTIVE);
> +		/* Update SActive register for new command */
> +		sactive = core_scr_read(qc->ap, SCR_ACTIVE);
>   		sactive |= (0x00000001<<  tag);

    BTW, () not needed here. You can also use BIT() macro.

> -		core_scr_write(SCR_ACTIVE, sactive);
> -
> -		dev_dbg(qc->ap->dev, "%s: tag=%d ap->link.sactive = 0x%08x "
> -			"sactive=0x%08x\n", __func__, tag, qc->ap->link.sactive,
> -			sactive);
> +		core_scr_write(qc->ap, SCR_ACTIVE, sactive);
> +		qc->dev->link->sactive |= 0x00000001<<  tag;
>
>   		ap->ops->sff_tf_load(ap,&qc->tf);
> -		sata_dwc_exec_command_by_tag(ap,&qc->tf, qc->tag,
> -					     SATA_DWC_CMD_ISSUED_PEND);
> +		sata_dwc_exec_command_by_tag(ap, &qc->tf, qc->tag);
>   	} else {
> -		ata_sff_qc_issue(qc);
> +		/* As ata_sff_qc_issue is no longer handle DMA transfer,
> +		 * change to use ata_bmdma_qc_issue instead */

    The preferred style of multi-line comments is this:

/*
  * bla
  * bla
  */

> +		ata_bmdma_qc_issue(qc);

    This is a bug fix, so should be in a prior patch.

>   	}
>   	return 0;
>   }
> @@ -1582,7 +1572,12 @@ static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
>   static void sata_dwc_error_handler(struct ata_port *ap)
>   {
>   	ap->link.flags |= ATA_LFLAG_NO_HRST;
> -	ata_sff_error_handler(ap);
> +	ata_bmdma_error_handler(ap);

    Same about this. I've already noted this on Friday.

> +}
> +
> +u8 sata_dwc_check_altstatus(struct ata_port *ap)
> +{
> +	return ioread8(ap->ioaddr.altstatus_addr);

    This is the same as the default implementation, why you need to redefine it?

> @@ -1638,13 +1637,38 @@ static int sata_dwc_probe(struct platform_device *ofdev)
>   	struct ata_host *host;
>   	struct ata_port_info pi = sata_dwc_port_info[0];
>   	const struct ata_port_info *ppi[] = {&pi, NULL };
> +	const unsigned int *dma_chan;
> +
> +	/* Check if device is declared in device tree */
> +	if (!of_device_is_available(ofdev->dev.of_node)) {
> +		printk(KERN_INFO "%s: Port disabled via device-tree\n",
> +		ofdev->dev.of_node->full_name);
> +		return 0;
> +	}

    This check is not related to dual port support I think.

>
>   	/* Allocate DWC SATA device */
>   	hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);

    Consider switching to the managed device interface (devm_kzalloc() and 
friends).

>   	if (hsdev == NULL) {
>   		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
>   		err = -ENOMEM;
> -		goto error;
> +		goto error_out_5;
> +	}
[...]
> +	dma_chan = of_get_property(ofdev->dev.of_node, "dma-channel", NULL);

    I think you should use of_property_read_u32() instead.

> @@ -1653,7 +1677,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
>   		dev_err(&ofdev->dev, "ioremap failed for SATA register"
>   			" address\n");
>   		err = -ENODEV;
> -		goto error_kmalloc;
> +		goto error_out_4;
>   	}
>   	hsdev->reg_base = base;
>   	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
> @@ -1666,7 +1690,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
>   	if (!host) {
>   		dev_err(&ofdev->dev, "ata_host_alloc_pinfo failed\n");
>   		err = -ENOMEM;
> -		goto error_iomap;
> +		goto error_out_4;

   Are you sure it's not 'error_out_3' at this point?

> @@ -1688,23 +1712,30 @@ static int sata_dwc_probe(struct platform_device *ofdev)
>   	if (irq == NO_IRQ) {

    You should get rid of NO_IRQ.

> -	/* Initialize AHB DMAC */
> -	dma_dwc_init(hsdev, irq);
> +	/* Init glovbal dev list */

    s/glovbal/global/

WBR, Sergei
