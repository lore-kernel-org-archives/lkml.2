Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2AQOdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:33:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:22146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab2AQOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:33:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="57261669"
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on
 old MSM DMA APIs
From: Vinod Koul <vinod.koul@intel.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, tsoni@qualcomm.com, johlstei@qualcomm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org>
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org>
	 <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Jan 2012 20:01:41 +0530
Message-ID: <1326810701.1540.161.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
> +static int msm_dma_alloc_chan_resources(struct dma_chan *dchan)
> +{
> +	struct msm_dma_chan *chan = to_msm_chan(dchan);
> +
> +	/* Has this channel already been allocated? */
> +	if (chan->desc_pool)
> +		return 1;
that is _wrong_. This would mean you have allocated 1 descriptor.
Please read the documentation again.
> +
> +/*
> + *  Assignes cookie for each transfer descriptor passed.
> + *  Returns
> + *	Assigend cookie for success.
typo	 ^^^^^^^^^
> +
> +
> +/*
> + *  Prepares the transfer descriptors for BOX transaction.
> + *  Returns
> + *      address of dma_async_tx_descriptor for success.
> + *      Pointer of error value for failure.
> + */
pls use kernel-doc style for these...
> +static struct dma_async_tx_descriptor *msm_dma_prep_box(
> +		struct dma_chan *dchan,
> +		struct dma_box_list *dst_box, struct dma_box_list *src_box,
> +		unsigned int num_list,	unsigned long flags)
> +{
> +	struct msm_dma_chan *chan;
> +	struct msm_dma_desc_sw *new;
> +	int cmd_cnt = 0;
> +	int first = 0;
> +	int i;
> +	struct adm_box_cmd_t *box_cmd_vaddr;
> +
> +	if (!dchan)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (num_list == 0)
> +		return ERR_PTR(-EINVAL);
> +	if (!dst_box || !src_box)
> +		return ERR_PTR(-EINVAL);
> +
> +	chan = to_msm_chan(dchan);
> +
> +	cmd_cnt = num_list;
> +
> +	new = msm_dma_alloc_descriptor(chan, cmd_cnt, DMA_BOX);
> +
> +	if (!new) {
> +		dev_err(chan->dev,
> +			"No free memory for link descriptor\n");
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	box_cmd_vaddr = new->vaddr_box_cmd;
> +
> +	for (i = 0; i < num_list; i++) {
> +
> +		box_cmd_vaddr->src_row_addr =
> +				box_dma_row_address(src_box + i);
> +		box_cmd_vaddr->src_dst_len =
> +				(box_dma_row_len(src_box + i) &
> +				MSM_BOX_SRC_RLEN_MASK) <<
> +				MSM_BOX_SRC_RLEN_SHIFT;
> +		box_cmd_vaddr->cmd_cntrl =
> +				(box_dma_private_data(src_box + i) &
> +				MSM_DMA_CMD_MASK) | MSM_BOX_MODE_CMD;
> +
> +		box_cmd_vaddr->num_rows = (box_dma_row_num(src_box + i) &
> +				MSM_BOX_SRC_RNUM_MASK) <<
> +				MSM_BOX_SRC_RNUM_SHIFT;
> +
> +		box_cmd_vaddr->row_offset = (box_dma_row_offset(src_box + i) &
> +				MSM_BOX_SRC_ROFFSET_MASK) <<
> +				MSM_BOX_SRC_ROFFSET_SHIFT;
> +
> +		if (first == 0) {
> +			if (cmd_cnt == 1)
> +				box_cmd_vaddr->cmd_cntrl |=
> +				CMD_LC | CMD_OCB | CMD_OCU;
> +			else
> +				box_cmd_vaddr->cmd_cntrl |=
> +						CMD_OCB;
> +			first = 1;
> +		}
> +		box_cmd_vaddr++;
> +	}
> +
> +	if (cmd_cnt > 1) {
> +		box_cmd_vaddr--;
> +		box_cmd_vaddr->cmd_cntrl |= CMD_LC | CMD_OCU;
> +	}
> +
> +	box_cmd_vaddr = new->vaddr_box_cmd;
> +
> +	for (i = 0; i < num_list; i++) {
> +
> +		box_cmd_vaddr->dst_row_addr = box_dma_row_address(dst_box + i);
> +		box_cmd_vaddr->src_dst_len |=
> +			(box_dma_row_len(dst_box + i) & MSM_BOX_DST_RLEN_MASK);
> +		box_cmd_vaddr->num_rows |=
> +				(box_dma_row_num(dst_box + i) &
> +			MSM_BOX_DST_RNUM_MASK);
> +
> +		box_cmd_vaddr->row_offset |=
> +				(box_dma_row_offset(dst_box + i) &
> +					MSM_BOX_DST_ROFFSET_MASK);
> +		box_cmd_vaddr++;
> +	}
> +#ifdef DEBUG
> +	i = 0;
> +	box_cmd_vaddr = new->vaddr_box_cmd;
> +	do {
> +		dev_dbg(chan->dev, "cmd %d src 0x%x dst 0x%x len 0x%x "
> +		"cntrl 0x%x row_offset 0x%x num_rows 0x%x\n",
> +			i, box_cmd_vaddr->src_row_addr,
> +			box_cmd_vaddr->dst_row_addr,
> +			box_cmd_vaddr->src_dst_len,
> +			box_cmd_vaddr->cmd_cntrl,
> +			box_cmd_vaddr->row_offset,
> +			box_cmd_vaddr->num_rows);
> +			box_cmd_vaddr++;
> +			i++;
> +	} while (!((box_cmd_vaddr-1)->cmd_cntrl & CMD_LC));
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
> +	int cmd_type = (int) arg;
> +
> +	if (cmd == DMA_TERMINATE_ALL) {
> +		switch (cmd_type) {
> +		case GRACEFUL_FLUSH:
> +				msm_dmov_stop_cmd(chan->chan_id, NULL, 1);
> +			break;
> +		case FORCED_FLUSH:
> +			/*
> +			 * We treate default as forced flush
> +			 * so we fall through
> +			 */
> +		default:
> +				msm_dmov_stop_cmd(chan->chan_id, NULL, 0);
> +			break;
> +		}
> +	}
for other cmds you _should_ not return 0
> +	return 0;
> +}
> +
> +static void msm_dma_chan_remove(struct msm_dma_chan *chan)
> +{
> +	tasklet_kill(&chan->tasklet);
> +	list_del(&chan->channel.device_node);
> +	kfree(chan);
> +}
> +
> +static __devinit int msm_dma_chan_probe(struct msm_dma_device *qdev,
> +					int channel)
> +{
> +	struct msm_dma_chan *chan;
> +
> +	chan = kzalloc(sizeof(*chan), GFP_KERNEL);
> +	if (!chan) {
> +		dev_err(qdev->dev, "no free memory for DMA channels!\n");
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&chan->lock);
> +	INIT_LIST_HEAD(&chan->pending_list);
> +	INIT_LIST_HEAD(&chan->active_list);
> +
> +	chan->chan_id = channel;
> +	chan->completed_cookie = 0;
> +	chan->channel.cookie = 0;
> +	chan->max_len = MAX_TRANSFER_LENGTH;
> +	chan->err = 0;
> +	qdev->chan[channel] = chan;
> +	chan->channel.device = &qdev->common;
> +	chan->dev = qdev->dev;
> +
> +	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
> +
> +	list_add_tail(&chan->channel.device_node, &qdev->common.channels);
> +	qdev->common.chancnt++;
> +
> +	return 0;
> +}
> +
> +static int __devinit msm_dma_probe(struct platform_device *pdev)
> +{
> +	struct msm_dma_device *qdev;
> +	int i;
> +	int ret = 0;
> +
> +	qdev = kzalloc(sizeof(*qdev), GFP_KERNEL);
devm_kzalloc pls
> +	if (!qdev) {
> +		dev_err(&pdev->dev, "Not enough memory for device\n");
> +		return -ENOMEM;
> +	}
> +
> +	qdev->dev = &pdev->dev;
> +	INIT_LIST_HEAD(&qdev->common.channels);
> +	qdev->common.device_alloc_chan_resources =
> +				msm_dma_alloc_chan_resources;
> +	qdev->common.device_free_chan_resources =
> +				msm_dma_free_chan_resources;
> +	dma_cap_set(DMA_SG, qdev->common.cap_mask);
> +	dma_cap_set(DMA_BOX, qdev->common.cap_mask);
> +
> +	qdev->common.device_prep_dma_sg = msm_dma_prep_sg;
> +	qdev->common.device_prep_dma_box = msm_dma_prep_box;
> +	qdev->common.device_issue_pending = msm_dma_issue_pending;
> +	qdev->common.dev = &pdev->dev;
> +	qdev->common.device_tx_status = msm_tx_status;
> +	qdev->common.device_control = msm_dma_chan_control;
> +
> +	for (i = SD3_CHAN_START; i < MSM_DMA_MAX_CHANS_PER_DEVICE; i++) {
> +		ret = msm_dma_chan_probe(qdev, i);
> +		if (ret) {
> +			dev_err(&pdev->dev, "channel %d probe failed\n", i);
> +			goto chan_free;
> +		}
> +	}
> +
> +	dev_info(&pdev->dev, "registering dma device\n");
> +
> +	ret = dma_async_device_register(&qdev->common);
> +
> +	if (ret) {
> +		dev_err(&pdev->dev, "Registering Dma device failed\n");
> +		goto chan_free;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, qdev);
> +	return 0;
> +chan_free:
> +	for (i = SD3_CHAN_START; i < MSM_DMA_MAX_CHANS_PER_DEVICE; i++) {
> +		if (qdev->chan[i])
> +			msm_dma_chan_remove(qdev->chan[i]);
> +	}
> +	kfree(qdev);
you leak the chan memory allocated
> +	return ret;
> +}
> +
> +static int  __devexit msm_dma_remove(struct platform_device *pdev)
> +{
> +	struct msm_dma_device *qdev = platform_get_drvdata(pdev);
> +	int i;
> +
> +	dma_async_device_unregister(&qdev->common);
> +
> +	for (i = SD3_CHAN_START; i < MSM_DMA_MAX_CHANS_PER_DEVICE; i++) {
> +		if (qdev->chan[i])
> +			msm_dma_chan_remove(qdev->chan[i]);
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, NULL);
> +	kfree(qdev);
ditto
> +
> +	return 0;
> +}
> +
> +static struct platform_driver msm_dma_driver = {
> +	.remove = __devexit_p(msm_dma_remove),
> +	.driver = {
> +		.name = "msm_dma",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static __init int msm_dma_init(void)
> +{
> +	return platform_driver_probe(&msm_dma_driver, msm_dma_probe);
> +}
> +subsys_initcall(msm_dma_init);
> +
> +static void __exit msm_dma_exit(void)
> +{
> +	platform_driver_unregister(&msm_dma_driver);
> +}
> +module_exit(msm_dma_exit);
> +
> +MODULE_DESCRIPTION("Qualcomm DMA driver");
> +MODULE_LICENSE("GPL v2");
More comments, once I understand what "BOX mode" is?
Also, if you can add basic driver without box mode, we can merge fairly
quickly, box mode can come once we understand what we want and how...


-- 
~Vinod

