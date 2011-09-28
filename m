Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1I1PPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:15:47 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45309 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1I1PPq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <1317200618.1573.1765.camel@vkoul-udesk3>
References: <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	<1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
Date: Wed, 28 Sep 2011 20:45:45 +0530
Message-ID: <CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        rmk@arm.linux.org.uk, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 September 2011 14:33, Vinod Koul <vinod.koul@intel.com> wrote:
> On Wed, 2011-09-28 at 12:09 +0530, Jassi Brar wrote:

>>
>> +     struct dma_async_tx_descriptor *(*device_prep_interleaved_dma)(
>> +             struct dma_chan *chan, struct dmaxfer_template *xt,
>> +             unsigned long flags);
> what's the flags used for?
Same as for device_prep_slave_sg, device_prep_dma_sg, device_prep_dma_interrupt,
device_prep_dma_memset etc. Usually for flagging buffer map/unmap'ing
in this case.
Btw, this was present in v3 as well.


>> +enum xfer_direction {
>> +     MEM_TO_MEM,
>> +     MEM_TO_DEV,
>> +     DEV_TO_MEM,
>> +     DEV_TO_DEV,
> Use/update dma_data_direction.
dma_data_direction is the mapping attribute of a buffer.
While that info is what some dmac driver might need ultimately, our main
aim here is to tell exactly if Src and Dst is Memory or a device's FIFO.

Mapping attribute of src/dst buffers could be very well deducted from
xfer_direction, but dma_data_direction isn't meant to tell if Src and Dst
is Mem or FIFO.
Also, for (SLAVE && !src_inc && !dst_inc) we need to disambiguate three
options  Mem->Fifo,  Fifo->Mem,  *Fifo->Fifo*(not impossible)
So while using dma_data_direction would work today, that sure is hacky
and not future-proof.


>> +/**
>> + * struct dmaxfer_template - Template to convey DMAC the transfer pattern
>> + *    and attributes.
>> + * @src_start: Bus address of source for the first chunk.
>> + * @dst_start: Bus address of destination for the first chunk.
>> + * @dir: Specifies the type of Source and Destination.
>> + * @src_inc: If the source address increments after reading from it.
>> + * @dst_inc: If the destination address increments after writing to it.
>> + * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
>> + *           Otherwise, source is read contiguously (icg ignored).
>> + *           Ignored if src_inc is false.
>> + * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
>> + *           Otherwise, destination is filled contiguously (icg ignored).
>> + *           Ignored if dst_inc is false.
>> + * @frm_irq: If the client expects DMAC driver to do callback after each frame.
> I thought you were going to remove this?
Yes, I just forgot.
