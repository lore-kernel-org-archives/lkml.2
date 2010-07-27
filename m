Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab0G0LUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:20:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:42821 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0G0LUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:20:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 27 Jul 2010 13:20:33 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH + an old question] firewire: ohci: use memory barriers to
 order descriptor updates
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.21d3972644f46dc9@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we append to a DMA program, we need to ensure that the PCI device
sees the updates in the intended order.  We need:

1. a write memory barrier between initialization of new descriptors and
   the update of the last old descriptor to point to the new
   descriptors (i.e. branch_address update),

2. a write memory barrier between branch_address update and wake-up of
   the DMA unit by MMIO register write.

This patch adds only barrier 1.

Barrier 2 is implicit in writel() on most machines --- or at least I
think it is.  See this from arch/alpha/include/asm/io.h:

    #define build_mmio_write(name, size, type, reg, barrier) \
    static inline void name(type val, volatile void __iomem *addr) \
    { asm volatile("mov" size " %0,%1": :reg (val), \
    "m" (*(volatile type __force *)addr) barrier); }

    build_mmio_write(writel, "l", unsigned int, "r", :"memory")

Does this order the mmio write relative to previous memory writes?

I am not so sure about barrier semantics of writel() on some less
popular architectures.  From arch/alpha/include/asm/io.h:

    extern inline void writel(u32 b, volatile void __iomem *addr)
    {
	    __raw_writel(b, addr);
	    mb();
    }

This mb() is nice but we need a barrier in front of the __raw_writel.
Somebody who cares might want to add it in the architecture code or in
hundreds of drivers.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -595,6 +595,7 @@ static int ar_context_add_page(struct ar
 	ab->descriptor.res_count      = cpu_to_le16(PAGE_SIZE - offset);
 	ab->descriptor.branch_address = 0;
 
+	wmb(); /* finish init of new descriptors before branch_address update */
 	ctx->last_buffer->descriptor.branch_address = cpu_to_le32(ab_bus | 1);
 	ctx->last_buffer->next = ab;
 	ctx->last_buffer = ab;
@@ -982,6 +983,8 @@ static void context_append(struct contex
 	d_bus = desc->buffer_bus + (d - desc->buffer) * sizeof(*d);
 
 	desc->used += (z + extra) * sizeof(*d);
+
+	wmb(); /* finish init of new descriptors before branch_address update */
 	ctx->prev->branch_address = cpu_to_le32(d_bus | z);
 	ctx->prev = find_branch_descriptor(d, z);
 

-- 
Stefan Richter
-=====-==-=- -=== ==-==
http://arcgraph.de/sr/

