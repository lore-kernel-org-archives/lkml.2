Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901Ab1CIRlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:41:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:8739 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932876Ab1CIRln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:41:43 -0500
X-IronPort-AV: E=Sophos;i="4.62,291,1297054800"; 
   d="scan'208";a="139432613"
From: Ian Campbell <ian.campbell@citrix.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 07/14] xen: events: use per-cpu variable for cpu_evtchn_mask
Date: Wed,  9 Mar 2011 17:41:19 +0000
Message-Id: <1299692486-28634-7-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Mar 2011 17:41:43.0289 (UTC) FILETIME=[41007E90:01CBDE81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't see any reason why it isn't already.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index a40b2a1..2dffa43 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -107,19 +107,9 @@ static struct irq_info *irq_info;
 static int *pirq_to_irq;
 
 static int *evtchn_to_irq;
-struct cpu_evtchn_s {
-	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
-};
-
-static __initdata struct cpu_evtchn_s init_evtchn_mask = {
-	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
-};
-static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
 
-static inline unsigned long *cpu_evtchn_mask(int cpu)
-{
-	return cpu_evtchn_mask_p[cpu].bits;
-}
+static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
+		      cpu_evtchn_mask);
 
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
@@ -257,7 +247,7 @@ static inline unsigned long active_evtchns(unsigned int cpu,
 					   unsigned int idx)
 {
 	return (sh->evtchn_pending[idx] &
-		cpu_evtchn_mask(cpu)[idx] &
+		per_cpu(cpu_evtchn_mask, cpu)[idx] &
 		~sh->evtchn_mask[idx]);
 }
 
@@ -270,8 +260,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 	cpumask_copy(irq_to_desc(irq)->irq_data.affinity, cpumask_of(cpu));
 #endif
 
-	clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
-	set_bit(chn, cpu_evtchn_mask(cpu));
+	clear_bit(chn, per_cpu(cpu_evtchn_mask, cpu_from_irq(irq)));
+	set_bit(chn, per_cpu(cpu_evtchn_mask, cpu));
 
 	irq_info[irq].cpu = cpu;
 }
@@ -289,8 +279,8 @@ static void init_evtchn_cpu_bindings(void)
 #endif
 
 	for_each_possible_cpu(i)
-		memset(cpu_evtchn_mask(i),
-		       (i == 0) ? ~0 : 0, sizeof(struct cpu_evtchn_s));
+		memset(per_cpu(cpu_evtchn_mask, i),
+		       (i == 0) ? ~0 : 0, sizeof(*per_cpu(cpu_evtchn_mask, i)));
 
 }
 
@@ -925,7 +915,7 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 {
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int cpu = smp_processor_id();
-	unsigned long *cpu_evtchn = cpu_evtchn_mask(cpu);
+	unsigned long *cpu_evtchn = per_cpu(cpu_evtchn_mask, cpu);
 	int i;
 	unsigned long flags;
 	static DEFINE_SPINLOCK(debug_lock);
@@ -1462,8 +1452,6 @@ void __init xen_init_IRQ(void)
 {
 	int i;
 
-	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
-				    GFP_KERNEL);
 	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
 
 	/* We are using nr_irqs as the maximum number of pirq available but
-- 
1.5.6.5

