Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1KCCVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:21:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab1KCBc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:32:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:51 2011
Message-Id: <20111102221451.381540716@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiajun Wu <b06378@freescale.com>,
        Li Yang <leoli@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [014/107] powerpc/mpic: Fix problem that affinity is not updated
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Yang Li <leoli@freescale.com>

commit 38e1313fc753482b93aa6c6f11cfbd43a5bcd963 upstream.

Since commit 57b150cce8e004ddd36330490a68bfb59b7271e9, desc->affinity
of an irq is changed after calling desc->chip->set_affinity.
Therefore we need to fix the irq_choose_cpu() not to depend on the
desc->affinity for new mask.

Signed-off-by: Jiajun Wu <b06378@freescale.com>
Signed-off-by: Li Yang <leoli@freescale.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/sysdev/mpic.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -567,12 +567,10 @@ static void __init mpic_scan_ht_pics(str
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
 #ifdef CONFIG_SMP
-static int irq_choose_cpu(unsigned int virt_irq)
+static int irq_choose_cpu(const cpumask_t *mask)
 {
-	cpumask_t mask;
 	int cpuid;
 
-	cpumask_copy(&mask, irq_desc[virt_irq].affinity);
 	if (cpus_equal(mask, CPU_MASK_ALL)) {
 		static int irq_rover;
 		static DEFINE_SPINLOCK(irq_rover_lock);
@@ -594,20 +592,15 @@ static int irq_choose_cpu(unsigned int v
 
 		spin_unlock_irqrestore(&irq_rover_lock, flags);
 	} else {
-		cpumask_t tmp;
-
-		cpus_and(tmp, cpu_online_map, mask);
-
-		if (cpus_empty(tmp))
+		cpuid = cpumask_first_and(mask, cpu_online_mask);
+		if (cpuid >= nr_cpu_ids)
 			goto do_round_robin;
-
-		cpuid = first_cpu(tmp);
 	}
 
 	return get_hard_smp_processor_id(cpuid);
 }
 #else
-static int irq_choose_cpu(unsigned int virt_irq)
+static int irq_choose_cpu(const cpumask_t *mask)
 {
 	return hard_smp_processor_id();
 }
@@ -816,7 +809,7 @@ int mpic_set_affinity(unsigned int irq,
 	unsigned int src = mpic_irq_to_hw(irq);
 
 	if (mpic->flags & MPIC_SINGLE_DEST_CPU) {
-		int cpuid = irq_choose_cpu(irq);
+		int cpuid = irq_choose_cpu(cpumask);
 
 		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION), 1 << cpuid);
 	} else {


