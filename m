Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2DCL6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 07:58:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39488 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2DCL61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 07:58:27 -0400
Message-ID: <4F7AE584.3050805@mvista.com>
Date: Tue, 03 Apr 2012 15:56:52 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Thang Q. Nguyen" <tqnguyen@apm.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeff Garzik <jgarzik@pobox.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/1] Add support 2 SATA ports for Maui and change filename
 from sata_dwc_460ex.c to sata_dwc_4xx.c
References: <1333447938-16461-1-git-send-email-tqnguyen@apm.com>
In-Reply-To: <1333447938-16461-1-git-send-email-tqnguyen@apm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03-04-2012 14:12, Thang Q. Nguyen wrote:

> Signed-off-by: Thang Q. Nguyen<tqnguyen@apm.com>
> ---
> Changes for v2:
> 	- Use git rename feature to change the driver to the newname and for
> 	  easier review.

>   arch/powerpc/boot/dts/bluestone.dts              |   21 +
>   drivers/ata/Makefile                             |    2 +-
>   drivers/ata/{sata_dwc_460ex.c =>  sata_dwc_4xx.c} | 1371 ++++++++++++++--------
>   3 files changed, 904 insertions(+), 490 deletions(-)
>   rename drivers/ata/{sata_dwc_460ex.c =>  sata_dwc_4xx.c} (56%)

    You submitted a magapatch doing several things at once (some even 
needlessly) and even in two areas of the kernel. This needs proper 
splitting/description.

> diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
> index cfa23bf..803fda6 100644
> --- a/arch/powerpc/boot/dts/bluestone.dts
> +++ b/arch/powerpc/boot/dts/bluestone.dts
> @@ -155,6 +155,27 @@
>   					/*RXDE*/  0x5 0x4>;
>   		};
>
> +		/* SATA DWC devices */
> +		SATA0: sata@bffd1000 {
> +			compatible = "amcc,sata-apm821xx";
> +			reg =<4 0xbffd1000 0x800   /* SATA0 */
> +			       4 0xbffd0800 0x400>; /* AHBDMA */
> +			dma-channel=<0>;
> +			interrupt-parent =<&UIC0>;
> +			interrupts =<26 4    /* SATA0 */
> +			              25 4>;  /* AHBDMA */
> +		};
> +
> +		SATA1: sata@bffd1800 {
> +			compatible = "amcc,sata-apm821xx";
> +			reg =<4 0xbffd1800 0x800   /* SATA1 */
> +			       4 0xbffd0800 0x400>; /* AHBDMA */
> +			dma-channel=<1>;
> +			interrupt-parent =<&UIC0>;
> +			interrupts =<27 4    /* SATA1 */
> +			              25 4>;  /* AHBDMA */
> +		};
> +
>   		POB0: opb {
>   			compatible = "ibm,opb";
>   			#address-cells =<1>;

    The above should be in a separate patch for PPC people, of course.

> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_4xx.c
> similarity index 56%
> rename from drivers/ata/sata_dwc_460ex.c
> rename to drivers/ata/sata_dwc_4xx.c
> index 69f7cde..bdbb35a 100644
> --- a/drivers/ata/sata_dwc_460ex.c
> +++ b/drivers/ata/sata_dwc_4xx.c
> @@ -1,5 +1,5 @@
>   /*
> - * drivers/ata/sata_dwc_460ex.c
> + * drivers/ata/sata_dwc_4xx.c

    This line should be removed altogether.

>    *
>    * Synopsys DesignWare Cores (DWC) SATA host driver
>    *
[...]
> @@ -135,13 +146,12 @@ enum {
>   	DMA_CTL_LLP_DSTEN =	0x08000000, /* Blk chain enable Dst */
>   };
>
> -#define	DMA_CTL_BLK_TS(size)	((size)&  0x000000FFF)	/* Blk Transfer size */
> +#define DMA_CTL_BLK_TS(size)	((size)&  0x000000FFF)	/* Blk Transfer size */

    Avoid random whitespoace changes.

>   #define DMA_CHANNEL(ch)		(0x00000001<<  (ch))	/* Select channel */
>   	/* Enable channel */
> -#define	DMA_ENABLE_CHAN(ch)	((0x00000001<<  (ch)) |			\
> -				 ((0x000000001<<  (ch))<<  8))
> +#define	DMA_ENABLE_CHAN(ch)	(0x00000101<<  (ch))
>   	/* Disable channel */
> -#define	DMA_DISABLE_CHAN(ch)	(0x00000000 | ((0x000000001<<  (ch))<<  8))
> +#define	DMA_DISABLE_CHAN(ch)	(0x000000100<<  (ch))
>   	/* Transfer Type&  Flow Controller */

   These cleanups are not related to adding support for 2 channels

> @@ -298,43 +313,32 @@ struct sata_dwc_device_port {
>   #define HSDEV_FROM_QC(qc)	((struct sata_dwc_device *)\
>   					(qc)->ap->host->private_data)
>   #define HSDEV_FROM_HSDEVP(p)	((struct sata_dwc_device *)\
> -						(hsdevp)->hsdev)
> +					(hsdevp)->hsdev)

    Avoid random whitespoace changes.

> +/*
> + * Globals
> + */
> +static struct sata_dwc_device *dwc_dev_list[2];
> +static struct ahb_dma_regs *sata_dma_regs;

    This assumes that the system only has single controller, doesn't it?

>  /*
> - * Function: get_burst_length_encode
> - * arguments: datalength: length in bytes of data
> - * returns value to be programmed in register corresponding to data length
> + * Calculate value to be programmed in register corresponding to data length
>   * This value is effectively the log(base 2) of the length
>   */
> -static  int get_burst_length_encode(int datalength)
> +static int get_burst_length_encode(int datalength)

    Is it releated to adding support to 2 ports?

>   {
>   	int items = datalength>>  2;	/* div by 4 to get lword count */
>
> @@ -414,152 +416,205 @@ static  int get_burst_length_encode(int datalength)
>   	return 0;
>   }
>
> -static  void clear_chan_interrupts(int c)
> +/*
> + * Clear channel interrupt. No interrupt for the specified channel
> + * generated until it is enabled again.
> + */
> +static void clear_chan_interrupts(int c)
>   {
> -	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.tfr.low),
> -		 DMA_CHANNEL(c));
> -	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.block.low),
> +	out_le32(&(sata_dma_regs->interrupt_clear.tfr.low), DMA_CHANNEL(c));
> +	out_le32(&(sata_dma_regs->interrupt_clear.block.low), DMA_CHANNEL(c));
> +	out_le32(&(sata_dma_regs->interrupt_clear.srctran.low),
>   		 DMA_CHANNEL(c));
> -	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.srctran.low),
> -		 DMA_CHANNEL(c));
> -	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.dsttran.low),
> -		 DMA_CHANNEL(c));
> -	out_le32(&(host_pvt.sata_dma_regs->interrupt_clear.error.low),
> +	out_le32(&(sata_dma_regs->interrupt_clear.dsttran.low),
>   		 DMA_CHANNEL(c));
> +	out_le32(&(sata_dma_regs->interrupt_clear.error.low), DMA_CHANNEL(c));

    () with & are not necessary.

>   }
>
>   /*
> - * Function: dma_request_channel
> - * arguments: None
> - * returns channel number if available else -1
> - * This function assigns the next available DMA channel from the list to the
> - * requester
> + * Check if the selected DMA channel is currently enabled.
>    */
> -static int dma_request_channel(void)
> +static int sata_dwc_dma_chk_en(int ch)
>   {
> -	int i;
> +	u32 dma_chan_reg;
> +	/* Read the DMA channel register */
> +	dma_chan_reg = in_le32(&(sata_dma_regs->dma_chan_en.low));
> +	/* Check if it is currently enabled */
> +	if (dma_chan_reg & DMA_CHANNEL(ch))
> +		return 1;
> +	return 0;
> +}

    Is this related to the claimed subject of adding support for 2 ports?

>
> -	for (i = 0; i<  DMA_NUM_CHANS; i++) {
> -		if (!(in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low))&\
> -			DMA_CHANNEL(i)))
> -			return i;
> +/*
> + * Terminate the current DMA transfer
> + *
> + * Refer to the "Abnormal Transfer Termination" section
> + * Disable the corresponding bit in the ChEnReg register
> + * and poll that register to until the channel is terminated.
> + */
> +static void sata_dwc_dma_terminate(struct ata_port *ap, int dma_ch)
> +{
> +	int enabled = sata_dwc_dma_chk_en(dma_ch);
> +	/* If the channel is currenly in use, release it. */
> +	if (enabled)  {
> +		dev_dbg(ap->dev,
> +			"%s terminate DMA on channel=%d (mask=0x%08x) ...",
> +			__func__, dma_ch, DMA_DISABLE_CHAN(dma_ch));
> +		dev_dbg(ap->dev, "ChEnReg=0x%08x\n",
> +			in_le32(&(sata_dma_regs->dma_chan_en.low)));
> +		/* Disable the selected channel */
> +		out_le32(&(sata_dma_regs->dma_chan_en.low),
> +			DMA_DISABLE_CHAN(dma_ch));
> +
> +		/* Wait for the channel is disabled */
> +		do {
> +			enabled = sata_dwc_dma_chk_en(dma_ch);
> +			ndelay(1000);
> +		} while (enabled);
> +		dev_dbg(ap->dev, "done\n");
>   	}
> -	dev_err(host_pvt.dwc_dev, "%s NO channel chan_en: 0x%08x\n", __func__,
> -		in_le32(&(host_pvt.sata_dma_regs->dma_chan_en.low)));
> +}

    Same question.

> +
> +/*
> + * Check if the DMA channel is currently available for transferring data
> + * on the specified ata_port.
> + */
> +static int dma_request_channel(struct ata_port *ap)
> +{
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	/* Check if the channel is not currently in use */
> +	if (!(in_le32(&(sata_dma_regs->dma_chan_en.low))&\
> +		DMA_CHANNEL(hsdev->dma_channel)))
> +		return hsdev->dma_channel;
> +
> +	dev_err(ap->dev, "%s Channel %d is currently in use\n", __func__,
> +		hsdev->dma_channel);
>   	return -1;
>   }

    Same question.

> +/*
> + * Registers ISR for a particular DMA channel interrupt
> + */
> +static int dma_request_interrupts(struct sata_dwc_device *hsdev, int irq)
> +{
> +	int retval;
> +
> +	/* Unmask error interrupt */
> +	out_le32(&sata_dma_regs->interrupt_mask.error.low,
> +		in_le32(&sata_dma_regs->interrupt_mask.error.low) |
> +		 DMA_ENABLE_CHAN(hsdev->dma_channel));
> +
> +	/* Unmask end-of-transfer interrupt */
> +	out_le32(&sata_dma_regs->interrupt_mask.tfr.low,
> +		in_le32(&sata_dma_regs->interrupt_mask.tfr.low) |
> +		 DMA_ENABLE_CHAN(hsdev->dma_channel));
> +
> +	retval = request_irq(irq, dma_dwc_handler, IRQF_SHARED, "SATA DMA",
> +		hsdev);
>   	if (retval) {
> -		dev_err(host_pvt.dwc_dev, "%s: could not get IRQ %d\n",
> +		dev_err(hsdev->dev, "%s: could not get IRQ %d\n",\
>   		__func__, irq);
>   		return -ENODEV;
>   	}
>
>   	/* Mark this interrupt as requested */
>   	hsdev->irq_dma = irq;
> +
>   	return 0;
>   }

    Same question.

>   /*
> - * Function: dma_dwc_exit
> - * arguments: None
> - * returns status
> - * This function exits the SATA DMA driver
> - */
> -static void dma_dwc_exit(struct sata_dwc_device *hsdev)
> -{
> -	dev_dbg(host_pvt.dwc_dev, "%s:\n", __func__);
> -	if (host_pvt.sata_dma_regs) {
> -		iounmap(host_pvt.sata_dma_regs);
> -		host_pvt.sata_dma_regs = NULL;
> -	}
> -
> -	if (hsdev->irq_dma) {
> -		free_irq(hsdev->irq_dma, hsdev);
> -		hsdev->irq_dma = 0;
> -	}
> -}

    Same question.

>   static int sata_dwc_scr_read(struct ata_link *link, unsigned int scr, u32 *val)
>   {
> -	if (scr>  SCR_NOTIFICATION) {
> +	if (unlikely(scr>  SCR_NOTIFICATION)) {
>   		dev_err(link->ap->dev, "%s: Incorrect SCR offset 0x%02x\n",
>   			__func__, scr);
>   		return -EINVAL;
>   	}
>
>   	*val = in_le32((void *)link->ap->ioaddr.scr_addr + (scr * 4));
> -	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=val=0x%08x\n",
> +	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=0x%08x\n",
>   		__func__, link->ap->print_id, scr, *val);
>
>   	return 0;
> @@ -828,7 +867,7 @@ static int sata_dwc_scr_write(struct ata_link *link, unsigned int scr, u32 val)
>   {
>   	dev_dbg(link->ap->dev, "%s: id=%d reg=%d val=val=0x%08x\n",
>   		__func__, link->ap->print_id, scr, val);
> -	if (scr>  SCR_NOTIFICATION) {
> +	if (unlikely(scr>  SCR_NOTIFICATION)) {
>   		dev_err(link->ap->dev, "%s: Incorrect SCR offset 0x%02x\n",
>   			 __func__, scr);
>   		return -EINVAL;

    Same question.

> @@ -838,23 +877,24 @@ static int sata_dwc_scr_write(struct ata_link *link, unsigned int scr, u32 val)
>   	return 0;
>   }
>
> -static u32 core_scr_read(unsigned int scr)
> +static u32 core_scr_read(struct ata_port *ap, unsigned int scr)
>   {
> -	return in_le32((void __iomem *)(host_pvt.scr_addr_sstatus) +\
> -			(scr * 4));
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);

    Insert empty line here, please.

> +	return in_le32((void __iomem *)hsdev->scr_base + (scr * 4));
>   }
>
> -static void core_scr_write(unsigned int scr, u32 val)
> +
> +static void core_scr_write(struct ata_port *ap, unsigned int scr, u32 val)
>   {
> -	out_le32((void __iomem *)(host_pvt.scr_addr_sstatus) + (scr * 4),
> -		val);
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);

     And here.

> +	out_le32((void __iomem *)hsdev->scr_base + (scr * 4), val);
>   }
>
> -static void clear_serror(void)
> +static void clear_serror(struct ata_port *ap)
>   {
> -	u32 val;
> -	val = core_scr_read(SCR_ERROR);
> -	core_scr_write(SCR_ERROR, val);
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);

    And here.

> +	out_le32((void __iomem *)hsdev->scr_base + 4,
> +		in_le32((void __iomem *)hsdev->scr_base + 4));
>
>   }
>
> @@ -864,12 +904,105 @@ static void clear_interrupt_bit(struct sata_dwc_device *hsdev, u32 bit)
>   		 in_le32(&hsdev->sata_dwc_regs->intpr));
>   }
>
> +/*
> + * Porting the ata_bus_softreset function from the libata-sff.c library.
> + */
> +static int sata_dwc_bus_softreset(struct ata_port *ap, unsigned int devmask,
> +		unsigned long deadline)
> +{
> +	struct ata_ioports *ioaddr =&ap->ioaddr;
> +
> +	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
> +
> +	/* Software reset.  causes dev0 to be selected */
> +	iowrite8(ap->ctl, ioaddr->ctl_addr);
> +	udelay(20);	/* FIXME: flush */
> +	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
> +	udelay(20);	/* FIXME: flush */
> +	iowrite8(ap->ctl, ioaddr->ctl_addr);
> +	ap->last_ctl = ap->ctl;
> +
> +	/* Wait the port to become ready */
> +	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
> +}

    I don't see

> +
> +/*
> + * Do soft reset on the current SATA link.
> + */
> +static int sata_dwc_softreset(struct ata_link *link, unsigned int *classes,
> +				unsigned long deadline)
> +{
> +	int rc;
> +	u8 err;
> +	struct ata_port *ap = link->ap;
> +	unsigned int devmask = 0;

    Why delcare it at all if it's always 0?

> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	/* Select device 0 again */
> +	ap->ops->sff_dev_select(ap, 0);
> +
> +	DPRINTK("about to softreset, devmask=%x\n", devmask);
> +	rc = sata_dwc_bus_softreset(ap, devmask, deadline);
> +
> +	/* If link is occupied, -ENODEV too is an error */
> +	if (rc && (rc != -ENODEV || sata_scr_valid(link))) {
> +		ata_link_printk(link, KERN_ERR, "SRST failed(errno=%d)\n", rc);
> +		return rc;
> +	}
> +
> +	/* Determine by signature whether we have ATA or ATAPI devices */
> +	classes[0] = ata_sff_dev_classify(&link->device[0],
> +				devmask&  (1<<  0),&err);

     Always 0, and it should be 1.

> +	DPRINTK("EXIT, classes[0]=%u [1]=%u\n", classes[0], classes[1]);

    classes[1] will always be empty.

> +	clear_serror(link->ap);
> +
> +	/* Terminate DMA if it is currently in use */
> +	sata_dwc_dma_terminate(link->ap, hsdev->dma_channel);

    Isn't it too late?

> +
> +	return rc;
> +}
> +
> +/*
> + * Reset all internal parameters to default value.
> + * This function should be called in hardreset
> + */
> +static void dwc_reset_internal_params(struct ata_port *ap)
> +{
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	int tag;

    Empty line here please.

> +	for (tag = 0; tag<  SATA_DWC_QCMD_MAX; tag++)
> +		hsdevp->dma_pending[tag] = SATA_DWC_DMA_PENDING_NONE;
> +
> +	hsdevp->sata_dwc_sactive_issued = 0;
> +	hsdevp->sata_dwc_sactive_queued = 0;
> +}
> +
> +static int sata_dwc_hardreset(struct ata_link *link, unsigned int *classes,
> +			unsigned long deadline)
> +{
> +	int rc;
> +	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +	bool online;
> +
> +	/* Reset internal parameters to default values */
> +	dwc_reset_internal_params(link->ap);
> +
> +	/* Call standard hard reset */
> +	rc = sata_link_hardreset(link, timing, deadline,&online, NULL);
> +
> +	/* Reconfigure the port after hard reset */
> +	if (ata_link_online(link))
> +		sata_dwc_init_port(link->ap);
> +
> +	return online ? -EAGAIN : rc;
> +}
> +

    What does this have to do with adding support for 2 ports again?

> @@ -918,11 +1049,7 @@ static void sata_dwc_error_intr(struct ata_port *ap,
>   }
>
>   /*
> - * Function : sata_dwc_isr
> - * arguments : irq, void *dev_instance, struct pt_regs *regs
> - * Return value : irqreturn_t - status of IRQ
>   * This Interrupt handler called via port ops registered function.
> - * .irq_handler = sata_dwc_isr
>   */
>   static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
>   {
> @@ -930,14 +1057,14 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
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
>
>   	/* Read the interrupt register */
>   	intpr = in_le32(&hsdev->sata_dwc_regs->intpr);
> @@ -958,38 +1085,61 @@ static irqreturn_t sata_dwc_isr(int irq, void *dev_instance)
>   	/* Check for DMA SETUP FIS (FP DMA) interrupt */
>   	if (intpr&  SATA_DWC_INTPR_NEWFP) {
>   		clear_interrupt_bit(hsdev, SATA_DWC_INTPR_NEWFP);
> +		if (ap->qc_allocated == 0x0) {
> +			handled = 1;
> +			goto DONE;
> +		}
>
>   		tag = (u8)(in_le32(&hsdev->sata_dwc_regs->fptagr));
> +		mask = qcmd_tag_to_mask(tag);
>   		dev_dbg(ap->dev, "%s: NEWFP tag=%d\n", __func__, tag);
> -		if (hsdevp->cmd_issued[tag] != SATA_DWC_CMD_ISSUED_PEND)
> +		if ((hsdevp->sata_dwc_sactive_queued&  mask) == 0)
>   			dev_warn(ap->dev, "CMD tag=%d not pending?\n", tag);
>
> -		host_pvt.sata_dwc_sactive_issued |= qcmd_tag_to_mask(tag);
> -
>   		qc = ata_qc_from_tag(ap, tag);
>   		/*
>   		 * Start FP DMA for NCQ command.  At this point the tag is the
>   		 * active tag.  It is the tag that matches the command about to
>   		 * be completed.
>   		 */
> -		qc->ap->link.active_tag = tag;
> -		sata_dwc_bmdma_start_by_tag(qc, tag);
> +		if (qc) {
> +			hsdevp->sata_dwc_sactive_issued |= mask;
> +			/* Prevent to issue more commands */
> +			qc->ap->link.active_tag = tag;
> +			qc->dev->link->sactive |= (1<<  qc->tag);
> +			num_lli = map_sg_to_lli(ap, qc->sg, qc->n_elem, \
> +				hsdevp->llit[tag], hsdevp->llit_dma[tag], \
> +				(void *__iomem)(&hsdev->sata_dwc_regs->dmadr), \
> +				qc->dma_dir);
> +			sata_dwc_bmdma_start_by_tag(qc, tag);
> +			wmb();
> +			qc->ap->hsm_task_state = HSM_ST_LAST;
> +		} else {
> +		    hsdevp->sata_dwc_sactive_issued&= ~mask;
> +		    dev_warn(ap->dev, "No QC available for tag %d (intpr="
> +		    "0x%08x, qc_allocated=0x%08x, qc_active=0x%08x)\n", tag,\
> +			intpr, ap->qc_allocated, ap->qc_active);

    Indent the above preperly with tabs.

> +		}
>
[...]
> @@ -1167,70 +1245,51 @@ static void sata_dwc_clear_dmacr(struct sata_dwc_device_port *hsdevp, u8 tag)
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
> -	if (tag>  0) {
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

    What does this chenge have to do with the claimed target of thye patch.

>   static int sata_dwc_qc_complete(struct ata_port *ap, struct ata_queued_cmd *qc,
>   				u32 check_status)
>   {
> -	u8 status = 0;
> -	u32 mask = 0x0;
> +	u8 status;
> +	int i;
>   	u8 tag = qc->tag;
>   	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> -	host_pvt.sata_dwc_sactive_queued = 0;
> +	u32 serror;
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
> +		i = 0;
> +		while (status&  ATA_BUSY) {
> +			if (++i>  10)
> +				break;
> +			status = ap->ops->sff_check_altstatus(ap);
> +		};
> +
> +		if (unlikely(status&  ATA_BUSY))
> +			dev_err(ap->dev, "QC complete cmd=0x%02x STATUS BUSY "
> +				"(0x%02x) [%d]\n", qc->tf.command, status, i);
> +		serror = core_scr_read(ap, SCR_ERROR);
> +		if (unlikely(serror&  SATA_DWC_SERROR_ERR_BITS))
> +			dev_err(ap->dev, "****** SERROR=0x%08x ******\n",
> +				serror);
> +	}
>   	dev_dbg(ap->dev, "QC complete cmd=0x%02x status=0x%02x ata%u:"
>   		" protocol=%d\n", qc->tf.command, status, ap->print_id,
>   		 qc->tf.protocol);
>
> -	/* clear active bit */
> -	mask = (~(qcmd_tag_to_mask(tag)));
> -	host_pvt.sata_dwc_sactive_queued = (host_pvt.sata_dwc_sactive_queued) \
> -						&  mask;
> -	host_pvt.sata_dwc_sactive_issued = (host_pvt.sata_dwc_sactive_issued) \
> -						&  mask;
> -	ata_qc_complete(qc);
> +	hsdevp->sata_dwc_sactive_issued&= ~qcmd_tag_to_mask(tag);
> +
> +	/* Complete taskfile transaction (does not read SCR registers) */
> +	if (ata_is_atapi(qc->tf.protocol))
> +		ata_sff_hsm_move(ap, qc, status, 0);
> +	else
> +		ata_qc_complete(qc);
> +
> +	if (hsdevp->sata_dwc_sactive_queued == 0)
> +		ap->link.active_tag = ATA_TAG_POISON;
> +
>   	return 0;
>   }

    Same question.

> +static void sata_dwc_init_port(struct ata_port *ap)
> +{
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	/* Configure DMA */
> +	if (ap->port_no == 0)  {
> +		dev_dbg(ap->dev, "%s: clearing TXCHEN, RXCHEN in DMAC\n",
> +				__func__);
> +
> +		/* Clear all transmit/receive bits */
> +		out_le32(&hsdev->sata_dwc_regs->dmacr,
> +			 SATA_DWC_DMACR_TXRXCH_CLEAR);
> +
> +		dev_dbg(ap->dev, "%s: setting burst size DBTSR\n", __func__);
> +		out_le32(&hsdev->sata_dwc_regs->dbtsr,
> +			 (SATA_DWC_DBTSR_MWR(AHB_DMA_BRST_DFLT) |
> +			  SATA_DWC_DBTSR_MRD(AHB_DMA_BRST_DFLT)));

    Why not put the above init. in a separate function, instead of associating 
with channehl 0?

> +	}
> +
> +	/* Enable interrupts */
> +	sata_dwc_enable_interrupts(hsdev);
> +}
> +
>   static void sata_dwc_setup_port(struct ata_ioports *port, unsigned long base)
>   {
>   	port->cmd_addr = (void *)base + 0x00;
> @@ -1276,10 +1359,7 @@ static void sata_dwc_setup_port(struct ata_ioports *port, unsigned long base)
>   }
>
>   /*
> - * Function : sata_dwc_port_start
> - * arguments : struct ata_ioports *port
> - * Return value : returns 0 if success, error code otherwise
> - * This function allocates the scatter gather LLI table for AHB DMA
> + * Allocates the scatter gather LLI table for AHB DMA
>    */
>   static int sata_dwc_port_start(struct ata_port *ap)
>   {
> @@ -1287,6 +1367,7 @@ static int sata_dwc_port_start(struct ata_port *ap)
>   	struct sata_dwc_device *hsdev;
>   	struct sata_dwc_device_port *hsdevp = NULL;
>   	struct device *pdev;
> +	u32 sstatus;
>   	int i;
>
>   	hsdev = HSDEV_FROM_AP(ap);
> @@ -1308,12 +1389,10 @@ static int sata_dwc_port_start(struct ata_port *ap)
>   		err = -ENOMEM;
>   		goto CLEANUP;
>   	}
> +	memset(hsdevp, 0, sizeof(*hsdevp));

   We already called kzalloc(), so the allocated buffer is already cleared.

>   	hsdevp->hsdev = hsdev;
>
> -	for (i = 0; i<  SATA_DWC_QCMD_MAX; i++)
> -		hsdevp->cmd_issued[i] = SATA_DWC_CMD_ISSUED_NOT;
> -
> -	ap->bmdma_prd = 0;	/* set these so libata doesn't use them */
> +	ap->bmdma_prd = 0;  /* set these so libata doesn't use them */

    Avoid random whitespace changes.

> @@ -1347,32 +1426,47 @@ static int sata_dwc_port_start(struct ata_port *ap)
>   	}
>
>   	/* Clear any error bits before libata starts issuing commands */
> -	clear_serror();
> +	clear_serror(ap);
>   	ap->private_data = hsdevp;
> +
> +	/* Are we in Gen I or II */
> +	sstatus = core_scr_read(ap, SCR_STATUS);
> +	switch (SATA_DWC_SCR0_SPD_GET(sstatus)) {
> +	case 0x0:
> +		dev_info(ap->dev, "**** No neg speed (nothing attached?)\n");
> +		break;
> +	case 0x1:
> +		dev_info(ap->dev, "**** GEN I speed rate negotiated\n");
> +		break;
> +	case 0x2:
> +		dev_info(ap->dev, "**** GEN II speed rate negotiated\n");
> +		break;
> +	}
> +

    libata will negoptiate the speed, why this is needed?

>   static void sata_dwc_port_stop(struct ata_port *ap)
>   {
>   	int i;
> -	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
>   	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
>
>   	dev_dbg(ap->dev, "%s: ap->id = %d\n", __func__, ap->print_id);
>
> -	if (hsdevp&&  hsdev) {
> -		/* deallocate LLI table */
> +	if (hsdevp) {
> +		/* De-allocate LLI table */
>   		for (i = 0; i<  SATA_DWC_QCMD_MAX; i++) {
>   			dma_free_coherent(ap->host->dev,
> -					  SATA_DWC_DMAC_LLI_TBL_SZ,
> -					 hsdevp->llit[i], hsdevp->llit_dma[i]);
> +				SATA_DWC_DMAC_LLI_TBL_SZ,
> +				hsdevp->llit[i], hsdevp->llit_dma[i]);

    It was properly indented before.

> @@ -1381,15 +1475,76 @@ static void sata_dwc_port_stop(struct ata_port *ap)
>   }
>
>   /*
> - * Function : sata_dwc_exec_command_by_tag
> - * arguments : ata_port *ap, ata_taskfile *tf, u8 tag, u32 cmd_issued
> - * Return value : None
> - * This function keeps track of individual command tag ids and calls
> - * ata_exec_command in libata
> + * As our SATA is master only, no dev_select function needed.
> + * This just overwrite the ata_sff_dev_select() function in
> + * libata-sff
> + */
> +void sata_dwc_dev_select(struct ata_port *ap, unsigned int device)
> +{
> +	ndelay(100);

    Why?

> +}
> +
> +/**
> + * Filter ATAPI cmds which are unsuitable for DMA.
> + *
> + * The bmdma engines cannot handle speculative data sizes
> + * (bytecount under/over flow). So only allow DMA for
> + * data transfer commands with known data sizes.
> + */
> +static int sata_dwc_check_atapi_dma(struct ata_queued_cmd *qc)
> +{
> +	struct scsi_cmnd *scmd = qc->scsicmd;
> +	int pio = 1; /* ATAPI DMA disabled by default */
> +	unsigned int lba;
> +
> +	if (scmd) {
> +		switch (scmd->cmnd[0]) {
> +		case WRITE_6:
> +		case WRITE_10:
> +		case WRITE_12:
> +		case READ_6:
> +		case READ_10:
> +		case READ_12:
> +			pio = 0; /* DMA is safe */
> +			break;
> +		}
> +
> +		/* Command WRITE_10 with LBA between -45150 (FFFF4FA2)
> +		 * and -1 (FFFFFFFF) shall use PIO mode */
> +		if (scmd->cmnd[0] == WRITE_10) {
> +			lba = (scmd->cmnd[2]<<  24) |
> +				(scmd->cmnd[3]<<  16) |
> +				(scmd->cmnd[4]<<  8) |
> +				 scmd->cmnd[5];
> +			if (lba>= 0xFFFF4FA2)
> +				pio = 1;
> +		}
> +		/*
> +		* WORK AROUND: Fix DMA issue when blank CD/DVD disc
> +		* in the drive and user use the 'fdisk -l' command.
> +		* No DMA data returned so we can not complete the QC.
> +		*/
> +		if (scmd->cmnd[0] == READ_10) {
> +			lba = (scmd->cmnd[2]<<  24) |
> +				  (scmd->cmnd[3]<<  16) |
> +				  (scmd->cmnd[4]<<  8) |
> +				   scmd->cmnd[5];
> +			if (lba<  0x20)
> +				pio = 1;
> +		}
> +	}
> +	dev_dbg(qc->ap->dev, "%s - using %s mode for command cmd=0x%02x\n", \
> +		__func__, (pio ? "PIO" : "DMA"), scmd->cmnd[0]);
> +	return pio;
> +}

    ATAPI support is a different matter then 2-port support. Needs to be in a 
separate patch.

> @@ -1437,42 +1588,54 @@ static void sata_dwc_bmdma_start_by_tag(struct ata_queued_cmd *qc, u8 tag)
[...]
>   	dev_dbg(ap->dev, "%s qc=%p tag: %x cmd: 0x%02x dma_dir: %s "
>   		"start_dma? %x\n", __func__, qc, tag, qc->tf.command,
>   		get_dma_dir_descript(qc->dma_dir), start_dma);
> -	sata_dwc_tf_dump(&(qc->tf));
> +	sata_dwc_tf_dump(hsdev->dev, &(qc->tf));

    () with & not necessary.

>
> +	/* Enable to start DMA transfer */
>   	if (start_dma) {
> -		reg = core_scr_read(SCR_ERROR);
> -		if (reg&  SATA_DWC_SERROR_ERR_BITS) {
> +		reg = core_scr_read(ap, SCR_ERROR);
> +		if (unlikely(reg&  SATA_DWC_SERROR_ERR_BITS)) {
>   			dev_err(ap->dev, "%s: ****** SError=0x%08x ******\n",
>   				__func__, reg);

    libata will print SError register...

>   		}
>
> -		if (dir == DMA_TO_DEVICE)
> +		if (dir == DMA_TO_DEVICE) {
>   			out_le32(&hsdev->sata_dwc_regs->dmacr,
>   				SATA_DWC_DMACR_TXCHEN);
> -		else
> +		} else {
>   			out_le32(&hsdev->sata_dwc_regs->dmacr,
>   				SATA_DWC_DMACR_RXCHEN);
> +		}
>
>   		/* Enable AHB DMA transfer on the specified channel */
> -		dma_dwc_xfer_start(dma_chan);
> +		dwc_dma_xfer_start(dma_chan);
> +		hsdevp->sata_dwc_sactive_queued&= ~qcmd_tag_to_mask(tag);
>   	}
>   }
> @@ -1490,34 +1653,98 @@ static void sata_dwc_bmdma_start(struct ata_queued_cmd *qc)
>   	sata_dwc_bmdma_start_by_tag(qc, tag);
>   }
>
> +static u8 sata_dwc_dma_status(struct ata_port *ap)
> +{
> +	u32 status = 0;
> +	u32 tfr_reg, err_reg;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +
> +	/* Check DMA register for status */
> +	tfr_reg = in_le32(&(sata_dma_regs->interrupt_status.tfr.low));
> +	err_reg = in_le32(&(sata_dma_regs->interrupt_status.error.low));
> +
> +	if (unlikely(err_reg&  DMA_CHANNEL(hsdev->dma_channel)))
> +		status = ATA_DMA_ERR | ATA_DMA_INTR;

    Error bit in BMIDE (SFF-8038i) specification doesn't cause interrupt.

> +	else if (tfr_reg&  DMA_CHANNEL(hsdev->dma_channel))
> +		status = ATA_DMA_INTR;
> +	return status;
> +}
> +
[...]
> +
> +int sata_dwc_qc_defer(struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(ap);
> +	u8 status;
> +	int ret;
> +
> +	dev_dbg(qc->ap->dev, "%s -\n", __func__);
> +	ret = ata_std_qc_defer(qc);
> +	if (ret) {
> +		printk(KERN_DEBUG "STD Defer %s cmd %s tag=%d\n",
> +			(ret == ATA_DEFER_LINK) ? "LINK" : "PORT",
> +			ata_get_cmd_descript(qc->tf.command), qc->tag);
> +		return ret;
> +	}
> +
> +	/* Check the SATA host for busy status */
> +	if (ata_is_ncq(qc->tf.protocol)) {
> +		status = ap->ops->sff_check_altstatus(ap);
> +		if (status&  ATA_BUSY) {
> +			dev_dbg(ap->dev,
> +				"Defer PORT cmd %s tag=%d as host is busy\n",
> +				ata_get_cmd_descript(qc->tf.command), qc->tag);
> +			return ATA_DEFER_PORT;/*HOST BUSY*/
> +		}
> +
> +		/* This will prevent collision error */
> +		if (hsdevp->sata_dwc_sactive_issued) {
> +			dev_dbg(ap->dev, "Defer PORT cmd %s with tag %d " \
> +				"because another dma xfer is outstanding\n",
> +				ata_get_cmd_descript(qc->tf.command), qc->tag);

    What kind of NCQ is this if you can't start another comamnd when some are 
active already?!

> +
> +			return ATA_DEFER_PORT;/*DEVICE&HOST BUSY*/
> +		}
> +
> +	}
> +
> +	return 0;
> +}

> +void sata_dwc_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
> +{
> +	iowrite8(tf->command, ap->ioaddr.command_addr);
> +	/* If we have an mmio device with no ctl and no altstatus
> +	 * method, this will fail. No such devices are known to exist.
> +	 */
> +	if (ap->ioaddr.altstatus_addr)

    Isn't it always set?

> +		ioread8(ap->ioaddr.altstatus_addr);
> +
> +	ndelay(400);
>   }

    Why duplicate the standard sff_exec_command() method at all?

> @@ -1525,6 +1752,8 @@ static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
>   	u32 sactive;
>   	u8 tag = qc->tag;
>   	struct ata_port *ap = qc->ap;
> +	struct sata_dwc_device_port *hsdevp = HSDEVP_FROM_AP(qc->ap);
> +	u8 status;
>
>   #ifdef DEBUG_NCQ
>   	if (qc->tag>  0 || ap->link.sactive>  1)
> @@ -1541,50 +1770,148 @@ static unsigned int sata_dwc_qc_issue(struct ata_queued_cmd *qc)
>   	sata_dwc_qc_prep_by_tag(qc, tag);
>
>   	if (ata_is_ncq(qc->tf.protocol)) {
> -		sactive = core_scr_read(SCR_ACTIVE);
> +		status = ap->ops->sff_check_altstatus(ap);
> +		if (status&  ATA_BUSY) {
> +			/* Ignore the QC when device is BUSY */
> +			sactive = core_scr_read(qc->ap, SCR_ACTIVE);
> +			dev_info(ap->dev, "Ignore current QC as device BUSY"
> +				"tag=%d, sactive=0x%08x)\n", qc->tag, sactive);
> +			return AC_ERR_SYSTEM;
> +		}
> +
> +		if (hsdevp->sata_dwc_sactive_issued)
> +			return AC_ERR_SYSTEM;

    Very strange NCQ... was there a point in implementing it at all?

> +
> +		sactive = core_scr_read(qc->ap, SCR_ACTIVE);
>   		sactive |= (0x00000001<<  tag);
> -		core_scr_write(SCR_ACTIVE, sactive);
> +		qc->dev->link->sactive |= (0x00000001<<  tag);

    () not needed.

> +		core_scr_write(qc->ap, SCR_ACTIVE, sactive);
>
>   		dev_dbg(qc->ap->dev, "%s: tag=%d ap->link.sactive = 0x%08x "
> -			"sactive=0x%08x\n", __func__, tag, qc->ap->link.sactive,
> +			"sactive=0x%x\n", __func__, tag, qc->ap->link.sactive,

    Why?

>   			sactive);
>
>   		ap->ops->sff_tf_load(ap,&qc->tf);
> -		sata_dwc_exec_command_by_tag(ap,&qc->tf, qc->tag,
> -					     SATA_DWC_CMD_ISSUED_PEND);
> +		sata_dwc_exec_command_by_tag(ap,&qc->tf, qc->tag);
>   	} else {
> -		ata_sff_qc_issue(qc);
> +		ap->link.active_tag = qc->tag;
> +		/* Pass QC to libata-sff to process */
> +		ata_bmdma_qc_issue(qc);

    This don't have to do with the claimed subject of the patch.

>   	}
>   	return 0;
>   }
>
>   /*
> - * Function : sata_dwc_qc_prep
> - * arguments : ata_queued_cmd *qc
> - * Return value : None
> - * qc_prep for a particular queued command
> + * Prepare for a particular queued command
>    */
>
>   static void sata_dwc_qc_prep(struct ata_queued_cmd *qc)
>   {
> -	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO))
> +	if ((qc->dma_dir == DMA_NONE) || (qc->tf.protocol == ATA_PROT_PIO)
> +		|| (qc->tf.protocol == ATAPI_PROT_PIO))

    Adding support for ATAPI is another matter than adding support for two 
ports. Should be in a patch of its own.

>   		return;
>
>   #ifdef DEBUG_NCQ
>   	if (qc->tag>  0)
>   		dev_info(qc->ap->dev, "%s: qc->tag=%d ap->active_tag=0x%08x\n",
>   			 __func__, qc->tag, qc->ap->link.active_tag);
> -
> -	return ;
>   #endif
>   }
>
> +/*
> + * Get the QC currently used for transferring data
> + */
> +static struct ata_queued_cmd *sata_dwc_get_active_qc(struct ata_port *ap)
> +{
> +	struct ata_queued_cmd *qc;
> +
> +	qc = ata_qc_from_tag(ap, ap->link.active_tag);
> +	if (qc&&  !(qc->tf.flags&  ATA_TFLAG_POLLING))
> +		return qc;
> +	return NULL;
> +}
> +
> +/*
> + * dwc_lost_interrupt -  check and process if interrupt is lost.
> + * @ap: ATA port
> + *
> + * Process the command when it is timeout.
> + * Check to see if interrupt is lost. If yes, complete the qc.
> + */
> +static void sata_dwc_lost_interrupt(struct ata_port *ap)
> +{
> +	u8 status;
> +	struct sata_dwc_device *hsdev = HSDEV_FROM_AP(ap);
> +	struct ata_queued_cmd *qc;
> +
> +	dev_dbg(ap->dev, "%s -\n", __func__);
> +	/* Only one outstanding command per SFF channel */
> +	qc = sata_dwc_get_active_qc(ap);
> +	/* We cannot lose an interrupt on a non-existent or polled command */
> +	if (!qc)
> +		return;
> +
> +	/* See if the controller thinks it is still busy - if so the command
> +	 isn't a lost IRQ but is still in progress */
> +	status = ap->ops->sff_check_altstatus(ap);
> +	if (status&  ATA_BUSY) {
> +		ata_port_printk(ap, KERN_INFO, "%s - ATA_BUSY\n", __func__);
> +		return;
> +	}
> +
> +	/* There was a command running, we are no longer busy and we have
> +	   no interrupt. */
> +	ata_link_printk(qc->dev->link, KERN_WARNING,
> +		"lost interrupt (Status 0x%x)\n", status);
> +
> +	if (sata_dwc_dma_chk_en(hsdev->dma_channel)) {
> +		/* When DMA does transfer does not complete,
> +		 see if DMA fails */
> +		qc->err_mask |= AC_ERR_DEV;
> +		ap->hsm_task_state = HSM_ST_ERR;
> +		sata_dwc_dma_terminate(ap, hsdev->dma_channel);
> +	}
> +	sata_dwc_qc_complete(ap, qc, 1);
> +}
> +
 > +
>  static void sata_dwc_error_handler(struct ata_port *ap)
>  {
> -	ap->link.flags |= ATA_LFLAG_NO_HRST;
> +	bool thaw = false;
> +	struct ata_queued_cmd *qc;
> +	u8 status = ap->ops->bmdma_status(ap);
> +
> +	qc = sata_dwc_get_active_qc(ap);
> +	/* In case of DMA timeout, process it. */
> +	if (qc && ata_is_dma(qc->tf.protocol)) {
> +		if ((qc->err_mask == AC_ERR_TIMEOUT)
> +			&& (status & ATA_DMA_ERR)) {
> +			qc->err_mask = AC_ERR_HOST_BUS;
> +			thaw = true;
> +		}
> +
> +		if (thaw) {
> +			ap->ops->sff_check_status(ap);
> +			if (ap->ops->sff_irq_clear)
> +				ap->ops->sff_irq_clear(ap);
> +		}
> +	}
> +	if (thaw)
> +		ata_eh_thaw_port(ap);
> +
>  	ata_sff_error_handler(ap);
>  }
>

    I don't think this goes well with adding support for 2 ports. Seems to be 
material for another patch.

[...]
> +u8 sata_dwc_check_status(struct ata_port *ap)
> +{
> +	return ioread8(ap->ioaddr.status_addr);
> +}

    This method is equivalent to ata_sff_check_status(), why redefine it?

> +
> +u8 sata_dwc_check_altstatus(struct ata_port *ap)
> +{
> +	return ioread8(ap->ioaddr.altstatus_addr);
> +}

    This method is optional. The above is equivalent to the default 
implementnation, why redefine it?

> @@ -1604,7 +1931,10 @@ static struct ata_port_operations sata_dwc_ops = {
>   	.inherits		=&ata_sff_port_ops,
>
>   	.error_handler		= sata_dwc_error_handler,
> +	.softreset		= sata_dwc_softreset,
> +	.hardreset		= sata_dwc_hardreset,
>
> +	.qc_defer		= sata_dwc_qc_defer,
>   	.qc_prep		= sata_dwc_qc_prep,
>   	.qc_issue		= sata_dwc_qc_issue,
>
> @@ -1614,8 +1944,17 @@ static struct ata_port_operations sata_dwc_ops = {
>   	.port_start		= sata_dwc_port_start,
>   	.port_stop		= sata_dwc_port_stop,
>
> +	.check_atapi_dma	= sata_dwc_check_atapi_dma,
>   	.bmdma_setup		= sata_dwc_bmdma_setup,
>   	.bmdma_start		= sata_dwc_bmdma_start,
> +	.bmdma_status		= sata_dwc_dma_status,
> +
> +	.sff_dev_select		= sata_dwc_dev_select,
> +	.sff_check_status	= sata_dwc_check_status,
> +	.sff_check_altstatus	= sata_dwc_check_altstatus,
> +	.sff_exec_command	= sata_dwc_exec_command,
> +
> +	.lost_interrupt		= sata_dwc_lost_interrupt,
>   };
>
>   static const struct ata_port_info sata_dwc_port_info[] = {
> @@ -1639,21 +1978,49 @@ static int sata_dwc_probe(struct platform_device *ofdev)
>   	struct ata_port_info pi = sata_dwc_port_info[0];
>   	const struct ata_port_info *ppi[] = {&pi, NULL };
 >

    Why empty line here?

> +	const unsigned int *dma_chan;
> +
>   	/* Allocate DWC SATA device */
> -	hsdev = kzalloc(sizeof(*hsdev), GFP_KERNEL);
> +	hsdev = kmalloc(sizeof(*hsdev), GFP_KERNEL);

    Why change kzalloc() to kmalloc() if you do memset() later?

>   	if (hsdev == NULL) {
>   		dev_err(&ofdev->dev, "kmalloc failed for hsdev\n");
>   		err = -ENOMEM;
> -		goto error;
> +		goto error_out_5;
>   	}
> +	memset(hsdev, 0, sizeof(*hsdev));
>
[...]
> +	/* Identify SATA controller index from the cell-index property */

    Comment don't match the code?

> +	dma_chan = of_get_property(ofdev->dev.of_node, "dma-channel", NULL);
> +	if (dma_chan) {
> +		dev_notice(&ofdev->dev, "Getting DMA channel %d\n", *dma_chan);
> +		hsdev->dma_channel = *dma_chan;
> +	} else {
> +		hsdev->dma_channel = 0;
> +	}
> +
[...]
> @@ -1777,7 +2159,18 @@ static struct platform_driver sata_dwc_driver = {
>   	.remove = sata_dwc_remove,
>   };
>
> -module_platform_driver(sata_dwc_driver);
> +static int __init sata_dwc_init(void)
> +{
> +	return platform_driver_register(&sata_dwc_driver);
> +}
> +
> +static void __exit sata_dwc_exit(void)
> +{
> +	platform_driver_unregister(&sata_dwc_driver);
> +}
> +
> +module_init(sata_dwc_init);
> +module_exit(sata_dwc_exit);

    Why you changed this from module_platfrom_driver()?

MBR, Sergei
