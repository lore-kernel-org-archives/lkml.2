Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1IPRvi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:51:38 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:33568 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab1IPRvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:51:37 -0400
MIME-Version: 1.0
In-Reply-To: <1316192791.27626.1881.camel@vkoul-udesk3>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	<1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	<1316164077.27626.1030.camel@vkoul-udesk3>
	<CAJe_Zhd5d7XeuVJpuyNYBmhwBkX_dgi+nngftCO9C589cF1Yqg@mail.gmail.com>
	<1316192791.27626.1881.camel@vkoul-udesk3>
Date: Fri, 16 Sep 2011 23:21:36 +0530
Message-ID: <CAJe_ZhdFKbVrx1Xf_Qc=y_bqZc6b_8sbhekRMDbnj+QA4HU21A@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Define generic transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2011 22:36, Vinod Koul <vinod.koul@intel.com> wrote:
>> >> Define a new api that could be used for doing fancy data transfers
>> >> like interleaved to contiguous copy and vice-versa.
>> > Then this is a very specific type of transfer this API supports, so the
>> > name generic_xxx is not apt!
>>
>> Currently it doesn't support every operation, perhaps there will be an
>> operation that couldn't ever be merged into this.
>> But it does support interleaved(async and slave), memcpy, memset, dma_sg,
>> slave_sg, and cyclic.
>> Please feel free to suggest a better name.
> ATM, this api is for interleaved like dma operation. so
> prep_interleaved_dma may be better suited.
Well, ok I can live with that.

> Let the generalization be discussed separately...
As you wish.

>> >> +/**
>> >> + * Generic Transfer Request
>> >> + * ------------------------
>> >> + * A chunk is collection of contiguous bytes to be transfered.
>> >> + * The gap(in bytes) between two chunks is called inter-chunk-gap(ICG).
>> >> + * ICGs may or maynot change between chunks.
>> >> + * A FRAME is the smallest series of contiguous {chunk,icg} pairs,
>> >> + *  that when repeated an integral number of times, specifies the transfer.
>> >> + * A transfer template is specification of a Frame, the number of times
>> >> + *  it is to be repeated and other per-transfer attributes.
>> >> + *
>> >> + * Practically, a client driver would have ready a template for each
>> >> + *  type of transfer it is going to need during its lifetime and
>> >> + *  set only 'src_start' and 'dst_start' before submitting the requests.
>> >> + *
>> >> + *
>> >> + *  |      Frame-1        |       Frame-2       | ~ |       Frame-'numf'  |
>> >> + *  |====....==.===...=...|====....==.===...=...| ~ |====....==.===...=...|
>> >> + *
>> >> + *    ==  Chunk size
>> >> + *    ... ICG
>> >> + */
>> >> +
>> >> +/**
>> >> + * struct data_chunk - Element of scatter-gather list that makes a frame.
>> >> + * @size: Number of bytes to read from source.
>> >> + *     size_dst := fn(op, size_src), so doesn't mean much for destination.
>> >> + * @icg: Number of bytes to jump after last src/dst address of this
>> >> + *    chunk and before first src/dst address for next chunk.
>> >> + *    Ignored for dst(assumed 0), if dst_inc is true and dst_sgl is false.
>> >> + *    Ignored for src(assumed 0), if src_inc is true and src_sgl is false.
>> >> + */
>> >> +struct data_chunk {
>> >> +     size_t size;
>> >> +     size_t icg;
>> >> +};
>> >> +
>> >> +/**
>> >> + * struct dmaxfer_template - Template to convey DMAC the transfer pattern
>> >> + *    and attributes.
>> >> + * @src_start: Bus address of source for the first chunk.
>> >> + * @dst_start: Bus address of destination for the first chunk.
>> >> + * @src_inc: If the source address increments after reading from it.
>> >> + * @dst_inc: If the destination address increments after writing to it.
>> >> + * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
>> >> + *           Otherwise, source is read contiguously (icg ignored).
>> >> + *           Ignored if src_inc is false.
>> >> + * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
>> >> + *           Otherwise, destination is filled contiguously (icg ignored).
>> >> + *           Ignored if dst_inc is false.
>> >> + * @frm_irq: If the client expects DMAC driver to do callback after each frame.
>> >> + * @numf: Number of frames in this template.
>> >> + * @frame_size: Number of chunks in a frame i.e, size of sgl[].
>> >> + * @sgl: Array of {chunk,icg} pairs that make up a frame.
>> >> + */
>> >> +struct dmaxfer_template {
>> >> +     dma_addr_t src_start;
>> >> +     dma_addr_t dst_start;
>> >> +     bool src_inc;
>> >> +     bool dst_inc;
>> >> +     bool src_sgl;
>> >> +     bool dst_sgl;
>> >> +     bool frm_irq;
>> >> +     size_t numf;
>> >> +     size_t frame_size;
>> >> +     struct data_chunk sgl[0];
>> >> +};
>> > This kind of transfer can be either slave (audio interleaved) based or
>> > mem-to-mem (extracting still image from a buffer),
>> > How do you propose the dmac know about this is unclear to me
>>
>> Every 'prepare' callback already passes the channel chosen for the transfer.
>> And the DMAC driver already knows if that channel is SLAVE capable or not.
> How about above params, you should add they may/may not be valid
> depending upon the mode.
If you look at the documentation above the 'struct dmaxfer_template', I have
already mentioned what params are ignored/invalid when.
Or is there something else you want mentioned ?

> Pls also send updates to documentation for this API
Ok, I'll write some notes on using this api in Documentation/dmaengine.txt
