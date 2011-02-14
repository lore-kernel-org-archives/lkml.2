Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BNNBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:01:39 -0500
Received: from service87.mimecast.com ([94.185.240.25]:40726 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752631Ab1BNNBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:01:37 -0500
Subject: Re: [PATCH v4 16/19] ARM: LPAE: Use generic dma_addr_t type
 definition
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>
In-Reply-To: <20110212103413.GD15616@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com>
	 <1295891761-18366-17-git-send-email-catalin.marinas@arm.com>
	 <20110212103413.GD15616@n2100.arm.linux.org.uk>
Organization: ARM Limited
Date: Mon, 14 Feb 2011 13:01:30 +0000
Message-ID: <1297688490.31111.38.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 14 Feb 2011 13:01:32.0835 (UTC) FILETIME=[4DB08730:01CBCC47]
X-MC-Unique: 111021413013401601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-12 at 10:34 +0000, Russell King - ARM Linux wrote:
> On Mon, Jan 24, 2011 at 05:55:58PM +0000, Catalin Marinas wrote:
> > From: Will Deacon <will.deacon@arm.com>
> >
> > This patch uses the types.h implementation in asm-generic to define the
> > dma_addr_t type as the same width as phys_addr_t.
> >
> > NOTE: this is a temporary patch until the corresponding patches unifying
> > the dma_addr_t and removing the dma64_addr_t are merged into mainline.
> 
> I'm not too sure about this patch.  All of the DMA devices we have only
> take 32-bit addresses for their DMA, so making dma_addr_t 64-bit seems
> wrong as we'll implicitly truncate these addresses.

If we don't enable LPAE, the dma_addr_t is 32-bit, so existing platforms
are not affected. With Cortex-A15, new platforms may have PCIe and be
able to access memory beyond 32-bit (if they don't support >32-bit DMA
at least for some critical devices, I'm not sure why they would use
A15).

For things like hard drives for example, it becomes problematic as pages
are allocated by the VFS layer from highmem and passed to the driver for
DMA. If we keep dma_addr_t to 32-bit you would need to use DMA bounce
even if the PCIe device supports >32-bit physical addresses.

> As ARM platforms don't (sanely) support DMA, I think dropping this patch
> for the time being would be a good idea, and stick with 32-bit dma_addr_t,
> especially as we need to first do a sweep for dma_addr_t usage in device
> driver structures (such as dma engine scatter lists.)  These really should
> use __le32/__be32/u32 depending on whether they're little endian, big
> endian or native endian.

Maybe we could make the dma_addr_t size configurable (and disabled by
default) since I expect there'll be platforms capable of >32-bit DMA.

-- 
Catalin


