Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2ATMqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:46:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20356 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2ATMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:46:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6594"; a="156598152"
Message-ID: <4F196214.30608@codeaurora.org>
Date: Fri, 20 Jan 2012 18:16:12 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-arch@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bryanh@codeaurora.org, tsoni@qualcomm.com, dwalker@fifo99.com,
        dan.j.williams@intel.com, davidb@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, johlstei@qualcomm.com
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on
 old MSM DMA APIs
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org> <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org> <1326810701.1540.161.camel@vkoul-udesk3>
In-Reply-To: <1326810701.1540.161.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 8:01 PM, Vinod Koul wrote:
> On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
>> +static int msm_dma_alloc_chan_resources(struct dma_chan *dchan)
>> +{
>> +	struct msm_dma_chan *chan = to_msm_chan(dchan);
>> +
>> +	/* Has this channel already been allocated? */
>> +	if (chan->desc_pool)
>> +		return 1;
> that is _wrong_. This would mean you have allocated 1 descriptor.
> Please read the documentation again.
Yes you are right, i will update in next patch release.
>> +
>> +/*
>> + *  Assignes cookie for each transfer descriptor passed.
>> + *  Returns
>> + *	Assigend cookie for success.
> typo	 ^^^^^^^^^
I will change
>> +
>> +
>> +/*
>> + *  Prepares the transfer descriptors for BOX transaction.
>> + *  Returns
>> + *      address of dma_async_tx_descriptor for success.
>> + *      Pointer of error value for failure.
>> + */
> pls use kernel-doc style for these...
I will update
>> +static struct dma_async_tx_descriptor *msm_dma_prep_box(
>> +		struct dma_chan *dchan,
>> +		struct dma_box_list *dst_box, struct dma_box_list *src_box,
>> +		unsigned int num_list,	unsigned long flags)
>> +{
>> +
>> +/*
>> + *  Controlling the hardware channel like stopping, flushing.
>> + */
>> +static int msm_dma_chan_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>> +							unsigned long arg)
>> +{
>> +	int cmd_type = (int) arg;
>> +
>> +	if (cmd == DMA_TERMINATE_ALL) {
>> +		switch (cmd_type) {
>> +		case GRACEFUL_FLUSH:
>> +				msm_dmov_stop_cmd(chan->chan_id, NULL, 1);
>> +			break;
>> +		case FORCED_FLUSH:
>> +			/*
>> +			 * We treate default as forced flush
>> +			 * so we fall through
>> +			 */
>> +		default:
>> +				msm_dmov_stop_cmd(chan->chan_id, NULL, 0);
>> +			break;
>> +		}
>> +	}
> for other cmds you _should_ not return 0
I will update
>> +	return 0;
>> +}
>> +
>> +static void msm_dma_chan_remove(struct msm_dma_chan *chan)
>> +{
>> +	tasklet_kill(&chan->tasklet);
>> +	list_del(&chan->channel.device_node);
>> +	kfree(chan);
>> +}
>> +
>> +static __devinit int msm_dma_chan_probe(struct msm_dma_device *qdev,
>> +					int channel)
>> +{
>> +	struct msm_dma_chan *chan;
>> +
>> +	chan = kzalloc(sizeof(*chan), GFP_KERNEL);
>> +	if (!chan) {
>> +		dev_err(qdev->dev, "no free memory for DMA channels!\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	spin_lock_init(&chan->lock);
>> +	INIT_LIST_HEAD(&chan->pending_list);
>> +	INIT_LIST_HEAD(&chan->active_list);
>> +
>> +	chan->chan_id = channel;
>> +	chan->completed_cookie = 0;
>> +	chan->channel.cookie = 0;
>> +	chan->max_len = MAX_TRANSFER_LENGTH;
>> +	chan->err = 0;
>> +	qdev->chan[channel] = chan;
>> +	chan->channel.device =&qdev->common;
>> +	chan->dev = qdev->dev;
>> +
>> +	tasklet_init(&chan->tasklet, dma_do_tasklet, (unsigned long)chan);
>> +
>> +	list_add_tail(&chan->channel.device_node,&qdev->common.channels);
>> +	qdev->common.chancnt++;
>> +
>> +	return 0;
>> +}
>> +
>> +static int __devinit msm_dma_probe(struct platform_device *pdev)
>> +{
>> +	struct msm_dma_device *qdev;
>> +	int i;
>> +	int ret = 0;
>> +
>> +	qdev = kzalloc(sizeof(*qdev), GFP_KERNEL);
> devm_kzalloc pls
I will update.
>> +	if (!qdev) {
>> +		dev_err(&pdev->dev, "Not enough memory for device\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	qdev->dev =&pdev->dev;
>> +	INIT_LIST_HEAD(&qdev->common.channels);
>> +	qdev->common.device_alloc_chan_resources =
>> +				msm_dma_alloc_chan_resources;
>> +	qdev->common.device_free_chan_resources =
>> +				msm_dma_free_chan_resources;
>> +	dma_cap_set(DMA_SG, qdev->common.cap_mask);
>> +	dma_cap_set(DMA_BOX, qdev->common.cap_mask);
>> +
>> +	qdev->common.device_prep_dma_sg = msm_dma_prep_sg;
>> +	qdev->common.device_prep_dma_box = msm_dma_prep_box;
>> +	qdev->common.device_issue_pending = msm_dma_issue_pending;
>> +	qdev->common.dev =&pdev->dev;
>> +	qdev->common.device_tx_status = msm_tx_status;
>> +	qdev->common.device_control = msm_dma_chan_control;
>> +
>> +	for (i = SD3_CHAN_START; i<  MSM_DMA_MAX_CHANS_PER_DEVICE; i++) {
>> +		ret = msm_dma_chan_probe(qdev, i);
>> +		if (ret) {
>> +			dev_err(&pdev->dev, "channel %d probe failed\n", i);
>> +			goto chan_free;
>> +		}
>> +	}
>> +
>> +	dev_info(&pdev->dev, "registering dma device\n");
>> +
>> +	ret = dma_async_device_register(&qdev->common);
>> +
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Registering Dma device failed\n");
>> +		goto chan_free;
>> +	}
>> +
>> +	dev_set_drvdata(&pdev->dev, qdev);
>> +	return 0;
>> +chan_free:
>> +	for (i = SD3_CHAN_START; i<  MSM_DMA_MAX_CHANS_PER_DEVICE; i++) {
>> +		if (qdev->chan[i])
>> +			msm_dma_chan_remove(qdev->chan[i]);
>> +	}
>> +	kfree(qdev);
> you leak the chan memory allocated
I am freeing chan memory from msm_dma_chan_remove() called above.
>> +	return ret;
>> +}
>> +
>> +static int  __devexit msm_dma_remove(struct platform_device *pdev)
>> +{
>> +	struct msm_dma_device *qdev = platform_get_drvdata(pdev);
>> +	int i;
>> +
>> +	dma_async_device_unregister(&qdev->common);
>> +
>> +	for (i = SD3_CHAN_START; i<  MSM_DMA_MAX_CHANS_PER_DEVICE; i++) {
>> +		if (qdev->chan[i])
>> +			msm_dma_chan_remove(qdev->chan[i]);
>> +	}
>> +
>> +	dev_set_drvdata(&pdev->dev, NULL);
>> +	kfree(qdev);
> ditto
I am freeing chan memory from msm_dma_chan_remove() called above.
>> +
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver msm_dma_driver = {
>> +	.remove = __devexit_p(msm_dma_remove),
>> +	.driver = {
>> +		.name = "msm_dma",
>> +		.owner = THIS_MODULE,
>> +	},
>> +};
>> +
>> +static __init int msm_dma_init(void)
>> +{
>> +	return platform_driver_probe(&msm_dma_driver, msm_dma_probe);
>> +}
>> +subsys_initcall(msm_dma_init);
>> +
>> +static void __exit msm_dma_exit(void)
>> +{
>> +	platform_driver_unregister(&msm_dma_driver);
>> +}
>> +module_exit(msm_dma_exit);
>> +
>> +MODULE_DESCRIPTION("Qualcomm DMA driver");
>> +MODULE_LICENSE("GPL v2");
> More comments, once I understand what "BOX mode" is?
> Also, if you can add basic driver without box mode, we can merge fairly
> quickly, box mode can come once we understand what we want and how...
We also implemented SG mode using device_prep_dma_sg() but we need to 
pass extra parameter "command configuration" to our HW with every 
descriptor.
Please can you suggest a way to transfer private param to 
device_prep_dma_sg()

>
>


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
