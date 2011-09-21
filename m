Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1IUKTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 06:19:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53321 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab1IUKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 06:19:16 -0400
Date: Wed, 21 Sep 2011 11:18:57 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, 21cnbao@gmail.com
Subject: Re: [PATCHv3] DMAEngine: Define interleaved transfer request api
Message-ID: <20110921101857.GA29782@flint.arm.linux.org.uk>
References: <1316072789-12830-1-git-send-email-jaswinder.singh@linaro.org> <1316520730-3655-1-git-send-email-jaswinder.singh@linaro.org> <1316537529.31295.14.camel@vkoul-udesk3> <CAJe_ZhdB6y--3XuTp7hzrBjkBTUfp5Anta2Z8SMaqbc=z6jMGA@mail.gmail.com> <1316586723.1573.4.camel@vkoul-udesk3> <CAJe_Zhc67VR-+YAYaLhbwOF=eo2s7wOkjwvi+kJ5=bGt-YWmqA@mail.gmail.com> <1316587903.1573.8.camel@vkoul-udesk3> <CAJe_ZheO7e0Ft364io86aqnShK11XMTj+iC5eeU_zVCY0fJghw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJe_ZheO7e0Ft364io86aqnShK11XMTj+iC5eeU_zVCY0fJghw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 01:01:24PM +0530, Jassi Brar wrote:
> Of course!
> It doesn't make any sense for a mem->mem client asking
> for DMA_FROM_DEVICE when it wanted MemSet.

Yes it does.  For memset, you _are_ DMAing data from the DMA device to
memory.  The fact that the data is constant is merely incidental (and
a private property of the DMA controller.)

Also, this memory *has* to be mapped via the DMA API to ensure coherency,
and it *has* to be mapped using DMA_FROM_DEVICE.  Otherwise you won't see
the data until effects such as cache eviction have happened (even then
you may find your nicely memset'd data is overwritten by dirty cache
lines.)

So, to say that M2M transfers don't have DMA_FROM_DEVICE/TO_DEVICE
properties shows a lack of appreciation for what is actually going on
at the hardware level.

> > Same as few ields in xt_template would be for peripheral case..
>
> No properly written client would ever pass 'invalid' values for
> xt_template members.
> But _every_ properly written Mem->Mem client would have to
> ask for DMA_TO/FROM_DEVICE, following what you suggest.

Which is definitely a good thing.

> Btw, even if we wanted, Memcpy couldn't be represented by
> either DMA_TO_DEVICE or  DMA_FROM_DEVICE, because
> both Src and Dst increments here.

memcpy(dst,src,len) would require the source to be mapped DMA_TO_DEVICE
and the destination mapped DMA_FROM_DEVICE via the DMA API.

Look, the DMA_TO_DEVICE/FROM_DEVICE are completely separate properties
from "do we increment the source" "do we increment the destination"
properties.

There are existing client drivers in the kernel which already use M->P
DMA with non-incrementing source memory addresses (SPI transfers where
the transmit path has to be loaded with dummy data) and P->M DMA with
non-incrementing destination memory addresses (SPI discarding RX data.)

So, there's _absolutely_ no way that any sane API can ever infer the
DMA direction from the source/destination increment specifications.
Ignore this at your peril (and you'll find that people will botch
around your new API.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
