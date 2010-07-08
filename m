Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab0GHX76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 19:59:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26790 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab0GHX7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 19:59:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6037"; a="46915312"
Message-ID: <4C366678.60605@codeaurora.org>
Date: Thu, 08 Jul 2010 16:59:52 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-arch@vger.kernel.org,
       dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
References: <1278135507-20294-1-git-send-email-zpfeffer@codeaurora.org> <m14oggpepx.fsf@fess.ebiederm.org> <4C35034B.6040906@codeaurora.org> <20100707230710.GA31792@n2100.arm.linux.org.uk>
In-Reply-To: <20100707230710.GA31792@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Wed, Jul 07, 2010 at 03:44:27PM -0700, Zach Pfeffer wrote:
>> The DMA API handles the allocation and use of DMA channels. It can
>> configure physical transfer settings, manage scatter-gather lists,
>> etc. 
> 
> You're confused about what the DMA API is.  You're talking about
> the DMA engine subsystem (drivers/dma) not the DMA API (see
> Documentation/DMA-API.txt, include/linux/dma-mapping.h, and
> arch/arm/include/asm/dma-mapping.h)

Thanks for the clarification. 

> 
>> The VCM allows all device buffers to be passed between all devices in
>> the system without passing those buffers through each domain's
>> API. This means that instead of writing code to interoperate between
>> DMA engines, IOMMU mapped spaces, CPUs and physically addressed
>> devices the user can simply target a device with a buffer using the
>> same API regardless of how that device maps or otherwise accesses the
>> buffer.
> 
> With the DMA API, if we have a SG list which refers to the physical
> pages (as a struct page, offset, length tuple), the DMA API takes
> care of dealing with CPU caches and IOMMUs to make the data in the
> buffer visible to the target device.  It provides you with a set of
> cookies referring to the SG lists, which may be coalesced if the
> IOMMU can do so.
> 
> If you have a kernel virtual address, the DMA API has single buffer
> mapping/unmapping functions to do the same thing, and provide you
> with a cookie to pass to the device to refer to that buffer.
> 
> These cookies are whatever the device needs to be able to access
> the buffer - for instance, if system SDRAM is located at 0xc0000000
> virtual, 0x80000000 physical and 0x40000000 as far as the DMA device
> is concerned, then the cookie for a buffer at 0xc0000000 virtual will
> be 0x40000000 and not 0x80000000.

It sounds like I've got some work to do. I appreciate the feedback.

The problem I'm trying to solve boils down to this: map a set of
contiguous physical buffers to an aligned IOMMU address. I need to
allocate the set of physical buffers in a particular way: use 1 MB
contiguous physical memory, then 64 KB, then 4 KB, etc. and I need to
align the IOMMU address in a particular way. I also need to swap out the
IOMMU address spaces and map the buffers into the kernel.

I have this all solved, but it sounds like I'll need to migrate to the DMA
API to upstream it.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
