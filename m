Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927Ab1IUPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:21:18 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1IUPVS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:21:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110921101857.GA29782@flint.arm.linux.org.uk>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org>
	<1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org>
	<1316537529.31295.14.camel@vkoul-udesk3>
	<CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com>
	<1316586723.1573.4.camel@vkoul-udesk3>
	<CAJe_Zhc67VR-+YAYaLhbwOF=eo2s7wOkjwvi+kJ5=bGt-YWmqA@mail.gmail.com>
	<1316587903.1573.8.camel@vkoul-udesk3>
	<CAJe_ZheO7e0Ft364io86aqnShK11XMTj+iC5eeU_zVCY0fJghw@mail.gmail.com>
	<20110921101857.GA29782@flint.arm.linux.org.uk>
Date: Wed, 21 Sep 2011 20:51:16 +0530
Message-ID: <CAJe_ZheQFk2mHENVXm+BL8FS72V=br8=xMbc-DPMpxj0dsWD=A@mail.gmail.com>
Subject: Re: [PATCHv3] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, 21cnbao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 September 2011 15:48, Russell King <rmk@arm.linux.org.uk> wrote:
> On Wed, Sep 21, 2011 at 01:01:24PM +0530, Jassi Brar wrote:
>> Of course!
>> It doesn't make any sense for a mem->mem client asking
>> for DMA_FROM_DEVICE when it wanted MemSet.
>
> Yes it does.  For memset, you _are_ DMAing data from the DMA device to
> memory.  The fact that the data is constant is merely incidental (and
> a private property of the DMA controller.)
>
> Also, this memory *has* to be mapped via the DMA API to ensure coherency,
> and it *has* to be mapped using DMA_FROM_DEVICE.  Otherwise you won't see
> the data until effects such as cache eviction have happened (even then
> you may find your nicely memset'd data is overwritten by dirty cache
> lines.)
>
> So, to say that M2M transfers don't have DMA_FROM_DEVICE/TO_DEVICE
> properties shows a lack of appreciation for what is actually going on
> at the hardware level.
I don't discount that. I just think memory map/unmap'ing should not be
any business of the dmac driver. It should be handled by either client
or by some common part of dmaengine api.
Infact I never really asked 'why' the dmac driver needs to know the
direction, rather I only tried to explain 'how' it can find out.

Anyways, I am ok if this new api too must support map/unmap'ing of
buffers on behalf of the client.

> So, there's _absolutely_ no way that any sane API can ever infer the
> DMA direction from the source/destination increment specifications.
> Ignore this at your peril (and you'll find that people will botch
> around your new API.)
Yes. But having a 'enum dma_data_direction' flag wouldn't make it
future-proof either.

Seems I would have to define something like :-
enum xfer_direction {
	MEM_TO_MEM,
	MEM_TO_DEV,
	DEV_TO_MEM,
	DEV_TO_DEV,
 };

And replace every 'enum dma_data_direction' in the dmaengine api
with 'enum xfer_direction'

Thanks.
