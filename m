Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0GBGRo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:17:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52645 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab0GBGRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:17:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6030"; a="46260772"
Message-ID: <4C2D847E.5080602@codeaurora.org>
Date: Thu, 01 Jul 2010 23:17:34 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Daniel Walker <dwalker@codeaurora.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, mel@csn.ul.ie,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 3/3] mm: iommu: The Virtual Contiguous Memory Manager
References: <1277877350-2147-1-git-send-email-zpfeffer@codeaurora.org> <1277877350-2147-3-git-send-email-zpfeffer@codeaurora.org> <20100701101746.3810cc3b.randy.dunlap@oracle.com> <20100701180241.GA3594@basil.fritz.box> <1278012503.7738.17.camel@c-dwalke-linux.qualcomm.com> <20100701193850.GB3594@basil.fritz.box> <4C2D0FF1.6010206@codeaurora.org> <20100701230056.GD3594@basil.fritz.box>
In-Reply-To: <20100701230056.GD3594@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> The VCMM provides a more abstract, global view with finer-grained
>> control of each mapping a user wants to create. For instance, the
>> semantics of iommu_map preclude its use in setting up just the IOMMU
>> side of a mapping. With a one-sided map, two IOMMU devices can be
> 
> Hmm? dma_map_* does not change any CPU mappings. It only sets up
> DMA mapping(s).

Sure, but I was saying that iommu_map() doesn't just set up the IOMMU
mappings, its sets up both the iommu and kernel buffer mappings.

> 
>> Additionally, the current IOMMU interface does not allow users to
>> associate one page table with multiple IOMMUs unless the user explicitly
> 
> That assumes that all the IOMMUs on the system support the same page table
> format, right?

Actually no. Since the VCMM abstracts a page-table as a Virtual
Contiguous Region (VCM) a VCM can be associated with any device,
regardless of their individual page table format.

> 
> As I understand your approach would help if you have different
> IOMMus with an different low level interface, which just 
> happen to have the same pte format. Is that very likely?
> 
> I would assume if you have lots of copies of the same IOMMU
> in the system then you could just use a single driver with multiple
> instances that share some state for all of them.  That model
> would fit in the current interfaces. There's no reason multiple
> instances couldn't share the same allocation data structure.
> 
> And if you have lots of truly different IOMMUs then they likely
> won't be able to share PTEs at the hardware level anyways, because
> the formats are too different.

See VCM's above.

> 
>> The VCMM takes the long view. Its designed for a future in which the
>> number of IOMMUs will go up and the ways in which these IOMMUs are
>> composed will vary from system to system, and may vary at
>> runtime. Already, there are ~20 different IOMMU map implementations in
>> the kernel. Had the Linux kernel had the VCMM, many of those
>> implementations could have leveraged the mapping and topology management
>> of a VCMM, while focusing on a few key hardware specific functions (map
>> this physical address, program the page table base register).
> 
> The standard Linux approach to such a problem is to write
> a library that drivers can use for common functionality, not put a middle 
> layer in between. Libraries are much more flexible than layers.

That's true up to the, "is this middle layer so useful that its worth
it" point. The VM is a middle layer, you could make the same argument
about it, "the mapping code isn't too hard, just map in the memory
that you need and be done with it". But the VM middle layer provides a
clean separation between page frames and pages which turns out to be
infinitely useful. The VCMM is built in the same spirit, It says
things like, "mapping is a global problem, I'm going to abstract
entire virtual spaces and allow people arbitrary chuck size
allocation, I'm not going to care that my device is physically mapping
this buffer and this other device is a virtual, virtual device."

> 
> That said I'm not sure there's all that much duplicated code anyways.
> A lot of the code is always IOMMU specific. The only piece
> which might be shareable is the mapping allocation, but I don't
> think that's very much of a typical driver
> 
> In my old pci-gart driver the allocation was all only a few lines of code, 
> although given it was somewhat dumb in this regard because it only managed a 
> small remapping window.

I agree that its not a lot of code, and that this layer may be a bit heavy, but I'd like to focus on is a global mapping view useful and if so is something like the graph management that the VCMM provides generally useful.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
