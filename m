Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0G1H2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 03:28:14 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59812 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab0G1H2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 03:28:10 -0400
X-Sasl-enc: CfiPCmeCDREV7wfEeW5K9eIcPAWUyWg7YBbthQCXzEmr 1280302089
Message-ID: <4C4FDC06.3050703@ladisch.de>
Date: Wed, 28 Jul 2010 09:28:06 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH + an old question] firewire: ohci: use memory barriers
 to order descriptor updates
References: <tkrat.21d3972644f46dc9@s5r6.in-berlin.de>
In-Reply-To: <tkrat.21d3972644f46dc9@s5r6.in-berlin.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> We need:
> 2. a write memory barrier between branch_address update and wake-up of
>    the DMA unit by MMIO register write.
> 
> Barrier 2 is implicit in writel() on most machines --- or at least I
> think it is.  See this from arch/x86/include/asm/io.h:
> 
>     #define build_mmio_write(name, size, type, reg, barrier) \
>     static inline void name(type val, volatile void __iomem *addr) \
>     { asm volatile("mov" size " %0,%1": :reg (val), \
>     "m" (*(volatile type __force *)addr) barrier); }
> 
>     build_mmio_write(writel, "l", unsigned int, "r", :"memory")
> 
> Does this order the mmio write relative to previous memory writes?

This asm barrier prevents the compiler from reordering.

The main purpose of writel() and friends is to access the address space
where memory-mapped I/O ranges reside; there are architectures where the
normal memory access commands cannot be used.  This does not necessarily
imply anything about reordering semantics.

However, PCI address ranges are marked by the device's config registers
as either cacheable or not, and the kernel heeds this when mapping these
ranges.  Registers are, of course, marked as uncacheable.


Regards,
Clemens
