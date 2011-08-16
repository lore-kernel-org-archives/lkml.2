Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab1HPXBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:01:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543Ab1HPXBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:01:46 -0400
Date: Tue, 16 Aug 2011 16:01:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Chul Kim <chul.kim@idt.com>, Kumar Gala <galak@kernel.crashing.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] RapidIO: Add mport driver for Tsi721 bridge
Message-Id: <20110816160120.50bda968.akpm@linux-foundation.org>
In-Reply-To: <1313178334-6964-1-git-send-email-alexandre.bounine@idt.com>
References: <1313178334-6964-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Aug 2011 15:45:34 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Add RapidIO mport driver for IDT TSI721 PCI Express-to-SRIO bridge device.
> The driver provides full set of callback functions defined for mport devices
> in RapidIO subsystem. It also is compatible with current version of RIONET
> driver (Ethernet over RapidIO messaging services).
> 
> This patch is applicable to kernel versions starting from 2.6.39.

What a huge driver.

>
> ...
>
> --- /dev/null
> +++ b/drivers/rapidio/devices/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# RapidIO master port configuration
> +#
> +
> +config RAPIDIO_TSI721
> +	bool "IDT Tsi721 PCI Express SRIO Controller support"
> +	depends on RAPIDIO && PCI && PCIEPORTBUS

The dependency on PCI is redundant - PCIEPORTBUS already depends on
PCI.  Doesn't matter much though.

> +	default "n"
> +	---help---
> +	  Include support for IDT Tsi721 PCI Express Serial RapidIO controller.
>
> ...
>
> +static int tsi721_maint_dma(struct tsi721_device *priv, u32 sys_size,
> +			u16 destid, u8 hopcount, u32 offset, int len,
> +			u32 *data, int do_wr)
> +{
> +	struct tsi721_dma_desc *bd_ptr;
> +	u32 rd_count, swr_ptr, ch_stat;
> +	int i, err = 0;
> +	u32 op = do_wr ? MAINT_WR : MAINT_RD;
> +
> +	if (offset > (RIO_MAINT_SPACE_SZ - len) || (len != sizeof(u32)))
> +		return -EINVAL;
> +
> +	bd_ptr = priv->bdma[TSI721_DMACH_MAINT].bd_base;
> +
> +	rd_count = ioread32(
> +			priv->regs + TSI721_DMAC_DRDCNT(TSI721_DMACH_MAINT));
> +
> +	/* Initialize DMA descriptor */
> +	bd_ptr[0].type_id = cpu_to_le32((DTYPE2 << 29) | (op << 19) | destid);
> +	bd_ptr[0].bcount = cpu_to_le32((sys_size << 26) | 0x04);
> +	bd_ptr[0].raddr_lo = cpu_to_le32((hopcount << 24) | offset);
> +	bd_ptr[0].raddr_hi = 0;
> +	if (do_wr)
> +		bd_ptr[0].data[0] = cpu_to_be32p(data);
> +	else
> +		bd_ptr[0].data[0] = 0xffffffff;
> +
> +	mb();
> +
> +	/* Start DMA operation */
> +	iowrite32(rd_count + 2,
> +		priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> +	(void)ioread32(priv->regs + TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> +	i = 0;
> +
> +	/* Wait until DMA transfer is finished */
> +	while ((ch_stat = ioread32(priv->regs +
> +		TSI721_DMAC_STS(TSI721_DMACH_MAINT))) & TSI721_DMAC_STS_RUN) {
> +		udelay(10);
> +		i++;
> +		if (i >= 5000000) {
> +			dev_dbg(&priv->pdev->dev,
> +				"%s : DMA[%d] read timeout ch_status=%x\n",
> +				__func__, TSI721_DMACH_MAINT, ch_stat);
> +			if (!do_wr)
> +				*data = 0xffffffff;
> +			err = -EFAULT;
> +			goto err_out;
> +		}
> +	}

Fifty seconds!?!?

EFAULT seems an inappropriate errno.

> +	if (ch_stat & TSI721_DMAC_STS_ABORT) {
> +		/* If DMA operation aborted due to error,
> +		 * reinitialize DMA channel
> +		 */
> +		dev_dbg(&priv->pdev->dev, "%s : DMA ABORT ch_stat=%x\n",
> +			__func__, ch_stat);
> +		dev_dbg(&priv->pdev->dev, "OP=%d : destid=%x hc=%x off=%x\n",
> +			do_wr ? MAINT_WR : MAINT_RD, destid, hopcount, offset);
> +		iowrite32(TSI721_DMAC_INT_ALL,
> +			priv->regs + TSI721_DMAC_INT(TSI721_DMACH_MAINT));
> +		iowrite32(TSI721_DMAC_CTL_INIT,
> +			priv->regs + TSI721_DMAC_CTL(TSI721_DMACH_MAINT));
> +		udelay(10);
> +		iowrite32(0, priv->regs +
> +				TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> +		udelay(1);
> +		if (!do_wr)
> +			*data = 0xffffffff;
> +		err = -EFAULT;
> +		goto err_out;
> +	}
> +
> +	if (!do_wr)
> +		*data = be32_to_cpu(bd_ptr[0].data[0]);
> +
> +	/*
> +	 * Update descriptor status FIFO RD pointer.
> +	 * NOTE: Skipping check and clear FIFO entries because we are waiting
> +	 * for transfer to be completed.
> +	 */
> +	swr_ptr = ioread32(priv->regs + TSI721_DMAC_DSWP(TSI721_DMACH_MAINT));
> +	iowrite32(swr_ptr, priv->regs + TSI721_DMAC_DSRP(TSI721_DMACH_MAINT));
> +err_out:
> +
> +	return err;
> +}
>
> ...
>
> +static int
> +tsi721_pw_handler(struct rio_mport *mport)
> +{
> +	struct tsi721_device *priv = mport->priv;
> +	u32 pw_stat;
> +	u32 pw_buf[TSI721_RIO_PW_MSG_SIZE/sizeof(u32)];
> +
> +
> +	pw_stat = ioread32(priv->regs + TSI721_RIO_PW_RX_STAT);
> +
> +	if (pw_stat & TSI721_RIO_PW_RX_STAT_PW_VAL) {
> +		pw_buf[0] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(0));
> +		pw_buf[1] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(1));
> +		pw_buf[2] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(2));
> +		pw_buf[3] = ioread32(priv->regs + TSI721_RIO_PW_RX_CAPT(3));
> +
> +		/* Queue PW message (if there is room in FIFO),
> +		 * otherwise discard it.
> +		 */
> +		spin_lock(&priv->pw_fifo_lock);
> +		if (kfifo_avail(&priv->pw_fifo) >= TSI721_RIO_PW_MSG_SIZE)
> +			kfifo_in(&priv->pw_fifo, pw_buf,
> +						TSI721_RIO_PW_MSG_SIZE);
> +		else
> +			priv->pw_discard_count++;
> +		spin_unlock(&priv->pw_fifo_lock);
> +	}
> +
> +	/* Clear pending PW interrupts */
> +	iowrite32(TSI721_RIO_PW_RX_STAT_PW_DISC | TSI721_RIO_PW_RX_STAT_PW_VAL,
> +		  priv->regs + TSI721_RIO_PW_RX_STAT);
> +
> +	schedule_work(&priv->pw_work);

I see scheduled work being done, but no flush_scheduled_work() or
similar.  This is often a bug, leading to code being executed after
device shutdown or even after rmmod.

> +	return 0;
> +}
> +
> +static void tsi721_pw_dpc(struct work_struct *work)
> +{
> +	struct tsi721_device *priv = container_of(work, struct tsi721_device,
> +						    pw_work);
> +	unsigned long flags;
> +	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)]; /* Use full size PW message
> +							buffer for RIO layer */
> +
> +	/*
> +	 * Process port-write messages
> +	 */
> +	spin_lock_irqsave(&priv->pw_fifo_lock, flags);
> +	while (kfifo_out(&priv->pw_fifo, (unsigned char *)msg_buffer,
> +			 TSI721_RIO_PW_MSG_SIZE)) {
> +		/* Process one message */
> +		spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
> +#ifdef DEBUG_PW
> +		{
> +		u32 i;
> +		pr_debug("%s : Port-Write Message:", __func__);
> +		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); ) {
> +			pr_debug("0x%02x: %08x %08x %08x %08x", i*4,
> +				msg_buffer[i], msg_buffer[i + 1],
> +				msg_buffer[i + 2], msg_buffer[i + 3]);
> +			i += 4;
> +		}
> +		pr_debug("\n");
> +		}
> +#endif
> +		/* Pass the port-write message to RIO core for processing */
> +		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
> +		spin_lock_irqsave(&priv->pw_fifo_lock, flags);
> +	}
> +	spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
> +}

The lock handling in this function is pretty ugly-looking.  Is it correct?

>
> ...
>
> +static void tsi721_db_dpc(struct work_struct *work)
> +{
> +	struct tsi721_device *priv = container_of(work, struct tsi721_device,
> +						    idb_work);
> +	struct rio_mport *mport;
> +	struct rio_dbell *dbell;
> +	int found = 0;
> +	u32 wr_ptr, rd_ptr;
> +	u64 *idb_entry;
> +	u32 regval;
> +	union {
> +		u64 msg;
> +		u8  bytes[8];
> +	} idb;
> +
> +	/*
> +	 * Process queued inbound doorbells
> +	 */
> +	mport = priv->mport;
> +
> +	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE));
> +	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
> +
> +	while (wr_ptr != rd_ptr) {
> +		idb_entry = (u64 *)(priv->idb_base +
> +					(TSI721_IDB_ENTRY_SIZE * rd_ptr));
> +		rd_ptr++;
> +		idb.msg = *idb_entry;

Is this code correct on both little-endian and big-endian hardware?

> +		*idb_entry = 0;
> +
> +		/* Process one doorbell */
> +		list_for_each_entry(dbell, &mport->dbells, node) {
> +			if ((dbell->res->start <= DBELL_INF(idb.bytes)) &&
> +			    (dbell->res->end >= DBELL_INF(idb.bytes))) {
> +				found = 1;
> +				break;
> +			}
> +		}
> +
> +		if (found) {
> +			dbell->dinb(mport, dbell->dev_id, DBELL_SID(idb.bytes),
> +				    DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
> +		} else {
> +			dev_dbg(&priv->pdev->dev,
> +				"spurious inb doorbell, sid %2.2x tid %2.2x"
> +				" info %4.4x\n", DBELL_SID(idb.bytes),
> +				DBELL_TID(idb.bytes), DBELL_INF(idb.bytes));
> +		}
> +	}
> +
> +	iowrite32(rd_ptr & (IDB_QSIZE - 1),
> +		priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
> +
> +	/* Re-enable IDB interrupts */
> +	regval = ioread32(priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
> +	regval |= TSI721_SR_CHINT_IDBQRCV;
> +	iowrite32(regval,
> +		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
> +}
> +
>
> ...
>
> +static void tsi721_interrupts_init(struct tsi721_device *priv)
> +{
> +	u32 intr;
> +
> +	/* Enable IDB interrupts */
> +	iowrite32(TSI721_SR_CHINT_ALL,
> +		priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
> +	iowrite32(TSI721_SR_CHINT_IDBQRCV,
> +		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
> +	iowrite32(TSI721_INT_SR2PC_CHAN(IDB_QUEUE),
> +		priv->regs + TSI721_DEV_CHAN_INTE);
> +
> +	/* Enable SRIO MAC interrupts */
> +	iowrite32(TSI721_RIO_EM_DEV_INT_EN_INT,
> +		priv->regs + TSI721_RIO_EM_DEV_INT_EN);
> +
> +	if (priv->flags & TSI721_USING_MSIX)
> +		intr = TSI721_DEV_INT_SRIO;
> +	else
> +		intr = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
> +			TSI721_DEV_INT_SMSG_CH;
> +
> +	iowrite32(intr, priv->regs + TSI721_DEV_INTE);
> +	(void)ioread32(priv->regs + TSI721_DEV_INTE);

Why include all of these void casts, btw?

> +}
> +
> +/**
> + * tsi721_request_msix - register interrupt service for MSI-X mode.
> + * @mport: RapidIO master port structure
> + *
> + * Registers MSI-X interrupt service routines for interrupts that are active
> + * immediately after mport initialization. Messaging interrupt service routines
> + * should be registered during corresponding open requests.
> + */
> +static int tsi721_request_msix(struct rio_mport *mport)
> +{
> +	struct tsi721_device *priv = mport->priv;
> +	int err = 0;
> +
> +	err = request_irq(priv->msix[TSI721_VECT_IDB].vector,
> +			tsi721_sr2pc_ch_msix, 0,
> +			priv->msix[TSI721_VECT_IDB].irq_name, (void *)mport);
> +	if (err)
> +		goto out;
> +
> +	err = request_irq(priv->msix[TSI721_VECT_PWRX].vector,
> +			tsi721_srio_msix, 0,
> +			priv->msix[TSI721_VECT_PWRX].irq_name, (void *)mport);

Did we leak the first IRQ here?

> +out:
> +	return err;
> +}
> +
>
> ...
>
> +static int tsi721_enable_msix(struct tsi721_device *priv)
> +{
> +	struct msix_entry entries[TSI721_VECT_MAX];
> +	int err;
> +	int i;
> +
> +	entries[TSI721_VECT_IDB].entry = TSI721_MSIX_SR2PC_IDBQ_RCV(IDB_QUEUE);
> +	entries[TSI721_VECT_PWRX].entry = TSI721_MSIX_SRIO_MAC_INT;
> +
> +	/*
> +	 * Initialize MSI-X entries for Messaging Engine:
> +	 * this driver supports four RIO mailboxes (inbound and outbound)
> +	 * NOTE: Inbound message MBOX 0...4 use IB channels 4...7. Therefore
> +	 * offset +4 is added to IB MBOX number.
> +	 */
> +	for (i = 0; i < RIO_MAX_MBOX; i++) {
> +		entries[TSI721_VECT_IMB0_RCV + i].entry =
> +					TSI721_MSIX_IMSG_DQ_RCV(i + 4);
> +		entries[TSI721_VECT_IMB0_INT + i].entry =
> +					TSI721_MSIX_IMSG_INT(i + 4);
> +		entries[TSI721_VECT_OMB0_DONE + i].entry =
> +					TSI721_MSIX_OMSG_DONE(i);
> +		entries[TSI721_VECT_OMB0_INT + i].entry =
> +					TSI721_MSIX_OMSG_INT(i);
> +	}
> +
> +	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
> +	if (err) {
> +		if (err > 0)
> +			dev_info(&priv->pdev->dev,
> +				 "Only %d MSI-X vectors available, "
> +				 "not using MSI-X\n", err);
> +		return err;
> +	}
> +
> +	/*
> +	 * Copy MSI-X vector information into tsi721 private structure
> +	 */
> +	priv->msix[TSI721_VECT_IDB].vector = entries[TSI721_VECT_IDB].vector;
> +	snprintf(priv->msix[TSI721_VECT_IDB].irq_name, IRQ_DEVICE_NAME_MAX,
> +		 DRV_NAME "-idb@pci:%s", pci_name(priv->pdev));
> +	priv->msix[TSI721_VECT_PWRX].vector = entries[TSI721_VECT_PWRX].vector;
> +	snprintf(priv->msix[TSI721_VECT_PWRX].irq_name, IRQ_DEVICE_NAME_MAX,
> +		 DRV_NAME "-pwrx@pci:%s", pci_name(priv->pdev));
> +
> +	for (i = 0; i < RIO_MAX_MBOX; i++) {
> +		priv->msix[TSI721_VECT_IMB0_RCV + i].vector =
> +				entries[TSI721_VECT_IMB0_RCV + i].vector;
> +		snprintf(priv->msix[TSI721_VECT_IMB0_RCV + i].irq_name,
> +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-imbr%d@pci:%s",
> +			 i, pci_name(priv->pdev));
> +
> +		priv->msix[TSI721_VECT_IMB0_INT + i].vector =
> +				entries[TSI721_VECT_IMB0_INT + i].vector;
> +		snprintf(priv->msix[TSI721_VECT_IMB0_INT + i].irq_name,
> +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-imbi%d@pci:%s",
> +			 i, pci_name(priv->pdev));
> +
> +		priv->msix[TSI721_VECT_OMB0_DONE + i].vector =
> +				entries[TSI721_VECT_OMB0_DONE + i].vector;
> +		snprintf(priv->msix[TSI721_VECT_OMB0_DONE + i].irq_name,
> +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-ombd%d@pci:%s",
> +			 i, pci_name(priv->pdev));
> +
> +		priv->msix[TSI721_VECT_OMB0_INT + i].vector =
> +				entries[TSI721_VECT_OMB0_INT + i].vector;
> +		snprintf(priv->msix[TSI721_VECT_OMB0_INT + i].irq_name,
> +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-ombi%d@pci:%s",
> +			 i, pci_name(priv->pdev));
> +	}

Did we need a dependency on CONFIG_PCI_MSI?

> +	return 0;
> +}
> +
>
> ...
>
> +static int tsi721_bdma_ch_init(struct tsi721_device *priv, int chnum)
> +{
> +	struct tsi721_dma_desc *bd_ptr;
> +	u64		*sts_ptr;
> +	dma_addr_t	bd_phys, sts_phys;
> +	int		sts_size;
> +	int		bd_num = priv->bdma[chnum].bd_num;
> +
> +	dev_dbg(&priv->pdev->dev, "Init Block DMA Engine, CH%d\n", chnum);
> +
> +	/*
> +	 * Initialize DMA channel for maintenance requests
> +	 */
> +
> +	/* Allocate space for DMA descriptors */
> +	bd_ptr = dma_alloc_coherent(&priv->pdev->dev,
> +					bd_num * sizeof(struct tsi721_dma_desc),
> +					&bd_phys, GFP_KERNEL);
> +	if (!bd_ptr)
> +		return -ENOMEM;
> +
> +	priv->bdma[chnum].bd_phys = bd_phys;
> +	priv->bdma[chnum].bd_base = bd_ptr;
> +
> +	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));

There it is again.  Perhaps we need a dma_zalloc_coherent().

> +	dev_dbg(&priv->pdev->dev, "DMA descriptors @ %p (phys = %llx)\n",
> +		bd_ptr, (unsigned long long)bd_phys);
> +
> +	/* Allocate space for descriptor status FIFO */
> +	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
> +					bd_num : TSI721_DMA_MINSTSSZ;
> +	sts_size = roundup_pow_of_two(sts_size);
> +	sts_ptr = dma_alloc_coherent(&priv->pdev->dev,
> +				     sts_size * sizeof(struct tsi721_dma_sts),
> +				     &sts_phys, GFP_KERNEL);
> +	if (!sts_ptr) {
> +		/* Free space allocated for DMA descriptors */
> +		dma_free_coherent(&priv->pdev->dev,
> +				  bd_num * sizeof(struct tsi721_dma_desc),
> +				  bd_ptr, bd_phys);
> +		priv->bdma[chnum].bd_base = NULL;
> +		return -ENOMEM;
> +	}
> +
> +	priv->bdma[chnum].sts_phys = sts_phys;
> +	priv->bdma[chnum].sts_base = sts_ptr;
> +	priv->bdma[chnum].sts_size = sts_size;
> +
> +	memset(sts_ptr, 0, sts_size);

and again.

> +	dev_dbg(&priv->pdev->dev,
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
> +		priv->regs + TSI721_DMAC_DPTRH(chnum));
> +	iowrite32(((u64)bd_phys & TSI721_DMAC_DPTRL_MASK),
> +		priv->regs + TSI721_DMAC_DPTRL(chnum));
> +
> +	/* Setup descriptor status FIFO */
> +	iowrite32(((u64)sts_phys >> 32),
> +		priv->regs + TSI721_DMAC_DSBH(chnum));
> +	iowrite32(((u64)sts_phys & TSI721_DMAC_DSBL_MASK),
> +		priv->regs + TSI721_DMAC_DSBL(chnum));
> +	iowrite32(TSI721_DMAC_DSSZ_SIZE(sts_size),
> +		priv->regs + TSI721_DMAC_DSSZ(chnum));
> +
> +	/* Clear interrupt bits */
> +	iowrite32(TSI721_DMAC_INT_ALL,
> +		priv->regs + TSI721_DMAC_INT(chnum));
> +
> +	(void)ioread32(priv->regs + TSI721_DMAC_INT(chnum));
> +
> +	/* Toggle DMA channel initialization */
> +	iowrite32(TSI721_DMAC_CTL_INIT,	priv->regs + TSI721_DMAC_CTL(chnum));
> +	(void)ioread32(priv->regs + TSI721_DMAC_CTL(chnum));
> +	udelay(10);
> +
> +	return 0;
> +}
> +
>
> ...
>
> +struct tsi721_dma_desc {
> +	__le32 type_id;
> +
> +#define TSI721_DMAD_DEVID	0x0000ffff
> +#define TSI721_DMAD_CRF		0x00010000
> +#define TSI721_DMAD_PRIO	0x00060000
> +#define TSI721_DMAD_RTYPE	0x00780000
> +#define TSI721_DMAD_IOF		0x08000000
> +#define TSI721_DMAD_DTYPE	0xe0000000
> +
> +	__le32 bcount;
> +
> +#define TSI721_DMAD_BCOUNT1	0x03ffffff /* if DTYPE == 1 */
> +#define TSI721_DMAD_BCOUNT2	0x0000000f /* if DTYPE == 2 */
> +#define TSI721_DMAD_TT		0x0c000000
> +#define TSI721_DMAD_RADDR0	0xc0000000
> +
> +	union {
> +		__le32 raddr_lo;	   /* if DTYPE == (1 || 2) */
> +		__le32 next_lo;		   /* if DTYPE == 3 */
> +	};
> +
> +#define TSI721_DMAD_CFGOFF	0x00ffffff
> +#define TSI721_DMAD_HOPCNT	0xff000000
> +
> +	union {
> +		__le32 raddr_hi;	   /* if DTYPE == (1 || 2) */
> +		__le32 next_hi;		   /* if DTYPE == 3 */
> +	};
> +
> +	union {
> +		struct {		   /* if DTYPE == 1 */
> +			__le32 bufptr_lo;
> +			__le32 bufptr_hi;
> +			__le32 s_dist;
> +			__le32 s_size;
> +		} t1;
> +		__le32 data[4];		   /* if DTYPE == 2 */
> +		u32    reserved[4];	   /* if DTYPE == 3 */
> +	};
> +} __attribute__((aligned(32)));

We have the __aligned helper for this.  (more below)

>
> ...
>

