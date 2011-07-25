Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1GYNxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:53:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56922 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1GYNxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <1311593444.29703.20.camel@vkoul-mobl4>
References: <1311453088-5063-1-git-send-email-jaswinder.singh@linaro.org>
	<1311593444.29703.20.camel@vkoul-mobl4>
Date: Mon, 25 Jul 2011 19:23:05 +0530
Message-ID: <CAJe_ZhdWsoL3WgUg6F4AuoHjGNLO07ZH+UPPd2qHLEW0f6LTGg@mail.gmail.com>
Subject: Re: [RFC] DMAEngine: Define generic transfer request api
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        sundaram@ti.com, linus.walleij@linaro.org, rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2011 17:00, Vinod Koul <vkoul@infradead.org> wrote:
> On Sun, 2011-07-24 at 02:01 +0530, Jassi Brar wrote:
>> This is an attempt to define an api that could be used for doing
>> fancy data transfers like interleaved to contiguous copy and vice-versa.
>> Traditional SG_list based transfers tend to be very inefficient
>> in such cases. Such cases call for some very condensed api to convey
>> pattern of the transfer. This is an attempt at that condensed api.
>>
>> The api supports all 4 variants of scatter-gather and contiguous transfer.
>> Besides, it could easily represent common operations like
>>       device_prep_dma_{cyclic, memset, memcpy}
> and how do you specify if the transfer is cyclic, memset or mempcy...
>> and maybe some more that I am not sure of.
>>
>> Of course, this api too can't help transfers that don't lend to DMA by
>> nature, i.e, scattered tiny read/writes with no periodic pattern.
> For that you use current sg_list :)
_tiny_ is the keyword here :)
SGL isn't an efficient method to convey transfer patterns with lengths
and skips in a few bytes.
And if they are big enough, we can use this api still.

>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>> ---
>>  include/linux/dmaengine.h |   74 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 74 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
>> index eee7add..a6cdb57 100644
>> --- a/include/linux/dmaengine.h
>> +++ b/include/linux/dmaengine.h
>> @@ -74,6 +74,76 @@ enum dma_transaction_type {
>>  /* last transaction type for creation of the capabilities mask */
>>  #define DMA_TX_TYPE_END (DMA_CYCLIC + 1)
>>
>> +/**
>> + * Generic Transfer Request
>> + * ------------------------
>> + * A chunk is collection of contiguous bytes to be transfered.
>> + * The gap(in bytes) between two chunks is called inter-chunk-gap(ICG).
>> + * ICGs may or maynot change between chunks.
>> + * A FRAME is the smallest series of contiguous {chunk,icg} pairs,
>> + *  that when repeated an integral number of times, specifies the transfer.
>> + * A transfer template is specification of a Frame, the number of times
>> + *  it is to be repeated and other per-transfer attributes.
>> + *
>> + * Practically, a client driver would have ready a template for each
>> + *  type of transfer it is going to need during its lifetime and
>> + *  set only 'src_start' and 'dst_start' before submitting the requests.
>> + *
>> + *
>> + *  |      Frame-1        |       Frame-2       | ~ |       Frame-'numf'  |
>> + *  |====....==.===...=...|====....==.===...=...| ~ |====....==.===...=...|
>> + *
>> + *    ==  Chunk size
>> + *    ... ICG
>> + */
>> +
>> +/**
>> + * struct data_chunk - Element of scatter-gather list that makes a frame.
>> + * @size: Number of bytes to read from source.
>> + *     size_dst := fn(op, size_src), so doesn't mean much for destination.
>> + * @icg: Number of bytes to jump after last src/dst address of this
>> + *    chunk and before first src/dst address for next chunk.
>> + *    Ignored for dst(assumed 0), if dst_inc is true and dst_sgl is false.
>> + *    Ignored for src(assumed 0), if src_inc is true and src_sgl is false.
>> + */
>> +struct data_chunk {
>> +     size_t size;
>> +     size_t icg;
>> +};
>> +
>> +/**
>> + * struct xfer_template - Template to convey DMAC the transfer pattern
>> + *    and attributes.
>> + * @op: The operation to perform on source data before writing it on
>> + *    to destination address.
> example of ops pls
We can convey almost every kind of offline-'dma' operation via this generic api.

>> + * @src_start: Absolute address of source for the first chunk.
>> + * @dst_start: Absolute address of destination for the first chunk.
> absolute = bus addr, right, if so bus addr would be a better term
Yup

>> + * @src_inc: If the source address increments after reading from it.
>> + * @dst_inc: If the destination address increments after writing to it.
> Is the inc in bytes?
I mean increment by src_width bytes(I removed it and made it an attribute
of the channel rather than transfer). That could be conveyed via maybe
SLAVE_CONFIG ... or with a new different name ;)

>> + * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
>> + *           Otherwise, source is read contiguously (icg ignored).
>> + *           Ignored if src_inc is false.
>> + * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
>> + *           Otherwise, destination is filled contiguously (icg ignored).
>> + *           Ignored if dst_inc is false.
>> + * @frm_irq: If the client expects DMAC driver to do callback after each frame.
> why not reuse the callback in descriptor for this?
At the moment, it is for at least conveying cyclic transfers in a
single descriptor.

>> + * @numf: Number of frames in this template.
>> + * @frame_size: Number of chunks in a frame i.e, size of sgl[].
>> + * @sgl: Array of {chunk,icg} pairs that make up a frame.
>> + */
>> +struct xfer_template {
>> +     enum dma_transaction_type op;
>> +     dma_addr_t src_start;
>> +     dma_addr_t dst_start;
>> +     bool src_inc;
>> +     bool dst_inc;
>> +     bool src_sgl;
>> +     bool dst_sgl;
>> +     bool frm_irq;
>> +     size_t numf;
>> +     size_t frame_size;
>> +     struct data_chunk sgl[0];
>> +};
>>
>>  /**
>>   * enum dma_ctrl_flags - DMA flags to augment operation preparation,
>> @@ -430,6 +500,7 @@ struct dma_tx_state {
>>   * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
>>   *   The function takes a buffer of size buf_len. The callback function will
>>   *   be called after period_len bytes have been transferred.
>> + * @device_prep_dma_xfer: Transfer expression in 'most' generic way.
>>   * @device_control: manipulate all pending operations on a channel, returns
>>   *   zero or error code
>>   * @device_tx_status: poll for transaction completion, the optional
>> @@ -494,6 +565,9 @@ struct dma_device {
>>       struct dma_async_tx_descriptor *(*device_prep_dma_cyclic)(
>>               struct dma_chan *chan, dma_addr_t buf_addr, size_t buf_len,
>>               size_t period_len, enum dma_data_direction direction);
>> +     struct dma_async_tx_descriptor *(*device_prep_dma_xfer)(
>> +             struct dma_chan *chan, struct xfer_template *xt,
>> +             unsigned long flags);
>>       int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
>>               unsigned long arg);
>>
>
> Is this coordinated with Sundaram, he was trying similar thing with help
> from Linus W?
>
Nopes.
I replied, to his proposal to add TI specific flag to DMA API, that we need
something generic enough to be usable by other DMACs as well.

For example, types of transfers possible with PL330 are almost unlimited
because PL330 is actually a processor with it's own instruction set !
I kept in mind the PL330 capabilities and all the trickery I had to employ
while working on DMA client(multimedia) drivers.

Please look at this api from POV that we are to write an ideal DMA API
from scratch. Later we can decide which parts are too old to be changed
and which could be introduced for new drivers and slowly/safely modified
in extant drivers.

I don't know if it is acceptable(please let me know if it is not), but I am
introducing my bigger picture a stroke at time, because neither am I
really good at communicating, nor people tend to accept even
'independently-valid' patches if they are introduced as part of something
bigger that they won't probably like. Or so do I think.

Thanks,
Jassi

-- 
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  -
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
