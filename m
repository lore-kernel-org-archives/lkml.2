Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0G1JJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 05:09:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50783 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0G1JJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 05:09:24 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C4FF3B3.1050800@s5r6.in-berlin.de>
Date: Wed, 28 Jul 2010 11:09:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH + an old question] firewire: ohci: use memory barriers
 to order descriptor updates
References: <tkrat.21d3972644f46dc9@s5r6.in-berlin.de> <4C4FDC06.3050703@ladisch.de>
In-Reply-To: <4C4FDC06.3050703@ladisch.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Stefan Richter wrote:
>> We need:
>> 2. a write memory barrier between branch_address update and wake-up of
>>    the DMA unit by MMIO register write.
>>
>> Barrier 2 is implicit in writel() on most machines --- or at least I
>> think it is.  See this from arch/x86/include/asm/io.h:
>>
>>     #define build_mmio_write(name, size, type, reg, barrier) \
>>     static inline void name(type val, volatile void __iomem *addr) \
>>     { asm volatile("mov" size " %0,%1": :reg (val), \
>>     "m" (*(volatile type __force *)addr) barrier); }
>>
>>     build_mmio_write(writel, "l", unsigned int, "r", :"memory")
>>
>> Does this order the mmio write relative to previous memory writes?
> 
> This asm barrier prevents the compiler from reordering.
> 
> The main purpose of writel() and friends is to access the address space
> where memory-mapped I/O ranges reside; there are architectures where the
> normal memory access commands cannot be used.  This does not necessarily
> imply anything about reordering semantics.
> 
> However, PCI address ranges are marked by the device's config registers
> as either cacheable or not, and the kernel heeds this when mapping these
> ranges.  Registers are, of course, marked as uncacheable.

But the memory to which we wrote before that is cachable (though
cache-coherent, allocated by dma_alloc_coherent).  This memory write
should not cross the mmio register write.

Documentation/DocBook/deviceiobook.tmpl mentions that mmio reads to a
device are ordered WRT to DMA transactions that the device issued before
that mmio read.  But no mentions of mmio write to a device vs. preceding
memory accesses by the CPU.

Well, a quick look how some hopefully well-written drivers use and don't
use wmb() indicates that I don't need to worry.  Perhaps it is time to
look for a PCI book.
-- 
Stefan Richter
-=====-==-=- -=== ===--
http://arcgraph.de/sr/
