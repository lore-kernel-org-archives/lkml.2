Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1CCKMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 05:12:14 -0500
Received: from service87.mimecast.com ([94.185.240.25]:53316 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753724Ab1CCKMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 05:12:12 -0500
Subject: Re: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
From: Catalin Marinas <catalin.marinas@arm.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <4D6F481B.8000700@codeaurora.org>
References: <4D6D9C03.2080906@codeaurora.org>
	 <20110302083904.GA4493@n2100.arm.linux.org.uk>
	 <4D6F481B.8000700@codeaurora.org>
Organization: ARM Limited
Date: Thu, 03 Mar 2011 10:11:57 +0000
Message-ID: <1299147117.22540.25.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 03 Mar 2011 10:12:05.0970 (UTC) FILETIME=[72C9CB20:01CBD98B]
X-MC-Unique: 111030310120905701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-03 at 07:49 +0000, Saravana Kannan wrote:
> On 03/02/2011 12:39 AM, Russell King - ARM Linux wrote:
> > On Tue, Mar 01, 2011 at 05:23:15PM -0800, Saravana Kannan wrote:
> >> If I'm not missing some magic, this would mean that
> >> "CONFIG_ARM_DMA_MEM_BUFFERABLE" determines if readl(s)/writel(s) get to
> >> have a built in mb() or not.
[...]
> > I think you misunderstand what's going on.  IO accesses are always ordered
> > with respect to themselves.  The barriers are there to ensure ordering
> > between DMA coherent memory (normal non-cached memory) and IO accesses
> > (device).
> 
> Unfortunately this is not correct. The ARM spec doesn't guarantee that
> all IO accesses should be ordered with respect to themselves. It only
> requires that the ordering should be guaranteed at least within a 1KB
> region.

That's because the CPU does not have control of the delays on various
buses. But a device connected to the same bus receives the accesses in
order.

> And the most critical point is hidden in a comment that goes:
> "The size of a memory mapped peripheral, or a block of memory, is
> IMPLEMENTATION DEFINED, but is not smaller than 1KByte."
> 
> I guess most of the confusion is due to the ARM spec not being very
> obvious about the 1KB limitation.

What that means is that the hardware shouldn't have two different buses
(possibly with different delays) within a 1KB range.

Even if accesses to all peripherals are ordered, you still cannot
guarantee that a writel() would change the state of a device (and that's
specific to all architectures). Sometimes if you want to make sure the
device state changed you need a readl() back.

> So, going back to my point, I think it's wrong for
> CONFIG_ARM_DMA_MEM_BUFFERABLE to control how stuff unrelated to DMA behaves.

In an ideal world, all driver authors know what memory ordering is and
add the necessary barriers. But since that's not the case, the only way
to get ordering between Normal Non-cacheable access (DMA buffer) and
Device access (via writel) is to add the mb() in the I/O accessors.

This has been discussed at length on several occasions on linux-arch and
LKML. We don't have other solution since adding barriers to drivers
wasn't found feasible by others. Of course, if you can optimised your
driver to use the relaxed accessors and add explicit barriers.

> I have also encountered a few people who kept went "but readl/writel was
> recently changed to add mem barriers, so we can all remove the mb()s in
> our driver (unrelated to DMA) code". 

But why did they have those barriers around I/O accessors in the first
place? As you say, nothing related to DMA. If you access two different
devices and want to ensure an ordering of the state changes, I doubt a
barrier would help. Most likely you need a read back from the device.

> That would have made their code incorrect for two reasons:
> 1. readl/writel doesn't always have a mem barrier because of config that
> can be turned off.
> 2. In cases where readl/writel didn't have mb(), there is not enough
> ordering guarantee without an explicit mb().

See my comment above, what do they try to achieve by using mb() around
already ordered I/O accessors?

> I think as a community, we should stop saying that readl/writel ensures
> ordering with respect to all IO accesses. It doesn't even guarantee
> ordering within the same device (when their register regions are > 1KB).

It definitely guarantees ordering to the same device. The 1KB is a
minimum limit but there is no upper bound (and it should definitely
cover a single device).

> After reading the above, please let me know if a patch to decouple the
> "readl/writel with builtin mb()" from CONFIG_ARM_DMA_MEM_BUFFERABLE
> would be accepted. If so, I can go ahead and send it out soon.

No, I don't think this would be acceptable. I can point you to past
discussion where Linus stated that Normal Non-cacheable memory and I/O
accesses should be ordered.

What you can do actually is make sure that all architectures support the
relaxed accessors and change the drivers to use these instead.

-- 
Catalin


