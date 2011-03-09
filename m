Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab1CIEhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 23:37:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12427 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab1CIEhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 23:37:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6279"; a="78840169"
Message-ID: <4D770416.2020505@codeaurora.org>
Date: Tue, 08 Mar 2011 20:37:42 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arm-msm@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
References: <4D6D9C03.2080906@codeaurora.org>	<20110302083904.GA4493@n2100.arm.linux.org.uk>	<4D6F481B.8000700@codeaurora.org> <1299147117.22540.25.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1299147117.22540.25.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discussed this further with our resident ARM expert. The rest of the 
email is me understanding his comments and rephrasing them to suit this 
thread.

On 03/03/2011 02:11 AM, Catalin Marinas wrote:
> On Thu, 2011-03-03 at 07:49 +0000, Saravana Kannan wrote:
>> On 03/02/2011 12:39 AM, Russell King - ARM Linux wrote:
>>> On Tue, Mar 01, 2011 at 05:23:15PM -0800, Saravana Kannan wrote:
>>>> If I'm not missing some magic, this would mean that
>>>> "CONFIG_ARM_DMA_MEM_BUFFERABLE" determines if readl(s)/writel(s) get to
>>>> have a built in mb() or not.
> [...]
>>> I think you misunderstand what's going on.  IO accesses are always ordered
>>> with respect to themselves.  The barriers are there to ensure ordering
>>> between DMA coherent memory (normal non-cached memory) and IO accesses
>>> (device).
>>
>> Unfortunately this is not correct. The ARM spec doesn't guarantee that
>> all IO accesses should be ordered with respect to themselves. It only
>> requires that the ordering should be guaranteed at least within a 1KB
>> region.
>
> That's because the CPU does not have control of the delays on various
> buses. But a device connected to the same bus receives the accesses in
> order.

 From the ARM spec, at the least, we have established that IO accesses 
are not guaranteed to be ordered with respect to all IO accesses. So, I 
kindly request that we no longer perpetuate the incorrect statement that 
IO accesses are ordered wrt to all IO accesses.

The only continuing disagreement is on whether the minimum limit is 1KB 
or "the entire address space of a given device". More on that below.

>> And the most critical point is hidden in a comment that goes:
>> "The size of a memory mapped peripheral, or a block of memory, is
>> IMPLEMENTATION DEFINED, but is not smaller than 1KByte."
>>
>> I guess most of the confusion is due to the ARM spec not being very
>> obvious about the 1KB limitation.
>
> What that means is that the hardware shouldn't have two different buses
> (possibly with different delays) within a 1KB range.

Rephrasing comments from our resident expert:
This 1KB limit is not really tied to there being different "speeds" on 
the buses.  Rather it is a fundamental topological issue.  It has to do 
with how the "core" interleaves the interconnect. If the interleave is 
at the 1KB level, there are two different bus interfaces at the 1KB 
interleave.  So even if the downstream "device" has a single *input* 
bus, the processor and the interconnect have two different paths to get 
to that device, if the address space spans 1KB. So there is no 
guaranteed order across the 1KB boundary, even if in concept the two 
sides of the boundary are talking to the same "device".

> Even if accesses to all peripherals are ordered, you still cannot
> guarantee that a writel() would change the state of a device (and that's
> specific to all architectures). Sometimes if you want to make sure the
> device state changed you need a readl() back.

Yes, a device might take much longer to change the state or process the 
command after the write completes. I realize that has nothing to do with 
memory barriers.

>> So, going back to my point, I think it's wrong for
>> CONFIG_ARM_DMA_MEM_BUFFERABLE to control how stuff unrelated to DMA behaves.
>
> In an ideal world, all driver authors know what memory ordering is and
> add the necessary barriers. But since that's not the case, the only way
> to get ordering between Normal Non-cacheable access (DMA buffer) and
> Device access (via writel) is to add the mb() in the I/O accessors.
>
> This has been discussed at length on several occasions on linux-arch and
> LKML. We don't have other solution since adding barriers to drivers
> wasn't found feasible by others. Of course, if you can optimised your
> driver to use the relaxed accessors and add explicit barriers.

I think my comment for clean up was misunderstood to be more that what I 
intend. I will address this at the end of this email.

>> I have also encountered a few people who kept went "but readl/writel was
>> recently changed to add mem barriers, so we can all remove the mb()s in
>> our driver (unrelated to DMA) code".
>
> But why did they have those barriers around I/O accessors in the first
> place? As you say, nothing related to DMA. If you access two different
> devices and want to ensure an ordering of the state changes, I doubt a
> barrier would help. Most likely you need a read back from the device.

These barriers were needed because the device spanned more than 1KB of 
address space. See below.

>> That would have made their code incorrect for two reasons:
>> 1. readl/writel doesn't always have a mem barrier because of config that
>> can be turned off.
>> 2. In cases where readl/writel didn't have mb(), there is not enough
>> ordering guarantee without an explicit mb().
>
> See my comment above, what do they try to achieve by using mb() around
> already ordered I/O accessors?
>
>> I think as a community, we should stop saying that readl/writel ensures
>> ordering with respect to all IO accesses. It doesn't even guarantee
>> ordering within the same device (when their register regions are>  1KB).
 >
> It definitely guarantees ordering to the same device. The 1KB is a
> minimum limit but there is no upper bound (and it should definitely
> cover a single device).

Rephrasing comments from our resident expert:
That is not true.  It only guarantees ordering to the 1KB boundary. 
That is the implementation-defined limit of what constitutes a "device". 
  Any "device" which crosses that boundary is viewed as two separate 
devices from the core's perspective, and there is no guaranteed order, 
absent an explicit barrier operation.

The 1KB is the minimum size that the architecture allows the hardware to 
establish as its limit for guaranteed ordering.

It is not true that the hardware is obligated to go *above* that limit 
just because a given "device" happens to have address space that crosses 
the boundary.  As soon as you have two separate interconnect ports and 
thus two separate paths to get to the device, because it crossed the 1KB 
boundary, then you have the potential of being out-of-order.  Software 
is obligated to use explicit barriers on accesses that cross that 
threshold, regardless of whether *physically* the accesses end up at the 
same downstream "device".

>> After reading the above, please let me know if a patch to decouple the
>> "readl/writel with builtin mb()" from CONFIG_ARM_DMA_MEM_BUFFERABLE
>> would be accepted. If so, I can go ahead and send it out soon.
>
> No, I don't think this would be acceptable. I can point you to past
> discussion where Linus stated that Normal Non-cacheable memory and I/O
> accesses should be ordered.
>
> What you can do actually is make sure that all architectures support the
> relaxed accessors and change the drivers to use these instead.

There were a couple of reason for starting this thread:
* Check if my understanding of CONFIG_ARM_DMA_MEM_BUFFERABLE's effect on 
readl/writl were correct and if I was missing anything.
Result: Yes, I was missing some stuff about the config affecting DMA 
memory mapping, but I did understand the point about having mb()s in 
readl/writel correctly.

* Bring to attention that the ARM spec doesn't guarantee all IO accesses 
are ordered wrt each other and have the community update it's 
understanding of IO access ordering.
Result: It think we agree on this update. At least Russell seems to. The 
ARM spec is very clear on this. The only part we disagree on is the 1KB 
limit.

* If my understanding about how CONFIG_ARM_DMA_MEM_BUFFERABLE affects 
readl/writel was correct and we agree on the IO access ordering update, 
then it would show that mb()s matter for more than just DMA. In which 
case, I wanted to split that single config into two and clean up the 
names while still leaving CONFIG_ARM_DMA_MEM_BUFFERABLE functionally the 
same.
Result?: After the above discussion, I hope the community agrees that 
it's reasonable to reorganize and rename the config to make the config 
more understandable and less confusing to developers. Less confusion == 
less bugs in my opinion. I will send out a patch sometime this week to 
show what I mean.

But modifying the behaviour of DMA was not my intention. I will of 
course read the discussion you mention (will ping you if I can't find 
it) to get a better understanding of the DMA stuff.

Catalin,

To summarize,
Our internal ARM expert continues to state that the 1KB is the minimum 
limit even within a single device. Judging his expertise based on my 
previous interactions with him, I'm inclined to believe him. I think at 
the least we should give him the benefit of the doubt. Looks like a 
definitive way to settle this disagreement would be to check with the 
author of those updates/comment I referred to in the ARMv7 ARM.

If the 1KB limit is correct, it would certainly help improving the 
correctness of drivers for the ARM kernel. If the 1KB limit is wrong, we 
don't lose anything.

So, if you don't mind, could you please check with the author of those 
updates and comments in the ARMv7 ARM?

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
