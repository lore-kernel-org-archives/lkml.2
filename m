Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1JASMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 14:12:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:32759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab1JASMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 14:12:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,473,1312182000"; 
   d="scan'208";a="73332850"
Subject: Re: [RFC PATCH 2/2 -mm] RapidIO: TSI721 Add DMA Engine support
From: Vinod Koul <vinod.koul@intel.com>
To: Alexandre Bounine <alexandre.bounine@idt.com>,
        Dan <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
In-Reply-To: <1317418715-9666-2-git-send-email-alexandre.bounine@idt.com>
References: <1317418715-9666-1-git-send-email-alexandre.bounine@idt.com>
	 <1317418715-9666-2-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 01 Oct 2011 23:36:31 +0530
Message-ID: <1317492391.1573.1844.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 17:38 -0400, Alexandre Bounine wrote:
> Adds support for DMA Engine API.
> 
> Includes following changes:
> - Modifies BDMA register offset definitions to support per-channel handling
> - Separates BDMA channel reserved for RIO Maintenance requests
> - Adds DMA Engine callback routines
Dan please review this, I donot agree with approach here
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Kumar Gala <galak@kernel.crashing.org>
> Cc: Matt Porter <mporter@kernel.crashing.org>
> Cc: Li Yang <leoli@freescale.com>
> ---
>  drivers/rapidio/devices/Kconfig      |    8 +
>  drivers/rapidio/devices/Makefile     |    1 +
>  drivers/rapidio/devices/tsi721.c     |  201 ++++++----
>  drivers/rapidio/devices/tsi721.h     |  107 ++++-
>  drivers/rapidio/devices/tsi721_dma.c |  802 ++++++++++++++++++++++++++++++++++
>  5 files changed, 1029 insertions(+), 90 deletions(-)
>  create mode 100644 drivers/rapidio/devices/tsi721_dma.c
> 
> diff --git a/drivers/rapidio/devices/Kconfig b/drivers/rapidio/devices/Kconfig
> index 12a9d7f..3a2db3d 100644
> --- a/drivers/rapidio/devices/Kconfig
> +++ b/drivers/rapidio/devices/Kconfig
> @@ -8,3 +8,11 @@ config RAPIDIO_TSI721
>  	default "n"
>  	---help---
>  	  Include support for IDT Tsi721 PCI Express Serial RapidIO controller.
> +
> +config TSI721_DMA
> +	bool "IDT Tsi721 RapidIO DMA support"
> +	depends on RAPIDIO_TSI721
> +	default "n"
> +	select RAPIDIO_DMA_ENGINE
> +	help
> +	  Enable DMA support for IDT Tsi721 PCIe-to-SRIO controller.
> diff --git a/drivers/rapidio/devices/Makefile b/drivers/rapidio/devices/Makefile
> index 3b7b4e2..8cbce45 100644
> --- a/drivers/rapidio/devices/Makefile
> +++ b/drivers/rapidio/devices/Makefile
> @@ -3,3 +3,4 @@
>  #
>  
>  obj-$(CONFIG_RAPIDIO_TSI721)	+= tsi721.o
> +obj-$(CONFIG_TSI721_DMA) += tsi721_dma.o
> diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
> index 5225930..5e893a6 100644
> --- a/drivers/rapidio/devices/tsi721.c
> +++ b/drivers/rapidio/devices/tsi721.c
> @@ -108,6 +108,7 @@ static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
>  			u16 destid, u8 hopcount, u32 offset, int len,
>  			u32 *data, int do_wr)
>  {
> +	void __iomem *regs = priv->regs + TSI721_DMAC_BASE(priv->mdma.ch_id);
>  	struct tsi721_dma_desc *bd_ptr;
>  	u32 rd_count, swr_ptr, ch_stat;
>  	int i, err = 0;
> @@ -116,10 +117,9 @@ static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
>  	if (offset > (RIO_MAINT_SPACE_SZ - len) || (len != sizeof(u32)))
>  		return -EINVAL;
>  
> -	bd_ptr = priv->bdma[TSI721_DMACH_MAINT].bd_base;
> +	bd_ptr = priv->mdma.bd_base;
>  
> -	rd_count = ioread32(
> -			priv->regs + TSI721_DMAC_DRDCNT(TSI721_DMACH_MAINT));
> +	rd_count = ioread32(regs + TSI721_DMAC_DRDCNT);
>  
>  	/* Initialize DMA descriptor */
>  	bd_ptr[0].type_id = cpu_to_le32((DTYPE2 << 29) | (op << 19) | destid);
> @@ -134,19 +134,18 @@ static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
>  	mb();
>  
>  	/* Start DMA operation */
> -	iowrite32(rd_count + 2,
> -		priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> -	ioread32(priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> +	iowrite32(rd_count + 2,	regs + TSI721_DMAC_DWRCNT);
> +	ioread32(regs + TSI721_DMAC_DWRCNT);
>  	i = 0;
>  
>  	/* Wait until DMA transfer is finished */
> -	while ((ch_stat = ioread32(priv->regs +
> -		TSI721_DMAC_STS(TSI721_DMACH_MAINT))) & TSI721_DMAC_STS_RUN) {
> +	while ((ch_stat = ioread32(regs + TSI721_DMAC_STS))
> +							& TSI721_DMAC_STS_RUN) {
>  		udelay(1);
>  		if (++i >= 5000000) {
>  			dev_dbg(&priv->pdev->dev,
>  				"%s : DMA[%d] read timeout ch_status=%x\n",
> -				__func__, TSI721_DMACH_MAINT, ch_stat);
> +				__func__, priv->mdma.ch_id, ch_stat);
>  			if (!do_wr)
>  				*data = 0xffffffff;
>  			err = -EIO;
> @@ -162,13 +161,10 @@ static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
>  			__func__, ch_stat);
>  		dev_dbg(&priv->pdev->dev, "OP=%d : destid=%x hc=%x off=%x\n",
>  			do_wr ? MAINT_WR : MAINT_RD, destid, hopcount, offset);
> -		iowrite32(TSI721_DMAC_INT_ALL,
> -			priv->regs + TSI721_DMAC_INT(TSI721_DMACH_MAINT));
> -		iowrite32(TSI721_DMAC_CTL_INIT,
> -			priv->regs + TSI721_DMAC_CTL(TSI721_DMACH_MAINT));
> +		iowrite32(TSI721_DMAC_INT_ALL, regs + TSI721_DMAC_INT);
> +		iowrite32(TSI721_DMAC_CTL_INIT, regs + TSI721_DMAC_CTL);
>  		udelay(10);
> -		iowrite32(0, priv->regs +
> -				TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> +		iowrite32(0, regs + TSI721_DMAC_DWRCNT);
>  		udelay(1);
>  		if (!do_wr)
>  			*data = 0xffffffff;
> @@ -184,8 +180,8 @@ static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
>  	 * NOTE: Skipping check and clear FIFO entries because we are waiting
>  	 * for transfer to be completed.
>  	 */
> -	swr_ptr = ioread32(priv->regs + TSI721_DMAC_DSWP(TSI721_DMACH_MAINT));
> -	iowrite32(swr_ptr, priv->regs + TSI721_DMAC_DSRP(TSI721_DMACH_MAINT));
> +	swr_ptr = ioread32(regs + TSI721_DMAC_DSWP);
> +	iowrite32(swr_ptr, regs + TSI721_DMAC_DSRP);
>  err_out:
>  
>  	return err;
> @@ -540,6 +536,22 @@ static irqreturn_t tsi721_irqhandler(int irq, void *ptr)
>  			tsi721_pw_handler(mport);
>  	}
>  
> +#ifdef CONFIG_TSI721_DMA
> +	if (dev_int & TSI721_DEV_INT_BDMA_CH) {
> +		int ch;
> +
> +		if (dev_ch_int & TSI721_INT_BDMA_CHAN_M) {
> +			dev_dbg(&priv->pdev->dev,
> +				"IRQ from DMA channel 0x%08x\n", dev_ch_int);
> +
> +			for (ch = 0; ch < TSI721_DMA_MAXCH; ch++) {
> +				if (!(dev_ch_int & TSI721_INT_BDMA_CHAN(ch)))
> +					continue;
> +				tsi721_bdma_handler(&priv->bdma[ch]);
> +			}
> +		}
> +	}
> +#endif
>  	return IRQ_HANDLED;
>  }
>  
> @@ -552,18 +564,26 @@ static void tsi721_interrupts_init(struct tsi721_device *priv)
>  		priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
>  	iowrite32(TSI721_SR_CHINT_IDBQRCV,
>  		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
> -	iowrite32(TSI721_INT_SR2PC_CHAN(IDB_QUEUE),
> -		priv->regs + TSI721_DEV_CHAN_INTE);
>  
>  	/* Enable SRIO MAC interrupts */
>  	iowrite32(TSI721_RIO_EM_DEV_INT_EN_INT,
>  		priv->regs + TSI721_RIO_EM_DEV_INT_EN);
>  
> +	/* Enable interrupts from channels in use */
> +#ifdef CONFIG_TSI721_DMA
> +	intr = TSI721_INT_SR2PC_CHAN(IDB_QUEUE) |
> +		(TSI721_INT_BDMA_CHAN_M &
> +		 ~TSI721_INT_BDMA_CHAN(TSI721_DMACH_MAINT));
> +#else
> +	intr = TSI721_INT_SR2PC_CHAN(IDB_QUEUE);
> +#endif
> +	iowrite32(intr,	priv->regs + TSI721_DEV_CHAN_INTE);
> +
>  	if (priv->flags & TSI721_USING_MSIX)
>  		intr = TSI721_DEV_INT_SRIO;
>  	else
>  		intr = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
> -			TSI721_DEV_INT_SMSG_CH;
> +			TSI721_DEV_INT_SMSG_CH | TSI721_DEV_INT_BDMA_CH;
>  
>  	iowrite32(intr, priv->regs + TSI721_DEV_INTE);
>  	ioread32(priv->regs + TSI721_DEV_INTE);
> @@ -714,12 +734,29 @@ static int tsi721_enable_msix(struct tsi721_device *priv)
>  					TSI721_MSIX_OMSG_INT(i);
>  	}
>  
> +#ifdef CONFIG_TSI721_DMA
> +	/*
> +	 * Initialize MSI-X entries for Block DMA Engine:
> +	 * this driver supports XXX DMA channels
> +	 * (one is reserved for SRIO maintenance transactions)
> +	 */
> +	for (i = 0; i < TSI721_DMA_CHNUM; i++) {
> +		entries[TSI721_VECT_DMA0_DONE + i].entry =
> +					TSI721_MSIX_DMACH_DONE(i);
> +		entries[TSI721_VECT_DMA0_INT + i].entry =
> +					TSI721_MSIX_DMACH_INT(i);
> +	}
> +#endif /* CONFIG_TSI721_DMA */
> +
>  	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
>  	if (err) {
>  		if (err > 0)
>  			dev_info(&priv->pdev->dev,
>  				 "Only %d MSI-X vectors available, "
>  				 "not using MSI-X\n", err);
> +		else
> +			dev_err(&priv->pdev->dev,
> +				"Failed to enable MSI-X (err=%d)\n", err);
>  		return err;
>  	}
>  
> @@ -759,6 +796,22 @@ static int tsi721_enable_msix(struct tsi721_device *priv)
>  			 i, pci_name(priv->pdev));
>  	}
>  
> +#ifdef CONFIG_TSI721_DMA
> +	for (i = 0; i < TSI721_DMA_CHNUM; i++) {
> +		priv->msix[TSI721_VECT_DMA0_DONE + i].vector =
> +				entries[TSI721_VECT_DMA0_DONE + i].vector;
> +		snprintf(priv->msix[TSI721_VECT_DMA0_DONE + i].irq_name,
> +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-dmad%d@pci:%s",
> +			 i, pci_name(priv->pdev));
> +
> +		priv->msix[TSI721_VECT_DMA0_INT + i].vector =
> +				entries[TSI721_VECT_DMA0_INT + i].vector;
> +		snprintf(priv->msix[TSI721_VECT_DMA0_INT + i].irq_name,
> +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-dmai%d@pci:%s",
> +			 i, pci_name(priv->pdev));
> +	}
> +#endif /* CONFIG_TSI721_DMA */
> +
>  	return 0;
>  }
>  #endif /* CONFIG_PCI_MSI */
> @@ -889,20 +942,34 @@ static void tsi721_doorbell_free(struct tsi721_device *priv)
>  	priv->idb_base = NULL;
>  }
>  
> -static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
> +/**
> + * tsi721_bdma_maint_init - Initialize maintenance request BDMA channel.
> + * @priv: pointer to tsi721 private data
> + *
> + * Initialize BDMA channel allocated for RapidIO maintenance read/write
> + * request generation
> + * Returns %0 on success or %-ENOMEM on failure.
> + */
> +static int tsi721_bdma_maint_init(struct tsi721_device *priv)
>  {
>  	struct tsi721_dma_desc *bd_ptr;
>  	u64		*sts_ptr;
>  	dma_addr_t	bd_phys, sts_phys;
>  	int		sts_size;
> -	int		bd_num = priv->bdma[chnum].bd_num;
> +	int		bd_num = 2;
> +	void __iomem	*regs;
>  
> -	dev_dbg(&priv->pdev->dev, "Init Block DMA Engine, CH%d\n", chnum);
> +	dev_dbg(&priv->pdev->dev,
> +		"Init Block DMA Engine for Maintenance requests, CH%d\n",
> +		TSI721_DMACH_MAINT);
>  
>  	/*
>  	 * Initialize DMA channel for maintenance requests
>  	 */
>  
> +	priv->mdma.ch_id = TSI721_DMACH_MAINT;
> +	regs = priv->regs + TSI721_DMAC_BASE(TSI721_DMACH_MAINT);
> +
>  	/* Allocate space for DMA descriptors */
>  	bd_ptr = dma_alloc_coherent(&priv->pdev->dev,
>  					bd_num * sizeof(struct tsi721_dma_desc),
> @@ -910,8 +977,9 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
>  	if (!bd_ptr)
>  		return -ENOMEM;
>  
> -	priv->bdma[chnum].bd_phys = bd_phys;
> -	priv->bdma[chnum].bd_base = bd_ptr;
> +	priv->mdma.bd_num = bd_num;
> +	priv->mdma.bd_phys = bd_phys;
> +	priv->mdma.bd_base = bd_ptr;
>  
>  	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
>  
> @@ -930,13 +998,13 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
>  		dma_free_coherent(&priv->pdev->dev,
>  				  bd_num * sizeof(struct tsi721_dma_desc),
>  				  bd_ptr, bd_phys);
> -		priv->bdma[chnum].bd_base = NULL;
> +		priv->mdma.bd_base = NULL;
>  		return -ENOMEM;
>  	}
>  
> -	priv->bdma[chnum].sts_phys = sts_phys;
> -	priv->bdma[chnum].sts_base = sts_ptr;
> -	priv->bdma[chnum].sts_size = sts_size;
> +	priv->mdma.sts_phys = sts_phys;
> +	priv->mdma.sts_base = sts_ptr;
> +	priv->mdma.sts_size = sts_size;
>  
>  	memset(sts_ptr, 0, sts_size);
>  
> @@ -951,83 +1019,61 @@ static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
>  	bd_ptr[bd_num - 1].next_hi = cpu_to_le32((u64)bd_phys >> 32);
>  
>  	/* Setup DMA descriptor pointers */
> -	iowrite32(((u64)bd_phys >> 32),
> -		priv->regs + TSI721_DMAC_DPTRH(chnum));
> +	iowrite32(((u64)bd_phys >> 32),	regs + TSI721_DMAC_DPTRH);
>  	iowrite32(((u64)bd_phys & TSI721_DMAC_DPTRL_MASK),
> -		priv->regs + TSI721_DMAC_DPTRL(chnum));
> +		regs + TSI721_DMAC_DPTRL);
>  
>  	/* Setup descriptor status FIFO */
> -	iowrite32(((u64)sts_phys >> 32),
> -		priv->regs + TSI721_DMAC_DSBH(chnum));
> +	iowrite32(((u64)sts_phys >> 32), regs + TSI721_DMAC_DSBH);
>  	iowrite32(((u64)sts_phys & TSI721_DMAC_DSBL_MASK),
> -		priv->regs + TSI721_DMAC_DSBL(chnum));
> +		regs + TSI721_DMAC_DSBL);
>  	iowrite32(TSI721_DMAC_DSSZ_SIZE(sts_size),
> -		priv->regs + TSI721_DMAC_DSSZ(chnum));
> +		regs + TSI721_DMAC_DSSZ);
>  
>  	/* Clear interrupt bits */
> -	iowrite32(TSI721_DMAC_INT_ALL,
> -		priv->regs + TSI721_DMAC_INT(chnum));
> +	iowrite32(TSI721_DMAC_INT_ALL, regs + TSI721_DMAC_INT);
>  
> -	ioread32(priv->regs + TSI721_DMAC_INT(chnum));
> +	ioread32(regs + TSI721_DMAC_INT);
>  
>  	/* Toggle DMA channel initialization */
> -	iowrite32(TSI721_DMAC_CTL_INIT,	priv->regs + TSI721_DMAC_CTL(chnum));
> -	ioread32(priv->regs + TSI721_DMAC_CTL(chnum));
> +	iowrite32(TSI721_DMAC_CTL_INIT,	regs + TSI721_DMAC_CTL);
> +	ioread32(regs + TSI721_DMAC_CTL);
>  	udelay(10);
>  
>  	return 0;
>  }
>  
> -static int tsi721_bdma_ch_free(struct tsi721_device *priv, int chnum)
> +static int tsi721_bdma_maint_free(struct tsi721_device *priv)
>  {
>  	u32 ch_stat;
> +	struct tsi721_bdma_maint *mdma = &priv->mdma;
> +	void __iomem *regs = priv->regs + TSI721_DMAC_BASE(mdma->ch_id);
>  
> -	if (priv->bdma[chnum].bd_base == NULL)
> +	if (mdma->bd_base == NULL)
>  		return 0;
>  
>  	/* Check if DMA channel still running */
> -	ch_stat = ioread32(priv->regs +	TSI721_DMAC_STS(chnum));
> +	ch_stat = ioread32(regs + TSI721_DMAC_STS);
>  	if (ch_stat & TSI721_DMAC_STS_RUN)
>  		return -EFAULT;
>  
>  	/* Put DMA channel into init state */
> -	iowrite32(TSI721_DMAC_CTL_INIT,
> -		priv->regs + TSI721_DMAC_CTL(chnum));
> +	iowrite32(TSI721_DMAC_CTL_INIT,	regs + TSI721_DMAC_CTL);
>  
>  	/* Free space allocated for DMA descriptors */
>  	dma_free_coherent(&priv->pdev->dev,
> -		priv->bdma[chnum].bd_num * sizeof(struct tsi721_dma_desc),
> -		priv->bdma[chnum].bd_base, priv->bdma[chnum].bd_phys);
> -	priv->bdma[chnum].bd_base = NULL;
> +		mdma->bd_num * sizeof(struct tsi721_dma_desc),
> +		mdma->bd_base, mdma->bd_phys);
> +	mdma->bd_base = NULL;
>  
>  	/* Free space allocated for status FIFO */
>  	dma_free_coherent(&priv->pdev->dev,
> -		priv->bdma[chnum].sts_size * sizeof(struct tsi721_dma_sts),
> -		priv->bdma[chnum].sts_base, priv->bdma[chnum].sts_phys);
> -	priv->bdma[chnum].sts_base = NULL;
> -	return 0;
> -}
> -
> -static int tsi721_bdma_init(struct tsi721_device *priv)
> -{
> -	/* Initialize BDMA channel allocated for RapidIO maintenance read/write
> -	 * request generation
> -	 */
> -	priv->bdma[TSI721_DMACH_MAINT].bd_num = 2;
> -	if (tsi721_bdma_ch_init(priv, TSI721_DMACH_MAINT)) {
> -		dev_err(&priv->pdev->dev, "Unable to initialize maintenance DMA"
> -			" channel %d, aborting\n", TSI721_DMACH_MAINT);
> -		return -ENOMEM;
> -	}
> -
> +		mdma->sts_size * sizeof(struct tsi721_dma_sts),
> +		mdma->sts_base, mdma->sts_phys);
> +	mdma->sts_base = NULL;
>  	return 0;
>  }
>  
> -static void tsi721_bdma_free(struct tsi721_device *priv)
> -{
> -	tsi721_bdma_ch_free(priv, TSI721_DMACH_MAINT);
> -}
> -
>  /* Enable Inbound Messaging Interrupts */
>  static void
>  tsi721_imsg_interrupt_enable(struct tsi721_device *priv, int ch,
> @@ -2043,7 +2089,8 @@ static void tsi721_disable_ints(struct tsi721_device *priv)
>  
>  	/* Disable all BDMA Channel interrupts */
>  	for (ch = 0; ch < TSI721_DMA_MAXCH; ch++)
> -		iowrite32(0, priv->regs + TSI721_DMAC_INTE(ch));
> +		iowrite32(0,
> +			priv->regs + TSI721_DMAC_BASE(ch) + TSI721_DMAC_INTE);
>  
>  	/* Disable all general BDMA interrupts */
>  	iowrite32(0, priv->regs + TSI721_BDMA_INTE);
> @@ -2292,7 +2339,7 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
>  	tsi721_init_pc2sr_mapping(priv);
>  	tsi721_init_sr2pc_mapping(priv);
>  
> -	if (tsi721_bdma_init(priv)) {
> +	if (tsi721_bdma_maint_init(priv)) {
>  		dev_err(&pdev->dev, "BDMA initialization failed, aborting\n");
>  		err = -ENOMEM;
>  		goto err_unmap_bars;
> @@ -2312,12 +2359,16 @@ static int __devinit tsi721_probe(struct pci_dev *pdev,
>  	if (err)
>  		goto err_free_consistent;
>  
> +#ifdef CONFIG_TSI721_DMA
> +	tsi721_register_dma(priv);
> +#endif
> +
>  	return 0;
>  
>  err_free_consistent:
>  	tsi721_doorbell_free(priv);
>  err_free_bdma:
> -	tsi721_bdma_free(priv);
> +	tsi721_bdma_maint_free(priv);
>  err_unmap_bars:
>  	if (priv->regs)
>  		iounmap(priv->regs);
> diff --git a/drivers/rapidio/devices/tsi721.h b/drivers/rapidio/devices/tsi721.h
> index 58be4de..2f756dc 100644
> --- a/drivers/rapidio/devices/tsi721.h
> +++ b/drivers/rapidio/devices/tsi721.h
> @@ -21,6 +21,10 @@
>  #ifndef __TSI721_H
>  #define __TSI721_H
>  
> +#ifdef CONFIG_TSI721_DMA
> +#include <linux/dmaengine.h>
> +#endif
> +
>  #define DRV_NAME	"tsi721"
>  
>  #define DEFAULT_HOPCOUNT	0xff
> @@ -165,6 +169,8 @@
>  #define TSI721_DEV_INTE		0x29840
>  #define TSI721_DEV_INT		0x29844
>  #define TSI721_DEV_INTSET	0x29848
> +#define TSI721_DEV_INT_BDMA_CH	0x00002000
> +#define TSI721_DEV_INT_BDMA_NCH	0x00001000
>  #define TSI721_DEV_INT_SMSG_CH	0x00000800
>  #define TSI721_DEV_INT_SMSG_NCH	0x00000400
>  #define TSI721_DEV_INT_SR2PC_CH	0x00000200
> @@ -179,6 +185,8 @@
>  #define TSI721_INT_IMSG_CHAN(x)	(1 << (16 + (x)))
>  #define TSI721_INT_OMSG_CHAN_M	0x0000ff00
>  #define TSI721_INT_OMSG_CHAN(x)	(1 << (8 + (x)))
> +#define TSI721_INT_BDMA_CHAN_M	0x000000ff
> +#define TSI721_INT_BDMA_CHAN(x)	(1 << (x))
>  
>  /*
>   * PC2SR block registers
> @@ -233,14 +241,16 @@
>   *   x = 0..7
>   */
>  
> -#define TSI721_DMAC_DWRCNT(x)	(0x51000 + (x) * 0x1000)
> -#define TSI721_DMAC_DRDCNT(x)	(0x51004 + (x) * 0x1000)
> +#define TSI721_DMAC_BASE(x)	(0x51000 + (x) * 0x1000)
> +
> +#define TSI721_DMAC_DWRCNT	0x000
> +#define TSI721_DMAC_DRDCNT	0x004
>  
> -#define TSI721_DMAC_CTL(x)	(0x51008 + (x) * 0x1000)
> +#define TSI721_DMAC_CTL		0x008
>  #define TSI721_DMAC_CTL_SUSP	0x00000002
>  #define TSI721_DMAC_CTL_INIT	0x00000001
>  
> -#define TSI721_DMAC_INT(x)	(0x5100c + (x) * 0x1000)
> +#define TSI721_DMAC_INT		0x00c
>  #define TSI721_DMAC_INT_STFULL	0x00000010
>  #define TSI721_DMAC_INT_DONE	0x00000008
>  #define TSI721_DMAC_INT_SUSP	0x00000004
> @@ -248,34 +258,33 @@
>  #define TSI721_DMAC_INT_IOFDONE	0x00000001
>  #define TSI721_DMAC_INT_ALL	0x0000001f
>  
> -#define TSI721_DMAC_INTSET(x)	(0x51010 + (x) * 0x1000)
> +#define TSI721_DMAC_INTSET	0x010
>  
> -#define TSI721_DMAC_STS(x)	(0x51014 + (x) * 0x1000)
> +#define TSI721_DMAC_STS		0x014
>  #define TSI721_DMAC_STS_ABORT	0x00400000
>  #define TSI721_DMAC_STS_RUN	0x00200000
>  #define TSI721_DMAC_STS_CS	0x001f0000
>  
> -#define TSI721_DMAC_INTE(x)	(0x51018 + (x) * 0x1000)
> +#define TSI721_DMAC_INTE	0x018
>  
> -#define TSI721_DMAC_DPTRL(x)	(0x51024 + (x) * 0x1000)
> +#define TSI721_DMAC_DPTRL	0x024
>  #define TSI721_DMAC_DPTRL_MASK	0xffffffe0
>  
> -#define TSI721_DMAC_DPTRH(x)	(0x51028 + (x) * 0x1000)
> +#define TSI721_DMAC_DPTRH	0x028
>  
> -#define TSI721_DMAC_DSBL(x)	(0x5102c + (x) * 0x1000)
> +#define TSI721_DMAC_DSBL	0x02c
>  #define TSI721_DMAC_DSBL_MASK	0xffffffc0
>  
> -#define TSI721_DMAC_DSBH(x)	(0x51030 + (x) * 0x1000)
> +#define TSI721_DMAC_DSBH	0x030
>  
> -#define TSI721_DMAC_DSSZ(x)	(0x51034 + (x) * 0x1000)
> +#define TSI721_DMAC_DSSZ	0x034
>  #define TSI721_DMAC_DSSZ_SIZE_M	0x0000000f
>  #define TSI721_DMAC_DSSZ_SIZE(size)	(__fls(size) - 4)
>  
> -
> -#define TSI721_DMAC_DSRP(x)	(0x51038 + (x) * 0x1000)
> +#define TSI721_DMAC_DSRP	0x038
>  #define TSI721_DMAC_DSRP_MASK	0x0007ffff
>  
> -#define TSI721_DMAC_DSWP(x)	(0x5103c + (x) * 0x1000)
> +#define TSI721_DMAC_DSWP	0x03c
>  #define TSI721_DMAC_DSWP_MASK	0x0007ffff
>  
>  #define TSI721_BDMA_INTE	0x5f000
> @@ -624,7 +633,48 @@ enum tsi721_smsg_int_flag {
>  
>  /* Structures */
>  
> +#ifdef CONFIG_TSI721_DMA
> +
> +struct tsi721_tx_desc {
> +	struct dma_async_tx_descriptor	txd;
> +	struct tsi721_dma_desc		*hw_desc;
> +	u16				destid;
> +	/* low 64-bits of 66-bit RIO address */
> +	u64				rio_addr;
> +	/* upper 2-bits of 66-bit RIO address */
> +	u8				rio_addr_u;
> +	bool				interrupt;
> +	struct list_head		desc_node;
> +	struct list_head		tx_list;
> +};
> +
>  struct tsi721_bdma_chan {
> +	int		id;
> +	void __iomem	*regs;
> +	int		bd_num;		/* number of buffer descriptors */
> +	void		*bd_base;	/* start of DMA descriptors */
> +	dma_addr_t	bd_phys;
> +	void		*sts_base;	/* start of DMA BD status FIFO */
> +	dma_addr_t	sts_phys;
> +	int		sts_size;
> +	u32		sts_rdptr;
> +	u32		wr_count;
> +	u32		wr_count_next;
> +
> +	struct dma_chan		dchan;
> +	struct tsi721_tx_desc	*tx_desc;
> +	spinlock_t		lock;
> +	struct list_head	active_list;
> +	struct list_head	queue;
> +	struct list_head	free_list;
> +	dma_cookie_t		completed_cookie;
> +	struct tasklet_struct	tasklet;
> +};
> +
> +#endif /* CONFIG_TSI721_DMA */
> +
> +struct tsi721_bdma_maint {
> +	int		ch_id;		/* BDMA channel number */
>  	int		bd_num;		/* number of buffer descriptors */
>  	void		*bd_base;	/* start of DMA descriptors */
>  	dma_addr_t	bd_phys;
> @@ -719,6 +769,24 @@ enum tsi721_msix_vect {
>  	TSI721_VECT_IMB1_INT,
>  	TSI721_VECT_IMB2_INT,
>  	TSI721_VECT_IMB3_INT,
> +#ifdef CONFIG_TSI721_DMA
> +	TSI721_VECT_DMA0_DONE,
> +	TSI721_VECT_DMA1_DONE,
> +	TSI721_VECT_DMA2_DONE,
> +	TSI721_VECT_DMA3_DONE,
> +	TSI721_VECT_DMA4_DONE,
> +	TSI721_VECT_DMA5_DONE,
> +	TSI721_VECT_DMA6_DONE,
> +	TSI721_VECT_DMA7_DONE,
> +	TSI721_VECT_DMA0_INT,
> +	TSI721_VECT_DMA1_INT,
> +	TSI721_VECT_DMA2_INT,
> +	TSI721_VECT_DMA3_INT,
> +	TSI721_VECT_DMA4_INT,
> +	TSI721_VECT_DMA5_INT,
> +	TSI721_VECT_DMA6_INT,
> +	TSI721_VECT_DMA7_INT,
> +#endif /* CONFIG_TSI721_DMA */
>  	TSI721_VECT_MAX
>  };
>  
> @@ -752,7 +820,11 @@ struct tsi721_device {
>  	u32		pw_discard_count;
>  
>  	/* BDMA Engine */
> +	struct tsi721_bdma_maint mdma; /* Maintenance rd/wr request channel */
> +
> +#ifdef CONFIG_TSI721_DMA
>  	struct tsi721_bdma_chan bdma[TSI721_DMA_CHNUM];
> +#endif
>  
>  	/* Inbound Messaging */
>  	int		imsg_init[TSI721_IMSG_CHNUM];
> @@ -763,4 +835,9 @@ struct tsi721_device {
>  	struct tsi721_omsg_ring	omsg_ring[TSI721_OMSG_CHNUM];
>  };
>  
> +#ifdef CONFIG_TSI721_DMA
> +extern void tsi721_bdma_handler(struct tsi721_bdma_chan *chan);
> +extern int __devinit tsi721_register_dma(struct tsi721_device *priv);
> +#endif
> +
>  #endif
> diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
> new file mode 100644
> index 0000000..75a27a0
> --- /dev/null
> +++ b/drivers/rapidio/devices/tsi721_dma.c
> @@ -0,0 +1,802 @@
> +/*
> + * DMA Engine support for Tsi721 PCIExpress-to-SRIO bridge
> + *
> + * Copyright 2011 Integrated Device Technology, Inc.
> + * Alexandre Bounine <alexandre.bounine@idt.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc., 59
> + * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
> + */
> +
> +#include <linux/io.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/rio.h>
> +#include <linux/rio_drv.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
> +#include <linux/kfifo.h>
> +#include <linux/delay.h>
> +
> +#include "tsi721.h"
> +
> +static inline struct tsi721_bdma_chan *to_tsi721_chan(struct dma_chan *chan)
> +{
> +	return container_of(chan, struct tsi721_bdma_chan, dchan);
> +}
> +
> +static inline struct tsi721_device *to_tsi721(struct dma_device *ddev)
> +{
> +	return container_of(ddev, struct rio_mport, dma)->priv;
> +}
> +
> +static inline
> +struct tsi721_tx_desc *to_tsi721_desc(struct dma_async_tx_descriptor *txd)
> +{
> +	return container_of(txd, struct tsi721_tx_desc, txd);
> +}
> +
> +static inline
> +struct tsi721_tx_desc *tsi721_dma_first_active(struct tsi721_bdma_chan *chan)
> +{
> +	return list_first_entry(&chan->active_list,
> +				struct tsi721_tx_desc, desc_node);
> +}
> +
> +static int tsi721_bdma_ch_init(struct tsi721_bdma_chan *chan)
> +{
> +	struct tsi721_dma_desc *bd_ptr;
> +	struct device *dev = chan->dchan.device->dev;
> +	u64		*sts_ptr;
> +	dma_addr_t	bd_phys;
> +	dma_addr_t	sts_phys;
> +	int		sts_size;
> +	int		bd_num = chan->bd_num;
> +
> +	dev_dbg(dev, "Init Block DMA Engine, CH%d\n", chan->id);
> +
> +	/* Allocate space for DMA descriptors */
> +	bd_ptr = dma_alloc_coherent(dev,
> +				bd_num * sizeof(struct tsi721_dma_desc),
> +				&bd_phys, GFP_KERNEL);
> +	if (!bd_ptr)
> +		return -ENOMEM;
> +
> +	chan->bd_phys = bd_phys;
> +	chan->bd_base = bd_ptr;
> +
> +	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
> +
> +	dev_dbg(dev, "DMA descriptors @ %p (phys = %llx)\n",
> +		bd_ptr, (unsigned long long)bd_phys);
> +
> +	/* Allocate space for descriptor status FIFO */
> +	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
> +					bd_num : TSI721_DMA_MINSTSSZ;
> +	sts_size = roundup_pow_of_two(sts_size);
> +	sts_ptr = dma_alloc_coherent(dev,
> +				     sts_size * sizeof(struct tsi721_dma_sts),
> +				     &sts_phys, GFP_KERNEL);
> +	if (!sts_ptr) {
> +		/* Free space allocated for DMA descriptors */
> +		dma_free_coherent(dev,
> +				  bd_num * sizeof(struct tsi721_dma_desc),
> +				  bd_ptr, bd_phys);
> +		chan->bd_base = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	chan->sts_phys = sts_phys;
> +	chan->sts_base = sts_ptr;
> +	chan->sts_size = sts_size;
> +
> +	memset(sts_ptr, 0, sts_size);
> +
> +	dev_dbg(dev,
> +		"desc status FIFO @ %p (phys = %llx) size=0x%x\n",
> +		sts_ptr, (unsigned long long)sts_phys, sts_size);
> +
> +	/* Initialize DMA descriptors ring */
> +	bd_ptr[bd_num - 1].type_id = cpu_to_le32(DTYPE3 << 29);
> +	bd_ptr[bd_num - 1].next_lo = cpu_to_le32((u64)bd_phys &
> +						 TSI721_DMAC_DPTRL_MASK);
> +	bd_ptr[bd_num - 1].next_hi = cpu_to_le32((u64)bd_phys >> 32);
> +
> +	/* Setup DMA descriptor pointers */
> +	iowrite32(((u64)bd_phys >> 32),
> +		chan->regs + TSI721_DMAC_DPTRH);
> +	iowrite32(((u64)bd_phys & TSI721_DMAC_DPTRL_MASK),
> +		chan->regs + TSI721_DMAC_DPTRL);
> +
> +	/* Setup descriptor status FIFO */
> +	iowrite32(((u64)sts_phys >> 32),
> +		chan->regs + TSI721_DMAC_DSBH);
> +	iowrite32(((u64)sts_phys & TSI721_DMAC_DSBL_MASK),
> +		chan->regs + TSI721_DMAC_DSBL);
> +	iowrite32(TSI721_DMAC_DSSZ_SIZE(sts_size),
> +		chan->regs + TSI721_DMAC_DSSZ);
> +
> +	/* Clear interrupt bits */
> +	iowrite32(TSI721_DMAC_INT_ALL,
> +		chan->regs + TSI721_DMAC_INT);
> +
> +	ioread32(chan->regs + TSI721_DMAC_INT);
> +
> +	/* Toggle DMA channel initialization */
> +	iowrite32(TSI721_DMAC_CTL_INIT,	chan->regs + TSI721_DMAC_CTL);
> +	ioread32(chan->regs + TSI721_DMAC_CTL);
> +	chan->wr_count = chan->wr_count_next = 0;
> +	chan->sts_rdptr = 0;
> +	udelay(10);
> +
> +	return 0;
> +}
> +
> +static int tsi721_bdma_ch_free(struct tsi721_bdma_chan *chan)
> +{
> +	u32 ch_stat;
> +
> +	if (chan->bd_base == NULL)
> +		return 0;
> +
> +	/* Check if DMA channel still running */
> +	ch_stat = ioread32(chan->regs +	TSI721_DMAC_STS);
> +	if (ch_stat & TSI721_DMAC_STS_RUN)
> +		return -EFAULT;
> +
> +	/* Put DMA channel into init state */
> +	iowrite32(TSI721_DMAC_CTL_INIT,	chan->regs + TSI721_DMAC_CTL);
> +
> +	/* Free space allocated for DMA descriptors */
> +	dma_free_coherent(chan->dchan.device->dev,
> +		chan->bd_num * sizeof(struct tsi721_dma_desc),
> +		chan->bd_base, chan->bd_phys);
> +	chan->bd_base = NULL;
> +
> +	/* Free space allocated for status FIFO */
> +	dma_free_coherent(chan->dchan.device->dev,
> +		chan->sts_size * sizeof(struct tsi721_dma_sts),
> +		chan->sts_base, chan->sts_phys);
> +	chan->sts_base = NULL;
> +	return 0;
> +}
> +
> +static
> +void tsi721_bdma_interrupt_enable(struct tsi721_bdma_chan *chan, int enable)
> +{
> +	if (enable) {
> +		/* Clear pending BDMA channel interrupts */
> +		iowrite32(TSI721_DMAC_INT_ALL, chan->regs + TSI721_DMAC_INT);
> +		ioread32(chan->regs + TSI721_DMAC_INT);
> +		/* Enable BDMA channel interrupts */
> +		iowrite32(TSI721_DMAC_INT_ALL, chan->regs + TSI721_DMAC_INTE);
> +	} else {
> +		/* Disable BDMA channel interrupts */
> +		iowrite32(0, chan->regs + TSI721_DMAC_INTE);
> +		/* Clear pending BDMA channel interrupts */
> +		iowrite32(TSI721_DMAC_INT_ALL, chan->regs + TSI721_DMAC_INT);
> +	}
> +
> +}
> +
> +static bool tsi721_dma_is_idle(struct tsi721_bdma_chan *chan)
> +{
> +	u32 sts;
> +
> +	sts = ioread32(chan->regs + TSI721_DMAC_STS);
> +	return ((sts & TSI721_DMAC_STS_RUN) == 0);
> +}
> +
> +void tsi721_bdma_handler(struct tsi721_bdma_chan *chan)
> +{
> +	/* Disable BDMA channel interrupts */
> +	iowrite32(0, chan->regs + TSI721_DMAC_INTE);
> +
> +	tasklet_schedule(&chan->tasklet);
> +}
> +
> +#ifdef CONFIG_PCI_MSI
> +/**
> + * tsi721_omsg_msix - MSI-X interrupt handler for outbound messaging
> + * @irq: Linux interrupt number
> + * @ptr: Pointer to interrupt-specific data (mport structure)
> + *
> + * Handles outbound messaging interrupts signaled using MSI-X.
> + */
> +static irqreturn_t tsi721_bdma_msix(int irq, void *ptr)
> +{
> +	struct tsi721_bdma_chan *chan = ptr;
> +
> +	tsi721_bdma_handler(chan);
> +	return IRQ_HANDLED;
> +}
> +#endif /* CONFIG_PCI_MSI */
> +
> +/* Must be called with the spinlock held */
> +static void tsi721_start_dma(struct tsi721_bdma_chan *chan)
> +{
> +	if (!tsi721_dma_is_idle(chan)) {
> +		dev_err(chan->dchan.device->dev,
> +			"BUG: Attempt to start non-idle channel\n");
> +		return;
> +	}
> +
> +	if (chan->wr_count == chan->wr_count_next) {
> +		dev_err(chan->dchan.device->dev,
> +			"BUG: Attempt to start DMA with no BDs ready\n");
> +		return;
> +	}
> +
> +	dev_dbg(chan->dchan.device->dev,
> +		"tx_chan: %p, chan: %d, regs: %p\n",
> +		chan, chan->dchan.chan_id, chan->regs);
> +
> +	iowrite32(chan->wr_count_next, chan->regs + TSI721_DMAC_DWRCNT);
> +	ioread32(chan->regs + TSI721_DMAC_DWRCNT);
> +
> +	chan->wr_count = chan->wr_count_next;
> +}
> +
> +static void tsi721_desc_put(struct tsi721_bdma_chan *chan,
> +			    struct tsi721_tx_desc *desc)
> +{
> +	dev_dbg(chan->dchan.device->dev, "Put desc: %p into free list\n", desc);
> +
> +	if (desc) {
> +		spin_lock_bh(&chan->lock);
> +		list_splice_init(&desc->tx_list, &chan->free_list);
> +		list_add(&desc->desc_node, &chan->free_list);
> +		chan->wr_count_next = chan->wr_count;
> +		spin_unlock_bh(&chan->lock);
> +	}
> +}
> +
> +static struct tsi721_tx_desc *tsi721_desc_get(struct tsi721_bdma_chan *chan)
> +{
> +	struct tsi721_tx_desc *tx_desc, *_tx_desc;
> +	struct tsi721_tx_desc *ret = NULL;
> +	int i;
> +
> +	spin_lock_bh(&chan->lock);
> +	list_for_each_entry_safe(tx_desc, _tx_desc,
> +				 &chan->free_list, desc_node) {
> +		if (async_tx_test_ack(&tx_desc->txd)) {
> +			list_del(&tx_desc->desc_node);
> +			ret = tx_desc;
> +			break;
> +		}
> +		dev_dbg(chan->dchan.device->dev,
> +			"desc %p not ACKed\n", tx_desc);
> +	}
> +
> +	i = chan->wr_count_next % chan->bd_num;
> +	if (i == chan->bd_num - 1) {
> +		i = 0;
> +		chan->wr_count_next++; /* skip link descriptor */
> +	}
> +
> +	chan->wr_count_next++;
> +	tx_desc->txd.phys = chan->bd_phys + i * sizeof(struct tsi721_dma_desc);
> +	tx_desc->hw_desc = &((struct tsi721_dma_desc *)chan->bd_base)[i];
> +
> +	spin_unlock_bh(&chan->lock);
> +
> +	return ret;
> +}
> +
> +static
> +int tsi721_fill_desc(struct tsi721_bdma_chan *chan, struct tsi721_tx_desc *desc,
> +	struct scatterlist *sg, enum dma_rtype rtype, u32 sys_size)
> +{
> +	struct tsi721_dma_desc *bd_ptr = desc->hw_desc;
> +	u64 rio_addr;
> +
> +	if (sg_dma_len(sg) > TSI721_DMAD_BCOUNT1 + 1) {
> +		dev_err(chan->dchan.device->dev, "SG element is too large\n");
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(chan->dchan.device->dev,
> +		"desc: 0x%llx, addr: 0x%llx len: 0x%x\n",
> +		(u64)desc->txd.phys, (unsigned long long)sg_dma_address(sg),
> +		sg_dma_len(sg));
> +
> +	dev_dbg(chan->dchan.device->dev, "bd_ptr = %p did=%d raddr=0x%llx\n",
> +		bd_ptr, desc->destid, desc->rio_addr);
> +
> +	/* Initialize DMA descriptor */
> +	bd_ptr->type_id = cpu_to_le32((DTYPE1 << 29) |
> +					(rtype << 19) | desc->destid);
> +	if (desc->interrupt)
> +		bd_ptr->type_id |= cpu_to_le32(TSI721_DMAD_IOF);
> +	bd_ptr->bcount = cpu_to_le32(((desc->rio_addr & 0x3) << 30) |
> +					(sys_size << 26) | sg_dma_len(sg));
> +	rio_addr = (desc->rio_addr >> 2) |
> +				((u64)(desc->rio_addr_u & 0x3) << 62);
> +	bd_ptr->raddr_lo = cpu_to_le32(rio_addr & 0xffffffff);
> +	bd_ptr->raddr_hi = cpu_to_le32(rio_addr >> 32);
> +	bd_ptr->t1.bufptr_lo = cpu_to_le32(
> +					(u64)sg_dma_address(sg) & 0xffffffff);
> +	bd_ptr->t1.bufptr_hi = cpu_to_le32((u64)sg_dma_address(sg) >> 32);
> +	bd_ptr->t1.s_dist = 0;
> +	bd_ptr->t1.s_size = 0;
> +
> +	mb();
> +
> +	return 0;
> +}
> +
> +static void tsi721_dma_chain_complete(struct tsi721_bdma_chan *chan,
> +				      struct tsi721_tx_desc *desc)
> +{
> +	struct dma_async_tx_descriptor *txd = &desc->txd;
> +	dma_async_tx_callback callback = txd->callback;
> +	void *param = txd->callback_param;
> +
> +	list_splice_init(&desc->tx_list, &chan->free_list);
> +	list_move(&desc->desc_node, &chan->free_list);
> +	chan->completed_cookie = txd->cookie;
> +
> +	if (callback)
> +		callback(param);
> +}
> +
> +static void tsi721_dma_complete_all(struct tsi721_bdma_chan *chan)
> +{
> +	struct tsi721_tx_desc *desc, *_d;
> +	LIST_HEAD(list);
> +
> +	BUG_ON(!tsi721_dma_is_idle(chan));
> +
> +	if (!list_empty(&chan->queue))
> +		tsi721_start_dma(chan);
> +
> +	list_splice_init(&chan->active_list, &list);
> +	list_splice_init(&chan->queue, &chan->active_list);
> +
> +	list_for_each_entry_safe(desc, _d, &list, desc_node)
> +		tsi721_dma_chain_complete(chan, desc);
> +}
> +
> +static void tsi721_clr_stat(struct tsi721_bdma_chan *chan)
> +{
> +	u32 srd_ptr;
> +	u64 *sts_ptr;
> +	int i, j;
> +
> +	/* Check and clear descriptor status FIFO entries */
> +	srd_ptr = chan->sts_rdptr;
> +	sts_ptr = chan->sts_base;
> +	j = srd_ptr * 8;
> +	while (sts_ptr[j]) {
> +		for (i = 0; i < 8 && sts_ptr[j]; i++, j++)
> +			sts_ptr[j] = 0;
> +
> +		++srd_ptr;
> +		srd_ptr %= chan->sts_size;
> +		j = srd_ptr * 8;
> +	}
> +
> +	iowrite32(srd_ptr, chan->regs + TSI721_DMAC_DSRP);
> +	chan->sts_rdptr = srd_ptr;
> +}
> +
> +static void tsi721_advance_work(struct tsi721_bdma_chan *chan)
> +{
> +	if (list_empty(&chan->active_list) ||
> +		list_is_singular(&chan->active_list)) {
> +		dev_dbg(chan->dchan.device->dev,
> +			"%s: Active_list empty\n", __func__);
> +		tsi721_dma_complete_all(chan);
> +	} else {
> +		dev_dbg(chan->dchan.device->dev,
> +			"%s: Active_list NOT empty\n", __func__);
> +		tsi721_dma_chain_complete(chan, tsi721_dma_first_active(chan));
> +		tsi721_start_dma(chan);
> +	}
> +}
> +
> +static void tsi721_dma_tasklet(unsigned long data)
> +{
> +	struct tsi721_bdma_chan *chan = (struct tsi721_bdma_chan *)data;
> +	u32 dmac_int, dmac_sts;
> +
> +	dmac_int = ioread32(chan->regs + TSI721_DMAC_INT);
> +	dev_dbg(chan->dchan.device->dev, "%s: DMAC%d_INT = 0x%x\n",
> +		__func__, chan->id, dmac_int);
> +	/* Clear channel interrupts */
> +	iowrite32(dmac_int, chan->regs + TSI721_DMAC_INT);
> +
> +	if (dmac_int & TSI721_DMAC_INT_ERR) {
> +		dmac_sts = ioread32(chan->regs + TSI721_DMAC_STS);
> +		dev_err(chan->dchan.device->dev,
> +			"%s: DMA ERROR - DMAC%d_STS = 0x%x\n",
> +			__func__, chan->id, dmac_sts);
> +	}
> +
> +	if (dmac_int & TSI721_DMAC_INT_STFULL) {
> +		dev_err(chan->dchan.device->dev,
> +			"%s: DMAC%d descriptor status FIFO is full\n",
> +			__func__, chan->id);
> +	}
> +
> +	if (dmac_int & (TSI721_DMAC_INT_DONE | TSI721_DMAC_INT_IOFDONE)) {
> +		tsi721_clr_stat(chan);
> +		spin_lock(&chan->lock);
> +		tsi721_advance_work(chan);
> +		spin_unlock(&chan->lock);
> +	}
> +
> +	/* Re-Enable BDMA channel interrupts */
> +	iowrite32(TSI721_DMAC_INT_ALL, chan->regs + TSI721_DMAC_INTE);
> +}
> +
> +static dma_cookie_t tsi721_tx_submit(struct dma_async_tx_descriptor *txd)
> +{
> +	struct tsi721_tx_desc *desc = to_tsi721_desc(txd);
> +	struct tsi721_bdma_chan *chan = to_tsi721_chan(txd->chan);
> +	dma_cookie_t cookie;
> +
> +	spin_lock_bh(&chan->lock);
> +
> +	cookie = txd->chan->cookie;
> +	if (++cookie < 0)
> +		cookie = 1;
> +	txd->chan->cookie = cookie;
> +	txd->cookie = cookie;
> +
> +	if (list_empty(&chan->active_list)) {
> +		list_add_tail(&desc->desc_node, &chan->active_list);
> +		tsi721_start_dma(chan);
> +	} else {
> +		list_add_tail(&desc->desc_node, &chan->queue);
> +	}
> +
> +	spin_unlock_bh(&chan->lock);
> +	return cookie;
> +}
> +
> +static int tsi721_alloc_chan_resources(struct dma_chan *dchan)
> +{
> +	struct tsi721_bdma_chan *chan = to_tsi721_chan(dchan);
> +	struct tsi721_device *priv = to_tsi721(dchan->device);
> +	struct tsi721_tx_desc *desc = NULL;
> +	LIST_HEAD(tmp_list);
> +	int i;
> +	int rc;
> +
> +	if (chan->bd_base)
> +		return chan->bd_num - 1;
> +
> +	/* Initialize BDMA channel */
> +	if (tsi721_bdma_ch_init(chan)) {
> +		dev_err(dchan->device->dev, "Unable to initialize data DMA"
> +			" channel %d, aborting\n", chan->id);
> +		return -ENOMEM;
> +	}
> +
> +	/* Allocate matching number of logical descriptors */
> +	desc = kzalloc((chan->bd_num - 1) * sizeof(struct tsi721_tx_desc),
> +			GFP_KERNEL);
> +	if (!desc) {
> +		dev_err(dchan->device->dev,
> +			"Failed to allocate logical descriptors\n");
> +		rc = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	chan->tx_desc = desc;
> +
> +	for (i = 0; i < chan->bd_num - 1; i++) {
> +		dma_async_tx_descriptor_init(&desc[i].txd, dchan);
> +		desc[i].txd.tx_submit = tsi721_tx_submit;
> +		desc[i].txd.flags = DMA_CTRL_ACK;
> +		INIT_LIST_HEAD(&desc[i].tx_list);
> +		list_add_tail(&desc[i].desc_node, &tmp_list);
> +	}
> +
> +	spin_lock_bh(&chan->lock);
> +	list_splice(&tmp_list, &chan->free_list);
> +	chan->completed_cookie = dchan->cookie = 1;
> +	spin_unlock_bh(&chan->lock);
> +
> +#ifdef CONFIG_PCI_MSI
> +	if (priv->flags & TSI721_USING_MSIX) {
> +		/* Request interrupt service if we are in MSI-X mode */
> +		rc = request_irq(
> +			priv->msix[TSI721_VECT_DMA0_DONE + chan->id].vector,
> +			tsi721_bdma_msix, 0,
> +			priv->msix[TSI721_VECT_DMA0_DONE + chan->id].irq_name,
> +			(void *)chan);
> +
> +		if (rc) {
> +			dev_dbg(dchan->device->dev,
> +				"Unable to allocate MSI-X interrupt for "
> +				"BDMA%d-DONE\n", chan->id);
> +			goto err_out;
> +		}
> +
> +		rc = request_irq(priv->msix[TSI721_VECT_DMA0_INT +
> +					    chan->id].vector,
> +			tsi721_bdma_msix, 0,
> +			priv->msix[TSI721_VECT_DMA0_INT + chan->id].irq_name,
> +			(void *)chan);
> +
> +		if (rc)	{
> +			dev_dbg(dchan->device->dev,
> +				"Unable to allocate MSI-X interrupt for "
> +				"BDMA%d-INT\n", chan->id);
> +			free_irq(
> +				priv->msix[TSI721_VECT_DMA0_DONE +
> +					   chan->id].vector,
> +				(void *)chan);
> +			rc = -EIO;
> +			goto err_out;
> +		}
> +	}
> +#endif /* CONFIG_PCI_MSI */
> +
> +	tsi721_bdma_interrupt_enable(chan, 1);
> +
> +	return chan->bd_num - 1;
> +
> +err_out:
> +	kfree(desc);
> +	tsi721_bdma_ch_free(chan);
> +	return rc;
> +}
> +
> +static void tsi721_free_chan_resources(struct dma_chan *dchan)
> +{
> +	struct tsi721_bdma_chan *chan = to_tsi721_chan(dchan);
> +	struct tsi721_device *priv = to_tsi721(dchan->device);
> +	LIST_HEAD(list);
> +
> +	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
> +
> +	BUG_ON(!list_empty(&chan->active_list));
> +	BUG_ON(!list_empty(&chan->queue));
> +
> +	spin_lock_irq(&chan->lock);
> +	list_splice_init(&chan->free_list, &list);
> +	spin_unlock_irq(&chan->lock);
> +
> +	tsi721_bdma_interrupt_enable(chan, 0);
> +
> +#ifdef CONFIG_PCI_MSI
> +	if (priv->flags & TSI721_USING_MSIX) {
> +		free_irq(priv->msix[TSI721_VECT_DMA0_DONE + chan->id].vector,
> +			 (void *)chan);
> +		free_irq(priv->msix[TSI721_VECT_DMA0_INT + chan->id].vector,
> +			 (void *)chan);
> +	}
> +#endif /* CONFIG_PCI_MSI */
> +
> +	tsi721_bdma_ch_free(chan);
> +	kfree(chan->tx_desc);
> +}
> +
> +static
> +enum dma_status tsi721_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
> +				 struct dma_tx_state *txstate)
> +{
> +	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
> +	dma_cookie_t		last_used;
> +	dma_cookie_t		last_completed;
> +	int			ret;
> +
> +	spin_lock_irq(&bdma_chan->lock);
> +	last_completed = bdma_chan->completed_cookie;
> +	last_used = dchan->cookie;
> +	spin_unlock_irq(&bdma_chan->lock);
> +
> +	ret = dma_async_is_complete(cookie, last_completed, last_used);
> +
> +	dma_set_tx_state(txstate, last_completed, last_used, 0);
> +
> +	dev_dbg(dchan->device->dev,
> +		"%s: exit, ret: %d, last_completed: %d, last_used: %d\n",
> +		__func__, ret, last_completed, last_used);
> +
> +	return ret;
> +}
> +
> +static void tsi721_issue_pending(struct dma_chan *dchan)
> +{
> +	struct tsi721_bdma_chan *chan = to_tsi721_chan(dchan);
> +
> +	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
> +
> +	if (tsi721_dma_is_idle(chan)) {
> +		spin_lock_bh(&chan->lock);
> +		tsi721_advance_work(chan);
> +		spin_unlock_bh(&chan->lock);
> +	} else
> +		dev_dbg(dchan->device->dev,
> +			"%s: DMA channel still busy\n", __func__);
> +}
> +
> +static
> +struct dma_async_tx_descriptor *tsi721_prep_slave_sg(struct dma_chan *dchan,
> +			struct scatterlist *sgl, unsigned int sg_len,
> +			enum dma_data_direction direction, unsigned long flags)
> +{
> +	struct tsi721_bdma_chan *bdma_chan = to_tsi721_chan(dchan);
> +	struct tsi721_tx_desc *desc = NULL;
> +	struct tsi721_tx_desc *first = NULL;
> +	struct scatterlist *sg;
> +	struct rio_dma_ext *rext = dchan->private;
> +	u64 rio_addr = rext->rio_addr; /* FIXME: assuming 64-bit rio_addr for now */
> +	unsigned int i;
> +	u32 sys_size = dma_to_mport(dchan->device)->sys_size;
> +	enum dma_rtype rtype;
> +
> +	if (!sgl || !sg_len) {
> +		dev_err(dchan->device->dev, "%s: No SG list\n", __func__);
> +		return NULL;
> +	}
> +
> +	if (direction == DMA_FROM_DEVICE)
> +		rtype = NREAD;
> +	else if (direction == DMA_TO_DEVICE) {
> +		switch (rext->wr_type) {
> +		case RDW_ALL_NWRITE:
> +			rtype = ALL_NWRITE;
> +			break;
> +		case RDW_ALL_NWRITE_R:
> +			rtype = ALL_NWRITE_R;
> +			break;
> +		case RDW_LAST_NWRITE_R:
> +		default:
> +			rtype = LAST_NWRITE_R;
> +			break;
> +		}
> +	} else {
> +		dev_err(dchan->device->dev,
> +			"%s: Unsupported DMA direction option\n", __func__);
> +		return NULL;
> +	}
> +
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		int err;
> +
> +		dev_dbg(dchan->device->dev, "%s: sg #%d\n", __func__, i);
> +		desc = tsi721_desc_get(bdma_chan);
> +		if (!desc) {
> +			dev_err(dchan->device->dev,
> +				"Not enough descriptors available\n");
> +			goto err_desc_get;
> +		}
> +
> +		if (sg_is_last(sg))
> +			desc->interrupt = (flags & DMA_PREP_INTERRUPT) != 0;
> +		else
> +			desc->interrupt = false;
> +
> +		desc->destid = rext->destid;
> +		desc->rio_addr = rio_addr;
> +		desc->rio_addr_u = 0;
> +
> +		err = tsi721_fill_desc(bdma_chan, desc, sg, rtype, sys_size);
> +		if (err) {
> +			dev_err(dchan->device->dev,
> +				"Failed to build desc: %d\n", err);
> +			goto err_desc_get;
> +		}
> +
> +		rio_addr += sg_dma_len(sg);
> +
> +		if (!first)
> +			first = desc;
> +		else
> +			list_add_tail(&desc->desc_node, &first->tx_list);
> +	}
> +
> +	first->txd.cookie = -EBUSY;
> +	desc->txd.flags = flags;
> +
> +	return &first->txd;
> +
> +err_desc_get:
> +	tsi721_desc_put(bdma_chan, first);
> +	return NULL;
> +}
> +
> +static int tsi721_device_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
> +			     unsigned long arg)
> +{
> +	struct tsi721_bdma_chan *chan = to_tsi721_chan(dchan);
> +	struct tsi721_tx_desc *desc, *_d;
> +	LIST_HEAD(list);
> +
> +	dev_dbg(dchan->device->dev, "%s: Entry\n", __func__);
> +
> +	if (cmd != DMA_TERMINATE_ALL)
> +		return -ENXIO;
> +
> +	spin_lock_bh(&chan->lock);
> +
> +	/* make sure to stop the transfer */
> +	iowrite32(TSI721_DMAC_CTL_SUSP, chan->regs + TSI721_DMAC_CTL);
> +
> +	list_splice_init(&chan->active_list, &list);
> +	list_splice_init(&chan->queue, &list);
> +
> +	list_for_each_entry_safe(desc, _d, &list, desc_node)
> +		tsi721_dma_chain_complete(chan, desc);
> +
> +	spin_unlock_bh(&chan->lock);
> +
> +	return 0;
> +}
> +
> +int __devinit tsi721_register_dma(struct tsi721_device *priv)
> +{
> +	int i;
> +	int nr_channels = TSI721_DMA_MAXCH;
> +	int err;
> +	struct rio_mport *mport = priv->mport;
> +
> +	mport->dma.dev = &priv->pdev->dev;
> +	mport->dma.chancnt = nr_channels;
> +
> +	INIT_LIST_HEAD(&mport->dma.channels);
> +
> +	for (i = 0; i < nr_channels; i++) {
> +		struct tsi721_bdma_chan *bdma_chan = &priv->bdma[i];
> +
> +		if (i == TSI721_DMACH_MAINT)
> +			continue;
> +
> +		bdma_chan->bd_num = 64;
> +		bdma_chan->regs = priv->regs + TSI721_DMAC_BASE(i);
> +
> +		bdma_chan->dchan.device = &mport->dma;
> +		bdma_chan->dchan.cookie = 1;
> +		bdma_chan->dchan.chan_id = i;
> +		bdma_chan->id = i;
> +
> +		spin_lock_init(&bdma_chan->lock);
> +
> +		INIT_LIST_HEAD(&bdma_chan->active_list);
> +		INIT_LIST_HEAD(&bdma_chan->queue);
> +		INIT_LIST_HEAD(&bdma_chan->free_list);
> +
> +		tasklet_init(&bdma_chan->tasklet, tsi721_dma_tasklet,
> +			     (unsigned long)bdma_chan);
> +		list_add_tail(&bdma_chan->dchan.device_node,
> +			      &mport->dma.channels);
> +	}
> +
> +	dma_cap_zero(mport->dma.cap_mask);
> +	dma_cap_set(DMA_PRIVATE, mport->dma.cap_mask);
> +	dma_cap_set(DMA_RAPIDIO, mport->dma.cap_mask);
> +
> +	mport->dma.device_alloc_chan_resources = tsi721_alloc_chan_resources;
> +	mport->dma.device_free_chan_resources = tsi721_free_chan_resources;
> +	mport->dma.device_tx_status = tsi721_tx_status;
> +	mport->dma.device_issue_pending = tsi721_issue_pending;
> +	mport->dma.device_prep_slave_sg = tsi721_prep_slave_sg;
> +	mport->dma.device_control = tsi721_device_control;
> +
> +	err = dma_async_device_register(&mport->dma);
> +	if (err)
> +		dev_err(&priv->pdev->dev, "Failed to register DMA device\n");
> +
> +	return err;
> +}


-- 
~Vinod

