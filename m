Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab1CCHtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:49:51 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21743 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab1CCHtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:49:49 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77717140"
Message-ID: <4D6F481B.8000700@codeaurora.org>
Date: Wed, 02 Mar 2011 23:49:47 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
References: <4D6D9C03.2080906@codeaurora.org> <20110302083904.GA4493@n2100.arm.linux.org.uk>
In-Reply-To: <20110302083904.GA4493@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry that it took a while for me to get back. Had to contact our 
resident ARM expert to reconfirm my points and gather all the data in an 
externally available format.

On 03/02/2011 12:39 AM, Russell King - ARM Linux wrote:
> On Tue, Mar 01, 2011 at 05:23:15PM -0800, Saravana Kannan wrote:
>> If I'm not missing some magic, this would mean that
>> "CONFIG_ARM_DMA_MEM_BUFFERABLE" determines if readl(s)/writel(s) get to
>> have a built in mb() or not.
>
> You're missing that CONFIG_ARM_DMA_MEM_BUFFERABLE not only changes
> readl/writel but also the type for DMA coherent memory from strongly
> ordered to memory, non-cacheable.

Yeah, I noticed that after I sent the email, but my questions in my 
previous email still remains valid. See below.

> The barriers are required to ensure that reads and writes to DMA
> coherent memory are visible to the DMA device before the write
> completes, and any value read from DMA coherent memory will not
> bypass a read from a DMA device.
>
> The barriers in the IO macros have nothing to do with whether reads/writes
> to normal cacheable memory are visible to DMA devices.  That is what the
> streaming DMA API is for.
>
> In any case, the IO macros are always ordered with respect to other
> device writes irrespective of CONFIG_ARM_DMA_MEM_BUFFERABLE.

<snip>

> I think you misunderstand what's going on.  IO accesses are always ordered
> with respect to themselves.  The barriers are there to ensure ordering
> between DMA coherent memory (normal non-cached memory) and IO accesses
> (device).

Unfortunately this is not correct. The ARM spec doesn't guarantee that 
all IO accesses should be ordered with respect to themselves. It only 
requires that the ordering should be guaranteed at least within a 1KB 
region.

You can find this info in ARMv7 ARM spec[1] named 
"DDI0406B_arm_architecture_reference_manual_errata_markup_8_0.pdf", on 
page A3-45. There is a para that goes:

"Accesses must arrive at any particular memory-mapped peripheral or 
block of memory in program order, that is, A1 must arrive before A2. 
There are no ordering restrictions about when accesses arrive at 
different peripherals or blocks of memory, provided that the accesses 
follow the general ordering rules given in this section."

And the most critical point is hidden in a comment that goes:
"The size of a memory mapped peripheral, or a block of memory, is 
IMPLEMENTATION DEFINED, but is not smaller than 1KByte."

I guess most of the confusion is due to the ARM spec not being very 
obvious about the 1KB limitation.

So, going back to my point, I think it's wrong for 
CONFIG_ARM_DMA_MEM_BUFFERABLE to control how stuff unrelated to DMA behaves.

I have also encountered a few people who kept went "but readl/writel was 
recently changed to add mem barriers, so we can all remove the mb()s in 
our driver (unrelated to DMA) code". That would have made their code 
incorrect for two reasons:
1. readl/writel doesn't always have a mem barrier because of config that 
can be turned off.
2. In cases where readl/writel didn't have mb(), there is not enough 
ordering guarantee without an explicit mb().

I think as a community, we should stop saying that readl/writel ensures 
ordering with respect to all IO accesses. It doesn't even guarantee 
ordering within the same device (when their register regions are > 1KB).

After reading the above, please let me know if a patch to decouple the 
"readl/writel with builtin mb()" from CONFIG_ARM_DMA_MEM_BUFFERABLE 
would be accepted. If so, I can go ahead and send it out soon.

[1] 
http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.ddi0406b/index.html

Thanks,
Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
