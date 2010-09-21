Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0IUUFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 16:05:08 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43554 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab0IUUFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 16:05:07 -0400
Date: Tue, 21 Sep 2010 15:05:02 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: [PATCH] x86 - irq vector assignment
Message-ID: <20100921200502.GA26587@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to assign irq vectors to cpus on the correct node & fall back to global
assignment only if node-local fails. This reduces the chances of
using all of the interrupt vectors of a single cpu.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
Note: this is a fix for a problem we saw on systems with a large number of IOHs.
The IOHs are distributed across 10's of nodes.

Early in boot, the IO infrastructure assigns interrupts for the DMA engines.
Currently, all interrupts are targeted to cpu 0. This uses all interrupt
vectors on cpu 0. Later, some drivers try to create irqs targeted to
cpu 0. The assignment fails because all vectors are assigned.

This is a repost of a patch sent earlier. See
	http://marc.info/?l=linux-kernel&m=127740806705617&w=2
	http://marc.info/?l=linux-kernel&m=127791052828867&w=2



 arch/x86/kernel/apic/io_apic.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2010-09-17 13:00:19.164638447 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2010-09-17 13:00:23.448595373 -0500
@@ -3253,6 +3253,11 @@ unsigned int create_irq_nr(unsigned int
 		desc_new = move_irq_desc(desc_new, node);
 		cfg_new = desc_new->chip_data;
 
+#ifdef CONFIG_NUMA
+		if (node >= 0 && __assign_irq_vector(new, cfg_new, node_to_cpumask_map[node]) == 0)
+			irq = new;
+		else
+#endif
 		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
