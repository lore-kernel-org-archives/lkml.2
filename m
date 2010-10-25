Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab0JYQXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:23:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:44360 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab0JYQXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:23:47 -0400
X-IronPort-AV: E=Sophos;i="4.58,236,1286164800"; 
   d="scan'208";a="119590680"
From: Ian Campbell <ian.campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, xen-devel@lists.xensource.com, tglx@linutronix.de,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 5/5] xen: events: use per-cpu variable for cpu_evtchn_mask
Date: Mon, 25 Oct 2010 17:23:33 +0100
Message-Id: <1288023813-31989-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
References: <1288023736.11153.40.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 25 Oct 2010 16:23:47.0384 (UTC) FILETIME=[002DC380:01CB7461]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't see any reason why it isn't already.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 drivers/xen/events.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 9b58505..144ff72 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -110,19 +110,9 @@ static int *pirq_to_irq;
 static int nr_pirqs;
 
 static int *evtchn_to_irq;
-struct cpu_evtchn_s {
-	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
-};
 
-static __initdata struct cpu_evtchn_s init_evtchn_mask = {
-	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
-};
-static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
-
-static inline unsigned long *cpu_evtchn_mask(int cpu)
-{
-	return cpu_evtchn_mask_p[cpu].bits;
-}
+static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
+		      cpu_evtchn_mask);
 
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
@@ -301,7 +291,7 @@ static inline unsigned long active_evtchns(unsigned int cpu,
 					   unsigned int idx)
 {
 	return (sh->evtchn_pending[idx] &
-		cpu_evtchn_mask(cpu)[idx] &
+		per_cpu(cpu_evtchn_mask, cpu)[idx] &
 		~sh->evtchn_mask[idx]);
 }
 
@@ -314,8 +304,8 @@ static void bind_evtchn_to_cpu(unsigned int chn, unsigned int cpu)
 	cpumask_copy(irq_to_desc(irq)->affinity, cpumask_of(cpu));
 #endif
 
-	__clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
-	__set_bit(chn, cpu_evtchn_mask(cpu));
+	__clear_bit(chn, per_cpu(cpu_evtchn_mask, cpu_from_irq(irq)));
+	__set_bit(chn, per_cpu(cpu_evtchn_mask, cpu));
 
 	info_for_irq(irq)->cpu = cpu;
 }
@@ -332,7 +322,11 @@ static void init_evtchn_cpu_bindings(void)
 	}
 #endif
 
-	memset(cpu_evtchn_mask(0), ~0, sizeof(struct cpu_evtchn_s));
+	printk(KERN_CRIT "%s: CPU0 at %p size %zd\n", __func__,
+	       per_cpu(cpu_evtchn_mask, 0),
+	       sizeof(per_cpu(cpu_evtchn_mask, 0)));
+	memset(per_cpu(cpu_evtchn_mask, 0), ~0,
+	       sizeof(per_cpu(cpu_evtchn_mask, 0)));
 }
 
 static inline void clear_evtchn(int port)
@@ -1034,7 +1028,7 @@ irqreturn_t xen_debug_interrupt(int irq, void *dev_id)
 {
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int cpu = smp_processor_id();
-	unsigned long *cpu_evtchn = cpu_evtchn_mask(cpu);
+	unsigned long *cpu_evtchn = per_cpu(cpu_evtchn_mask, cpu);
 	int i;
 	unsigned long flags;
 	static DEFINE_SPINLOCK(debug_lock);
@@ -1539,9 +1533,6 @@ void __init xen_init_IRQ(void)
 	int i, rc;
 	struct physdev_nr_pirqs op_nr_pirqs;
 
-	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
-				    GFP_KERNEL);
-
 	rc = HYPERVISOR_physdev_op(PHYSDEVOP_get_nr_pirqs, &op_nr_pirqs);
 	if (rc < 0) {
 		nr_pirqs = nr_irqs;
-- 
1.5.6.5

