Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab2AQG0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 01:26:25 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32876 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2AQG0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 01:26:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6591"; a="153234744"
Message-ID: <4F151487.3060804@codeaurora.org>
Date: Tue, 17 Jan 2012 11:56:15 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: dan.j.williams@intel.com
CC: linux-arch@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
        vinod.koul@intel.com, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bryanh@codeaurora.org,
        tsoni@qualcomm.com, Daniel Walker <dwalker@fifo99.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        johlstei@qualcomm.com
Subject: Re: [PATCH v2 2/2] msm: DMAEngine: Add DMAEngine driver based on
 old MSM DMA APIs
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org> <1325854052-21402-3-git-send-email-kumarrav@codeaurora.org> <1325901569.10425.14.camel@m0nster> <4F0ACB65.3040802@codeaurora.org>
In-Reply-To: <4F0ACB65.3040802@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2012 4:41 PM, Ravi Kumar V wrote:
> On 1/7/2012 7:29 AM, Daniel Walker wrote:
>> On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
>>> Add DMAEngine based driver using the old MSM DMA APIs internally.
>>> The benefit of this approach is that not all the drivers
>>> have to get converted to DMAEngine APIs simultaneosly while
>>> both the drivers can stay enabled in the kernel. The client
>>> drivers using the old MSM APIs directly can now convert to
>>> DMAEngine one by one.
>>>
>>> Change-Id: I3647ed7b8c73b3078dfa8877a3560db3cb0a2373
>>> Signed-off-by: Ravi Kumar V<kumarrav@codeaurora.org>
>>> ---
>>> arch/arm/mach-msm/include/mach/dma.h | 33 ++
>>> drivers/dma/Kconfig | 12 +
>>> drivers/dma/Makefile | 1 +
>>> drivers/dma/msm-dma.c | 764 ++++++++++++++++++++++++++++++++++
>>> 4 files changed, 810 insertions(+), 0 deletions(-)
>>> create mode 100644 drivers/dma/msm-dma.c
>>>
>>> diff --git a/arch/arm/mach-msm/include/mach/dma.h
>>> b/arch/arm/mach-msm/include/mach/dma.h
>>> index 05583f5..34f4dac 100644
>>> --- a/arch/arm/mach-msm/include/mach/dma.h
>>> +++ b/arch/arm/mach-msm/include/mach/dma.h
>>> @@ -18,6 +18,39 @@
>>> #include<linux/list.h>
>>> #include<mach/msm_iomap.h>
>>>
>>> +#define msm_dma_set_crci(sg, crci) (((sg)->private_data) = \
>>> + (((sg)->private_data)& ~(0x7F8)) | \
>>> + crci)
>>> +#define msm_dma_set_endian(sg, en) (((sg)->private_data) = \
>>> + (((sg)->private_data)& ~(0x1F800)) | \
>>> + en)
>>> +#define msm_dma_set_tcb(sg, tcb) (((sg)->private_data) = \
>>> + (((sg)->private_data)& ~(0x80000)) | \
>>> + tcb)
>>> +#define sg_dma_offset(sg) ((sg)->offset)
>>> +#define sg_dma_private_data(sg) ((sg)->private_data)
>>> +#define box_dma_row_address(box) ((box)->dma_row_address)
>>> +#define box_dma_row_len(box) ((box)->dma_row_len)
>>> +#define box_dma_row_num(box) ((box)->dma_row_num)
>>> +#define box_dma_row_offset(box) ((box)->dma_row_offset)
>>> +#define box_dma_private_data(box) ((box)->private_data)
>>> +
>>> +#define MSM_DMA_CMD_MASK 0x9FFF8
>>> +#define MSM_DMA_CMD_SHIFT 0
>>> +#define MSM_BOX_SRC_RLEN_MASK 0xFFFF
>>> +#define MSM_BOX_SRC_RLEN_SHIFT 16
>>> +#define MSM_BOX_SRC_RNUM_MASK 0xFFFF
>>> +#define MSM_BOX_SRC_RNUM_SHIFT 16
>>> +#define MSM_BOX_SRC_ROFFSET_MASK 0xFFFF
>>> +#define MSM_BOX_SRC_ROFFSET_SHIFT 16
>>> +#define MSM_BOX_DST_RLEN_MASK 0xFFFF
>>> +#define MSM_BOX_DST_RNUM_MASK 0xFFFF
>>> +#define MSM_BOX_DST_ROFFSET_MASK 0xFFFF
>>> +#define MSM_BOX_MODE_CMD 0x3
>>> +
>>> +#define FORCED_FLUSH 0
>>> +#define GRACEFUL_FLUSH 1
>>
>> Could be an enum ..
>>
>>> struct msm_dmov_errdata {
>>> uint32_t flush[6];
>>> };
>>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>>> index ab8f469..3e69f42 100644
>>> --- a/drivers/dma/Kconfig
>>> +++ b/drivers/dma/Kconfig
>>> @@ -245,6 +245,18 @@ config EP93XX_DMA
>>> help
>>> Enable support for the Cirrus Logic EP93xx M2P/M2M DMA controller.
>>>
>>> +config MSM_DMA
>>> + tristate "Qualcomm MSM DMA support"
>>> + depends on ARCH_MSM
>>> + select DMA_ENGINE
>>> + help
>>> + Support the Qualcomm DMA engine. This engine is integrated into
>>> + Qualcomm chips.
>>> +
>>> + Say Y here if you have such a chipset.
>>> +
>>> + If unsure, say N.
>>> +
>>> config DMA_ENGINE
>>> bool
>>>
>>> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
>>> index 30cf3b1..56593f0 100644
>>> --- a/drivers/dma/Makefile
>>> +++ b/drivers/dma/Makefile
>>> @@ -19,6 +19,7 @@ obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
>>> obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
>>> obj-$(CONFIG_IMX_SDMA) += imx-sdma.o
>>> obj-$(CONFIG_IMX_DMA) += imx-dma.o
>>> +obj-$(CONFIG_MSM_DMA) += msm-dma.o
>>> obj-$(CONFIG_MXS_DMA) += mxs-dma.o
>>> obj-$(CONFIG_TIMB_DMA) += timb_dma.o
>>> obj-$(CONFIG_STE_DMA40) += ste_dma40.o ste_dma40_ll.o
>>> diff --git a/drivers/dma/msm-dma.c b/drivers/dma/msm-dma.c
>>> new file mode 100644
>>> index 0000000..51d9a2b
>>> --- /dev/null
>>> +++ b/drivers/dma/msm-dma.c
>>> @@ -0,0 +1,764 @@
>>> +/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 and
>>> + * only version 2 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>>> + * GNU General Public License for more details.
>>> + */
>>> +#include<linux/init.h>
>>> +#include<linux/slab.h>
>>> +#include<linux/clk.h>
>>> +#include<linux/err.h>
>>> +#include<linux/io.h>
>>> +#include<linux/interrupt.h>
>>> +#include<linux/module.h>
>>> +#include<linux/platform_device.h>
>>> +#include<linux/spinlock.h>
>>> +#include<linux/dmapool.h>
>>> +#include<linux/dmaengine.h>
>>> +#include<linux/dma-mapping.h>
>>> +
>>> +#include<mach/dma.h>
>>> +
>>> +#define SD3_CHAN_START 0
>>> +#define MSM_DMOV_CRCI_COUNT 16
>>> +#define MSM_DMA_MAX_CHANS_PER_DEVICE 16
>>> +#define MAX_TRANSFER_LENGTH 65535
>>> +#define NO_ERR_CHAN_STATUS 0x80000002
>>> +#define to_msm_chan(chan) container_of(chan, struct msm_dma_chan,
>>> channel)
>>> +
>>> +struct msm_dma_chan {
>>> + int chan_id;
>>> + dma_cookie_t completed_cookie;
>>> + dma_cookie_t error_cookie;
>>> + spinlock_t lock;
>>> + struct list_head active_list;
>>> + struct list_head pending_list;
>>> + struct dma_chan channel;
>>> + struct dma_pool *desc_pool;
>>> + struct device *dev;
>>> + int max_len;
>>> + int err;
>>> + struct tasklet_struct tasklet;
>>> +};
>>> +
>>> +struct msm_dma_device {
>>> + void __iomem *base;
>>> + struct device *dev;
>>> + struct dma_device common;
>>> + struct msm_dma_chan *chan[MSM_DMA_MAX_CHANS_PER_DEVICE];
>>> +};
>>> +
>>> +struct msm_dma_desc_hw {
>>> + unsigned int cmd_list_ptr;
>>> +} __aligned(8);
>>> +
>>> +/* Single Item Mode */
>>> +struct adm_cmd_t {
>>> + unsigned int cmd_cntrl;
>>> + unsigned int src;
>>> + unsigned int dst;
>>> + unsigned int len;
>>> +};
>>> +
>>> +struct adm_box_cmd_t {
>>> + uint32_t cmd_cntrl;
>>> + uint32_t src_row_addr;
>>> + uint32_t dst_row_addr;
>>> + uint32_t src_dst_len;
>>> + uint32_t num_rows;
>>> + uint32_t row_offset;
>>> +};
>>> +
>>> +struct msm_dma_desc_sw {
>>> + struct msm_dma_desc_hw hw;
>>> + struct adm_cmd_t *vaddr_cmd;
>>> + struct adm_box_cmd_t *vaddr_box_cmd;
>>> + size_t coherent_size;
>>> + dma_addr_t paddr_cmd_list;
>>> + struct list_head node;
>>> + struct msm_dmov_cmd dmov_cmd;
>>> + struct dma_async_tx_descriptor async_tx;
>>> +} __aligned(8);
>>> +
>>> +static int msm_dma_alloc_chan_resources(struct dma_chan *dchan)
>>> +{
>>> + struct msm_dma_chan *chan = to_msm_chan(dchan);
>>> +
>>> + /* Has this channel already been allocated? */
>>> + if (chan->desc_pool)
>>> + return 1;
>>> +
>>> + /*
>>> + * We need the descriptor to be aligned to 8bytes
>>> + * for meeting ADM specification requirement.
>>> + */
>>> + chan->desc_pool = dma_pool_create("msm_dma_desc_pool",
>>> + chan->dev,
>>> + sizeof(struct msm_dma_desc_sw),
>>> + __alignof__(struct msm_dma_desc_sw), 0);
>>> + if (!chan->desc_pool) {
>>> + dev_err(chan->dev, "unable to allocate channel %d "
>>> + "descriptor pool\n", chan->chan_id);
>>> + return -ENOMEM;
>>> + }
>>> +
>>> + chan->completed_cookie = 1;
>>> + dchan->cookie = 1;
>>> +
>>> + /* there is at least one descriptor free to be allocated */
>>> + return 1;
>>> +}
>>> +
>>> +static void msm_dma_free_desc_list(struct msm_dma_chan *chan,
>>> + struct list_head *list)
>>> +{
>>> + struct msm_dma_desc_sw *desc, *_desc;
>>> +
>>> + list_for_each_entry_safe(desc, _desc, list, node) {
>>> + list_del(&desc->node);
>>> + dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
>>> + }
>>> +}
>>> +
>>> +static void msm_dma_free_chan_resources(struct dma_chan *dchan)
>>> +{
>>> + struct msm_dma_chan *chan = to_msm_chan(dchan);
>>> + unsigned long flags;
>>> +
>>> + dev_dbg(chan->dev, "Free all channel resources.\n");
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> + msm_dma_free_desc_list(chan,&chan->active_list);
>>> + msm_dma_free_desc_list(chan,&chan->pending_list);
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> +
>>> + dma_pool_destroy(chan->desc_pool);
>>> + chan->desc_pool = NULL;
>>> +}
>>> +
>>> +static enum dma_status msm_dma_desc_status(struct msm_dma_chan *chan,
>>> + struct msm_dma_desc_sw *desc)
>>> +{
>>> + return dma_async_is_complete(desc->async_tx.cookie,
>>> + chan->completed_cookie,
>>> + chan->channel.cookie);
>>> +}
>>> +
>>> +static void msm_chan_desc_cleanup(struct msm_dma_chan *chan)
>>> +{
>>> + struct msm_dma_desc_sw *desc, *_desc;
>>> + unsigned long flags;
>>> +
>>> + dev_dbg(chan->dev, "Cleaning completed descriptor of channel %d\n",
>>> + chan->chan_id);
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> +
>>> + list_for_each_entry_safe(desc, _desc,&chan->active_list, node) {
>>> + dma_async_tx_callback callback;
>>> + void *callback_param;
>>> +
>>> + if (msm_dma_desc_status(chan, desc) == DMA_IN_PROGRESS)
>>> + break;
>>> +
>>> + /* Remove from the list of running transactions */
>>> + list_del(&desc->node);
>>> +
>>> + /* Run the link descriptor callback function */
>>> + callback = desc->async_tx.callback;
>>> + callback_param = desc->async_tx.callback_param;
>>> + if (callback) {
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> + callback(callback_param);
>>
>> Are you sure unlocking here is safe? at_hdmac.c holds the lock the
>> entire time, and fsldma.c deletes the entire list, then runs the
>> operations.
>>
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> + }
>>> +
>>> + /* Run any dependencies, then free the descriptor */
>>> + dma_run_dependencies(&desc->async_tx);
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> +
>>> + if (desc->vaddr_cmd) {
>>> + dma_free_coherent(chan->dev, desc->coherent_size,
>>> + (void *)desc->vaddr_cmd,
>>> + desc->paddr_cmd_list);
>>> + } else {
>>> + dma_free_coherent(chan->dev, desc->coherent_size,
>>> + (void *)desc->vaddr_box_cmd,
>>> + desc->paddr_cmd_list);
>>> + }
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> + dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
>>> + }
>>> +
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> +}
>>> +
>>> +static void dma_do_tasklet(unsigned long data)
>>> +{
>>> + struct msm_dma_chan *chan = (struct msm_dma_chan *)data;
>>> + msm_chan_desc_cleanup(chan);
>>> +}
>>> +
>>> +static void
>>> +msm_dma_complete_func(struct msm_dmov_cmd *cmd,
>>> + unsigned int result,
>>> + struct msm_dmov_errdata *err)
>>> +{
>>> + unsigned long flags;
>>> + struct msm_dma_desc_sw *desch = container_of(cmd,
>>> + struct msm_dma_desc_sw, dmov_cmd);
>>> + struct msm_dma_chan *chan = to_msm_chan(desch->async_tx.chan);
>>> +
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> +
>>> + if ((result != NO_ERR_CHAN_STATUS)&& err)
>>> + chan->error_cookie = desch->async_tx.cookie;
>>> + chan->completed_cookie = desch->async_tx.cookie;
>>> +
>>> + tasklet_schedule(&chan->tasklet);
>>> +
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> +}
>>> +
>>> +/*
>>> + * Passes transfer descriptors to DMA hardware.
>>> + */
>>> +static void msm_dma_issue_pending(struct dma_chan *dchan)
>>> +{
>>> + struct msm_dma_chan *chan = to_msm_chan(dchan);
>>> + struct msm_dma_desc_sw *desch;
>>> + unsigned long flags;
>>> +
>>> + if (chan->err)
>>> + return;
>>> +
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> +
>>> + if (list_empty(&chan->pending_list))
>>> + goto out_unlock;
>>> +
>>> + desch = list_first_entry(&chan->pending_list, struct msm_dma_desc_sw,
>>> + node);
>>> + list_del(&desch->node);
>>> + desch->dmov_cmd.complete_func = msm_dma_complete_func;
>>> + desch->dmov_cmd.execute_func = NULL;
>>> + desch->dmov_cmd.cmdptr = DMOV_CMD_ADDR(desch->async_tx.phys);
>>> + list_add_tail(&desch->node,&chan->active_list);
>>> + mb();
>>> + msm_dmov_enqueue_cmd(chan->chan_id,&desch->dmov_cmd);
>>> +out_unlock:
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> +}
>>> +
>>> +/*
>>> + * Assignes cookie for each transfer descriptor passed.
>>> + * Returns
>>> + * Assigend cookie for success.
>>> + * Error value for failure.
>>> + */
>>> +static dma_cookie_t msm_dma_tx_submit(struct dma_async_tx_descriptor
>>> *tx)
>>> +{
>>> + struct msm_dma_chan *chan = to_msm_chan(tx->chan);
>>> + struct msm_dma_desc_sw *desc = container_of(tx,
>>> + struct msm_dma_desc_sw, async_tx);
>>> + unsigned long flags;
>>> + dma_cookie_t cookie = -EBUSY;
>>> +
>>> + if (chan->err)
>>> + return cookie;
>>> +
>>> + spin_lock_irqsave(&chan->lock, flags);
>>> +
>>> + /*
>>> + * assign cookies to all of the software descriptors
>>> + * that make up this transaction
>>> + */
>>> + cookie = chan->channel.cookie;
>>> + cookie++;
>>> + if (cookie< 0)
>>> + cookie = DMA_MIN_COOKIE;
>>> +
>>> + desc->async_tx.cookie = cookie;
>>> + chan->channel.cookie = cookie;
>>> +
>>> + /* put this transaction onto the tail of the pending queue */
>>> + list_add_tail(&desc->node,&chan->pending_list);
>>> +
>>> + spin_unlock_irqrestore(&chan->lock, flags);
>>> +
>>> + return cookie;
>>> +}
>>> +
>>> +/*
>>> + * Returns the DMA transfer status of a particular cookie
>>> + */
>>> +static enum dma_status msm_tx_status(struct dma_chan *dchan,
>>> + dma_cookie_t cookie,
>>> + struct dma_tx_state *txstate)
>>> +{
>>> + struct msm_dma_chan *chan = to_msm_chan(dchan);
>>> + dma_cookie_t last_used;
>>> + dma_cookie_t last_complete;
>>> + enum dma_status status;
>>> +
>>> + last_used = dchan->cookie;
>>> + last_complete = chan->completed_cookie;
>>> +
>>> + dma_set_tx_state(txstate, last_complete, last_used, 0);
>>> +
>>> + status = dma_async_is_complete(cookie, last_complete, last_used);
>>> +
>>> + if (status != DMA_IN_PROGRESS)
>>> + if (chan->error_cookie == cookie)
>>> + status = DMA_ERROR;
>>> +
>>> + return status;
>>> +}
>>> +
>>> +static struct msm_dma_desc_sw *msm_dma_alloc_descriptor(
>>> + struct msm_dma_chan *chan,
>>> + int cmd_cnt,
>>> + int mask)
>>> +{
>>> + struct msm_dma_desc_sw *desc;
>>> + dma_addr_t pdesc_addr;
>>> + dma_addr_t paddr_cmd_list;
>>> + void *err = NULL;
>>> +
>>> + desc = dma_pool_alloc(chan->desc_pool, GFP_ATOMIC,&pdesc_addr);
>>> + if (!desc) {
>>> + dev_dbg(chan->dev, "out of memory for desc\n");
>>> + return ERR_CAST(desc);
>>> + }
>>> +
>>> + memset(desc, 0, sizeof(*desc));
>>> + desc->async_tx.phys = pdesc_addr;
>>> +
>>> + if (mask == DMA_BOX) {
>>> + desc->coherent_size = sizeof(struct adm_box_cmd_t);
>>> + desc->vaddr_box_cmd = dma_alloc_coherent(chan->dev,
>>> + sizeof(struct adm_box_cmd_t),
>>> + &paddr_cmd_list, GFP_ATOMIC);
>>> + if (!desc->vaddr_box_cmd) {
>>> + dev_dbg(chan->dev, "out of memory for desc\n");
>>> + err = desc->vaddr_box_cmd;
>>> + goto fail;
>>> + }
>>> + } else {
>>> + desc->coherent_size = sizeof(struct adm_cmd_t)*cmd_cnt;
>>> +
>>> + desc->vaddr_cmd = dma_alloc_coherent(chan->dev,
>>> + sizeof(struct adm_cmd_t)*cmd_cnt,
>>> + &paddr_cmd_list, GFP_ATOMIC);
>>> +
>>> + if (!desc->vaddr_cmd) {
>>> + dev_dbg(chan->dev, "out of memory for desc\n");
>>> + err = desc->vaddr_cmd;
>>> + goto fail;
>>> + }
>>> + }
>>> +
>>> + dma_async_tx_descriptor_init(&desc->async_tx,&chan->channel);
>>> + desc->async_tx.tx_submit = msm_dma_tx_submit;
>>> + desc->paddr_cmd_list = paddr_cmd_list;
>>> + desc->hw.cmd_list_ptr = (paddr_cmd_list>> 3) | CMD_PTR_LP;
>>> + return desc;
>>> +fail:
>>> + dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
>>> + return ERR_CAST(err);
>>> +}
>>> +
>>> +/*
>>> + * Prepares the transfer descriptors for SG transaction.
>>> + * Returns
>>> + * address of dma_async_tx_descriptor for success.
>>> + * Pointer of error value for failure.
>>> + */
>>> +static struct dma_async_tx_descriptor *msm_dma_prep_sg(
>>> + struct dma_chan *dchan,
>>> + struct scatterlist *dst_sg, unsigned int dst_nents,
>>> + struct scatterlist *src_sg, unsigned int src_nents,
>>> + unsigned long flags)
>>> +{
>>> +
>>> + struct msm_dma_chan *chan;
>>> + struct msm_dma_desc_sw *new;
>>> + size_t copy, len;
>>> + int cmd_cnt = 0;
>>> + int first = 0;
>>> + int i;
>>> + dma_addr_t src;
>>> + dma_addr_t dst;
>>> + struct adm_cmd_t *cmdlist_vaddr;
>>> + struct scatterlist *sg;
>>> +
>>> + if (!dchan)
>>> + return ERR_PTR(-EINVAL);
>>> +
>>> + if (dst_nents == 0 || src_nents == 0)
>>> + return ERR_PTR(-EINVAL);
>>> + if (!dst_sg || !src_sg)
>>> + return ERR_PTR(-EINVAL);
>>> +
>>> + if (dst_nents != src_nents)
>>> + return ERR_PTR(-EINVAL);
>>> +
>>> + chan = to_msm_chan(dchan);
>>> +
>>> + cmd_cnt = src_nents;
>>> +
>>> + for (i = 0; i< src_nents; i++) {
>>> + len = sg_dma_len(src_sg + i);
>>> + if (len != MAX_TRANSFER_LENGTH)
>>> + cmd_cnt += len/MAX_TRANSFER_LENGTH;
>>> + }
>>> +
>>> + new = msm_dma_alloc_descriptor(chan, cmd_cnt, DMA_SG);
>>> +
>>> + if (!new) {
>>> + dev_err(chan->dev,
>>> + "No free memory for link descriptor\n");
>>> + return ERR_PTR(-ENOMEM);
>>> + }
>>> +
>>> + cmdlist_vaddr = new->vaddr_cmd;
>>> +
>>> + for_each_sg(src_sg, sg, src_nents, i) {
>>> + len = sg_dma_len(sg);
>>> + src = sg_dma_address(sg);
>>> + do {
>>> + copy = (len>= MAX_TRANSFER_LENGTH) ?
>>> + MAX_TRANSFER_LENGTH : len;
>>> + cmdlist_vaddr->src = src;
>>> + cmdlist_vaddr->len = copy;
>>> + cmdlist_vaddr->cmd_cntrl =
>>> + (sg_dma_private_data(sg)& MSM_DMA_CMD_MASK);
>>> + if (first == 0) {
>>> + if (cmd_cnt == 1)
>>> + cmdlist_vaddr->cmd_cntrl = CMD_LC |
>>> + CMD_OCB | CMD_OCU;
>>> + else
>>> + cmdlist_vaddr->cmd_cntrl = CMD_OCB;
>>> + first = 1;
>>> + }
>>> + cmdlist_vaddr++;
>>> + len -= copy;
>>> + src += copy;
>>> + } while (len);
>>> + }
>>> + if (cmd_cnt> 1) {
>>> + cmdlist_vaddr--;
>>> + cmdlist_vaddr->cmd_cntrl |= CMD_LC | CMD_OCU;
>>> + }
>>> +
>>> + cmdlist_vaddr = new->vaddr_cmd;
>>> +
>>> + for_each_sg(dst_sg, sg, src_nents, i) {
>>> + len = sg_dma_len(sg);
>>> + dst = sg_dma_address(sg);
>>> + do {
>>> + copy = (len>= MAX_TRANSFER_LENGTH) ?
>>> + MAX_TRANSFER_LENGTH : len;
>>> + cmdlist_vaddr->dst = dst;
>>> + cmdlist_vaddr++;
>>> + len -= copy;
>>> + dst += copy;
>>> + } while (len);
>>> +
>>> + }
>>> +
>>> +#ifdef DEBUG
>>> + cmdlist_vaddr = new->vaddr_cmd;
>>> + i = 0;
>>> + do {
>>> + dev_dbg(chan->dev, "cmd %d src 0x%x dst 0x%x len 0x%x "
>>> + "cntrl 0x%x\n",
>>> + i, cmdlist_vaddr->src, cmdlist_vaddr->dst,
>>
>> Doesn't look like "i" has a log of meaning here.
>>
>> If it were me I'd make the two #ifdef DEBUG blocks into helper
>> functions, then you could combine them into a single block. Would look
>> cleaner too I think.
>>
>>> + cmdlist_vaddr->len, cmdlist_vaddr->cmd_cntrl);
>>> + cmdlist_vaddr++;
>>> + } while (!((cmdlist_vaddr-1)->cmd_cntrl& CMD_LC));
>>> +#endif
>>
>>> + new->async_tx.flags = flags;
>>> + new->async_tx.cookie = -EBUSY;
>>> +
>>> + return&new->async_tx;
>>> +}
>>> +
>>> +/*
>>> + * Prepares the transfer descriptors for BOX transaction.
>>> + * Returns
>>> + * address of dma_async_tx_descriptor for success.
>>> + * Pointer of error value for failure.
>>> + */
>>> +static struct dma_async_tx_descriptor *msm_dma_prep_box(
>>> + struct dma_chan *dchan,
>>> + struct dma_box_list *dst_box, struct dma_box_list *src_box,
>>> + unsigned int num_list, unsigned long flags)
>>> +{
>>> + struct msm_dma_chan *chan;
>>> + struct msm_dma_desc_sw *new;
>>> + int cmd_cnt = 0;
>>> + int first = 0;
>>> + int i;
>>> + struct adm_box_cmd_t *box_cmd_vaddr;
>>> +
>>> + if (!dchan)
>>> + return ERR_PTR(-EINVAL);
>>> +
>>> + if (num_list == 0)
>>> + return ERR_PTR(-EINVAL);
>>> + if (!dst_box || !src_box)
>>> + return ERR_PTR(-EINVAL);
>>> +
>>> + chan = to_msm_chan(dchan);
>>> +
>>> + cmd_cnt = num_list;
>>> +
>>> + new = msm_dma_alloc_descriptor(chan, cmd_cnt, DMA_BOX);
>>> +
>>> + if (!new) {
>>> + dev_err(chan->dev,
>>> + "No free memory for link descriptor\n");
>>> + return ERR_PTR(-ENOMEM);
>>> + }
>>> + box_cmd_vaddr = new->vaddr_box_cmd;
>>> +
>>> + for (i = 0; i< num_list; i++) {
>>> +
>>> + box_cmd_vaddr->src_row_addr =
>>> + box_dma_row_address(src_box + i);
>>> + box_cmd_vaddr->src_dst_len =
>>> + (box_dma_row_len(src_box + i)&
>>> + MSM_BOX_SRC_RLEN_MASK)<<
>>> + MSM_BOX_SRC_RLEN_SHIFT;
>>> + box_cmd_vaddr->cmd_cntrl =
>>> + (box_dma_private_data(src_box + i)&
>>> + MSM_DMA_CMD_MASK) | MSM_BOX_MODE_CMD;
>>> +
>>> + box_cmd_vaddr->num_rows = (box_dma_row_num(src_box + i)&
>>> + MSM_BOX_SRC_RNUM_MASK)<<
>>> + MSM_BOX_SRC_RNUM_SHIFT;
>>> +
>>> + box_cmd_vaddr->row_offset = (box_dma_row_offset(src_box + i)&
>>> + MSM_BOX_SRC_ROFFSET_MASK)<<
>>> + MSM_BOX_SRC_ROFFSET_SHIFT;
>>> +
>>> + if (first == 0) {
>>> + if (cmd_cnt == 1)
>>> + box_cmd_vaddr->cmd_cntrl |=
>>> + CMD_LC | CMD_OCB | CMD_OCU;
>>> + else
>>> + box_cmd_vaddr->cmd_cntrl |=
>>> + CMD_OCB;
>>> + first = 1;
>>> + }
>>> + box_cmd_vaddr++;
>>> + }
>>> +
>>> + if (cmd_cnt> 1) {
>>> + box_cmd_vaddr--;
>>> + box_cmd_vaddr->cmd_cntrl |= CMD_LC | CMD_OCU;
>>> + }
>>> +
>>> + box_cmd_vaddr = new->vaddr_box_cmd;
>>> +
>>> + for (i = 0; i< num_list; i++) {
>>> +
>>> + box_cmd_vaddr->dst_row_addr = box_dma_row_address(dst_box + i);
>>> + box_cmd_vaddr->src_dst_len |=
>>> + (box_dma_row_len(dst_box + i)& MSM_BOX_DST_RLEN_MASK);
>>> + box_cmd_vaddr->num_rows |=
>>> + (box_dma_row_num(dst_box + i)&
>>> + MSM_BOX_DST_RNUM_MASK);
>>> +
>>> + box_cmd_vaddr->row_offset |=
>>> + (box_dma_row_offset(dst_box + i)&
>>> + MSM_BOX_DST_ROFFSET_MASK);
>>> + box_cmd_vaddr++;
>>> + }
>>> +#ifdef DEBUG
>>> + i = 0;
>>> + box_cmd_vaddr = new->vaddr_box_cmd;
>>> + do {
>>> + dev_dbg(chan->dev, "cmd %d src 0x%x dst 0x%x len 0x%x "
>>> + "cntrl 0x%x row_offset 0x%x num_rows 0x%x\n",
>>> + i, box_cmd_vaddr->src_row_addr,
>>> + box_cmd_vaddr->dst_row_addr,
>>> + box_cmd_vaddr->src_dst_len,
>>> + box_cmd_vaddr->cmd_cntrl,
>>> + box_cmd_vaddr->row_offset,
>>> + box_cmd_vaddr->num_rows);
>>> + box_cmd_vaddr++;
>>> + i++;
>>> + } while (!((box_cmd_vaddr-1)->cmd_cntrl& CMD_LC));
>>> +#endif
>>> + new->async_tx.flags = flags;
>>> + new->async_tx.cookie = -EBUSY;
>>> +
>>> + return&new->async_tx;
>>> +}
>>> +
>>> +/*
>>> + * Controlling the hardware channel like stopping, flushing.
>>> + */
>>> +static int msm_dma_chan_control(struct dma_chan *chan, enum
>>> dma_ctrl_cmd cmd,
>>> + unsigned long arg)
>>> +{
>>> + int cmd_type = (int) arg;
>>
>> Why do you need to cast here? Both the flush macro's are positive.
>>
>>> +
>>> + if (cmd == DMA_TERMINATE_ALL) {
>>> + switch (cmd_type) {
>>> + case GRACEFUL_FLUSH:
>>> + msm_dmov_stop_cmd(chan->chan_id, NULL, 1);
>>> + break;
>>> + case FORCED_FLUSH:
>>> + /*
>>> + * We treate default as forced flush
>>> + * so we fall through
>>> + */
>>> + default:
>>> + msm_dmov_stop_cmd(chan->chan_id, NULL, 0);
>>> + break;
>>> + }
>>> + }
>>> + return 0;
>>> +}
>>> +
>>
>>
>
> I will address the comments in next patch release, i will wait for
> sometime for vinod comments and release new patch v3.
>
> Ravi

Dan williams please can you review my patch and let me know your comments.

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
