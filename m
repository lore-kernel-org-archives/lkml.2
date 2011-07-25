Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GYKzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:55:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38353 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1GYKzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:55:08 -0400
MIME-Version: 1.0
In-Reply-To: <1311453088-5063-1-git-send-email-jaswinder.singh@linaro.org>
References: <1311453088-5063-1-git-send-email-jaswinder.singh@linaro.org>
Date: Mon, 25 Jul 2011 12:55:07 +0200
Message-ID: <CAKnu2MpVwYSYgKBtpuqrrjHFQdjCEU_Q5iYe8qdfO9D1kzN0gw@mail.gmail.com>
Subject: Re: [RFC] DMAEngine: Define generic transfer request api
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, sundaram@ti.com, vinod.koul@intel.com,
        rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/23 Jassi Brar <jaswinder.singh@linaro.org>:

> This is an attempt to define an api that could be used for doing
> fancy data transfers like interleaved to contiguous copy and vice-versa.
> Traditional SG_list based transfers tend to be very inefficient
> in such cases. Such cases call for some very condensed api to convey
> pattern of the transfer. This is an attempt at that condensed api.
>
> The api supports all 4 variants of scatter-gather and contiguous transfer.
> Besides, it could easily represent common operations like
>        device_prep_dma_{cyclic, memset, memcpy}
> and maybe some more that I am not sure of.
>
> Of course, this api too can't help transfers that don't lend to DMA by
> nature, i.e, scattered tiny read/writes with no periodic pattern.
>
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>

I think this also looks interesting, it's the same idea as for using
control commands to set up striding, but by supporting a totally
new function call instead.

Do you think this method can be filled in with a default
implementation that converts the request to a plain sglist request
to memory or slave if interleaved transfers are not available?
That would mean that drivers can use this API on any DMA
engine, no matter whether it supports ICG/striding or not.

If we do that, this is much better than using a special control
command.

+ * @src_inc: If the source address increments after reading from it.
+ * @dst_inc: If the destination address increments after writing to it.

Currently whether source/destination increments or not is
implicit from transaction type, i.e. if it's a mem2mem transfer
it is implicit that both increment, if it's a slave transfer we can
infer from the direction (to/from peripheral) whether source or
destination is supposed to increment.

IMO this means duplication, and removes abstraction from the
API, it looks more like specific bits to be set in the DMA
hardware to control increments.

In this form it makes possible to set up nonsensical operations like
a memory-to-memory transfer to a non-incrementing address
which is not a peripheral FIFO, which is not good IMO. The API
should be semantically designed for setting up sensible operations.

+ * @op: The operation to perform on source data before writing it on
+ *      to destination address.

It is a enum dma_transaction_type after all, so can't it just say
"type of transfer"?

I think you can infer the above increment settings from this type,
so they should be removed.

+ * @frm_irq: If the client expects DMAC driver to do callback after each frame.

I don't understand the usecase for getting this IRQ, and it deviates
from the DMAengine way of setting a flag on the descriptor.
Instead I think you should maybe provide a new flag for the
unsigned long flags you're already passing in here:

+       struct dma_async_tx_descriptor *(*device_prep_dma_xfer)(
+               struct dma_chan *chan, struct xfer_template *xt,
+               unsigned long flags);
                 ^^^^^^^^^^^^^^^^^^^^^^

Thanks,
Linus Walleij
