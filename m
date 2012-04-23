Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2DWIo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 04:44:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:13166 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab2DWIo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 04:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="134108548"
Subject: Re: [PATCH V1] dmaengine: tegra: add dma driver
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Laxman Dewangan <ldewangan@nvidia.com>, rmk <rmk@arm.linux.org.uk>
Cc: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <4F9153AF.7020901@nvidia.com>
References: <1334912896-4614-1-git-send-email-ldewangan@nvidia.com>
	 <1334920487.31825.98.camel@vkoul-udesk3>  <4F9153AF.7020901@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Apr 2012 14:11:31 +0530
Message-ID: <1335170491.31825.104.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 17:46 +0530, Laxman Dewangan wrote:
> Thanks Vinod for quick review.
Since I was on vacation, I hadn't noticed Russell has already sent the
patches for omap dma support.
http://permalink.gmane.org/gmane.linux.ports.arm.omap/75034

It would be nice if both the efforts are coordinated.

Btw I like the virtual channel support introduced by Russell

> 
> On Friday 20 April 2012 04:44 PM, Vinod Koul wrote:
> > On Fri, 2012-04-20 at 14:38 +0530, Laxman Dewangan wrote:
> > + * dma_transfer_mode: Different dma transfer mode.
> >> + * DMA_MODE_ONCE: Dma transfer the configured buffer once and at the end of
> >> + *           transfer, dma  stops automatically and generates interrupt
> >> + *           if enabled. SW need to reprogram dma for next transfer.
> >> + * DMA_MODE_CYCLE: Dma keeps transferring the same buffer again and again
> >> + *           until dma stopped explicitly by SW or another buffer configured.
> >> + *           After transfer completes, dma again starts transfer from
> >> + *           beginning of buffer without sw intervention. If any new
> >> + *           address/size is configured during buffer transfer then
> >> + *           dma start transfer with new configuration otherwise it
> >> + *           will keep transferring with old configuration. It also
> >> + *           generates the interrupt after buffer transfer completes.
> > why do you need to define this? use the cyclic api to convey this
> 
> This is not the public definition, only used in dma_driver locally. The 
> tegra dma support the cyclic mode in two ways;
> Cyclic single interrupt mode on which it generates interrupt once full 
> buffer transfer completes and hw keep transferring the data from start 
> of buffer without sw intervention.
> Cyclic double interrupt mode on which it generates interrupt two times, 
> once after half buffer and second after full buffer. The hw keep 
> transferring buffer in cyclic manner.
> 
> I am using these mode based on how cyclic parameter is passed from client.
> If period_len is half of buffer len the using cyclic double interrupt 
> mode and hence configure dma once for two interrupt.
> For other cases, I am using the cyclic single interrupt mode.
> 
> 
> 
> >> + * DMA_MODE_CYCLE_HALF_NOTIFY: In this mode dma keeps transferring the buffer
> >> + *           into two folds. This is kind of ping-pong buffer where both
> >> + *           buffer size should be same. Dma completes the one buffer,
> >> + *           generates interrupt and keep transferring the next buffer
> >> + *           whose address start just next to first buffer. At the end of
> >> + *           second buffer transfer, dma again generates interrupt and
> >> + *           keep transferring of the data from starting of first buffer.
> >> + *           If sw wants to change the address/size of the buffer then
> >> + *           it needs to change only when dma transferring the second
> >> + *           half of buffer. In dma configuration, it only need to
> >> + *           configure starting of first buffer and size of first buffer.
> >> + *           Dma hw assumes that striating address of second buffer is just
> >> + *           next to end of first buffer and size is same as the first
> >> + *           buffer.
> > isnt this a specifc example of cylci and frankly why should dmaengine
> > care about this. This one of the configurations you are passing for a
> > cyclic dma operation
> 
> No special configuration is passed. Just based on buf_len and 
> period_len, the mode get selected.
> 
> >> + */
> >> +enum dma_transfer_mode {
> >> +     DMA_MODE_NONE,
> >> +     DMA_MODE_ONCE,
> >> +     DMA_MODE_CYCLE,
> >> +     DMA_MODE_CYCLE_HALF_NOTIFY,
> >> +};
> >> +
> >> +/* List of memory allocated for that channel */
> >> +struct tegra_dma_chan_mem_alloc {
> >> +     struct list_head        node;
> >> +};
> > this seems questionable too...
> 
> When we allocate the channel, initially allocate some descriptors with 
> some initial count. If client has more request and if it is found out of 
> descriptor then we reallocate the some more descriptors. All these 
> allocations are dynamically and when Chanel got released, it frees all 
> allocations.
> This structure is to maintain the list of memory pointers which are 
> allocated.
> 
> here I am allocating chunk of descriptor in one shot, not one by one. If 
> I allocate descriptor one by one then I will not need this structure. 
> tried to optimize the malloc call here.
> 
> 
> >> + * The client's request for data transfer can be broken into multiple
> >> + * sub-transfer as per requestor details and hw support.
> > typo                      ^^^^^^^^^
> 
> Will fix this.
> 
> >> + * tegra_dma_desc: Tegra dma descriptors which manages the client requests.
> >> + * This de scripts keep track of transfer status, callbacks, transfer and
> > again     ^^^^
> Will fix this, thanks for pointing. My spell check did not found it.
> 
> 
> >> +
> >> +static dma_cookie_t tegra_dma_tx_submit(struct dma_async_tx_descriptor *tx);
> >> +
> >> +static int allocate_tegra_desc(struct tegra_dma_channel *tdc,
> >> +             int ndma_desc, int nsg_req)
> > what does the last arg mean?
> 
> This is number of transfer request. So if client call the prep_slave or 
> prep_dma_cyclic with multiple segment/period len then this structure 
> will contain the details of sub transfer per segment/period_len.
> And it allocate one main dma_descriptor which have the transfer 
> descriptor. So one dma_desc which is allocated one per call will contain 
> list of such transfer requests.
> 
> >> +     INIT_LIST_HEAD(&sg_req_list);
> >> +
> >> +     /* Calculate total require size of memory and then allocate */
> >> +     dma_desc_size = sizeof(struct tegra_dma_desc) * ndma_desc;
> >> +     sg_req_size = sizeof(struct tegra_dma_sg_req) * nsg_req;
> >> +     chan_mem_size = sizeof(struct tegra_dma_chan_mem_alloc);
> >> +     total_size = chan_mem_size + dma_desc_size + sg_req_size;
> > why cant you simply allocate three structs you need?
> 
> So allocation is done for number of dma desc and number of request 
> structure and the structure which keeps track for allocated pointers.
> Here I am calculating total allocation size and then allocating once in 
> place of allocating them in loop.
> 
> >> +static int tegra_dma_slave_config(struct dma_chan *dc,
> >> +             struct dma_slave_config *sconfig)
> >> +{
> >> +     struct tegra_dma_channel *tdc = to_tegra_dma_chan(dc);
> >> +
> >> +     if (!list_empty(&tdc->pending_sg_req)) {
> >> +             dev_err(tdc2dev(tdc),
> >> +                  "dma requests are pending, cannot take new configuration");
> >> +             return -EBUSY;
> >> +     }
> >> +
> >> +     /* Slave specific configuration is must for channel configuration */
> >> +     if (!dc->private) {
> > private is deprecated, pls dont use that
> 
> OK,  I saw this in the linux-next and hence I used it. So is there any 
> way to send the client specific data to the dma driver.
> I will remove this.
> 
> 
> >> +
> >> +     apb_seq = APB_SEQ_WRAP_WORD_1;
> >> +
> >> +     switch (direction) {
> >> +     case DMA_MEM_TO_DEV:
> >> +             apb_ptr = tdc->dma_sconfig.dst_addr;
> >> +             apb_seq |= get_bus_width(tdc->dma_sconfig.dst_addr_width);
> >> +             csr |= CSR_DIR;
> >> +             break;
> >> +
> >> +     case DMA_DEV_TO_MEM:
> >> +             apb_ptr = tdc->dma_sconfig.src_addr;
> >> +             apb_seq |= get_bus_width(tdc->dma_sconfig.src_addr_width);
> >> +             break;
> > you dont support DMA_MEM_TO_DEV?
> >
> 
> Supported, first case ;-)
> But MEM_TO_MEM is not supported by this dma controller.
> 
> >
> >> +     if (!period_len)
> >> +             period_len = buf_len;
> > i am not sure about this assignment here. Why should period length be
> > ZERO?
> >
> 
> Just in case, if some client send it to ZERO then  setting it to buf_len 
> in place of returning error.
> 
> 
> >> +
> >> +     if (buf_len % period_len) {
> >> +             dev_err(tdc2dev(tdc),
> >> +                "buf_len %d should be multiple of period_len %d\n",
> >> +                     buf_len, period_len);
> >> +             return NULL;
> >> +     }
> > I am assuming you are also putting this as a constraint in sound driver.
> >
> 
> Yaah, I think sound driver make sure that the buf_len should be integer 
> multiple period_len. Not supporting if it is not  to reduce the complexity.
> 
> >> +
> >> +     half_buffer_notify = (buf_len == (2 * period_len)) ? true : false;
> >> +     len = (half_buffer_notify) ? buf_len / 2 : period_len;
> >> +     if ((len&  3) || (buf_addr&  3) ||
> >> +                     (len>  tdc->tdma->chip_data.max_dma_count)) {
> >> +             dev_err(tdc2dev(tdc),
> >> +                     "Dma length/memory address is not correct\n");
> > not supported would be apt
> 
> Fine. I will do it.
> 
> >> +#ifndef LINUX_TEGRA_DMA_H
> >> +#define LINUX_TEGRA_DMA_H
> >> +
> >> +/*
> >> + * tegra_dma_burst_size: Burst size of dma.
> >> + * @TEGRA_DMA_AUTO: Based on transfer size, select the burst size.
> >> + *       If it is multple of 32 bytes then burst size will be 32 bytes else
> >> + *       If it is multiple of 16 bytes then burst size will be 16 bytes else
> >> + *       If it is multiple of 4 bytes then burst size will be 4 bytes.
> >> + * @TEGRA_DMA_BURST_1: Burst size is 1 word/4 bytes.
> >> + * @TEGRA_DMA_BURST_4: Burst size is 4 word/16 bytes.
> >> + * @TEGRA_DMA_BURST_8: Burst size is 8 words/32 bytes.
> >> + */
> >> +enum tegra_dma_burst_size {
> >> +     TEGRA_DMA_AUTO,
> >> +     TEGRA_DMA_BURST_1,
> >> +     TEGRA_DMA_BURST_4,
> >> +     TEGRA_DMA_BURST_8,
> >> +};
> > why should this be global, clinet should pass them as defined in
> > dmaengine.h
> 
> The dma_slave_config on the dmaengine have the member as src_maxburst 
> and I understand that this is for maximum burst only.
> and so passing the actual burst size, I defined new enums.  Also wanted 
> to have the auto mode where I can select the BURST size based on the 
> request length.
> if some encoding and understanding is maintain between client and dma 
> driver then I can get rid of this:
> like src_maxburst = 0 is for the selection of burst size based on req 
> len otherwise use non-zero value of src_maxburst.
> 
> 
> 
> >> + * @dma_dev: required DMA master client device.
> >> + * @dm_req_id: Peripheral dma requestor ID.
> >> + */
> >> +struct tegra_dma_slave {
> >> +     struct device                   *client_dev;
> >> +     enum tegra_dma_requestor        dma_req_id;
> >> +     enum tegra_dma_burst_size       burst_size;
> > pls remove
> 
> if above is OK then I can remove this.
> 
> >> +};
> >> +
> >> +#endif /* LINUX_TEGRA_DMA_H */
> > Please also update the driver to use the cookie helpers in
> > drivers/dma/dmaengine.h
> >
> 
> I have already used cookie helper.
> 


-- 
~Vinod

