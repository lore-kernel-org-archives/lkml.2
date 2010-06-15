Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0FOF0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 01:26:22 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:42447 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752094Ab0FOF0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 01:26:21 -0400
Message-ID: <4C170EE2.4010706@st.com>
Date: Tue, 15 Jun 2010 10:55:54 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.infradead.org, yuanyabin1978@sina.com,
       linux-kernel@vger.kernel.org, Peter Pearse <peter.pearse@arm.com>,
       Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
       Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 	PrimeCells
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>	<4C15C60E.6080404@st.com> <AANLkTim9n-p-Pw6FWvzQMBiAuB3h9ILq1Ya6XWk_0l-c@mail.gmail.com>
In-Reply-To: <AANLkTim9n-p-Pw6FWvzQMBiAuB3h9ILq1Ya6XWk_0l-c@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2010 7:09 PM, Linus Walleij wrote:
> Hi Viresh, thanks a lot for reviewing this and I'd be *very* happy if
> you could give it a spin on
> the SPEAr as well!

I would be happy too linus, will do it in few weeks, right now we are running
short of time.

> 
> 2010/6/14 Viresh KUMAR <viresh.kumar@st.com>:
>>> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
>>> (...)
>>> + * (Bursts are irrelevant for mem to mem transfers - there are no burst
>>> + * signals)
>>
>> I agree that there are no request lines from memories but still we can program
>> them with burst in order to faster the transfer. This burst feature is
>> automatically handled by DMA.
> 
> Actually in the example platform data I set this to the maxburst size
> 256 Bytes, however if I read the manual correctly this is simply ignored
> when you do mem2mem transfers.
> 
> It will simply AHB master the bus until the transaction is finished. That
> is why the manual states:
> 
> "You must program memory-to-memory transfers with a low channel
> priority, otherwise:
> •    other DMA channels cannot access the bus until the
> memory-to-memory transfer
>      has finished
> •    other AHB masters cannot perform any transaction."

Yes i have seen them. One more thing i have found related to mem to mem
transfers is:
"You must set this value to the burst size of the destination peripheral,
or if the destination is memory, to the memory boundary size."

>>> +static void pl08x_set_cregs(struct pl08x_driver_data *pl08x,
>>> +                         struct pl08x_phy_chan *ch)
>>> +{
>>> +     u32 val;
>>> +
>>> +     /* Wait for channel inactive */
>>> +     val = readl(ch->base + PL080_CH_CONFIG);
>>> +     while (val & PL080_CONFIG_ACTIVE)
>>> +             val = readl(ch->base + PL080_CH_CONFIG);
>>
>> can we use pl08x_phy_channel_busy() instead of above code?
> 
> Fixed.
> 
>>> +     /*
>>> +      * Do not access config register until channel shows as inactive
>>> +      */
>>> +     val = readl(ch->base + PL080_CH_CONFIG);
>>> +     while ((val & PL080_CONFIG_ACTIVE) || (val & PL080_CONFIG_ENABLE))
>>> +             val = readl(ch->base + PL080_CH_CONFIG);
>>
>> above 3 fns are always called in order, i.e. pl08x_enable_phy_chan will
>> be called after pl08x_set_cregs, so we may not require these checks
>> here. Is my understanding correct??
> 
> The previous check if the channel is active before proceeding, this check also
> checks the enable bit, this behaviour comes straight from the manual and is
> required to avoid hardware races, so I don't dare to touch it really...
> 

I was talking about the similar check present in pl08x_set_cregs, which will
be called before this routine. pl08x_set_cregs has already checked if channel
is active or not. so checking active in this routine is not required.


>>> +     .device_alloc_chan_resources    = pl08x_alloc_chan_resources,
>>> +     .device_free_chan_resources     = pl08x_free_chan_resources,
>>> +     .device_prep_dma_xor            = NULL,
>>> +     .device_prep_dma_memset         = NULL,
>>> +     .device_prep_dma_interrupt      = pl08x_prep_dma_interrupt,
>>> +     .device_tx_status               = pl08x_dma_tx_status,
>>> +     .device_issue_pending           = pl08x_issue_pending,
>>> +     .device_prep_slave_sg           = pl08x_prep_slave_sg,
>>> +     .device_control                 = pl08x_control,
>>> +};
>>> +
>>
>> One more thing linus, why do we need to create this separation between
>> channels. i.e. few are for memcpy and few for slave_sg. Why don't all
>> channels support everything and this is resolved at runtime.
> 
> This is done in all in-tree drivers, the reason is (I think) that for example
> the dmatest.c test client will look for:
> 
> 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
> 		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
> 		thread_count += cnt > 0 ? cnt : 0;
> 
> So if you want to partition some channels for device I/O (typically some
> which are hard-coded to some devices) and others for memcpy() you create
> a slave instance for the former and a memcpy() instance for the latter.
> 
> In this case we multiplex the memcpy and slave transfers on the few
> physical channels we have, but I haven't finally decided how to handle this:
> perhaps we should always set on physical channel aside for memcpy
> so this won't ever fail, and then this special memcpy device entry will help.
> 
> Ideas? Use cases?

Hmmm. I am not sure, but i think we can't hard code a channel for some device.
All channels should be available with both capabilities. If still there are
some conditions (that you might know), where we need to hard code channels
for devices, then this should come from plat data in some way.



I have few more doubts that i wanted to ask. Are following supported in your
driver, we need them in SPEAr:
 - Configure burst size of source or destination.
 - Configure DMA Master for src or dest.
 - Transfer from Peripheral to Peripheral.
 - Configure Width of src or dest peripheral.
 - Configure Flow controller of transfer.
 - Some callback for fixing Request line multiplexing just before
	initiating transfer.
 - Multiple sg elements in slave_sg transfer. I think it is not supported.
 - Control for autoincrement of addresses, both in case of memory and
	peripherals.


viresh.
