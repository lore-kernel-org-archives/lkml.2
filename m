Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab1IOKCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 06:02:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54624 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1IOKCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 06:02:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110915082252.GB30518@flint.arm.linux.org.uk>
References: <1313147667-3385-1-git-send-email-jaswinder.singh@linaro.org>
	<1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	<20110915082252.GB30518@flint.arm.linux.org.uk>
Date: Thu, 15 Sep 2011 15:32:20 +0530
Message-ID: <CAJe_ZheeJMJhi-66J8LRf9f15Kv=cHdTmyeCqvg1=Y7DVXVJSQ@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Define generic transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: dan.j.williams@intel.com, vkoul@infradead.org,
        linux-kernel@vger.kernel.org, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 September 2011 13:52, Russell King <rmk@arm.linux.org.uk> wrote:
> On Thu, Sep 15, 2011 at 01:16:29PM +0530, Jassi Brar wrote:
>> +/**
>> + * struct dmaxfer_template - Template to convey DMAC the transfer pattern
>> + *    and attributes.
>> + * @src_start: Bus address of source for the first chunk.
>> + * @dst_start: Bus address of destination for the first chunk.
>> + * @src_inc: If the source address increments after reading from it.
>> + * @dst_inc: If the destination address increments after writing to it.
>> + * @src_sgl: If the 'icg' of sgl[] applies to Source (scattered read).
>> + *           Otherwise, source is read contiguously (icg ignored).
>> + *           Ignored if src_inc is false.
>> + * @dst_sgl: If the 'icg' of sgl[] applies to Destination (scattered write).
>> + *           Otherwise, destination is filled contiguously (icg ignored).
>> + *           Ignored if dst_inc is false.
>> + * @frm_irq: If the client expects DMAC driver to do callback after each frame.
>> + * @numf: Number of frames in this template.
>> + * @frame_size: Number of chunks in a frame i.e, size of sgl[].
>> + * @sgl: Array of {chunk,icg} pairs that make up a frame.
>> + */
>> +struct dmaxfer_template {
>> +     dma_addr_t src_start;
>> +     dma_addr_t dst_start;
>> +     bool src_inc;
>> +     bool dst_inc;
>> +     bool src_sgl;
>> +     bool dst_sgl;
>> +     bool frm_irq;

> How does this deal with the XOR operation, where you have
> two sources and one destination?  Unless you sort that out, I don't see
> how your idea of collapsing all the prepare functions can possibly work.

In this v2 revision I have dropped the member "enum dma_transaction_type op"
from "struct dmaxfer_template". So as such it wouldn't support.

In future though, it should be possible to support cascading XOR after
restoring the 'op' member.

Every other member of 'struct dmaxfer_template' would be interpreted
according to the type of operation requested.
For XOR operation - src_inc, dst_inc, src_sgl, dst_sgl, frm_irq would
be ignored.

For cascading XOR of 'N' sources  { Src1^Src2^....^SrcN -> Dst }
  dmaxfer_template.op := DMA_XOR
  dmaxfer_template.numf := 1
  dmaxfer_template.frame_size := N
  dmaxfer_template.sgl[] would point to an array of 'N' source chunks.

For simple XOR   i.e,   Src ^ Dst -> Dst
  Same as above(N:=2), but only the client would point 'dst_start' to
the address of second source chunk.
