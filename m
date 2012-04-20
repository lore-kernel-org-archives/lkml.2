Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2DTLRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:17:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:20870 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab2DTLRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156050449"
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: dan.j.williams@intel.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@nvidia.com,
        linux-tegra@vger.kernel.org
In-Reply-To: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Apr 2012 16:44:47 +0530
Message-ID: <1334920487.31825.98.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 14:38 +0530, Laxman Dewangan wrote:
> Adding dmaengine based NVIDIA's Tegra APB dma driver.
> This driver support the slave mode of data transfer from
> peripheral to memory and vice versa.
> The driver supports for the cyclic and non-cyclic mode
> of data transfer.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This is NVIDIA Tegra's APB dma controller driver based on dmaengine.
> There is already old driver in mach-tegra/dma.c and we want to get rid
> of this old style driver which exposes private apis.
> Once this driver get through, there will be series of patches to move all
> existing driver to use the dmaengine based driver and old mach-tegra/dma.c
> will get deleted. This driver has following feature than old one:
> - better queue managment.
> - Cyclic transfer supports.
> - Platform driver.
> - Full support for device tree.
> - Uses regmap mmio interface for debugfs/ context restore.
> - Multiple bug fixes over old driver.
[snip]
> + * dma_transfer_mode: Different dma transfer mode.
> + * DMA_MODE_ONCE: Dma transfer the configured buffer once and at the end of
> + *		transfer, dma  stops automatically and generates interrupt
> + *		if enabled. SW need to reprogram dma for next transfer.
> + * DMA_MODE_CYCLE: Dma keeps transferring the same buffer again and again
> + *		until dma stopped explicitly by SW or another buffer configured.
> + *		After transfer completes, dma again starts transfer from
> + *		beginning of buffer without sw intervention. If any new
> + *		address/size is	configured during buffer transfer then
> + *		dma start transfer with	new configuration otherwise it
> + *		will keep transferring with old	configuration. It also
> + *		generates the interrupt after buffer transfer completes.
why do you need to define this? use the cyclic api to convey this
> + * DMA_MODE_CYCLE_HALF_NOTIFY: In this mode dma keeps transferring the buffer
> + *		into two folds. This is kind of ping-pong buffer where both
> + *		buffer size should be same. Dma completes the one buffer,
> + *		generates interrupt and keep transferring the next buffer
> + *		whose address start just next to first buffer. At the end of
> + *		second buffer transfer, dma again generates interrupt and
> + *		keep transferring of the data from starting of first buffer.
> + *		If sw wants to change the address/size of the buffer then
> + *		it needs to change only when dma transferring the second
> + *		half of buffer. In dma configuration, it only need to
> + *		configure starting of first buffer and size of first buffer.
> + *		Dma hw assumes that striating address of second buffer is just
> + *		next to end of first buffer and size is same as the first
> + *		buffer.
isnt this a specifc example of cylci and frankly why should dmaengine
care about this. This one of the configurations you are passing for a
cyclic dma operation
> + */
> +enum dma_transfer_mode {
> +	DMA_MODE_NONE,
> +	DMA_MODE_ONCE,
> +	DMA_MODE_CYCLE,
> +	DMA_MODE_CYCLE_HALF_NOTIFY,
> +};
> +
> +/* List of memory allocated for that channel */
> +struct tegra_dma_chan_mem_alloc {
> +	struct list_head	node;
> +};
this seems questionable too...
> +
> +/* Dma channel registers */
> +struct tegra_dma_channel_regs {
> +	unsigned long	csr;
> +	unsigned long	ahb_ptr;
> +	unsigned long	apb_ptr;
> +	unsigned long	ahb_seq;
> +	unsigned long	apb_seq;
> +};
> +
> +/*
> + * tegra_dma_sg_req: Dma request details to configure hardware. This
> + * contains the details for one transfer to configure dma hw.
> + * The client's request for data transfer can be broken into multiple
> + * sub-transfer as per requestor details and hw support.
typo			  ^^^^^^^^^
> + * This sub transfer get added in the list of transfer and point to Tegra
> + * dma descriptor which manages the transfer details.
> + */
> +struct tegra_dma_sg_req {
> +	struct tegra_dma_channel_regs	ch_regs;
> +	int				req_len;
> +	bool				configured;
> +	bool				last_sg;
> +	bool				half_done;
> +	struct list_head		node;
> +	struct tegra_dma_desc		*dma_desc;
> +};
> +
> +/*
> + * tegra_dma_desc: Tegra dma descriptors which manages the client requests.
> + * This de scripts keep track of transfer status, callbacks, transfer and
again	  ^^^^
> + * request counts etc.
> + */
> +struct tegra_dma_desc {
> +	int				bytes_requested;
> +	int				bytes_transferred;
> +	enum dma_status			dma_status;
> +	struct dma_async_tx_descriptor	txd;
> +	struct list_head		node;
> +	struct list_head		tx_list;
> +	struct list_head		cb_node;
> +	bool				ack_reqd;
> +	bool				cb_due;
> +	dma_cookie_t			cookie;
> +};
> +
> +struct tegra_dma_channel;
> +
> +typedef void (*dma_isr_handler)(struct tegra_dma_channel *tdc,
> +				bool to_terminate);
> +
> +/* tegra_dma_channel: Channel specific information */
> +struct tegra_dma_channel {
> +	bool			config_init;
> +	int			id;
> +	int			irq;
> +	unsigned long		chan_base_offset;
> +	spinlock_t		lock;
> +	bool			busy;
> +	enum dma_transfer_mode	dma_mode;
> +	int			descs_allocated;
> +	struct dma_chan		dma_chan;
> +	struct tegra_dma	*tdma;
> +
> +	/* Different lists for managing the requests */
> +	struct list_head	free_sg_req;
> +	struct list_head	pending_sg_req;
> +	struct list_head	free_dma_desc;
> +	struct list_head	wait_ack_dma_desc;
> +	struct list_head	cb_desc;
> +
> +	/* isr handler and tasklet for bottom half of isr handling */
> +	dma_isr_handler		isr_handler;
> +	struct tasklet_struct	tasklet;
> +	dma_async_tx_callback	callback;
> +	void			*callback_param;
> +
> +	/* Channel-slave specific configuration */
> +	struct dma_slave_config dma_sconfig;
> +	struct tegra_dma_slave	dma_slave;
> +
> +	/* Allocated memory pointer list for this channel */
> +	struct list_head	alloc_ptr_list;
> +};
> +
> +/* tegra_dma: Tegra dma specific information */
> +struct tegra_dma {
> +	struct dma_device		dma_dev;
> +	struct device			*dev;
> +	struct clk			*dma_clk;
> +	spinlock_t			global_lock;
> +	void __iomem			*base_addr;
> +	struct regmap			*regmap_dma;
> +	struct tegra_dma_chip_data	chip_data;
> +
> +	/* Last member of the structure */
> +	struct tegra_dma_channel channels[0];
> +};
> +
> +static inline void tdma_write(struct tegra_dma *tdma, u32 reg, u32 val)
> +{
> +	regmap_write(tdma->regmap_dma, reg, val);
> +}
> +
> +static inline u32 tdma_read(struct tegra_dma *tdma, u32 reg)
> +{
> +	u32 val;
> +	regmap_read(tdma->regmap_dma, reg, &val);
> +	return val;
> +}
> +
> +static inline void tdc_write(struct tegra_dma_channel *tdc,
> +		u32 reg, u32 val)
> +{
> +	regmap_write(tdc->tdma->regmap_dma, tdc->chan_base_offset + reg, val);
> +}
> +
> +static inline u32 tdc_read(struct tegra_dma_channel *tdc, u32 reg)
> +{
> +	u32 val;
> +	regmap_read(tdc->tdma->regmap_dma, tdc->chan_base_offset + reg, &val);
> +	return val;
> +}
> +
> +static inline struct tegra_dma_channel *to_tegra_dma_chan(struct dma_chan *dc)
> +{
> +	return container_of(dc, struct tegra_dma_channel, dma_chan);
> +}
> +
> +static inline struct tegra_dma_desc *txd_to_tegra_dma_desc(
> +		struct dma_async_tx_descriptor *td)
> +{
> +	return container_of(td, struct tegra_dma_desc, txd);
> +}
> +
> +static inline struct device *tdc2dev(struct tegra_dma_channel *tdc)
> +{
> +	return &tdc->dma_chan.dev->device;
> +}
> +
> +static dma_cookie_t tegra_dma_tx_submit(struct dma_async_tx_descriptor *tx);
> +
> +static int allocate_tegra_desc(struct tegra_dma_channel *tdc,
> +		int ndma_desc, int nsg_req)
what does the last arg mean?
> +{
> +	int i;
> +	struct tegra_dma_desc *dma_desc;
> +	struct tegra_dma_sg_req *sg_req;
> +	struct dma_chan *dc = &tdc->dma_chan;
> +	struct list_head dma_desc_list;
> +	struct list_head sg_req_list;
> +	struct tegra_dma_chan_mem_alloc *chan_mem;
> +	void *memptr;
> +	size_t dma_desc_size;
> +	size_t sg_req_size;
> +	size_t chan_mem_size;
> +	size_t total_size;
> +	unsigned long flags;
> +
> +	INIT_LIST_HEAD(&dma_desc_list);
> +	INIT_LIST_HEAD(&sg_req_list);
> +
> +	/* Calculate total require size of memory and then allocate */
> +	dma_desc_size = sizeof(struct tegra_dma_desc) * ndma_desc;
> +	sg_req_size = sizeof(struct tegra_dma_sg_req) * nsg_req;
> +	chan_mem_size = sizeof(struct tegra_dma_chan_mem_alloc);
> +	total_size = chan_mem_size + dma_desc_size + sg_req_size;

why cant you simply allocate three structs you need? 
> +
> +	memptr = kzalloc(total_size, GFP_KERNEL);
> +	if (!memptr) {
> +		dev_err(tdc2dev(tdc),
> +			"%s(): Memory allocation fails\n", __func__);
> +		return -ENOMEM;
> +	}
> +	chan_mem = memptr;
> +
> +	/* Initialize dma descriptors */
> +	dma_desc = memptr + chan_mem_size;
> +	for (i = 0; i < ndma_desc; ++i, dma_desc++) {
> +		dma_async_tx_descriptor_init(&dma_desc->txd, dc);
> +		dma_desc->txd.tx_submit = tegra_dma_tx_submit;
> +		dma_desc->txd.flags = DMA_CTRL_ACK;
> +		list_add_tail(&dma_desc->node, &dma_desc_list);
> +	}
> +
> +	/* Initialize req descriptors */
> +	sg_req = memptr + chan_mem_size + dma_desc_size;
> +	for (i = 0; i < nsg_req; ++i, sg_req++)
> +		list_add_tail(&sg_req->node, &sg_req_list);
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	list_add_tail(&chan_mem->node, &tdc->alloc_ptr_list);
> +
> +	if (ndma_desc) {
> +		tdc->descs_allocated += ndma_desc;
> +		list_splice(&dma_desc_list, &tdc->free_dma_desc);
> +	}
> +
> +	if (nsg_req)
> +		list_splice(&sg_req_list, &tdc->free_sg_req);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return tdc->descs_allocated;
> +}
> +
> +/* Get dma desc from free list, if not there then allocate it */
> +static struct tegra_dma_desc *tegra_dma_desc_get(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_desc *dma_desc = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +
> +	/* Check from free list desc */
> +	if (!list_empty(&tdc->free_dma_desc)) {
> +		dma_desc = list_first_entry(&tdc->free_dma_desc,
> +					typeof(*dma_desc), node);
> +		list_del(&dma_desc->node);
> +		goto end;
> +	}
> +
> +	/*
> +	 * Check list with desc which are waiting for ack, may be it
> +	 * got acked from client.
> +	 */
> +	if (!list_empty(&tdc->wait_ack_dma_desc)) {
> +		list_for_each_entry(dma_desc, &tdc->wait_ack_dma_desc, node) {
> +			if (async_tx_test_ack(&dma_desc->txd)) {
> +				list_del(&dma_desc->node);
> +				goto end;
> +			}
> +		}
> +	}
> +
> +	/* There is no free desc, allocate it */
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	dev_dbg(tdc2dev(tdc),
> +		"Allocating more descriptors for channel %d\n", tdc->id);
> +	allocate_tegra_desc(tdc, DMA_NR_DESCS_PER_CHANNEL,
> +				DMA_NR_DESCS_PER_CHANNEL * DMA_NR_REQ_PER_DESC);
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->free_dma_desc))
> +		goto end;
> +
> +	dma_desc = list_first_entry(&tdc->free_dma_desc,
> +					typeof(*dma_desc), node);
> +	list_del(&dma_desc->node);
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return dma_desc;
> +}
> +
> +static void tegra_dma_desc_put(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_desc *dma_desc)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (!list_empty(&dma_desc->tx_list))
> +		list_splice_init(&dma_desc->tx_list, &tdc->free_sg_req);
> +	list_add_tail(&dma_desc->node, &tdc->free_dma_desc);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +}
> +
> +static void tegra_dma_desc_done_locked(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_desc *dma_desc)
> +{
> +	if (dma_desc->ack_reqd)
> +		list_add_tail(&dma_desc->node, &tdc->wait_ack_dma_desc);
> +	else
> +		list_add_tail(&dma_desc->node, &tdc->free_dma_desc);
> +}
> +
> +static struct tegra_dma_sg_req *tegra_dma_sg_req_get(
> +		struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_sg_req *sg_req = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->free_sg_req)) {
> +		spin_unlock_irqrestore(&tdc->lock, flags);
> +		dev_dbg(tdc2dev(tdc),
> +			"Reallocating sg_req for channel %d\n", tdc->id);
> +		allocate_tegra_desc(tdc, 0,
> +				DMA_NR_DESCS_PER_CHANNEL * DMA_NR_REQ_PER_DESC);
> +		spin_lock_irqsave(&tdc->lock, flags);
> +		if (list_empty(&tdc->free_sg_req)) {
> +			dev_dbg(tdc2dev(tdc),
> +			"Not found free sg_req for channel %d\n", tdc->id);
> +			goto end;
> +		}
> +	}
> +
> +	sg_req = list_first_entry(&tdc->free_sg_req, typeof(*sg_req), node);
> +	list_del(&sg_req->node);
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return sg_req;
> +}
> +
> +static int tegra_dma_slave_config(struct dma_chan *dc,
> +		struct dma_slave_config *sconfig)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +
> +	if (!list_empty(&tdc->pending_sg_req)) {
> +		dev_err(tdc2dev(tdc),
> +		     "dma requests are pending, cannot take new configuration");
> +		return -EBUSY;
> +	}
> +
> +	/* Slave specific configuration is must for channel configuration */
> +	if (!dc->private) {
private is deprecated, pls dont use that
> +		dev_err(tdc2dev(tdc),
> +			"Slave specific private data not found for chan %d\n",
> +			 tdc->id);
> +		return -EINVAL;
> +	}
> +
> +	memcpy(&tdc->dma_sconfig, sconfig, sizeof(*sconfig));
> +	memcpy(&tdc->dma_slave, dc->private, sizeof(tdc->dma_slave));
> +	tdc->config_init = true;
> +	return 0;
> +}
> +
> +static void tegra_dma_pause(struct tegra_dma_channel *tdc,
> +	bool wait_for_burst_complete)
> +{
> +	struct tegra_dma *tdma = tdc->tdma;
> +	spin_lock(&tdma->global_lock);
> +	tdma_write(tdma, APB_DMA_GEN, 0);
> +	if (wait_for_burst_complete)
> +		udelay(DMA_BUSRT_COMPLETE_TIME);
> +}
> +
> +static void tegra_dma_resume(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma *tdma = tdc->tdma;
> +	tdma_write(tdma, APB_DMA_GEN, GEN_ENABLE);
> +	spin_unlock(&tdma->global_lock);
> +}
> +
> +static void tegra_dma_stop(struct tegra_dma_channel *tdc)
> +{
> +	u32 csr;
> +	u32 status;
> +
> +	/* Disable interrupts */
> +	csr = tdc_read(tdc, APB_DMA_CHAN_CSR);
> +	csr &= ~CSR_IE_EOC;
> +	tdc_write(tdc, APB_DMA_CHAN_CSR, csr);
> +
> +	/* Disable dma */
> +	csr &= ~CSR_ENB;
> +	tdc_write(tdc, APB_DMA_CHAN_CSR, csr);
> +
> +	/* Clear interrupt status if it is there */
> +	status = tdc_read(tdc, APB_DMA_CHAN_STA);
> +	if (status & STA_ISE_EOC) {
> +		dev_dbg(tdc2dev(tdc), "%s():clearing interrupt\n", __func__);
> +		tdc_write(tdc, APB_DMA_CHAN_STA, status);
> +	}
> +	tdc->busy = false;
> +}
> +
> +static void tegra_dma_start(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_sg_req *sg_req)
> +{
> +	struct tegra_dma_channel_regs *ch_regs = &sg_req->ch_regs;
> +	unsigned long csr = ch_regs->csr;
> +
> +	tdc_write(tdc, APB_DMA_CHAN_CSR, csr);
> +	tdc_write(tdc, APB_DMA_CHAN_APB_SEQ, ch_regs->apb_seq);
> +	tdc_write(tdc, APB_DMA_CHAN_APB_PTR, ch_regs->apb_ptr);
> +	tdc_write(tdc, APB_DMA_CHAN_AHB_SEQ, ch_regs->ahb_seq);
> +	tdc_write(tdc, APB_DMA_CHAN_AHB_PTR, ch_regs->ahb_ptr);
> +
> +	/* Dump the configuration register if verbose mode enabled */
> +	dev_vdbg(tdc2dev(tdc),
> +		"%s(): csr: 0x%08lx\n", __func__, ch_regs->csr);
> +	dev_vdbg(tdc2dev(tdc),
> +		"%s(): apbseq: 0x%08lx\n", __func__, ch_regs->apb_seq);
> +	dev_vdbg(tdc2dev(tdc),
> +		"%s(): apbptr: 0x%08lx\n", __func__, ch_regs->apb_ptr);
> +	dev_vdbg(tdc2dev(tdc),
> +		"%s(): ahbseq: 0x%08lx\n", __func__, ch_regs->ahb_seq);
> +	dev_vdbg(tdc2dev(tdc),
> +		"%s(): ahbptr: 0x%08lx\n", __func__, ch_regs->ahb_ptr);
> +
> +	/* Start dma */
> +	csr |= CSR_ENB;
> +	tdc_write(tdc, APB_DMA_CHAN_CSR, csr);
> +}
> +
> +static void tegra_dma_configure_for_next(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_sg_req *nsg_req)
> +{
> +	unsigned long status;
> +
> +	/*
> +	 * The dma controller reloads the new configuration for next transfer
> +	 * after last burst of current transfer completes.
> +	 * If there is no IEC status then this makes sure that last burst
> +	 * has not be completed. There may be case that last burst is on
> +	 * flight and so it can complete but because dma is paused, it
> +	 * will not generates interrupt as well as not reload the new
> +	 * configuration.
> +	 * If there is already IEC status then interrupt handler need to
> +	 * load new configuration.
> +	 */
> +	tegra_dma_pause(tdc, false);
> +	status  = tdc_read(tdc, APB_DMA_CHAN_STA);
> +
> +	/*
> +	 * If interrupt is pending then do nothing as the ISR will handle
> +	 * the programing for new request.
> +	 */
> +	if (status & STA_ISE_EOC) {
> +		dev_err(tdc2dev(tdc),
> +			"Skipping new configuration as interrupt is pending\n");
> +		goto exit_config;
> +	}
> +
> +	/* Safe to program new configuration */
> +	tdc_write(tdc, APB_DMA_CHAN_APB_PTR, nsg_req->ch_regs.apb_ptr);
> +	tdc_write(tdc, APB_DMA_CHAN_AHB_PTR, nsg_req->ch_regs.ahb_ptr);
> +	tdc_write(tdc, APB_DMA_CHAN_CSR, nsg_req->ch_regs.csr | CSR_ENB);
> +	nsg_req->configured = true;
> +
> +exit_config:
> +	tegra_dma_resume(tdc);
> +}
> +
> +static void tdc_start_head_req(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_sg_req *sg_req;
> +
> +	if (list_empty(&tdc->pending_sg_req))
> +		return;
> +
> +	sg_req = list_first_entry(&tdc->pending_sg_req,
> +					typeof(*sg_req), node);
> +	tegra_dma_start(tdc, sg_req);
> +	sg_req->configured = true;
> +	tdc->busy = true;
> +}
> +
> +static void tdc_configure_next_head_desc(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_sg_req *hsgreq;
> +	struct tegra_dma_sg_req *hnsgreq;
> +
> +	if (list_empty(&tdc->pending_sg_req))
> +		return;
> +
> +	hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
> +	if (!list_is_last(&hsgreq->node, &tdc->pending_sg_req)) {
> +		hnsgreq = list_first_entry(&hsgreq->node,
> +					typeof(*hnsgreq), node);
> +		tegra_dma_configure_for_next(tdc, hnsgreq);
> +	}
> +}
> +
> +static inline int get_current_xferred_count(struct tegra_dma_channel *tdc,
> +	struct tegra_dma_sg_req *sg_req, unsigned long status)
> +{
> +	return sg_req->req_len - ((status & STA_COUNT_MASK) + 4);
> +}
> +
> +static void tegra_dma_abort_all(struct tegra_dma_channel *tdc)
> +{
> +	struct tegra_dma_sg_req *sgreq;
> +	struct tegra_dma_desc *dma_desc;
> +	while (!list_empty(&tdc->pending_sg_req)) {
> +		sgreq = list_first_entry(&tdc->pending_sg_req,
> +						typeof(*sgreq), node);
> +		list_del(&sgreq->node);
> +		list_add_tail(&sgreq->node, &tdc->free_sg_req);
> +		if (sgreq->last_sg) {
> +			dma_desc = sgreq->dma_desc;
> +			dma_desc->dma_status = DMA_ERROR;
> +			tegra_dma_desc_done_locked(tdc, dma_desc);
> +
> +			/* Add in cb list if it is not there. */
> +			if (!dma_desc->cb_due) {
> +				list_add_tail(&dma_desc->cb_node,
> +							&tdc->cb_desc);
> +				dma_desc->cb_due = true;
> +			}
> +			dma_cookie_complete(&dma_desc->txd);
> +		}
> +	}
> +	tdc->dma_mode = DMA_MODE_NONE;
> +}
> +
> +static bool handle_continuous_head_request(struct tegra_dma_channel *tdc,
> +		struct tegra_dma_sg_req *last_sg_req, bool to_terminate)
> +{
> +	struct tegra_dma_sg_req *hsgreq = NULL;
> +
> +	if (list_empty(&tdc->pending_sg_req)) {
> +		dev_err(tdc2dev(tdc),
> +			"%s(): Dma is running without any req list\n",
> +			__func__);
> +		tegra_dma_stop(tdc);
> +		return false;
> +	}
> +
> +	/*
> +	 * Check that head req on list should be in flight.
> +	 * If it is not in flight then abort transfer as
> +	 * transfer looping can not continue.
> +	 */
> +	hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
> +	if (!hsgreq->configured) {
> +		tegra_dma_stop(tdc);
> +		dev_err(tdc2dev(tdc),
> +			"Error in dma transfer loop, aborting dma\n");
> +		tegra_dma_abort_all(tdc);
> +		return false;
> +	}
> +
> +	/* Configure next request in single buffer mode */
> +	if (!to_terminate && (tdc->dma_mode == DMA_MODE_CYCLE))
> +		tdc_configure_next_head_desc(tdc);
> +	return true;
> +}
> +
> +static void handle_once_dma_done(struct tegra_dma_channel *tdc,
> +	bool to_terminate)
> +{
> +	struct tegra_dma_sg_req *sgreq;
> +	struct tegra_dma_desc *dma_desc;
> +
> +	tdc->busy = false;
> +	sgreq = list_first_entry(&tdc->pending_sg_req, typeof(*sgreq), node);
> +	dma_desc = sgreq->dma_desc;
> +	dma_desc->bytes_transferred += sgreq->req_len;
> +
> +	list_del(&sgreq->node);
> +	if (sgreq->last_sg) {
> +		dma_cookie_complete(&dma_desc->txd);
> +		list_add_tail(&dma_desc->cb_node, &tdc->cb_desc);
> +		dma_desc->cb_due = true;
> +		tegra_dma_desc_done_locked(tdc, dma_desc);
> +	}
> +	list_add_tail(&sgreq->node, &tdc->free_sg_req);
> +
> +	/* Do not start dma if it is going to be terminate */
> +	if (to_terminate || list_empty(&tdc->pending_sg_req))
> +		return;
> +
> +	tdc_start_head_req(tdc);
> +	return;
> +}
> +
> +static void handle_cont_sngl_cycle_dma_done(struct tegra_dma_channel *tdc,
> +		bool to_terminate)
> +{
> +	struct tegra_dma_sg_req *sgreq;
> +	struct tegra_dma_desc *dma_desc;
> +	bool st;
> +
> +	sgreq = list_first_entry(&tdc->pending_sg_req, typeof(*sgreq), node);
> +	dma_desc = sgreq->dma_desc;
> +	dma_desc->bytes_transferred += sgreq->req_len;
> +
> +	/* Callback need to be call */
> +	list_add_tail(&dma_desc->cb_node, &tdc->cb_desc);
> +	dma_desc->cb_due = true;
> +
> +	/* If not last req then put at end of pending list */
> +	if (!list_is_last(&sgreq->node, &tdc->pending_sg_req)) {
> +		list_del(&sgreq->node);
> +		list_add_tail(&sgreq->node, &tdc->pending_sg_req);
> +		sgreq->configured = false;
> +		st = handle_continuous_head_request(tdc, sgreq, to_terminate);
> +		if (!st)
> +			dma_desc->dma_status = DMA_ERROR;
> +	}
> +	return;
> +}
> +
> +static void handle_cont_dbl_cycle_dma_done(struct tegra_dma_channel *tdc,
> +		bool to_terminate)
> +{
> +	struct tegra_dma_sg_req *hsgreq;
> +	struct tegra_dma_sg_req *hnsgreq;
> +	struct tegra_dma_desc *dma_desc;
> +
> +	hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
> +	dma_desc = hsgreq->dma_desc;
> +	dma_desc->bytes_transferred += hsgreq->req_len;
> +
> +	if (!hsgreq->half_done) {
> +		if (!list_is_last(hsgreq->node.next, &tdc->pending_sg_req) &&
> +			!to_terminate) {
> +			hnsgreq = list_first_entry(&hsgreq->node,
> +						typeof(*hnsgreq), node);
> +			tegra_dma_configure_for_next(tdc, hnsgreq);
> +		}
> +		hsgreq->half_done = true;
> +		list_add_tail(&dma_desc->cb_node, &tdc->cb_desc);
> +		dma_desc->cb_due = true;
> +	} else {
> +		hsgreq->half_done = false;
> +		list_add_tail(&dma_desc->cb_node, &tdc->cb_desc);
> +		dma_desc->cb_due = true;
> +
> +		/*
> +		 * If this is not last entry then put the req in end of
> +		 * list for next cycle.
> +		 */
> +		if (!list_is_last(hsgreq->node.next, &tdc->pending_sg_req)) {
> +			list_del(&hsgreq->node);
> +			list_add_tail(&hsgreq->node, &tdc->pending_sg_req);
> +			hsgreq->configured = false;
> +		}
> +	}
> +	return;
> +}
> +
> +static void tegra_dma_tasklet(unsigned long data)
> +{
> +	struct tegra_dma_channel *tdc = (struct tegra_dma_channel *)data;
> +	unsigned long flags;
> +	dma_async_tx_callback callback = NULL;
> +	void *callback_param = NULL;
> +	struct tegra_dma_desc *dma_desc;
> +	struct list_head cb_dma_desc_list;
> +
> +	INIT_LIST_HEAD(&cb_dma_desc_list);
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->cb_desc)) {
> +		spin_unlock_irqrestore(&tdc->lock, flags);
> +		return;
> +	}
> +	list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +
> +	while (!list_empty(&cb_dma_desc_list)) {
> +		dma_desc  = list_first_entry(&cb_dma_desc_list,
> +				typeof(*dma_desc), cb_node);
> +		list_del(&dma_desc->cb_node);
> +
> +		callback = dma_desc->txd.callback;
> +		callback_param = dma_desc->txd.callback_param;
> +		dma_desc->cb_due = false;
> +		if (callback)
> +			callback(callback_param);
> +	}
> +}
> +
> +static irqreturn_t tegra_dma_isr(int irq, void *dev_id)
> +{
> +	struct tegra_dma_channel *tdc = dev_id;
> +	unsigned long status;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +
> +	status = tdc_read(tdc, APB_DMA_CHAN_STA);
> +	if (status & STA_ISE_EOC) {
> +		tdc_write(tdc, APB_DMA_CHAN_STA, status);
> +		if (!list_empty(&tdc->cb_desc)) {
> +			dev_err(tdc2dev(tdc),
> +				"Int before tasklet handled, Stopping DMA %d\n",
> +				tdc->id);
> +			tegra_dma_stop(tdc);
> +			tdc->isr_handler(tdc, true);
> +			tegra_dma_abort_all(tdc);
> +			/* Schedule tasklet to make callback */
> +			tasklet_schedule(&tdc->tasklet);
> +			goto end;
> +		}
> +		tdc->isr_handler(tdc, false);
> +		tasklet_schedule(&tdc->tasklet);
> +	} else {
> +		dev_info(tdc2dev(tdc),
> +			"Interrupt is already handled %d status 0x%08lx\n",
> +			tdc->id, status);
> +	}
> +
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return IRQ_HANDLED;
> +}
> +
> +static dma_cookie_t tegra_dma_tx_submit(struct dma_async_tx_descriptor *txd)
> +{
> +	struct tegra_dma_desc *dma_desc = txd_to_tegra_dma_desc(txd);
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(txd->chan);
> +	unsigned long flags;
> +	dma_cookie_t cookie;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	dma_desc->dma_status = DMA_IN_PROGRESS;
> +	cookie = dma_cookie_assign(&dma_desc->txd);
> +	dma_desc->cookie = dma_desc->txd.cookie;
> +	list_splice_tail_init(&dma_desc->tx_list, &tdc->pending_sg_req);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return cookie;
> +}
> +
> +static void tegra_dma_issue_pending(struct dma_chan *dc)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->pending_sg_req)) {
> +		dev_err(tdc2dev(tdc),
> +			"No requests for channel %d\n", tdc->id);
> +		goto end;
> +	}
> +	if (!tdc->busy) {
> +		tdc_start_head_req(tdc);
> +
> +		/* Continuous single mode: Configure next req */
> +		if (DMA_MODE_CYCLE) {
> +			/*
> +			 * Wait for 1 burst time for configure dma for
> +			 * next transfer.
> +			 */
> +			udelay(DMA_BUSRT_COMPLETE_TIME);
> +			tdc_configure_next_head_desc(tdc);
> +		}
> +	}
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return;
> +}
> +
> +static void tegra_dma_terminate_all(struct dma_chan *dc)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	struct tegra_dma_sg_req *sgreq;
> +	struct tegra_dma_desc *dma_desc;
> +	unsigned long flags;
> +	unsigned long status;
> +	struct list_head new_list;
> +	dma_async_tx_callback callback = NULL;
> +	void *callback_param = NULL;
> +	struct list_head cb_dma_desc_list;
> +	bool was_busy;
> +
> +	INIT_LIST_HEAD(&new_list);
> +	INIT_LIST_HEAD(&cb_dma_desc_list);
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +	if (list_empty(&tdc->pending_sg_req)) {
> +		spin_unlock_irqrestore(&tdc->lock, flags);
> +		return;
> +	}
> +
> +	if (!tdc->busy) {
> +		list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
> +		goto skip_dma_stop;
> +	}
> +
> +	/* Pause dma before checking the queue status */
> +	tegra_dma_pause(tdc, true);
> +
> +	status = tdc_read(tdc, APB_DMA_CHAN_STA);
> +	if (status & STA_ISE_EOC) {
> +		dev_dbg(tdc2dev(tdc), "%s():handling isr\n", __func__);
> +		tdc->isr_handler(tdc, true);
> +		status = tdc_read(tdc, APB_DMA_CHAN_STA);
> +	}
> +	list_splice_init(&tdc->cb_desc, &cb_dma_desc_list);
> +
> +	was_busy = tdc->busy;
> +	tegra_dma_stop(tdc);
> +	if (!list_empty(&tdc->pending_sg_req) && was_busy) {
> +		sgreq = list_first_entry(&tdc->pending_sg_req,
> +					typeof(*sgreq), node);
> +		sgreq->dma_desc->bytes_transferred +=
> +				get_current_xferred_count(tdc, sgreq, status);
> +	}
> +	tegra_dma_resume(tdc);
> +
> +skip_dma_stop:
> +	tegra_dma_abort_all(tdc);
> +	/* Ignore callbacks pending list */
> +	INIT_LIST_HEAD(&tdc->cb_desc);
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +
> +	/* Call callbacks if was pending before aborting requests */
> +	while (!list_empty(&cb_dma_desc_list)) {
> +		dma_desc  = list_first_entry(&cb_dma_desc_list,
> +				typeof(*dma_desc), cb_node);
> +		list_del(&dma_desc->cb_node);
> +		callback = dma_desc->txd.callback;
> +		callback_param = dma_desc->txd.callback_param;
> +		if (callback)
> +			callback(callback_param);
> +	}
> +}
> +
> +static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
> +	dma_cookie_t cookie, struct dma_tx_state *txstate)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	struct tegra_dma_desc *dma_desc;
> +	struct tegra_dma_sg_req *sg_req;
> +	enum dma_status ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&tdc->lock, flags);
> +
> +	ret = dma_cookie_status(dc, cookie, txstate);
> +	if (ret != DMA_SUCCESS)
> +		goto check_pending_q;
> +
> +	if (list_empty(&tdc->wait_ack_dma_desc))
> +		goto check_pending_q;
> +
> +	/* Check on wait_ack desc status */
> +	list_for_each_entry(dma_desc, &tdc->wait_ack_dma_desc, node) {
> +		if (dma_desc->cookie == cookie) {
> +			dma_set_residue(txstate,
> +				dma_desc->bytes_requested -
> +					dma_desc->bytes_transferred);
> +			ret = dma_desc->dma_status;
> +			goto end;
> +		}
> +	}
> +
> +check_pending_q:
> +	if (list_empty(&tdc->pending_sg_req))
> +		goto end;
> +
> +	/* May be this is in head list of pending list */
> +	list_for_each_entry(sg_req, &tdc->pending_sg_req, node) {
> +		dma_desc = sg_req->dma_desc;
> +		if (dma_desc->txd.cookie == cookie) {
> +			dma_set_residue(txstate,
> +				dma_desc->bytes_requested -
> +				dma_desc->bytes_transferred);
> +			ret = dma_desc->dma_status;
> +			goto end;
> +		}
> +	}
> +	dev_info(tdc2dev(tdc), "%s(): cookie does not found\n", __func__);
> +end:
> +	spin_unlock_irqrestore(&tdc->lock, flags);
> +	return ret;
> +}
> +
> +static int tegra_dma_device_control(struct dma_chan *dc, enum dma_ctrl_cmd cmd,
> +			unsigned long arg)
> +{
> +	switch (cmd) {
> +	case DMA_SLAVE_CONFIG:
> +		return tegra_dma_slave_config(dc,
> +				(struct dma_slave_config *)arg);
> +
> +	case DMA_TERMINATE_ALL:
> +		tegra_dma_terminate_all(dc);
> +		return 0;
> +	default:
> +		break;
> +	}
> +
> +	return -ENXIO;
> +}
> +
> +static inline int get_bus_width(enum dma_slave_buswidth slave_bw)
> +{
> +	BUG_ON(!slave_bw);
> +	switch (slave_bw) {
> +	case DMA_SLAVE_BUSWIDTH_1_BYTE:
> +		return APB_SEQ_BUS_WIDTH_8;
> +	case DMA_SLAVE_BUSWIDTH_2_BYTES:
> +		return APB_SEQ_BUS_WIDTH_16;
> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
> +		return APB_SEQ_BUS_WIDTH_32;
> +	case DMA_SLAVE_BUSWIDTH_8_BYTES:
> +		return APB_SEQ_BUS_WIDTH_64;
> +	default:
> +		BUG();
> +	}
> +}
> +
> +static inline int get_burst_size(struct tegra_dma_channel *tdc, int len)
> +{
> +	switch (tdc->dma_slave.burst_size) {
> +	case TEGRA_DMA_BURST_1:
> +		return AHB_SEQ_BURST_1;
> +	case TEGRA_DMA_BURST_4:
> +		return AHB_SEQ_BURST_4;
> +	case TEGRA_DMA_BURST_8:
> +		return AHB_SEQ_BURST_8;
> +	case TEGRA_DMA_AUTO:
> +		if (len & 0xF)
> +			return AHB_SEQ_BURST_1;
> +		else if ((len >> 4) & 0x1)
> +			return AHB_SEQ_BURST_4;
> +		else
> +			return AHB_SEQ_BURST_8;
> +	}
> +	WARN(1, KERN_WARNING "Invalid burst option\n");
> +	return AHB_SEQ_BURST_1;
> +}
> +
> +static bool init_dma_mode(struct tegra_dma_channel *tdc,
> +		enum dma_transfer_mode new_mode)
> +{
> +	if (tdc->dma_mode == DMA_MODE_NONE) {
> +		tdc->dma_mode = new_mode;
> +		switch (new_mode) {
> +		case DMA_MODE_ONCE:
> +			tdc->isr_handler = handle_once_dma_done;
> +			break;
> +		case DMA_MODE_CYCLE:
> +			tdc->isr_handler = handle_cont_sngl_cycle_dma_done;
> +			break;
> +		case DMA_MODE_CYCLE_HALF_NOTIFY:
> +			tdc->isr_handler = handle_cont_dbl_cycle_dma_done;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else {
> +		if (new_mode != tdc->dma_mode)
> +			return false;
> +	}
> +	return true;
> +}
> +
> +static struct dma_async_tx_descriptor *tegra_dma_prep_slave_sg(
> +	struct dma_chan *dc, struct scatterlist *sgl, unsigned int sg_len,
> +	enum dma_transfer_direction direction, unsigned long flags,
> +	void *context)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	struct tegra_dma_desc *dma_desc;
> +	unsigned int	    i;
> +	struct scatterlist      *sg;
> +	unsigned long csr, ahb_seq, apb_ptr, apb_seq;
> +	struct list_head req_list;
> +	struct tegra_dma_sg_req  *sg_req = NULL;
> +
> +	if (!tdc->config_init) {
> +		dev_err(tdc2dev(tdc), "dma channel is not configured\n");
> +		return NULL;
> +	}
> +	if (sg_len < 1) {
> +		dev_err(tdc2dev(tdc), "Invalid segment length %d\n", sg_len);
> +		return NULL;
> +	}
> +
> +	INIT_LIST_HEAD(&req_list);
> +
> +	ahb_seq = AHB_SEQ_INTR_ENB;
> +	ahb_seq |= AHB_SEQ_WRAP_NONE << AHB_SEQ_WRAP_SHIFT;
> +	ahb_seq |= AHB_SEQ_BUS_WIDTH_32;
> +
> +	csr = CSR_ONCE | CSR_FLOW;
> +	csr |= tdc->dma_slave.dma_req_id << CSR_REQ_SEL_SHIFT;
> +	if (flags & DMA_PREP_INTERRUPT)
> +		csr |= CSR_IE_EOC;
> +
> +	apb_seq = APB_SEQ_WRAP_WORD_1;
> +
> +	switch (direction) {
> +	case DMA_MEM_TO_DEV:
> +		apb_ptr = tdc->dma_sconfig.dst_addr;
> +		apb_seq |= get_bus_width(tdc->dma_sconfig.dst_addr_width);
> +		csr |= CSR_DIR;
> +		break;
> +
> +	case DMA_DEV_TO_MEM:
> +		apb_ptr = tdc->dma_sconfig.src_addr;
> +		apb_seq |= get_bus_width(tdc->dma_sconfig.src_addr_width);
> +		break;
you dont support DMA_MEM_TO_DEV?

> +	default:
> +		dev_err(tdc2dev(tdc), "Dma direction is not supported\n");
> +		return NULL;
> +	}
> +
> +	dma_desc = tegra_dma_desc_get(tdc);
> +	if (!dma_desc) {
> +		dev_err(tdc2dev(tdc), "Dma descriptors not available\n");
> +		goto fail;
> +	}
> +	INIT_LIST_HEAD(&dma_desc->tx_list);
> +	INIT_LIST_HEAD(&dma_desc->cb_node);
> +	dma_desc->bytes_requested = 0;
> +	dma_desc->bytes_transferred = 0;
> +	dma_desc->dma_status = DMA_IN_PROGRESS;
> +
> +	/* Make transfer requests */
> +	for_each_sg(sgl, sg, sg_len, i) {
> +		u32 len, mem;
> +
> +		mem = sg_phys(sg);
> +		len = sg_dma_len(sg);
> +
> +		if ((len & 3) || (mem & 3) ||
> +				(len > tdc->tdma->chip_data.max_dma_count)) {
> +			dev_err(tdc2dev(tdc),
> +				"Dma length/memory address is not correct\n");
> +			goto fail;
> +		}
> +
> +		sg_req = tegra_dma_sg_req_get(tdc);
> +		if (!sg_req) {
> +			dev_err(tdc2dev(tdc), "Dma sg-req not available\n");
> +			goto fail;
> +		}
> +
> +		ahb_seq |= get_burst_size(tdc, len);
> +		dma_desc->bytes_requested += len;
> +
> +		sg_req->ch_regs.apb_ptr = apb_ptr;
> +		sg_req->ch_regs.ahb_ptr = mem;
> +		sg_req->ch_regs.csr = csr | ((len - 4) & 0xFFFC);
> +		sg_req->ch_regs.apb_seq = apb_seq;
> +		sg_req->ch_regs.ahb_seq = ahb_seq;
> +		sg_req->configured = false;
> +		sg_req->last_sg = false;
> +		sg_req->dma_desc = dma_desc;
> +		sg_req->req_len = len;
> +
> +		list_add_tail(&sg_req->node, &dma_desc->tx_list);
> +	}
> +	sg_req->last_sg = true;
> +	dma_desc->ack_reqd = (flags & DMA_CTRL_ACK) ? false : true;
> +	if (dma_desc->ack_reqd)
> +		dma_desc->txd.flags = DMA_CTRL_ACK;
> +
> +	/*
> +	 * Make sure that mode should not be conflicting with currently
> +	 * configured mode.
> +	 */
> +	if (!init_dma_mode(tdc, DMA_MODE_ONCE)) {
> +		dev_err(tdc2dev(tdc), "Conflict in dma modes\n");
> +		goto fail;
> +	}
> +
> +	return &dma_desc->txd;
> +
> +fail:
> +	tegra_dma_desc_put(tdc, dma_desc);
> +	return NULL;
> +}
> +
> +struct dma_async_tx_descriptor *tegra_dma_prep_dma_cyclic(
> +	struct dma_chan *dc, dma_addr_t buf_addr, size_t buf_len,
> +	size_t period_len, enum dma_transfer_direction direction,
> +	void *context)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	struct tegra_dma_desc *dma_desc = NULL;
> +	struct tegra_dma_sg_req  *sg_req = NULL;
> +	unsigned long csr, ahb_seq, apb_ptr, apb_seq;
> +	int len;
> +	bool half_buffer_notify;
> +	enum dma_transfer_mode new_mode;
> +	size_t remain_len;
> +	dma_addr_t mem = buf_addr;
> +
> +	if (!buf_len) {
> +		dev_err(tdc2dev(tdc),
> +			"Buffer length is invalid len %d\n", buf_len);
> +	}
> +
> +	if (!tdc->config_init) {
> +		dev_err(tdc2dev(tdc),
> +			"DMA is not configured for slave\n");
> +		return NULL;
> +	}
> +
> +	if (tdc->busy) {
> +		dev_err(tdc2dev(tdc),
> +		 "DMA is already started, can not accept any more requests\n");
> +		return NULL;
> +	}
> +
> +	/*
> +	 * We only support cyclic transfer when buf_len is multiple of
> +	 * period_len.
> +	 * With period of buf_len, it will set dma mode DMA_MODE_CYCLE
> +	 * with one request.
> +	 * With period of buf_len/2, it will set dma mode
> +	 * DMA_MODE_CYCLE_HALF_NOTIFY with one requsts.
> +	 * Othercase, the transfer is broken in smaller requests of size
> +	 * of period_len and the transfer continues forever in cyclic way
> +	 * dma mode of DMA_MODE_CYCLE.
> +	 * If period_len is zero then assume dma mode DMA_MODE_CYCLE.
> +	 * We also allow to take more number of requests till dma is
> +	 * not started. The driver will loop over all requests.
> +	 * Once dma is started then new requests can be queued only after
> +	 * terminating the dma.
> +	 */
> +	if (!period_len)
> +		period_len = buf_len;
i am not sure about this assignment here. Why should period length be
ZERO?

> +
> +	if (buf_len % period_len) {
> +		dev_err(tdc2dev(tdc),
> +		   "buf_len %d should be multiple of period_len %d\n",
> +			buf_len, period_len);
> +		return NULL;
> +	}
I am assuming you are also putting this as a constraint in sound driver.

> +
> +	half_buffer_notify = (buf_len == (2 * period_len)) ? true : false;
> +	len = (half_buffer_notify) ? buf_len / 2 : period_len;
> +	if ((len & 3) || (buf_addr & 3) ||
> +			(len > tdc->tdma->chip_data.max_dma_count)) {
> +		dev_err(tdc2dev(tdc),
> +			"Dma length/memory address is not correct\n");
not supported would be apt
> +		return NULL;
> +	}
> +
> +	ahb_seq = AHB_SEQ_INTR_ENB;
> +	ahb_seq |= AHB_SEQ_WRAP_NONE << AHB_SEQ_WRAP_SHIFT;
> +	ahb_seq |= AHB_SEQ_BUS_WIDTH_32;
> +	if (half_buffer_notify)
> +		ahb_seq |= AHB_SEQ_DBL_BUF;
> +
> +	csr = CSR_FLOW | CSR_IE_EOC;
> +	csr |= tdc->dma_slave.dma_req_id << CSR_REQ_SEL_SHIFT;
> +
> +	apb_seq = APB_SEQ_WRAP_WORD_1;
> +
> +	switch (direction) {
> +	case DMA_MEM_TO_DEV:
> +		apb_ptr = tdc->dma_sconfig.dst_addr;
> +		apb_seq |= get_bus_width(tdc->dma_sconfig.dst_addr_width);
> +		csr |= CSR_DIR;
> +		break;
> +
> +	case DMA_DEV_TO_MEM:
> +		apb_ptr = tdc->dma_sconfig.src_addr;
> +		apb_seq |= get_bus_width(tdc->dma_sconfig.src_addr_width);
> +		break;
> +	default:
> +		dev_err(tdc2dev(tdc), "Dma direction is not supported\n");
> +		return NULL;
> +	}
> +
> +	dma_desc = tegra_dma_desc_get(tdc);
> +	if (!dma_desc) {
> +		dev_err(tdc2dev(tdc), "not enough descriptors available\n");
> +		goto fail;
> +	}
> +	INIT_LIST_HEAD(&dma_desc->tx_list);
> +
> +	dma_desc->bytes_transferred = 0;
> +	dma_desc->bytes_requested = buf_len;
> +	remain_len = (half_buffer_notify) ? len : buf_len;
> +	ahb_seq |= get_burst_size(tdc, len);
> +
> +	while (remain_len) {
> +		sg_req = tegra_dma_sg_req_get(tdc);
> +		if (!sg_req) {
> +			dev_err(tdc2dev(tdc), "Dma sg-req not available\n");
> +			goto fail;
> +		}
> +
> +		ahb_seq |= get_burst_size(tdc, len);
> +		sg_req->ch_regs.apb_ptr = apb_ptr;
> +		sg_req->ch_regs.ahb_ptr = mem;
> +		sg_req->ch_regs.csr = csr | ((len - 4) & 0xFFFC);
> +		sg_req->ch_regs.apb_seq = apb_seq;
> +		sg_req->ch_regs.ahb_seq = ahb_seq;
> +		sg_req->configured = false;
> +		sg_req->half_done = false;
> +		sg_req->last_sg = false;
> +		sg_req->dma_desc = dma_desc;
> +		sg_req->req_len = len;
> +
> +		list_add_tail(&sg_req->node, &dma_desc->tx_list);
> +		remain_len -= len;
> +		mem += len;
> +	}
> +	sg_req->last_sg = true;
> +	dma_desc->ack_reqd = true;
> +	dma_desc->txd.flags = DMA_CTRL_ACK;
> +
> +	/*
> +	 * We can not change the dma mode once it is initialized
> +	 * until all desc are terminated.
> +	 */
> +	new_mode = (half_buffer_notify) ?
> +			DMA_MODE_CYCLE_HALF_NOTIFY : DMA_MODE_CYCLE;
> +	if (!init_dma_mode(tdc, new_mode)) {
> +		dev_err(tdc2dev(tdc), "Conflict in dma modes\n");
> +		goto fail;
> +	}
> +
> +	return &dma_desc->txd;
> +
> +fail:
> +	tegra_dma_desc_put(tdc, dma_desc);
> +	return NULL;
> +}
> +
> +static int tegra_dma_alloc_chan_resources(struct dma_chan *dc)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	int total_desc;
> +
> +	total_desc = allocate_tegra_desc(tdc, DMA_NR_DESCS_PER_CHANNEL,
> +				DMA_NR_DESCS_PER_CHANNEL * DMA_NR_REQ_PER_DESC);
> +	dma_cookie_init(&tdc->dma_chan);
> +	dev_dbg(tdc2dev(tdc),
> +		"%s(): allocated %d descriptors\n", __func__, total_desc);
> +	tdc->config_init = false;
> +	return total_desc;
> +}
> +
> +static void tegra_dma_free_chan_resources(struct dma_chan *dc)
> +{
> +	struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> +	struct tegra_dma_chan_mem_alloc *mptr;
> +
> +	dev_dbg(tdc2dev(tdc),
> +		"%s(): channel %d and desc freeing %d\n",
> +		__func__, tdc->id, tdc->descs_allocated);
> +	if (tdc->busy)
> +		tegra_dma_terminate_all(dc);
> +
> +	INIT_LIST_HEAD(&tdc->pending_sg_req);
> +	INIT_LIST_HEAD(&tdc->free_sg_req);
> +	INIT_LIST_HEAD(&tdc->alloc_ptr_list);
> +	INIT_LIST_HEAD(&tdc->free_dma_desc);
> +	INIT_LIST_HEAD(&tdc->wait_ack_dma_desc);
> +	INIT_LIST_HEAD(&tdc->cb_desc);
> +	tdc->descs_allocated = 0;
> +	tdc->config_init = false;
> +	while (!list_empty(&tdc->alloc_ptr_list)) {
> +		mptr = list_first_entry(&tdc->alloc_ptr_list,
> +					typeof(*mptr), node);
> +		list_del(&mptr->node);
> +		kfree(mptr);
> +	}
> +}
> +
> +/* Tegra20 specific dma controller information */
> +static struct tegra_dma_chip_data tegra20_chip_data = {
> +	.nr_channels		= 16,
> +	.max_dma_count		= 1024UL * 64,
> +};
> +
> +/* Tegra30 specific dma controller information */
> +static struct tegra_dma_chip_data tegra30_chip_data = {
> +	.nr_channels		= 32,
> +	.max_dma_count		= 1024UL * 64,
> +};
> +
> +#if defined(CONFIG_OF)
> +/* Match table for of_platform binding */
> +static const struct of_device_id tegra_dma_of_match[] __devinitconst = {
> +	{ .compatible = "nvidia,tegra30-apbdma", .data = &tegra30_chip_data, },
> +	{ .compatible = "nvidia,tegra20-apbdma", .data = &tegra20_chip_data, },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, tegra_dma_of_match);
> +#else
> +#define tegra_dma_of_match NULL
> +#endif
> +
> +static struct platform_device_id dma_id_table[] = {
> +	{.name = "tegra30-apbdma", .driver_data = (ulong)&tegra30_chip_data, },
> +	{.name = "tegra20-apbdma", .driver_data = (ulong)&tegra20_chip_data, },
> +	{},
> +};
> +
> +static bool tdma_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +	unsigned int chan_reg;
> +
> +	if (reg < DMA_CHANNEL_BASE_ADDRESS_OFFSET)
> +		return false;
> +
> +	chan_reg = (reg - DMA_CHANNEL_BASE_ADDRESS_OFFSET) %
> +					DMA_CHANNEL_REGISTER_SIZE;
> +	switch (chan_reg) {
> +	case APB_DMA_CHAN_STA:
> +	case APB_DMA_CHAN_CSR:
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static bool tdma_wr_rd_reg(struct device *dev, unsigned int reg)
> +{
> +	unsigned int chan_reg;
> +
> +	/* Dma base registers */
> +	if (reg < DMA_CHANNEL_BASE_ADDRESS_OFFSET) {
> +		switch (reg) {
> +		case APB_DMA_GEN:
> +		case APB_DMA_CNTRL:
> +		case APB_DMA_IRQ_MASK:
> +		case APB_DMA_IRQ_MASK_SET:
> +			return true;
> +		default:
> +			return false;
> +		}
> +	}
> +
> +	/* Channel registers */
> +	chan_reg = (reg - DMA_CHANNEL_BASE_ADDRESS_OFFSET) %
> +						DMA_CHANNEL_REGISTER_SIZE;
> +	switch (chan_reg) {
> +	case APB_DMA_CHAN_CSR:
> +	case APB_DMA_CHAN_STA:
> +	case APB_DMA_CHAN_APB_SEQ:
> +	case APB_DMA_CHAN_APB_PTR:
> +	case APB_DMA_CHAN_AHB_SEQ:
> +	case APB_DMA_CHAN_AHB_PTR:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +static struct regmap_config tdma_regmap_config = {
> +	.name = "tegra-apbdma",
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
> +	.volatile_reg = tdma_volatile_reg,
> +	.writeable_reg = tdma_wr_rd_reg,
> +	.readable_reg = tdma_wr_rd_reg,
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int __devinit tegra_dma_probe(struct platform_device *pdev)
> +{
> +	struct resource	*res;
> +	struct tegra_dma *tdma;
> +	size_t	size;
> +	int ret;
> +	int i;
> +	struct tegra_dma_chip_data *chip_data = NULL;
> +
> +#if defined(CONFIG_OF)
> +	{
> +		const struct of_device_id *match;
> +		match = of_match_device(of_match_ptr(tegra_dma_of_match),
> +				&pdev->dev);
> +		if (match)
> +			chip_data = match->data;
> +	}
> +#else
> +	chip_data = (struct tegra_dma_chip_data *)pdev->id_entry->driver_data;
> +#endif
> +	if (!chip_data) {
> +		dev_err(&pdev->dev, "Error: Chip data is not valid\n");
> +		return -EINVAL;
> +	}
> +
> +	size = sizeof(struct tegra_dma);
> +	size += chip_data->nr_channels * sizeof(struct tegra_dma_channel);
> +	tdma = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
> +	if (!tdma) {
> +		dev_err(&pdev->dev, "Error: memory allocation failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	tdma->dev = &pdev->dev;
> +	memcpy(&tdma->chip_data, chip_data, sizeof(*chip_data));
> +	platform_set_drvdata(pdev, tdma);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "no mem resource for DMA\n");
> +		return -EINVAL;
> +	}
> +
> +	tdma->base_addr = devm_request_and_ioremap(&pdev->dev, res);
> +	if (!tdma->base_addr) {
> +		dev_err(&pdev->dev,
> +			"Cannot request memregion/iomap dma address\n");
> +		return -EADDRNOTAVAIL;
> +	}
> +
> +	/* Dma base register */
> +	tdma_regmap_config.max_register = resource_size(res);
> +	tdma->regmap_dma = devm_regmap_init_mmio(&pdev->dev, tdma->base_addr,
> +			(const struct regmap_config *)&tdma_regmap_config);
> +	if (IS_ERR(tdma->regmap_dma)) {
> +		dev_err(&pdev->dev, "regmap init failed\n");
> +		return PTR_ERR(tdma->regmap_dma);
> +	}
> +
> +	/* Clock */
> +	tdma->dma_clk = clk_get(&pdev->dev, "clk");
> +	if (IS_ERR(tdma->dma_clk)) {
> +		dev_err(&pdev->dev, "Error: Missing controller clock");
> +		return PTR_ERR(tdma->dma_clk);
> +	}
> +
> +	spin_lock_init(&tdma->global_lock);
> +
> +	INIT_LIST_HEAD(&tdma->dma_dev.channels);
> +	for (i = 0; i < chip_data->nr_channels; i++) {
> +		struct tegra_dma_channel *tdc = &tdma->channels[i];
> +		char irq_name[30];
> +
> +		tdc->chan_base_offset = DMA_CHANNEL_BASE_ADDRESS_OFFSET +
> +						i * DMA_CHANNEL_REGISTER_SIZE;
> +
> +		res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> +		if (!res) {
> +			ret = -EINVAL;
> +			dev_err(&pdev->dev,
> +				"Irq resource not found for channel %d\n", i);
> +			goto err_irq;
> +		}
> +		tdc->irq = res->start;
> +		snprintf(irq_name, sizeof(irq_name), "tegra_dma_chan.%d", i);
> +		ret = devm_request_irq(&pdev->dev, tdc->irq,
> +				tegra_dma_isr, 0, irq_name, tdc);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"request_irq failed for channel %d error %d\n",
> +				i, ret);
> +			goto err_irq;
> +		}
> +
> +		tdc->dma_chan.device = &tdma->dma_dev;
> +		dma_cookie_init(&tdc->dma_chan);
> +		list_add_tail(&tdc->dma_chan.device_node,
> +				&tdma->dma_dev.channels);
> +		tdc->tdma = tdma;
> +		tdc->id = i;
> +
> +		tasklet_init(&tdc->tasklet,
> +				tegra_dma_tasklet, (unsigned long)tdc);
> +		spin_lock_init(&tdc->lock);
> +
> +		INIT_LIST_HEAD(&tdc->pending_sg_req);
> +		INIT_LIST_HEAD(&tdc->free_sg_req);
> +		INIT_LIST_HEAD(&tdc->alloc_ptr_list);
> +		INIT_LIST_HEAD(&tdc->free_dma_desc);
> +		INIT_LIST_HEAD(&tdc->wait_ack_dma_desc);
> +		INIT_LIST_HEAD(&tdc->cb_desc);
> +	}
> +
> +	dma_cap_set(DMA_SLAVE, tdma->dma_dev.cap_mask);
> +	dma_cap_set(DMA_PRIVATE, tdma->dma_dev.cap_mask);
> +	tdma->dma_dev.dev = &pdev->dev;
> +	tdma->dma_dev.device_alloc_chan_resources =
> +					tegra_dma_alloc_chan_resources;
> +	tdma->dma_dev.device_free_chan_resources =
> +					tegra_dma_free_chan_resources;
> +	tdma->dma_dev.device_prep_slave_sg = tegra_dma_prep_slave_sg;
> +	tdma->dma_dev.device_prep_dma_cyclic = tegra_dma_prep_dma_cyclic;
> +	tdma->dma_dev.device_control = tegra_dma_device_control;
> +	tdma->dma_dev.device_tx_status = tegra_dma_tx_status;
> +	tdma->dma_dev.device_issue_pending = tegra_dma_issue_pending;
> +
> +	ret = dma_async_device_register(&tdma->dma_dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev,
> +			"Error in registering Tegra APB DMA driver %d\n", ret);
> +		goto err_irq;
> +	}
> +	dev_info(&pdev->dev, "Tegra APB DMA Controller, %d channels\n",
> +			chip_data->nr_channels);
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +
> +	/* Reset dma controller */
> +	tegra_periph_reset_assert(tdma->dma_clk);
> +	tegra_periph_reset_deassert(tdma->dma_clk);
> +
> +	/* Enable global dma registers */
> +	tdma_write(tdma, APB_DMA_GEN, GEN_ENABLE);
> +	tdma_write(tdma, APB_DMA_CNTRL, 0);
> +	tdma_write(tdma, APB_DMA_IRQ_MASK_SET, 0xFFFFFFFFul);
> +	return 0;
> +
> +err_irq:
> +	while (--i >= 0) {
> +		struct tegra_dma_channel *tdc = &tdma->channels[i];
> +		tasklet_kill(&tdc->tasklet);
> +	}
> +
> +	pm_runtime_disable(&pdev->dev);
> +	clk_put(tdma->dma_clk);
> +	return ret;
> +}
> +
> +static int __exit tegra_dma_remove(struct platform_device *pdev)
> +{
> +	struct tegra_dma *tdma = platform_get_drvdata(pdev);
> +	int i;
> +	struct tegra_dma_channel *tdc;
> +
> +	dma_async_device_unregister(&tdma->dma_dev);
> +
> +	for (i = 0; i < tdma->chip_data.nr_channels; ++i) {
> +		tdc = &tdma->channels[i];
> +		tasklet_kill(&tdc->tasklet);
> +	}
> +
> +	pm_runtime_disable(&pdev->dev);
> +	clk_put(tdma->dma_clk);
> +
> +	return 0;
> +}
> +
> +static int tegra_dma_runtime_idle(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct tegra_dma *tdma = platform_get_drvdata(pdev);
> +
> +	regcache_cache_only(tdma->regmap_dma, true);
> +	clk_disable(tdma->dma_clk);
> +	return 0;
> +}
> +
> +static int tegra_dma_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct tegra_dma *tdma = platform_get_drvdata(pdev);
> +	clk_enable(tdma->dma_clk);
> +	regcache_cache_only(tdma->regmap_dma, false);
> +	return 0;
> +}
> +
> +static int tegra_dma_suspend_noirq(struct device *dev)
> +{
> +	tegra_dma_runtime_idle(dev);
> +	return 0;
> +}
> +
> +static int tegra_dma_resume_noirq(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct tegra_dma *tdma = platform_get_drvdata(pdev);
> +
> +	tegra_dma_runtime_resume(dev);
> +
> +	/*
> +	 * After resume, dma register will not be sync with the cached value.
> +	 * Making sure they are in sync.
> +	 */
> +	regcache_mark_dirty(tdma->regmap_dma);
> +	regcache_sync(tdma->regmap_dma);
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops tegra_dma_dev_pm_ops = {
> +	.suspend_noirq = tegra_dma_suspend_noirq,
> +	.resume_noirq = tegra_dma_resume_noirq,
> +	.runtime_idle = tegra_dma_runtime_idle,
> +	.runtime_resume = tegra_dma_runtime_resume,
> +};
> +
> +static struct platform_driver tegra_dmac_driver = {
> +	.driver = {
> +		.name	= "tegra-apbdma",
> +		.owner = THIS_MODULE,
> +		.pm	= &tegra_dma_dev_pm_ops,
> +		.of_match_table = tegra_dma_of_match,
> +	},
> +	.probe		= tegra_dma_probe,
> +	.remove		= __exit_p(tegra_dma_remove),
> +	.id_table	= dma_id_table,
> +};
> +
> +static int __init tegra_dmac_init(void)
> +{
> +	return platform_driver_register(&tegra_dmac_driver);
> +}
> +arch_initcall_sync(tegra_dmac_init);
> +
> +static void __exit tegra_dmac_exit(void)
> +{
> +	platform_driver_unregister(&tegra_dmac_driver);
> +}
> +module_exit(tegra_dmac_exit);
> +
> +MODULE_DESCRIPTION("NVIDIA Tegra DMA Controller driver");
> +MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:tegra-apbdma");
> diff --git a/include/linux/tegra_dma.h b/include/linux/tegra_dma.h
> new file mode 100644
> index 0000000..e94aac3
> --- /dev/null
> +++ b/include/linux/tegra_dma.h
> @@ -0,0 +1,95 @@
> +/*
> + * Dma driver for Nvidia's Tegra dma controller.
> + *
> + * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef LINUX_TEGRA_DMA_H
> +#define LINUX_TEGRA_DMA_H
> +
> +/*
> + * tegra_dma_burst_size: Burst size of dma.
> + * @TEGRA_DMA_AUTO: Based on transfer size, select the burst size.
> + *	    If it is multple of 32 bytes then burst size will be 32 bytes else
> + *	    If it is multiple of 16 bytes then burst size will be 16 bytes else
> + *	    If it is multiple of 4 bytes then burst size will be 4 bytes.
> + * @TEGRA_DMA_BURST_1: Burst size is 1 word/4 bytes.
> + * @TEGRA_DMA_BURST_4: Burst size is 4 word/16 bytes.
> + * @TEGRA_DMA_BURST_8: Burst size is 8 words/32 bytes.
> + */
> +enum tegra_dma_burst_size {
> +	TEGRA_DMA_AUTO,
> +	TEGRA_DMA_BURST_1,
> +	TEGRA_DMA_BURST_4,
> +	TEGRA_DMA_BURST_8,
> +};
why should this be global, clinet should pass them as defined in
dmaengine.h
> +
> +/* Dma slave requestor */
> +enum tegra_dma_requestor {
> +	TEGRA_DMA_REQ_SEL_CNTR,
> +	TEGRA_DMA_REQ_SEL_I2S_2,
> +	TEGRA_DMA_REQ_SEL_APBIF_CH0 = TEGRA_DMA_REQ_SEL_I2S_2,
> +	TEGRA_DMA_REQ_SEL_I2S_1,
> +	TEGRA_DMA_REQ_SEL_APBIF_CH1 = TEGRA_DMA_REQ_SEL_I2S_1,
> +	TEGRA_DMA_REQ_SEL_SPD_I,
> +	TEGRA_DMA_REQ_SEL_APBIF_CH2 = TEGRA_DMA_REQ_SEL_SPD_I,
> +	TEGRA_DMA_REQ_SEL_UI_I,
> +	TEGRA_DMA_REQ_SEL_APBIF_CH3 = TEGRA_DMA_REQ_SEL_UI_I,
> +	TEGRA_DMA_REQ_SEL_MIPI,
> +	TEGRA_DMA_REQ_SEL_I2S2_2,
> +	TEGRA_DMA_REQ_SEL_I2S2_1,
> +	TEGRA_DMA_REQ_SEL_UARTA,
> +	TEGRA_DMA_REQ_SEL_UARTB,
> +	TEGRA_DMA_REQ_SEL_UARTC,
> +	TEGRA_DMA_REQ_SEL_SPI,
> +	TEGRA_DMA_REQ_SEL_DTV = TEGRA_DMA_REQ_SEL_SPI,
> +	TEGRA_DMA_REQ_SEL_AC97,
> +	TEGRA_DMA_REQ_SEL_ACMODEM,
> +	TEGRA_DMA_REQ_SEL_SL4B,
> +	TEGRA_DMA_REQ_SEL_SL2B1,
> +	TEGRA_DMA_REQ_SEL_SL2B2,
> +	TEGRA_DMA_REQ_SEL_SL2B3,
> +	TEGRA_DMA_REQ_SEL_SL2B4,
> +	TEGRA_DMA_REQ_SEL_UARTD,
> +	TEGRA_DMA_REQ_SEL_UARTE,
> +	TEGRA_DMA_REQ_SEL_I2C,
> +	TEGRA_DMA_REQ_SEL_I2C2,
> +	TEGRA_DMA_REQ_SEL_I2C3,
> +	TEGRA_DMA_REQ_SEL_DVC_I2C,
> +	TEGRA_DMA_REQ_SEL_OWR,
> +	TEGRA_DMA_REQ_SEL_I2C4,
> +	TEGRA_DMA_REQ_SEL_SL2B5,
> +	TEGRA_DMA_REQ_SEL_SL2B6,
> +	TEGRA_DMA_REQ_SEL_INVALID,
> +};
> +
> +/**
> + * struct tegra_dma_slave - Controller-specific information about a slave
> + * After requesting a dma channel by client through interface
> + * dma_request_channel(), the chan->private should be initialized with
> + * this structure.
> + * Once the chan->private is got initialized with proper client data,
> + * client need to call dmaengine_slave_config() to configure dma channel.
> + *
> + * @dma_dev: required DMA master client device.
> + * @dm_req_id: Peripheral dma requestor ID.
> + */
> +struct tegra_dma_slave {
> +	struct device			*client_dev;
> +	enum tegra_dma_requestor	dma_req_id;
> +	enum tegra_dma_burst_size	burst_size;
pls remove
> +};
> +
> +#endif /* LINUX_TEGRA_DMA_H */

Please also update the driver to use the cookie helpers in
drivers/dma/dmaengine.h

-- 
~Vinod

