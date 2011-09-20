Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1ITSJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:09:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41593 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1ITSJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <1316537529.31295.14.camel@vkoul-udesk3>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	<1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	<1316537529.31295.14.camel@vkoul-udesk3>
Date: Tue, 20 Sep 2011 23:38:59 +0530
Message-ID: <CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com>
Subject: Re: [PATCHv3] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 September 2011 22:22, Vinod Koul <vinod.koul@intel.com> wrote:
>>  /**
>>   * enum dma_ctrl_flags - DMA flags to augment operation preparation,
>> @@ -309,6 +376,8 @@ typedef void (*dma_async_tx_callback)(void *dma_async_param);
>>   * @chan: target channel for this operation
>>   * @tx_submit: set the prepared descriptor(s) to be executed by the engine
>>   * @callback: routine to call after this operation is complete
>> + *   And after each frame if the 'frm_irq' flag is set during
>> + *   device_prep_interleaved_dma.
> Nope, if callback is set it should be called
What makes you think it won't be called? Note that it starts with _AND_
'frm_irq' would only cause the callbacks done _additionally_ after each frame.

And no, DMA_PREP_INTERRUPT can't serve that purpose because that acts at
only the end of full transfer not a part of it.

> I think frm_irq is not required
Barry doesn't need it, so yes, I'd better remove it for now and make
my life easier.


> Also for slave transfers, how do we infer direction?
I already explained to Barry.  Here's it again.

At any time, the dmac driver knows if the channel, on which the xfer is
prepared/submitted is Slave or not.

SLAVE Transfer
   dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => DMA_TO_DEVICE
   !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => DMA_FROM_DEVICE

Mem->Mem Transfer
   dmaxfer_template.src_inc  && !dmaxfer_template.dst_inc  => Meaningless
   !dmaxfer_template.src_inc  && dmaxfer_template.dst_inc  => MemSet
