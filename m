Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab1JESPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:15:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:34896 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932812Ab1JESPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:15:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
	<CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	<CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	<CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	<CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	<CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	<CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	<20111003161349.GB28287@flint.arm.linux.org.uk>
	<CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
Date: Wed, 5 Oct 2011 11:14:59 -0700
Message-ID: <CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Barry Song <21cnbao@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 9:19 AM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
> On 3 October 2011 21:43, Russell King <rmk@arm.linux.org.uk> wrote:
>> On Mon, Oct 03, 2011 at 11:54:23AM +0530, Jassi Brar wrote:
>>> On 2 October 2011 06:03, Barry Song <21cnbao@gmail.com> wrote:
>>> > 2011/10/2 Jassi Brar <jaswinder.singh@linaro.org>
>>>
>>> >> > For example, it can't use
>>> >> > MEM_TO_MEM to map, it still need to know whether the memory is source
>>> >> > or dest.
>>> >> MEM_TO_MEM means "From Memory Source To Memory Destination"
>>> >>  Map Src buffer with DMA_TO_DEVICE and Dst buffer with DMA_FROM_DEVICE
>>> >>
>>> >> MEM_TO_DEV means "From Memory Source To FIFO Destination"
>>> >>  Map Src buffer with DMA_TO_DEVICE.
>>> >>
>>> >> DEV_TO_MEM means "From FIFO Source To Memory Destination"
>>> >>  Map Dst buffer with DMA_FROM_DEVICE
>>> >>
>>> >> DEV_TO_DEV means "From FIFO Source To FIFO Destination"
>>> >>
>>> >> What else would you want to know ?
>>> >
>>> > that is the problem. for example, drivers can't use MEM_TO_MEM as a
>>> > flag to do dma mapping. so xfer_direction can't cover all that
>>> > dma_data_direction can do.  that's why you need both
>>> > dma_data_direction and xfer_direction with some similar flags in them.
>>> >
>>> The client drivers map the src/dst buffers and the dmac driver unmaps
>>> them by default(!). For which, the dmac driver doesn't look at anything
>>> other than
>>>      DMA_COMPL_SKIP_SRC/DST_UNMAP
>>>      DMA_COMPL_SRC/DST_UNMAP_SINGLE
>>>   bits of 'enum dma_ctrl_flags'.
>>> For this unmap'ing purpose, the usage of dma_data_direction is already
>>> internal to the dmac driver.
>>
>> No.  Slave DMA engine drivers do *not* (and if they do, they should *not*)
>> honour the unmapping of submitted buffers.
>>
>> The unmapping of these buffers by the DMA engine driver is intended to be
>> done for the async_tx API and not slave DMA.
>>
> The proposed api is usable by both Slave as well as Async(Memcpy etc).
> So it *does* matter here.

Support for automatic unmapping is really only useful for simple cases
like net_dma where all operations in the chain are to distinct
buffers.  Trying to support it for async_tx contributed to the current
brokenness with respect to overlapping mappings for operation chaining
in the async-tx raid case.  So I would like to rip out unmap support
from the dma drivers, but before we can do that we need to teach raid
and net_dma how to manage the mappings themselves.  The raid lift is a
bit bigger because it needs to handle the cases of cpu-memcpy +
dma-xor-pq versus dma-memcpy + dma-xor-pq (I would drop support for
dma-memcpy + cpu-xor-pq and just make this case all cpu).

This new operation type strikes me as being in a similar vein to
commit a08abd8c "async_tx: structify submission arguments, add
scribble", in that we convert multiple submission arguments into one
description template.  With some tweaks it could probably even cover
the DMA_CYCLIC, but probably could not cover the raid ops.  In general
I'm concerned about operation type proliferation, so if we added this
one I'd like to see others removed.
