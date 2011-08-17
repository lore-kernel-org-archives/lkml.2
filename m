Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1HQUW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:22:29 -0400
Received: from mxout1.idt.com ([157.165.5.25]:56889 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab1HQUW1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:22:27 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] RapidIO: Add mport driver for Tsi721 bridge
Date: Wed, 17 Aug 2011 13:21:43 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520207367D@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110816160120.50bda968.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RapidIO: Add mport driver for Tsi721 bridge
Thread-Index: AcxcaIqj+f5vigxFTe+qSIoPTPMu6AAiMWqg
References: <1313178334-6964-1-git-send-email-alexandre.bounine@idt.com> <20110816160120.50bda968.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Kim, Chul" <Chul.Kim@idt.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> On Fri, 12 Aug 2011 15:45:34 -0400
> Alexandre Bounine <alexandre.bounine@idt.com> wrote:
> 
> > Add RapidIO mport driver for IDT TSI721 PCI Express-to-SRIO bridge
device.
> 
> What a huge driver.

It is not over yet. We have plans to add more stuff later.
 
> >
> > ...
> > +config RAPIDIO_TSI721
> > +	bool "IDT Tsi721 PCI Express SRIO Controller support"
> > +	depends on RAPIDIO && PCI && PCIEPORTBUS
> 
> The dependency on PCI is redundant - PCIEPORTBUS already depends on
> PCI.  Doesn't matter much though.

Agree. Will clean it for next release. 
 
> > +	default "n"
> > +	---help---
> > +	  Include support for IDT Tsi721 PCI Express Serial RapidIO
> controller.
> >
> > ...
> >
> > +	/* Wait until DMA transfer is finished */
> > +	while ((ch_stat = ioread32(priv->regs +
> > +		TSI721_DMAC_STS(TSI721_DMACH_MAINT))) &
TSI721_DMAC_STS_RUN) {
> > +		udelay(10);
> > +		i++;
> > +		if (i >= 5000000) {
> > +			dev_dbg(&priv->pdev->dev,
> > +				"%s : DMA[%d] read timeout
ch_status=%x\n",
> > +				__func__, TSI721_DMACH_MAINT, ch_stat);
> > +			if (!do_wr)
> > +				*data = 0xffffffff;
> > +			err = -EFAULT;
> > +			goto err_out;
> > +		}
> > +	}
> 
> Fifty seconds!?!?

Should be "udelay(1)" - 10 usec is too much here.
 
> EFAULT seems an inappropriate errno.

Switching to EIO.
 
> > +	if (ch_stat & TSI721_DMAC_STS_ABORT) {
> > +		/* If DMA operation aborted due to error,
> > +		 * reinitialize DMA channel
> > +		 */
.....

> > +		iowrite32(0, priv->regs +
> > +				TSI721_DMAC_DWRCNT(TSI721_DMACH_MAINT));
> > +		udelay(1);
> > +		if (!do_wr)
> > +			*data = 0xffffffff;
> > +		err = -EFAULT;

Here EIO as well because ABORT error reports more events than just bad
address.

> > ...
> >
> > +static int
> > +tsi721_pw_handler(struct rio_mport *mport)
> > +{
> > +	struct tsi721_device *priv = mport->priv;
> > +	u32 pw_stat;
> > +	u32 pw_buf[TSI721_RIO_PW_MSG_SIZE/sizeof(u32)];
> > +
> > +
> > +	pw_stat = ioread32(priv->regs + TSI721_RIO_PW_RX_STAT);
> > +
> > +	if (pw_stat & TSI721_RIO_PW_RX_STAT_PW_VAL) {
> > +		pw_buf[0] = ioread32(priv->regs +
TSI721_RIO_PW_RX_CAPT(0));
> > +		pw_buf[1] = ioread32(priv->regs +
TSI721_RIO_PW_RX_CAPT(1));
> > +		pw_buf[2] = ioread32(priv->regs +
TSI721_RIO_PW_RX_CAPT(2));
> > +		pw_buf[3] = ioread32(priv->regs +
TSI721_RIO_PW_RX_CAPT(3));
> > +
> > +		/* Queue PW message (if there is room in FIFO),
> > +		 * otherwise discard it.
> > +		 */
> > +		spin_lock(&priv->pw_fifo_lock);
> > +		if (kfifo_avail(&priv->pw_fifo) >=
TSI721_RIO_PW_MSG_SIZE)
> > +			kfifo_in(&priv->pw_fifo, pw_buf,
> > +						TSI721_RIO_PW_MSG_SIZE);
> > +		else
> > +			priv->pw_discard_count++;
> > +		spin_unlock(&priv->pw_fifo_lock);
> > +	}
> > +
> > +	/* Clear pending PW interrupts */
> > +	iowrite32(TSI721_RIO_PW_RX_STAT_PW_DISC |
TSI721_RIO_PW_RX_STAT_PW_VAL,
> > +		  priv->regs + TSI721_RIO_PW_RX_STAT);
> > +
> > +	schedule_work(&priv->pw_work);
> 
> I see scheduled work being done, but no flush_scheduled_work() or
> similar.  This is often a bug, leading to code being executed after
> device shutdown or even after rmmod.

Possibly my oversight. I will check if/where flush is needed.
 
> > +	return 0;
> > +}
> > +
> > +static void tsi721_pw_dpc(struct work_struct *work)
> > +{
> > +	struct tsi721_device *priv = container_of(work, struct
tsi721_device,
> > +						    pw_work);
> > +	unsigned long flags;
> > +	u32 msg_buffer[RIO_PW_MSG_SIZE/sizeof(u32)]; /* Use full size PW
message
> > +							buffer for RIO
layer */
> > +
> > +	/*
> > +	 * Process port-write messages
> > +	 */
> > +	spin_lock_irqsave(&priv->pw_fifo_lock, flags);
> > +	while (kfifo_out(&priv->pw_fifo, (unsigned char *)msg_buffer,
> > +			 TSI721_RIO_PW_MSG_SIZE)) {
> > +		/* Process one message */
> > +		spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
> > +#ifdef DEBUG_PW
> > +		{
> > +		u32 i;
> > +		pr_debug("%s : Port-Write Message:", __func__);
> > +		for (i = 0; i < RIO_PW_MSG_SIZE/sizeof(u32); ) {
> > +			pr_debug("0x%02x: %08x %08x %08x %08x", i*4,
> > +				msg_buffer[i], msg_buffer[i + 1],
> > +				msg_buffer[i + 2], msg_buffer[i + 3]);
> > +			i += 4;
> > +		}
> > +		pr_debug("\n");
> > +		}
> > +#endif
> > +		/* Pass the port-write message to RIO core for
processing */
> > +		rio_inb_pwrite_handler((union rio_pw_msg *)msg_buffer);
> > +		spin_lock_irqsave(&priv->pw_fifo_lock, flags);
> > +	}
> > +	spin_unlock_irqrestore(&priv->pw_fifo_lock, flags);
> > +}
> 
> The lock handling in this function is pretty ugly-looking.  Is it
> correct?

Ugly for sure. I am trying to protect message FIFO and not to lock it
during 
execution of rio_inb_pwrite_handler() because it may take relatively
long time.
Inbound port-write controller does not have any HW queue to store PW
messages
and my goal is to get them from device ASAP and to place into the FIFO.
I will redo this function to make locking to look better.     
 
> >
> > ...
> >
> > +static void tsi721_db_dpc(struct work_struct *work)
> > +{
> > +	struct tsi721_device *priv = container_of(work, struct
tsi721_device,
> > +						    idb_work);
> > +	struct rio_mport *mport;
> > +	struct rio_dbell *dbell;
> > +	int found = 0;
> > +	u32 wr_ptr, rd_ptr;
> > +	u64 *idb_entry;
> > +	u32 regval;
> > +	union {
> > +		u64 msg;
> > +		u8  bytes[8];
> > +	} idb;
> > +
> > +	/*
> > +	 * Process queued inbound doorbells
> > +	 */
> > +	mport = priv->mport;
> > +
> > +	wr_ptr = ioread32(priv->regs + TSI721_IDQ_WP(IDB_QUEUE));
> > +	rd_ptr = ioread32(priv->regs + TSI721_IDQ_RP(IDB_QUEUE));
> > +
> > +	while (wr_ptr != rd_ptr) {
> > +		idb_entry = (u64 *)(priv->idb_base +
> > +					(TSI721_IDB_ENTRY_SIZE *
rd_ptr));
> > +		rd_ptr++;
> > +		idb.msg = *idb_entry;
> 
> Is this code correct on both little-endian and big-endian hardware?

Yes. It works on both. Tested on x86 and powerpc.
 
> > +		*idb_entry = 0;
> > +
> > +		/* Process one doorbell */
> > +		list_for_each_entry(dbell, &mport->dbells, node) {
> > +			if ((dbell->res->start <= DBELL_INF(idb.bytes))
&&
> > +			    (dbell->res->end >= DBELL_INF(idb.bytes))) {
> > ...
> >
> > +static void tsi721_interrupts_init(struct tsi721_device *priv)
> > +{
> > +	u32 intr;
> > +
> > +	/* Enable IDB interrupts */
> > +	iowrite32(TSI721_SR_CHINT_ALL,
> > +		priv->regs + TSI721_SR_CHINT(IDB_QUEUE));
> > +	iowrite32(TSI721_SR_CHINT_IDBQRCV,
> > +		priv->regs + TSI721_SR_CHINTE(IDB_QUEUE));
> > +	iowrite32(TSI721_INT_SR2PC_CHAN(IDB_QUEUE),
> > +		priv->regs + TSI721_DEV_CHAN_INTE);
> > +
> > +	/* Enable SRIO MAC interrupts */
> > +	iowrite32(TSI721_RIO_EM_DEV_INT_EN_INT,
> > +		priv->regs + TSI721_RIO_EM_DEV_INT_EN);
> > +
> > +	if (priv->flags & TSI721_USING_MSIX)
> > +		intr = TSI721_DEV_INT_SRIO;
> > +	else
> > +		intr = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
> > +			TSI721_DEV_INT_SMSG_CH;
> > +
> > +	iowrite32(intr, priv->regs + TSI721_DEV_INTE);
> > +	(void)ioread32(priv->regs + TSI721_DEV_INTE);
> 
> Why include all of these void casts, btw?

Old habit. Used to have compiler warnings in some situations.
Not applicable to this case though. Will clean-up.

> > +}
> > +
> > +/**
> > + * tsi721_request_msix - register interrupt service for MSI-X mode.
> > + * @mport: RapidIO master port structure
> > + *
> > + * Registers MSI-X interrupt service routines for interrupts that
are active
> > + * immediately after mport initialization. Messaging interrupt
service routines
> > + * should be registered during corresponding open requests.
> > + */
> > +static int tsi721_request_msix(struct rio_mport *mport)
> > +{
> > +	struct tsi721_device *priv = mport->priv;
> > +	int err = 0;
> > +
> > +	err = request_irq(priv->msix[TSI721_VECT_IDB].vector,
> > +			tsi721_sr2pc_ch_msix, 0,
> > +			priv->msix[TSI721_VECT_IDB].irq_name, (void
*)mport);
> > +	if (err)
> > +		goto out;
> > +
> > +	err = request_irq(priv->msix[TSI721_VECT_PWRX].vector,
> > +			tsi721_srio_msix, 0,
> > +			priv->msix[TSI721_VECT_PWRX].irq_name, (void
> *)mport);
> 
> Did we leak the first IRQ here?

Yes we did. Will fix it here and in one more place.

> 
> > +out:
> > +	return err;
> > +}
> > +
> >
> > ...
> >
> > +static int tsi721_enable_msix(struct tsi721_device *priv)
> > +{
> > +	struct msix_entry entries[TSI721_VECT_MAX];
> > +	int err;
> > +	int i;
> > +
> > +	entries[TSI721_VECT_IDB].entry =
TSI721_MSIX_SR2PC_IDBQ_RCV(IDB_QUEUE);
> > +	entries[TSI721_VECT_PWRX].entry = TSI721_MSIX_SRIO_MAC_INT;
> > +
> > +	/*
> > +	 * Initialize MSI-X entries for Messaging Engine:
> > +	 * this driver supports four RIO mailboxes (inbound and
outbound)
> > +	 * NOTE: Inbound message MBOX 0...4 use IB channels 4...7.
Therefore
> > +	 * offset +4 is added to IB MBOX number.
> > +	 */
> > +	for (i = 0; i < RIO_MAX_MBOX; i++) {
> > +		entries[TSI721_VECT_IMB0_RCV + i].entry =
> > +					TSI721_MSIX_IMSG_DQ_RCV(i + 4);
> > +		entries[TSI721_VECT_IMB0_INT + i].entry =
> > +					TSI721_MSIX_IMSG_INT(i + 4);
> > +		entries[TSI721_VECT_OMB0_DONE + i].entry =
> > +					TSI721_MSIX_OMSG_DONE(i);
> > +		entries[TSI721_VECT_OMB0_INT + i].entry =
> > +					TSI721_MSIX_OMSG_INT(i);
> > +	}
> > +
> > +	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
> > +	if (err) {
> > +		if (err > 0)
> > +			dev_info(&priv->pdev->dev,
> > +				 "Only %d MSI-X vectors available, "
> > +				 "not using MSI-X\n", err);
> > +		return err;
> > +	}
> > +
> > +	/*
> > +	 * Copy MSI-X vector information into tsi721 private structure
> > +	 */
> > +	priv->msix[TSI721_VECT_IDB].vector =
entries[TSI721_VECT_IDB].vector;
> > +	snprintf(priv->msix[TSI721_VECT_IDB].irq_name,
IRQ_DEVICE_NAME_MAX,
> > +		 DRV_NAME "-idb@pci:%s", pci_name(priv->pdev));
> > +	priv->msix[TSI721_VECT_PWRX].vector =
entries[TSI721_VECT_PWRX].vector;
> > +	snprintf(priv->msix[TSI721_VECT_PWRX].irq_name,
IRQ_DEVICE_NAME_MAX,
> > +		 DRV_NAME "-pwrx@pci:%s", pci_name(priv->pdev));
> > +
> > +	for (i = 0; i < RIO_MAX_MBOX; i++) {
> > +		priv->msix[TSI721_VECT_IMB0_RCV + i].vector =
> > +				entries[TSI721_VECT_IMB0_RCV +
i].vector;
> > +		snprintf(priv->msix[TSI721_VECT_IMB0_RCV + i].irq_name,
> > +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-imbr%d@pci:%s",
> > +			 i, pci_name(priv->pdev));
> > +
> > +		priv->msix[TSI721_VECT_IMB0_INT + i].vector =
> > +				entries[TSI721_VECT_IMB0_INT +
i].vector;
> > +		snprintf(priv->msix[TSI721_VECT_IMB0_INT + i].irq_name,
> > +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-imbi%d@pci:%s",
> > +			 i, pci_name(priv->pdev));
> > +
> > +		priv->msix[TSI721_VECT_OMB0_DONE + i].vector =
> > +				entries[TSI721_VECT_OMB0_DONE +
i].vector;
> > +		snprintf(priv->msix[TSI721_VECT_OMB0_DONE + i].irq_name,
> > +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-ombd%d@pci:%s",
> > +			 i, pci_name(priv->pdev));
> > +
> > +		priv->msix[TSI721_VECT_OMB0_INT + i].vector =
> > +				entries[TSI721_VECT_OMB0_INT +
i].vector;
> > +		snprintf(priv->msix[TSI721_VECT_OMB0_INT + i].irq_name,
> > +			 IRQ_DEVICE_NAME_MAX, DRV_NAME "-ombi%d@pci:%s",
> > +			 i, pci_name(priv->pdev));
> > +	}
> 
> Did we need a dependency on CONFIG_PCI_MSI?

To reduce a driver footprint yes, but it will not help if
system implements regular MSI only. This may be better handled by using
device specific config option depending on CONFIG_PCI_MSI. This way I
will be able
to remove MSI-X code while keeping MSI function. Marking as TODO.

If code size is not a concern, pci_enable_msix() has dependency on
CONFIG_PCI_MSI
and will fail if MSI support is not enabled.

> 
> > +	return 0;
> > +}
> > +
> >
> > ...
> >
> > +static int tsi721_bdma_ch_init(struct tsi721_device *priv, int
chnum)
> > +{
> > +	struct tsi721_dma_desc *bd_ptr;
> > +	u64		*sts_ptr;
> > +	dma_addr_t	bd_phys, sts_phys;
> > +	int		sts_size;
> > +	int		bd_num = priv->bdma[chnum].bd_num;
> > +
> > +	dev_dbg(&priv->pdev->dev, "Init Block DMA Engine, CH%d\n",
chnum);
> > +
> > +	/*
> > +	 * Initialize DMA channel for maintenance requests
> > +	 */
> > +
> > +	/* Allocate space for DMA descriptors */
> > +	bd_ptr = dma_alloc_coherent(&priv->pdev->dev,
> > +					bd_num * sizeof(struct
tsi721_dma_desc),
> > +					&bd_phys, GFP_KERNEL);
> > +	if (!bd_ptr)
> > +		return -ENOMEM;
> > +
> > +	priv->bdma[chnum].bd_phys = bd_phys;
> > +	priv->bdma[chnum].bd_base = bd_ptr;
> > +
> > +	memset(bd_ptr, 0, bd_num * sizeof(struct tsi721_dma_desc));
> 
> There it is again.  Perhaps we need a dma_zalloc_coherent().

It will be nice match to kzalloc().
 
> > +	dev_dbg(&priv->pdev->dev, "DMA descriptors @ %p (phys =
%llx)\n",
> > +		bd_ptr, (unsigned long long)bd_phys);
> > +
> > +	/* Allocate space for descriptor status FIFO */
> > +	sts_size = (bd_num >= TSI721_DMA_MINSTSSZ) ?
> > +					bd_num : TSI721_DMA_MINSTSSZ;
> > +	sts_size = roundup_pow_of_two(sts_size);
> > +	sts_ptr = dma_alloc_coherent(&priv->pdev->dev,
> > +				     sts_size * sizeof(struct
tsi721_dma_sts),
> > +				     &sts_phys, GFP_KERNEL);
> > +	if (!sts_ptr) {
> > +		/* Free space allocated for DMA descriptors */
> > +		dma_free_coherent(&priv->pdev->dev,
> > +				  bd_num * sizeof(struct
tsi721_dma_desc),
> > +				  bd_ptr, bd_phys);
> > +		priv->bdma[chnum].bd_base = NULL;
> > +		return -ENOMEM;
> > +	}
> > +
> > +	priv->bdma[chnum].sts_phys = sts_phys;
> > +	priv->bdma[chnum].sts_base = sts_ptr;
> > +	priv->bdma[chnum].sts_size = sts_size;
> > +
> > +	memset(sts_ptr, 0, sts_size);
> 
> and again.

This memset() may be safely removed. I will review all similar cases.
 
> >
> > ...
> >
> > +struct tsi721_dma_desc {
> > +	__le32 type_id;
> > +

...
> > +
> > +	union {
> > +		struct {		   /* if DTYPE == 1 */
> > +			__le32 bufptr_lo;
> > +			__le32 bufptr_hi;
> > +			__le32 s_dist;
> > +			__le32 s_size;
> > +		} t1;
> > +		__le32 data[4];		   /* if DTYPE == 2 */
> > +		u32    reserved[4];	   /* if DTYPE == 3 */
> > +	};
> > +} __attribute__((aligned(32)));
> 
> We have the __aligned helper for this.  (more below)

No excuse to ignore it. Will update.
 
> >
> > ...
> >
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
