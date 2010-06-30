Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab0F3PIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:08:35 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52283 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752334Ab0F3PIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:08:34 -0400
Date: Wed, 30 Jun 2010 10:08:29 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86:  irq vector assignment
Message-ID: <20100630150829.GA14307@sgi.com>
References: <20100624193413.GA20457@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624193413.GA20457@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to assign irq vectors to cpus on the correct node & fall back to global
assignment only if node-local fails. This reduces the chances of
using all of the interrupt vectors of a single cpu.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---

V2 - Fix error for builds without CONFIG_NUMA.


On Thu, Jun 24, 2010 at 01:45:40PM -0700, Yinghai Lu wrote:
> how about update apic::target_cpus() to take node?


I may be overlooking something but I don't see the benefit of passing node to target_cpus().
It looks like only 1 place that calls target_cpus() has a valid "node". The other places would
pass -1. In addition, I'm not sure how some of the other subarches (ex., es7000_32) would
use the node number. Many would just ignore it.


---
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2010-06-25 08:11:07.186867196 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2010-06-25 08:41:51.790274150 -0500
@@ -3265,6 +3265,11 @@ unsigned int create_irq_nr(unsigned int
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
