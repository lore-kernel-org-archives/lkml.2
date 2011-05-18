Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1ERXcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:32:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:35438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab1ERXcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,234,1304319600"; 
   d="scan'208";a="438684143"
Message-Id: <20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Wed, 18 May 2011 16:31:31 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com, <stable@kernel.org>
Subject: [patch 1/9] x86, ioapic: fix potential resume deadlock
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=fix_gfp_kernel_alloc_with_irqs_disabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel J Blueman <daniel.blueman@gmail.com>

Fix a potential deadlock when resuming; here the calling function
has disabled interrupts, so we cannot sleep.

Change the memory allocation flag from GFP_KERNEL to GFP_ATOMIC.

TODO: We can do away with this memory allocation during resume by
reusing the ioapic suspend/resume code that uses boot time allocated
buffers.

Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <stable@kernel.org>     # v2.6.39
---
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -621,14 +621,14 @@ struct IO_APIC_route_entry **alloc_ioapi
 	struct IO_APIC_route_entry **ioapic_entries;
 
 	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_KERNEL);
+				GFP_ATOMIC);
 	if (!ioapic_entries)
 		return 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
 		ioapic_entries[apic] =
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_KERNEL);
+				nr_ioapic_registers[apic], GFP_ATOMIC);
 		if (!ioapic_entries[apic])
 			goto nomem;
 	}


