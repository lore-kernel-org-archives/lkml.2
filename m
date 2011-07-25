Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1GYNNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:13:07 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61384 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1GYNNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAKnu2MpVwYSYgKBtpuqrrjHFQdjCEU_Q5iYe8qdfO9D1kzN0gw@mail.gmail.com>
References: <1311453088-5063-1-git-send-email-jaswinder.singh@linaro.org>
	<CAKnu2MpVwYSYgKBtpuqrrjHFQdjCEU_Q5iYe8qdfO9D1kzN0gw@mail.gmail.com>
Date: Mon, 25 Jul 2011 18:43:04 +0530
Message-ID: <CAJe_ZhebB_99oEBucy_dS_f0T-OPDfUo6q_v0nh3gFvS0cn3qg@mail.gmail.com>
Subject: Re: [RFC] DMAEngine: Define generic transfer request api
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, sundaram@ti.com, vinod.koul@intel.com,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2011 16:25, Linus Walleij <linus.ml.walleij@gmail.com> wrote:
> 2011/7/23 Jassi Brar <jaswinder.singh@linaro.org>:
>
>> This is an attempt to define an api that could be used for doing
>> fancy data transfers like interleaved to contiguous copy and vice-versa.
>> Traditional SG_list based transfers tend to be very inefficient
>> in such cases. Such cases call for some very condensed api to convey
>> pattern of the transfer. This is an attempt at that condensed api.
>>
>> The api supports all 4 variants of scatter-gather and contiguous transfer.
>> Besides, it could easily represent common operations like
>>        device_prep_dma_{cyclic, memset, memcpy}
>> and maybe some more that I am not sure of.
>>
>> Of course, this api too can't help transfers that don't lend to DMA by
>> nature, i.e, scattered tiny read/writes with no periodic pattern.
>>
>> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
>
> I think this also looks interesting, it's the same idea as for using
> control commands to set up striding, but by supporting a totally
> new function call instead.
>
> Do you think this method can be filled in with a default
> implementation that converts the request to a plain sglist request
> to memory or slave if interleaved transfers are not available?
> That would mean that drivers can use this API on any DMA
> engine, no matter whether it supports ICG/striding or not.
At the moment, this is supposed to be used only for the fancy kind
of transfers that involve lengths and skips in a few _bytes_.
For which SGL is ineffient in the first place.

>
> If we do that, this is much better than using a special control
> command.
Maybe I should have added something like 'GENERAL_XFER' capability
flag to the api.
Though not set in stone, but I strongly believe this should be how it is now.

>
> + * @src_inc: If the source address increments after reading from it.
> + * @dst_inc: If the destination address increments after writing to it.
>
> Currently whether source/destination increments or not is
> implicit from transaction type, i.e. if it's a mem2mem transfer
> it is implicit that both increment, if it's a slave transfer we can
> infer from the direction (to/from peripheral) whether source or
> destination is supposed to increment.
Such few things are for later.... final part of my conspiracy ;)
Now that we are renovating the DMA API, we might come to
agree that this callback can just as well be employed for
Mem<->Device transfer.

>
> IMO this means duplication, and removes abstraction from the
> API, it looks more like specific bits to be set in the DMA
> hardware to control increments.
>
> In this form it makes possible to set up nonsensical operations like
> a memory-to-memory transfer to a non-incrementing address which
> is not a peripheral FIFO, which is not good IMO.
Not really.
We can convey 'memset' type of operation with this
 src_inc := false
 dsr_inc := true
 src_width := length of byte-sequence to repeated

The point is to cover as many possibilities as possible (at acceptable cost)
And of course, either the client won't make invalid requests or the
DMAC will reject them -- just as is _already_ the case.

>  The API should be semantically designed for setting up sensible operations.
No API can be fool-proof.

>
> + * @op: The operation to perform on source data before writing it on
> + *      to destination address.
>
> It is a enum dma_transaction_type after all, so can't it just say
> "type of transfer"?
It is to stress that it is possible to do complex operations as well.
XOR is not exactly a transfer, but an operation.
Theoretically a 'dma' can decode an mp3 stream and write the expanded
raw data to destination. So, it's not exactly a transfer - it's an operation.

> + * @frm_irq: If the client expects DMAC driver to do callback after each frame.
>
> I don't understand the usecase for getting this IRQ, and it deviates
> from the DMAengine way of setting a flag on the descriptor.
It doesn't take much bytes, so I would beg on my knees to please let it live.
Someday, it could be used to convey 'cyclic' transfer requests - that
is (only important members are set)
struct xfer_template {
       dma_addr_t src_start = address of ring buffer;
       bool frm_irq = true;
       size_t numf = ~0;
       size_t frame_size = number of parts of ring buffer;
};


> Instead I think you should maybe provide a new flag for the
> unsigned long flags you're already passing in here:
>
> +       struct dma_async_tx_descriptor *(*device_prep_dma_xfer)(
> +               struct dma_chan *chan, struct xfer_template *xt,
> +               unsigned long flags);
>                 ^^^^^^^^^^^^^^^^^^^^^^
This is at your mercy.

Thanks,
Jassi

-- 
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  -
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
