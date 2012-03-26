Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2CZHEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:04:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:55228 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab2CZHEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="123211233"
Subject: Re: [PATCH v5 2/2] DMAEngine: Add DMAEngine driver based on old
 MSM ADM DMA APIs
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: tsoni@codeaurora.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.or, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1332426216-25273-1-git-send-email-kumarrav@codeaurora.org>
References: <1332426216-25273-1-git-send-email-kumarrav@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 12:37:29 +0530
Message-ID: <1332745649.19804.69.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 19:53 +0530, Ravi Kumar V wrote:
> Add DMAEngine based driver using the old MSM ADM DMA APIs internally.
> The benefit of this approach is that not all the drivers
> have to get converted to DMAEngine APIs simultaneosly while
typo again!				
> both the drivers can stay enabled in the kernel. The client
> drivers using the old MSM APIs directly can now convert to
> DMAEngine one by one.
> 
> Signed-off-by: Ravi Kumar V <kumarrav@codeaurora.org>
> ---
>  arch/arm/mach-msm/include/mach/dma.h |   35 ++
>  drivers/dma/Kconfig                  |   12 +
>  drivers/dma/Makefile                 |    1 +
>  drivers/dma/msm_adm_dma.c            |  728 ++++++++++++++++++++++++++++++++++
>  4 files changed, 776 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/msm_adm_dma.c
> 
> diff --git a/arch/arm/mach-msm/include/mach/dma.h b/arch/arm/mach-msm/include/mach/dma.h
> index 05583f5..95b7b15 100644
> --- a/arch/arm/mach-msm/include/mach/dma.h
> +++ b/arch/arm/mach-msm/include/mach/dma.h
> @@ -18,6 +18,36 @@
>  #include <linux/list.h>
>  #include <mach/msm_iomap.h>
>  
> +#define sg_dma_offset(sg)               ((sg)->offset)
> +#define box_dma_row_address(box)        ((box)->dma_row_address)
> +#define box_dma_row_len(box)            ((box)->dma_row_len)
> +#define box_dma_row_num(box)            ((box)->dma_row_num)
> +#define box_dma_row_offset(box)         ((box)->dma_row_offset)
> +
> +#define MSM_DMA_CMD_MASK		0x9FFF8
> +#define MSM_DMA_CMD_SHIFT		0
> +#define MSM_BOX_SRC_RLEN_MASK		0xFFFF
> +#define MSM_BOX_SRC_RLEN_SHIFT		16
> +#define MSM_BOX_SRC_RNUM_MASK		0xFFFF
> +#define MSM_BOX_SRC_RNUM_SHIFT		16
> +#define MSM_BOX_SRC_ROFFSET_MASK	0xFFFF
> +#define MSM_BOX_SRC_ROFFSET_SHIFT	16
> +#define MSM_BOX_DST_RLEN_MASK		0xFFFF
> +#define MSM_BOX_DST_RNUM_MASK		0xFFFF
> +#define MSM_BOX_DST_ROFFSET_MASK	0xFFFF
> +#define MSM_BOX_MODE_CMD		0x3
> +
> +enum adm_flush_type {
> +	ADM_FORCED_FLUSH,
> +	ADM_GRACEFUL_FLUSH,
> +};
> +
> +enum adm_dma_type {
> +	ADM_SINGLE_MODE,
> +	ADM_SG_MODE,
> +	ADM_BOX_MODE,
> +};
> +
>  struct msm_dmov_errdata {
>  	uint32_t flush[6];
>  };
> @@ -32,6 +62,11 @@ struct msm_dmov_cmd {
>  	void *data;
>  };
>  
> +struct msm_adm_cmd_config {
> +	uint32_t num_cmd;
> +	uint32_t *cmd_cntrl;
> +};
> +
>  #ifndef CONFIG_ARCH_MSM8X60
>  void msm_dmov_enqueue_cmd(unsigned id, struct msm_dmov_cmd *cmd);
>  void msm_dmov_stop_cmd(unsigned id, struct msm_dmov_cmd *cmd, int graceful);
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index f1a2749..1f99362 100644

> +++ b/drivers/dma/msm_adm_dma.c
> +struct msm_dma_chan {
> +	int chan_id;
> +	dma_cookie_t completed_cookie;
> +	dma_cookie_t error_cookie;
i suspect you haven't updated this to use new cookie helpers
> +	spinlock_t lock;
> +	struct list_head active_list;
> +	struct list_head pending_list;
> +	struct dma_chan channel;
> +	struct dma_pool *desc_pool;
> +	struct device *dev;
> +	int max_len;
> +	int err;
> +	struct tasklet_struct tasklet;
> +};
> +
> +struct msm_dma_device {
> +	void __iomem *base;
> +	struct device *dev;
> +	struct dma_device common;
> +	struct msm_dma_chan *chan[MSM_DMA_MAX_CHANS_PER_DEVICE];
> +};
> +
> +struct msm_dma_desc_hw {
> +	unsigned int cmd_list_ptr;
> +} __aligned(8);
> +
> +/* Single Item Mode */
> +struct adm_cmd_t {
> +	unsigned int cmd_cntrl;
> +	unsigned int src;
> +	unsigned int dst;
> +	unsigned int len;
> +};
> +
> +struct adm_box_cmd_t {
> +	uint32_t cmd_cntrl;
> +	uint32_t src_row_addr;
> +	uint32_t dst_row_addr;
> +	uint32_t src_dst_len;
> +	uint32_t num_rows;
> +	uint32_t row_offset;
> +};
> +
> +struct msm_dma_desc_sw {
> +	struct msm_dma_desc_hw hw;
> +	struct adm_cmd_t *vaddr_cmd;
> +	struct adm_box_cmd_t *vaddr_box_cmd;
> +	size_t coherent_size;
> +	dma_addr_t paddr_cmd_list;
> +	struct list_head node;
> +	struct msm_dmov_cmd dmov_cmd;
> +	struct dma_async_tx_descriptor async_tx;
> +} __aligned(8);
> +
> +static int msm_dma_alloc_chan_resources(struct dma_chan *dchan)
> +{
> +	struct msm_dma_chan *chan = to_msm_chan(dchan);
> +
> +	/* Has this channel already been allocated? */
> +	if (chan->desc_pool)
> +		return 1;
> +
> +	/*
> +	 * We need the descriptor to be aligned to 8bytes
> +	 * for meeting ADM specification requirement.
> +	 */
> +	chan->desc_pool = dma_pool_create("msm_dma_desc_pool",
> +					chan->dev,
> +					sizeof(struct msm_dma_desc_sw),
> +				__alignof__(struct msm_dma_desc_sw), 0);
> +	if (!chan->desc_pool) {
> +		dev_err(chan->dev, "unable to allocate channel %d "
> +				"descriptor pool\n", chan->chan_id);
> +		return -ENOMEM;
> +	}
> +
> +	chan->completed_cookie = 1;
> +	dchan->cookie = 1;
rightly guessed...

> +
> +	/* there is at least one descriptor free to be allocated */
> +	return 1;
hrm?
You need to return the number of descriptors you allocate. And then why
1 here?
> +}
> +

> +static void msm_dma_free_chan_resources(struct dma_chan *dchan)
> +{
> +	struct msm_dma_chan *chan = to_msm_chan(dchan);
> +	unsigned long flags;
> +
> +	dev_dbg(chan->dev, "Free all channel resources.\n");
> +	spin_lock_irqsave(&chan->lock, flags);
> +	msm_dma_free_desc_list(chan, &chan->active_list);
> +	msm_dma_free_desc_list(chan, &chan->pending_list);
Shouldnt you check if dma is active?

> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	dma_pool_destroy(chan->desc_pool);
> +	chan->desc_pool = NULL;
> +}
> +
> +static enum dma_status msm_dma_desc_status(struct msm_dma_chan *chan,
> +					struct msm_dma_desc_sw *desc)
> +{
> +	return dma_async_is_complete(desc->async_tx.cookie,
> +					chan->completed_cookie,
> +					chan->channel.cookie);
> +}
> +
> +static void msm_chan_desc_cleanup(struct msm_dma_chan *chan)
> +{
> +	struct msm_dma_desc_sw *desc, *_desc;
> +	unsigned long flags;
> +
> +	dev_dbg(chan->dev, "Cleaning completed descriptor of channel %d\n",
> +							chan->chan_id);
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	list_for_each_entry_safe(desc, _desc, &chan->active_list, node) {
> +		dma_async_tx_callback callback;
> +		void *callback_param;
> +
> +		if (msm_dma_desc_status(chan, desc) == DMA_IN_PROGRESS)
> +			break;
> +
> +		/* Remove from the list of running transactions */
> +		list_del(&desc->node);
> +
> +		/* Run the link descriptor callback function */
> +		callback = desc->async_tx.callback;
> +		callback_param = desc->async_tx.callback_param;
> +		if (callback) {
> +			spin_unlock_irqrestore(&chan->lock, flags);
> +			callback(callback_param);
> +			spin_lock_irqsave(&chan->lock, flags);
> +		}
> +
> +		/* Run any dependencies, then free the descriptor */
> +		dma_run_dependencies(&desc->async_tx);
> +		spin_unlock_irqrestore(&chan->lock, flags);
> +
> +		if (desc->vaddr_cmd) {
> +			dma_free_coherent(chan->dev, desc->coherent_size,
> +						(void *)desc->vaddr_cmd,
> +							desc->paddr_cmd_list);
> +		} else {
> +			dma_free_coherent(chan->dev, desc->coherent_size,
> +						(void *)desc->vaddr_box_cmd,
> +							desc->paddr_cmd_list);
> +		}
> +		spin_lock_irqsave(&chan->lock, flags);
> +		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> +	}
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +static void dma_do_tasklet(unsigned long data)
> +{
> +	struct msm_dma_chan *chan = (struct msm_dma_chan *)data;
> +	msm_chan_desc_cleanup(chan);
> +}
> +
> +static void
> +msm_dma_complete_func(struct msm_dmov_cmd *cmd,
> +				unsigned int result,
> +				struct msm_dmov_errdata *err)
> +{
> +	unsigned long flags;
> +	struct msm_dma_desc_sw *desch = container_of(cmd,
> +				struct msm_dma_desc_sw, dmov_cmd);
> +	struct msm_dma_chan *chan = to_msm_chan(desch->async_tx.chan);
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	if ((result != NO_ERR_CHAN_STATUS) && err)
> +		chan->error_cookie = desch->async_tx.cookie;
> +	chan->completed_cookie = desch->async_tx.cookie;
> +
> +	tasklet_schedule(&chan->tasklet);
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +/*
> + *  Passes transfer descriptors to DMA hardware.
> + */
> +static void msm_dma_issue_pending(struct dma_chan *dchan)
> +{
> +	struct msm_dma_chan *chan = to_msm_chan(dchan);
> +	struct msm_dma_desc_sw *desch;
> +	unsigned long flags;
> +
> +	if (chan->err)
> +		return;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	if (list_empty(&chan->pending_list))
> +		goto out_unlock;
> +
> +	desch = list_first_entry(&chan->pending_list, struct msm_dma_desc_sw,
> +									node);
> +	list_del(&desch->node);
> +	desch->dmov_cmd.complete_func = msm_dma_complete_func;
> +	desch->dmov_cmd.execute_func = NULL;
> +	desch->dmov_cmd.cmdptr = DMOV_CMD_ADDR(desch->async_tx.phys);
> +	list_add_tail(&desch->node, &chan->active_list);
> +	mb();
> +	msm_dmov_enqueue_cmd(chan->chan_id, &desch->dmov_cmd);
> +out_unlock:
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +}
> +
> +/*
> + *  Assignes cookie for each transfer descriptor passed.
> + *  Returns
> + *	Assigend cookie for success.
> + *	Error value for failure.
> + */
> +static dma_cookie_t msm_dma_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	struct msm_dma_chan *chan = to_msm_chan(tx->chan);
> +	struct msm_dma_desc_sw *desc = container_of(tx,
> +	struct msm_dma_desc_sw, async_tx);
> +	unsigned long flags;
> +	dma_cookie_t cookie = -EBUSY;
> +
> +	if (chan->err)
> +		return cookie;
> +
> +	spin_lock_irqsave(&chan->lock, flags);
> +
> +	/*
> +	 * assign cookies to all of the software descriptors
> +	 * that make up this transaction
> +	 */
> +	cookie = chan->channel.cookie;
> +	cookie++;
> +	if (cookie < 0)
> +		cookie = DMA_MIN_COOKIE;
this needs update
> +
> +	desc->async_tx.cookie = cookie;
> +	chan->channel.cookie = cookie;
> +
> +	/* put this transaction onto the tail of the pending queue */
> +	list_add_tail(&desc->node, &chan->pending_list);
> +
> +	spin_unlock_irqrestore(&chan->lock, flags);
> +
> +	return cookie;
> +}
> +
> +/*
> + *  Returns the DMA transfer status of a particular cookie
> + */
> +static enum dma_status msm_tx_status(struct dma_chan *dchan,
> +					dma_cookie_t cookie,
> +				struct dma_tx_state *txstate)
> +{
> +	struct msm_dma_chan *chan = to_msm_chan(dchan);
> +	dma_cookie_t last_used;
> +	dma_cookie_t last_complete;
> +	enum dma_status status;
> +
> +	last_used = dchan->cookie;
> +	last_complete = chan->completed_cookie;
> +
> +	dma_set_tx_state(txstate, last_complete, last_used, 0);
> +
> +	status = dma_async_is_complete(cookie, last_complete, last_used);
> +
> +	if (status != DMA_IN_PROGRESS)
> +		if (chan->error_cookie == cookie)
> +			status = DMA_ERROR;
> +
> +	return status;
> +}
same here
> +
> +static struct msm_dma_desc_sw *msm_dma_alloc_descriptor(
> +				struct msm_dma_chan *chan,
> +				int cmd_cnt,
> +				enum adm_dma_type mask)
> +{
> +	struct msm_dma_desc_sw *desc;
> +	dma_addr_t pdesc_addr;
> +	dma_addr_t paddr_cmd_list;
> +	void *err = NULL;
> +
> +	desc = dma_pool_alloc(chan->desc_pool, GFP_ATOMIC, &pdesc_addr);
why atomic?
> +	if (!desc) {
> +		dev_dbg(chan->dev, "out of memory for desc\n");
> +		return ERR_CAST(desc);
> +	}
> +
> +	memset(desc, 0, sizeof(*desc));
> +	desc->async_tx.phys = pdesc_addr;
> +
> +	if (mask == ADM_BOX_MODE) {
> +		desc->coherent_size = sizeof(struct adm_box_cmd_t);
> +		desc->vaddr_box_cmd = dma_alloc_coherent(chan->dev,
> +				sizeof(struct adm_box_cmd_t),
> +				&paddr_cmd_list, GFP_ATOMIC);
> +		if (!desc->vaddr_box_cmd) {
> +			dev_dbg(chan->dev, "out of memory for desc\n");
> +			err = desc->vaddr_box_cmd;
> +			goto fail;
> +		}
> +	} else {
> +		desc->coherent_size = sizeof(struct adm_cmd_t)*cmd_cnt;
> +
> +		desc->vaddr_cmd = dma_alloc_coherent(chan->dev,
> +				sizeof(struct adm_cmd_t)*cmd_cnt,
> +				&paddr_cmd_list, GFP_ATOMIC);
> +
> +		if (!desc->vaddr_cmd) {
> +			dev_dbg(chan->dev, "out of memory for desc\n");
> +			err = desc->vaddr_cmd;
> +			goto fail;
> +		}
> +	}
> +
> +	dma_async_tx_descriptor_init(&desc->async_tx, &chan->channel);
> +	desc->async_tx.tx_submit = msm_dma_tx_submit;
> +	desc->paddr_cmd_list = paddr_cmd_list;
> +	desc->hw.cmd_list_ptr = (paddr_cmd_list >> 3) | CMD_PTR_LP;
> +	return desc;
> +fail:
> +	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
> +	return ERR_CAST(err);
> +}
> +
> +/*
> + *  Prepares the transfer descriptors for SG transaction.
> + *  Returns
> + *	address of dma_async_tx_descriptor for success.
> + *	Pointer of error value for failure.
Kernel style is to use kernel-doc for this kind of description
> + */
> +static struct dma_async_tx_descriptor *msm_dma_prep_sg(
> +		struct dma_chan *dchan,
> +		struct scatterlist *dst_sg, unsigned int dst_nents,
> +		struct scatterlist *src_sg, unsigned int src_nents,
> +		unsigned long flags, void *context)
> +{
> +
> +	struct msm_dma_chan *chan;
> +	struct msm_dma_desc_sw *new;
> +	size_t copy, len;
> +	int cmd_cnt = 0;
> +	int first = 0;
> +	int i;
> +	dma_addr_t src;
> +	dma_addr_t dst;
> +	struct adm_cmd_t *cmdlist_vaddr;
> +	struct scatterlist *sg;
> +	struct msm_adm_cmd_config *cmd_config = context;
> +
> +	if (!dchan)
> +		return NULL;
> +
> +	if (dst_nents == 0 || src_nents == 0)
> +		return NULL;
> +	if (!dst_sg || !src_sg)
> +		return NULL;
> +
> +	if ((dst_nents != src_nents) || (cmd_config->num_cmd != src_nents))
> +		return NULL;
> +
> +	chan = to_msm_chan(dchan);
> +
> +	cmd_cnt = src_nents;
> +	for (i = 0; i < src_nents; i++) {
> +		len = sg_dma_len(src_sg + i);
> +		if (len != MAX_TRANSFER_LENGTH)
> +			cmd_cnt += len/MAX_TRANSFER_LENGTH;
> +	}
> +
> +	new = msm_dma_alloc_descriptor(chan, cmd_cnt, ADM_SG_MODE);
> +
> +	if (!new) {
> +		dev_err(chan->dev,
> +			"No free memory for link descriptor\n");
> +		return NULL;
> +	}
> +
> +	cmdlist_vaddr = new->vaddr_cmd;
> +
> +	for_each_sg(src_sg, sg, src_nents, i) {
> +		len = sg_dma_len(sg);
> +		src = sg_dma_address(sg);
> +		do {
> +			copy = (len >= MAX_TRANSFER_LENGTH) ?
> +						MAX_TRANSFER_LENGTH : len;
> +			cmdlist_vaddr->src = src;
> +			cmdlist_vaddr->len = copy;
> +			cmdlist_vaddr->cmd_cntrl =
> +					*(cmd_config->cmd_cntrl + i) &
> +							MSM_DMA_CMD_MASK;
> +			if (first == 0) {
> +				if (cmd_cnt == 1)
> +					cmdlist_vaddr->cmd_cntrl |= CMD_LC;
> +				else
> +					cmdlist_vaddr->cmd_cntrl |= CMD_OCB;
> +				first = 1;
> +			}
> +			cmdlist_vaddr++;
> +			len -= copy;
> +			src += copy;
> +		} while (len);
> +	}
> +	if (cmd_cnt > 1) {
> +		cmdlist_vaddr--;
> +		cmdlist_vaddr->cmd_cntrl |= CMD_LC | CMD_OCU;
> +	}
> +
> +	cmdlist_vaddr = new->vaddr_cmd;
> +
> +	for_each_sg(dst_sg, sg, src_nents, i) {
> +		len = sg_dma_len(sg);
> +		dst = sg_dma_address(sg);
> +		do {
> +			copy = (len >= MAX_TRANSFER_LENGTH) ?
> +					MAX_TRANSFER_LENGTH : len;
> +			cmdlist_vaddr->dst = dst;
> +			cmdlist_vaddr++;
> +			len -= copy;
> +			dst += copy;
> +		} while (len);
> +
> +	}
> +
> +#ifdef DEBUG
> +	cmdlist_vaddr = new->vaddr_cmd;
> +	i = 0;
> +	do {
> +		dev_dbg(chan->dev, "cmd %d src 0x%x dst 0x%x len 0x%x "
> +						"cntrl 0x%x\n",
> +				i, cmdlist_vaddr->src, cmdlist_vaddr->dst,
> +				cmdlist_vaddr->len, cmdlist_vaddr->cmd_cntrl);
> +			cmdlist_vaddr++;
> +	} while (!((cmdlist_vaddr-1)->cmd_cntrl & CMD_LC));
> +#endif
> +	new->async_tx.flags = flags;
> +	new->async_tx.cookie = -EBUSY;
> +
> +	return &new->async_tx;
> +}
> +
> +/*
> + *  Controlling the hardware channel like stopping, flushing.
> + */
> +static int msm_dma_chan_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> +							unsigned long arg)
> +{
> +	enum adm_flush_type cmd_type = arg;
> +
> +	if (cmd == DMA_TERMINATE_ALL) {
> +		switch (cmd_type) {
> +		case ADM_GRACEFUL_FLUSH:
> +				msm_dmov_stop_cmd(chan->chan_id, NULL, 1);
> +			break;
> +		case ADM_FORCED_FLUSH:
> +			/*
> +			 * We treate default as forced flush
> +			 * so we fall through
> +			 */
> +		default:
> +				msm_dmov_stop_cmd(chan->chan_id, NULL, 0);
> +			break;
> +		}
> +	}
No slave? How do you pass the peripheral properties like addr etc?

> +	return 0;
> +}


> +
> +MODULE_DESCRIPTION("Qualcomm DMA driver");
> +MODULE_LICENSE("GPL v2");
MODULE_ALIAS, OWNER, AUTHOR pls


-- 
~Vinod

