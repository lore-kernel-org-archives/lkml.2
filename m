Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019Ab0ENV5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:57:07 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:37464 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab0ENV5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:57:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Nv5wmKPSLzJmszDGVc9ke7A3S0AM5si2uN9JCjhJiW6rF113EcQVVo7F4V3w7loS7E
         7I7XrkiO6F2F9xDIakEaKFyS8747fQoKUXQuDkqL2eA/4hOO7SNy0rryuPA9/9fBNdrB
         FrWnx7e191Yyzm2U++lUBM1DwfZapYelkNqU8=
Message-ID: <4BEDC72B.10507@pobox.com>
Date: Fri, 14 May 2010 17:56:59 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Rupjyoti Sarmah <rsarmah@amcc.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, sr@denx.de,
       linuxppc-dev@ozlabs.org, Sergei Shtylyov <sshtylyov@mvista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> < resubmission
 >
References: <201005051757.o45HvPmY005954@amcc.com>
In-Reply-To: <201005051757.o45HvPmY005954@amcc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 01:57 PM, Rupjyoti Sarmah wrote:
> +static  void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
> +{
> +	out_le32(&hsdev->sata_dwc_regs->intpr,
> +		 in_le32(&hsdev->sata_dwc_regs->intpr));
> +}
> +
> +static  u32 qcmd_tag_to_mask(u8 tag)
> +{
> +	return 0x00000001<<  (tag&  0x1f);
> +}
> +
> +/* See ahci.c */
> +static void sata_dwc_error_intr(struct ata_port *ap,
> +				struct sata_dwc_device *hsdev, uint intpr)
> +{
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	struct ata_eh_info *ehi =&ap->link.eh_info;
> +	unsigned int err_mask = 0, action = 0;
> +	struct ata_queued_cmd *qc;
> +	u32 serror;
> +	u8 status, tag;
> +	u32 err_reg;
> +
> +	ata_ehi_clear_desc(ehi);
> +
> +	serror = core_scr_read(SCR_ERROR);
> +	status = ap->ops->sff_check_status(ap);
> +
> +	err_reg = in_le32(&(host_pvt.sata_dma_regs->interrupt_status.error.\
> +			low));
> +	tag = ap->link.active_tag;
> +
> +	dev_err(ap->dev, "%s SCR_ERROR=0x%08x intpr=0x%08x status=0x%08x "
> +		"dma_intp=%d pending=%d issued=%d dma_err_status=0x%08x\n",
> +		__func__, serror, intpr, status, host_pvt.dma_interrupt_count,
> +		hsdevp->dma_pending[tag], hsdevp->cmd_issued[tag], err_reg);
> +
> +	/* Clear error register and interrupt bit */
> +	clear_serror();
> +	clear_interrupt_bit(hsdev, SATA_DWC_INTPR_ERR);
> +
> +	/* This is the only error happening now.  TODO check for exact error */
> +	err_mask |= AC_ERR_HOST_BUS;
> +	action |= ATA_EH_RESET;

this is a rather poor error mapping.


> +/******************************************************************************
> + * Function : sata_dwc_isr
> + * arguments : irq, void *dev_instance, struct pt_regs *regs
> + * Return value : irqreturn_t - status of IRQ
> + * This Interrupt handler called via port ops registered function.
> + * .irq_handler = sata_dwc_isr
> + *****************************************************************************/
> +static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
> +{
> +	struct ata_host *host = (struct ata_host *)dev_instance;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_HOST(host);
> +	struct ata_port *ap;
> +	struct ata_queued_cmd *qc;
> +	unsigned long flags;
> +	u8 status, tag;
> +	int handled, num_processed, port = 0;
> +	uint intpr, sactive, sactive2, tag_mask;
> +	struct sata_dwc_device_port *hsdevp;
> +	host_pvt.sata_dwc_sactive_issued = 0;
> +
> +	spin_lock_irqsave(&host->lock, flags);
> +
> +	/* Read the interrupt register */
> +	intpr = in_le32(&hsdev->sata_dwc_regs->intpr);
> +
> +	ap = host->ports[port];
> +	hsdevp = HSDEVP_FROM_AP(ap);
> +
> +	dev_dbg(ap->dev, "%s intpr=0x%08x active_tag=%d\n", __func__, intpr,
> +		ap->link.active_tag);
> +
> +	/* Check for error interrupt */
> +	if (intpr&  SATA_DWC_INTPR_ERR) {
> +		sata_dwc_error_intr(ap, hsdev, intpr);
> +		handled = 1;
> +		goto DONE;
> +	}
> +
> +	/* Check for DMA SETUP FIS (FP DMA) interrupt */
> +	if (intpr&  SATA_DWC_INTPR_NEWFP) {
> +		clear_interrupt_bit(hsdev, SATA_DWC_INTPR_NEWFP);
> +
> +		tag = (u8)(in_le32(&hsdev->sata_dwc_regs->fptagr));
> +		dev_dbg(ap->dev, "%s: NEWFP tag=%d\n", __func__, tag);
> +		if (hsdevp->cmd_issued[tag] != SATA_DWC_CMD_ISSUED_PEND)
> +			dev_warn(ap->dev, "CMD tag=%d not pending?\n", tag);
> +
> +		host_pvt.sata_dwc_sactive_issued |= qcmd_tag_to_mask(tag);
> +
> +		qc = ata_qc_from_tag(ap, tag);
> +		/* Start FP DMA for NCQ command.  At this point the tag is the
> +		 * active tag.  It is the tag that matches the command about to
> +		 * be completed.
> +		 */
> +		qc->ap->link.active_tag = tag;
> +		sata_dwc_bmdma_start_by_tag(qc, tag);
> +
> +		handled = 1;
> +		goto DONE;
> +	}
> +
> +	sactive = core_scr_read(SCR_ACTIVE);
> +	tag_mask = (host_pvt.sata_dwc_sactive_issued | sactive) ^ sactive;
> +
> +	/* If no sactive issued and tag_mask is zero then this is not NCQ */
> +	if (host_pvt.sata_dwc_sactive_issued == 0&&  tag_mask == 0) {
> +		if (ap->link.active_tag == ATA_TAG_POISON)
> +			tag = 0;
> +		else
> +			tag = ap->link.active_tag;
> +		qc = ata_qc_from_tag(ap, tag);
> +
> +		/* DEV interrupt w/ no active qc? */
> +		if (unlikely(!qc || (qc->tf.flags&  ATA_TFLAG_POLLING))) {
> +			dev_err(ap->dev, "%s interrupt with no active qc "
> +				"qc=%p\n", __func__, qc);
> +			ap->ops->sff_check_status(ap);
> +			handled = 1;
> +			goto DONE;
> +		}
> +
> +		status = ap->ops->sff_check_status(ap);
> +
> +		qc->ap->link.active_tag = tag;
> +		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
> +
> +		if (status&  ATA_ERR) {
> +			dev_dbg(ap->dev, "interrupt ATA_ERR (0x%x)\n", status);
> +			sata_dwc_qc_complete(ap, qc, 1);
> +			handled = 1;
> +			goto DONE;
> +		}
> +
> +		dev_dbg(ap->dev, "%s non-NCQ cmd interrupt, protocol: %s\n",
> +			__func__, ata_get_cmd_descript(qc->tf.protocol));
> +DRVSTILLBUSY:
> +		if (ata_is_dma(qc->tf.protocol)) {
> +			/* Each DMA transaction produces 2 interrupts. The DMAC
> +			 * transfer complete interrupt and the SATA controller
> +			 * operation done interrupt. The command should be
> +			 * completed only after both interrupts are seen.
> +			 */
> +			host_pvt.dma_interrupt_count++;
> +			if (hsdevp->dma_pending[tag] == \
> +					SATA_DWC_DMA_PENDING_NONE) {
> +				dev_err(ap->dev, "%s: DMA not pending "
> +					"intpr=0x%08x status=0x%08x pending"
> +					"=%d\n", __func__, intpr, status,
> +					hsdevp->dma_pending[tag]);
> +			}
> +
> +			if ((host_pvt.dma_interrupt_count % 2) == 0)
> +				sata_dwc_dma_xfer_complete(ap, 1);
> +		} else if (ata_is_pio(qc->tf.protocol)) {
> +			ata_sff_hsm_move(ap, qc, status, 0);
> +			handled = 1;
> +			goto DONE;
> +		} else {
> +			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
> +				goto DRVSTILLBUSY;
> +		}
> +
> +		handled = 1;
> +		goto DONE;
> +	}
> +
> +	/*
> +	 * This is a NCQ command. At this point we need to figure out for which
> +	 * tags we have gotten a completion interrupt.  One interrupt may serve
> +	 * as completion for more than one operation when commands are queued
> +	 * (NCQ).  We need to process each completed command.
> +	 */
> +
> +	 /* process completed commands */
> +	sactive = core_scr_read(SCR_ACTIVE);
> +	tag_mask = (host_pvt.sata_dwc_sactive_issued | sactive) ^ sactive;
> +
> +	if (sactive != 0 || (host_pvt.sata_dwc_sactive_issued)>  1 || \
> +							tag_mask>  1) {
> +		dev_dbg(ap->dev, "%s NCQ:sactive=0x%08x  sactive_issued=0x%08x"
> +			"tag_mask=0x%08x\n", __func__, sactive,
> +			host_pvt.sata_dwc_sactive_issued, tag_mask);
> +	}
> +
> +	if ((tag_mask | (host_pvt.sata_dwc_sactive_issued)) != \
> +					(host_pvt.sata_dwc_sactive_issued)) {
> +		dev_warn(ap->dev, "Bad tag mask?  sactive=0x%08x "
> +			 "(host_pvt.sata_dwc_sactive_issued)=0x%08x  tag_mask"
> +			 "=0x%08x\n", sactive, host_pvt.sata_dwc_sactive_issued,
> +			  tag_mask);
> +	}
> +
> +	/* read just to clear ... not bad if currently still busy */
> +	status = ap->ops->sff_check_status(ap);
> +	dev_dbg(ap->dev, "%s ATA status register=0x%x\n", __func__, status);
> +
> +	tag = 0;
> +	num_processed = 0;
> +	while (tag_mask) {
> +		num_processed++;
> +		while (!(tag_mask&  0x00000001)) {
> +			tag++;
> +			tag_mask<<= 1;
> +		}
> +		tag_mask&= (~0x00000001);
> +		qc = ata_qc_from_tag(ap, tag);
> +
> +		/* To be picked up by completion functions */
> +		qc->ap->link.active_tag = tag;
> +		hsdevp->cmd_issued[tag] = SATA_DWC_CMD_ISSUED_NOT;
> +
> +		/* Let libata/scsi layers handle error */
> +		if (status&  ATA_ERR) {
> +			dev_dbg(ap->dev, "%s ATA_ERR (0x%x)\n", __func__,
> +				status);
> +			sata_dwc_qc_complete(ap, qc, 1);
> +			handled = 1;
> +			goto DONE;
> +		}
> +
> +		/* Process completed command */
> +		dev_dbg(ap->dev, "%s NCQ command, protocol: %s\n", __func__,
> +			ata_get_cmd_descript(qc->tf.protocol));
> +		if (ata_is_dma(qc->tf.protocol)) {
> +			host_pvt.dma_interrupt_count++;
> +			if (hsdevp->dma_pending[tag] == \
> +					SATA_DWC_DMA_PENDING_NONE)
> +				dev_warn(ap->dev, "%s: DMA not pending?\n",
> +					__func__);
> +			if ((host_pvt.dma_interrupt_count % 2) == 0)
> +				sata_dwc_dma_xfer_complete(ap, 1);
> +		} else {
> +			if (unlikely(sata_dwc_qc_complete(ap, qc, 1)))
> +				goto STILLBUSY;
> +		}
> +		continue;
> +
> +STILLBUSY:
> +		ap->stats.idle_irq++;
> +		dev_warn(ap->dev, "STILL BUSY IRQ ata%d: irq trap\n",
> +			ap->print_id);
> +	} /* while tag_mask */

why not use ata_qc_complete_multiple?


> +static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag)
> +{
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_HSDEVP(hsdevp);
> +
> +	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX) {
> +		out_le32(&(hsdev->sata_dwc_regs->dmacr),
> +			 SATA_DWC_DMACR_RX_CLEAR(
> +				 in_le32(&(hsdev->sata_dwc_regs->dmacr))));
> +	} else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX) {
> +		out_le32(&(hsdev->sata_dwc_regs->dmacr),
> +			 SATA_DWC_DMACR_TX_CLEAR(
> +				 in_le32(&(hsdev->sata_dwc_regs->dmacr))));
> +	} else {
> +		/* This should not happen, it indicates the driver is out of
> +		 * sync.  If it does happen, clear dmacr anyway.
> +		 */
> +		dev_err(host_pvt.dwc_dev, "%s DMA protocol RX and"
> +			"TX DMA not pending tag=0x%02x pending=%d"
> +			" dmacr: 0x%08x\n", __func__, tag,
> +			hsdevp->dma_pending[tag],
> +			in_le32(&(hsdev->sata_dwc_regs->dmacr)));
> +		out_le32(&(hsdev->sata_dwc_regs->dmacr),
> +			SATA_DWC_DMACR_TXRXCH_CLEAR);
> +	}
> +}
> +
> +static void sata_dwc_dma_xfer_complete(struct ata_port *ap, u32 check_status)
> +{
> +	struct ata_queued_cmd *qc;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +	u8 tag = 0;
> +
> +	tag = ap->link.active_tag;
> +	qc = ata_qc_from_tag(ap, tag);

Note that qc may equal NULL!


> +#ifdef DEBUG_NCQ
> +	if (tag>  0) {
> +		dev_info(ap->dev, "%s tag=%u cmd=0x%02x dma dir=%s proto=%s "
> +			 "dmacr=0x%08x\n", __func__, qc->tag, qc->tf.command,
> +			 ata_get_cmd_descript(qc->dma_dir),
> +			 ata_get_cmd_descript(qc->tf.protocol),
> +			 in_le32(&(hsdev->sata_dwc_regs->dmacr)));
> +	}
> +#endif
> +
> +	if (ata_is_dma(qc->tf.protocol)) {
> +		if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_NONE) {
> +			dev_err(ap->dev, "%s DMA protocol RX and TX DMA not "
> +				"pending dmacr: 0x%08x\n", __func__,
> +				in_le32(&(hsdev->sata_dwc_regs->dmacr)));
> +		}
> +
> +		hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;
> +		sata_dwc_qc_complete(ap, qc, check_status);
> +		ap->link.active_tag = ATA_TAG_POISON;
> +	} else {
> +		sata_dwc_qc_complete(ap, qc, check_status);
> +	}
> +}
> +
> +static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
> +				u32 check_status)
> +{
> +	u8 status = 0;
> +	int i = 0;
> +	u32 mask = 0x0;
> +	u8 tag = qc->tag;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	u32 serror;
> +	host_pvt.sata_dwc_sactive_queued = 0;
> +	dev_dbg(ap->dev, "%s checkstatus? %x\n", __func__, check_status);
> +
> +	if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_TX)
> +		dev_err(ap->dev, "TX DMA PENDING\n");
> +	else if (hsdevp->dma_pending[tag] == SATA_DWC_DMA_PENDING_RX)
> +		dev_err(ap->dev, "RX DMA PENDING\n");
> +
> +	if (check_status) {
> +		i = 0;
> +		do {
> +			/* check main status, clearing INTRQ */
> +			status = ap->ops->sff_check_status(ap);
> +			if (status&  ATA_BUSY) {
> +				dev_dbg(ap->dev, "STATUS BUSY (0x%02x) [%d]\n",
> +						status, i);
> +			}
> +			if (++i>  10)
> +				break;
> +		} while (status&  ATA_BUSY);
> +
> +		status = ap->ops->sff_check_status(ap);
> +		if (unlikely(status&  ATA_BUSY))
> +			dev_err(ap->dev, "QC complete cmd=0x%02x STATUS BUSY"
> +				" (0x%02x)[%d]\n", qc->tf.command, status, i);
> +		serror = core_scr_read(SCR_ERROR);
> +		if (serror&  SATA_DWC_SERROR_ERR_BITS)
> +			dev_err(ap->dev, "****** SERROR=0x%08x ******\n",
> +				serror);
> +	}
> +	dev_dbg(ap->dev, "QC complete cmd=0x%02x status=0x%02x ata%u:"
> +		" protocol=%d\n", qc->tf.command, status, ap->print_id,
> +		 qc->tf.protocol);
> +
> +	/* clear active bit */
> +	mask = (~(qcmd_tag_to_mask(tag)));
> +	host_pvt.sata_dwc_sactive_queued = (host_pvt.sata_dwc_sactive_queued) \
> +						&  mask;
> +	host_pvt.sata_dwc_sactive_issued = (host_pvt.sata_dwc_sactive_issued) \
> +						&  mask;
> +
> +	/* Complete taskfile transaction (does not read SCR registers) */
> +	ata_qc_complete(qc);
> +
> +	return 0;

why is this loop in qc_complete?  That is highly unusual.


> +/******************************************************************************
> + * Function : sata_dwc_qc_prep
> + * arguments : ata_queued_cmd *qc
> + * Return value : None
> + * qc_prep for a particular queued command
> + *****************************************************************************/
> +#if 1
> +static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
> +{
> +	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))
> +		return;
> +
> +#ifdef DEBUG_NCQ
> +	if (qc->tag>  0)
> +		dev_info(qc->ap->dev, "%s: qc->tag=%d ap->active_tag=0x%08x\n",
> +			 __func__, tag, qc->ap->link.active_tag);
> +
> +	return ;
> +#endif
> +}
> +#endif
> +static void sata_dwc_error_handler(struct ata_port *ap)
> +{
> +	ap->link.flags |= ATA_LFLAG_NO_HRST;
> +	ata_sff_error_handler(ap);
> +	ap->link.flags&= ~ATA_LFLAG_NO_HRST;

why do you mess with ATA_LFLAG_NO_HRST in this way?


> +	/* Get SATA interrupt number */
> +	irq = irq_of_parse_and_map(ofdev->node, 0);
> +	if (irq == NO_IRQ) {
> +		dev_err(&ofdev->dev, "no SATA DMA irq\n");
> +		err = -ENODEV;
> +		goto error_out;
> +	}
> +
> +	/*
> +	 * Now, register with libATA core, this will also initiate the
> +	 * device discovery process, invoking our port_start() handler&
> +	 * error_handler() to execute a dummy Softreset EH session
> +	 */
> +	ata_host_activate(host, irq, sata_dwc_isr, 0,&sata_dwc_sht);

handle ata_host_activate failure


