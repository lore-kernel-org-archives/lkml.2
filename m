Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2EILF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:05:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16923 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691Ab2EILF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:05:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 09 May 2012 04:05:27 -0700
Message-ID: <4FAA4EA3.70001@nvidia.com>
Date: Wed, 9 May 2012 16:31:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@linux.intel.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 2/2] dmaengine: tegra: add dma driver
References: <1336030889-32269-1-git-send-email-ldewangan@nvidia.com>	 <1336030889-32269-3-git-send-email-ldewangan@nvidia.com> <1336558444.1540.243.camel@vkoul-udesk3>
In-Reply-To: <1336558444.1540.243.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Vinod for reviewing code.
I am removing the code from this thread which  is not require. Only 
keeping code surrounding our discussion.

On Wednesday 09 May 2012 03:44 PM, Vinod Koul wrote:
> On Thu, 2012-05-03 at 13:11 +0530, Laxman Dewangan wrote:
>> + * Initial number of descriptors to allocate for each channel during
>> + * allocation. More descriptors will be allocated dynamically if
>> + * client needs it.
>> + */
>> +#define DMA_NR_DESCS_PER_CHANNEL     4
>> +#define DMA_NR_REQ_PER_DESC          8
> all of these should be namespaced.
> APB and AHB are fairly generic names.
Fine, then I will go as APB_DMA_NR_DESC_xxx and APB_DMA_NR_REQ_xxx

>> +
>> +enum dma_transfer_mode {
>> +     DMA_MODE_NONE,
>> +     DMA_MODE_ONCE,
>> +     DMA_MODE_CYCLE,
>> +     DMA_MODE_CYCLE_HALF_NOTIFY,
>> +};
> I dont understand why you would need to keep track of these?
> You get a request for DMA. You have properties of transfer. You prepare
> you descriptors and then submit.
> Why would you need to create above modes and remember them?
I am allowing multiple desc requests in dma through prep_slave and 
prep_cyclic. So when dma channel does not have any request then it can 
set its mode as NONE.
Once the desc is requested the mode is set based on request. This mode 
will not get change until all dma request done and if new request come 
to dma channel, it checks that it should not conflict with older mode. 
The engine is configured in these mode and will change only when all 
transfer completed.
>> +struct tegra_dma_desc {
>> +     struct dma_async_tx_descriptor  txd;
>> +     int                             bytes_requested;
>> +     int                             bytes_transferred;
>> +     enum dma_status                 dma_status;
>> +     struct list_head                node;
>> +     struct list_head                tx_list;
>> +     struct list_head                cb_node;
>> +     bool                            ack_reqd;
>> +     bool                            cb_due;
> what are these two for, seems redundant to me

I am reusing the desc once the transfer completed from that desc, not 
freeing it memory.
The ack_reqd tells that client need to ack that desc so that it can be 
reused. So this flag tells that client need to ack that desc.
This is to track the flag DMA_CTRL_ACK which is passed by client in 
prep_slave_xxx.

cb_due is having different purpose. then ack. Once dma transfer 
completes, it schedules the tasklet and set the cb_due as callback 
pending. Before tasklet get schedule, if again transfer completes and 
re-enter into isr then it wil check that desc callback is pending or not 
and based on that it queued it on the callback list.

>> +static int allocate_tegra_desc(struct tegra_dma_channel *tdc,
>> +             int ndma_desc, int nsg_req)
> pls follow single convention for naming in driver eithe xxx_tegra_yyy or
> tegra_xxx_yyy... BUT not both!
Sure, i will do it.

>> +     /* Initialize DMA descriptors */
>> +     for (i = 0; i<  ndma_desc; ++i) {
>> +             dma_desc = kzalloc(sizeof(struct tegra_dma_desc), GFP_ATOMIC);
> kernel convention is kzalloc(sizeof(*dma_desc),....
yes I will do it, I missed this cleanup.
>> +
>> +
>> +     /* Check from free list desc */
>> +     if (!list_empty(&tdc->free_dma_desc)) {
>> +             dma_desc = list_first_entry(&tdc->free_dma_desc,
>> +                                     typeof(*dma_desc), node);
>> +             list_del(&dma_desc->node);
>> +             goto end;
>> +     }
> sorry I dont like this jumping and returning for two lines of code.
> Makes much sense to return from here.
Then goto will be replace as
spin_unlock_irqrestore()
return.
and all three places.
I will do if it is OK,

>> +static void tegra_dma_desc_done_locked(struct tegra_dma_channel *tdc,
>> +             struct tegra_dma_desc *dma_desc)
>> +{
>> +     if (dma_desc->ack_reqd)
>> +             list_add_tail(&dma_desc->node,&tdc->wait_ack_dma_desc);
> what does ack_reqd mean?
Client need to ack this desc before reusing it.

> Do you ahve unlocked version of this function, name suggests so...
Did not require the locked version of function. Will remove the locked 
and add in comment.

>> +     else
>> +             list_add_tail(&dma_desc->node,&tdc->free_dma_desc);
>> +}
>> +
>> +static struct tegra_dma_sg_req *tegra_dma_sg_req_get(
>> +             struct tegra_dma_channel *tdc)
> in this and other functions, you have used goto to unlock and return.
> Rather than that why don't you simplify code by calling these while
> holding lock

We are allocating memory also and that's why it is there.
But I can make it because I am callocating memory as GFP_ATOMIC.
However if the function call dma_async_tx_descriptor_init() can happen 
in atomic context i.e. calling spin_lock_init() call.

>> +                     }
>> +                     dma_cookie_complete(&dma_desc->txd);
> does this make sense. You are marking an aborted descriptor as complete.
If I dont call the the complete cookie of that channel will not get 
updated and on query, it will return as PROGRESS.
I need to update the dma channel completed cookie.

>> +     if (list_empty(&tdc->pending_sg_req)) {
>> +             dev_err(tdc2dev(tdc),
>> +                     "%s(): Dma is running without any req list\n",
>> +                     __func__);
> this is just waste of real estate and very ugly. Move them to 1/2 lines.

Let me see if I can save something here.

>> +             tegra_dma_stop(tdc);
>> +             return false;
>> +     }
>> +
>> +     /*
>> +      * Check that head req on list should be in flight.
>> +      * If it is not in flight then abort transfer as
>> +      * transfer looping can not continue.
>> +      */
>> +     hsgreq = list_first_entry(&tdc->pending_sg_req, typeof(*hsgreq), node);
>> +     if (!hsgreq->configured) {
>> +             tegra_dma_stop(tdc);
>> +             dev_err(tdc2dev(tdc),
>> +                     "Error in dma transfer loop, aborting dma\n");
>> +             tegra_dma_abort_all(tdc);
>> +             return false;
>> +     }
>> +
>> +     /* Configure next request in single buffer mode */
>> +     if (!to_terminate&&  (tdc->dma_mode == DMA_MODE_CYCLE))
>> +             tdc_configure_next_head_desc(tdc);
>> +     return true;
>> +}
>> +
>> +static void tegra_dma_tasklet(unsigned long data)
>> +{
>> +     struct tegra_dma_channel *tdc = (struct tegra_dma_channel *)data;
>> +     unsigned long flags;
>> +     dma_async_tx_callback callback = NULL;
>> +     void *callback_param = NULL;
>> +     struct tegra_dma_desc *dma_desc;
>> +     struct list_head cb_dma_desc_list;
>> +
>> +     INIT_LIST_HEAD(&cb_dma_desc_list);
>> +     spin_lock_irqsave(&tdc->lock, flags);
>> +     if (list_empty(&tdc->cb_desc)) {
>> +             spin_unlock_irqrestore(&tdc->lock, flags);
>> +             return;
>> +     }
>> +     list_splice_init(&tdc->cb_desc,&cb_dma_desc_list);
>> +     spin_unlock_irqrestore(&tdc->lock, flags);
>> +
>> +     while (!list_empty(&cb_dma_desc_list)) {
>> +             dma_desc  = list_first_entry(&cb_dma_desc_list,
>> +                             typeof(*dma_desc), cb_node);
>> +             list_del(&dma_desc->cb_node);
>> +
>> +             callback = dma_desc->txd.callback;
>> +             callback_param = dma_desc->txd.callback_param;
>> +             dma_desc->cb_due = false;
>> +             if (callback)
>> +                     callback(callback_param);
> You should mark the descriptor as complete before calling callback.
> Also tasklet is supposed to move the next pending descriptor to the
> engine, I dont see that happening here?
It is there. I am calling dma_cookie_complete from 
handle_once_dma_done() which get called from ISR.
In cyclic mode, I am not calling dma_cookie_complete() until it is 
aborted (for update the complete cookie) but cyclic/non-cyclic case I am 
calling callback.

>> +     /* Call callbacks if was pending before aborting requests */
>> +     while (!list_empty(&cb_dma_desc_list)) {
>> +             dma_desc  = list_first_entry(&cb_dma_desc_list,
>> +                             typeof(*dma_desc), cb_node);
>> +             list_del(&dma_desc->cb_node);
>> +             callback = dma_desc->txd.callback;
>> +             callback_param = dma_desc->txd.callback_param;
> again, callback would be called from tasklet, so why would it need to be
> called from here , and why would this be pending.
What happen if some callbacks are pending as tasklet does not get 
scheduled and meantime, the dma terminated (specially in multi-core system)?
Should we ignore all callbacks in this case?

