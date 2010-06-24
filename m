Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0FXTeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:34:16 -0400
Received: from relay3.sgi.com ([192.48.152.1]:43744 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751769Ab0FXTeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:34:15 -0400
Date: Thu, 24 Jun 2010 14:34:13 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - irq vector assignment
Message-ID: <20100624193413.GA20457@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to assign irqs to cpus on the correct node & fall back to global
assignment only if node-local fails. This reduces the chances of
using all of the interrupt vectors of a single cpu.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/kernel/apic/io_apic.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2010-06-24 12:58:11.658933610 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2010-06-24 13:56:26.734380290 -0500
@@ -3259,7 +3259,9 @@ unsigned int create_irq_nr(unsigned int
 		desc_new = move_irq_desc(desc_new, node);
 		cfg_new = desc_new->chip_data;
 
-		if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
+		if (node >= 0 && __assign_irq_vector(new, cfg_new, node_to_cpumask_map[node]) == 0)
+			irq = new;
+		else if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
 			irq = new;
 		break;
 	}
