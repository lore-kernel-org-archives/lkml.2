Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab1IGRLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:11:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59678 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1IGRLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:11:36 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@elte.hu,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Arnd Bergmann <arnd@arndb.de>,
        Geoff Levand <geoff@infradead.org>, Yong Zhang <yong.zhang0@gmail.com>,
        Milton Miller <miltonm@bga.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        Meador Inge <meador_inge@mentor.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 17/62] powerpc: irq: Remove IRQF_DISABLED
Date: Wed,  7 Sep 2011 16:10:14 +0800
Message-Id: <1315383059-3673-18-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag is a NOOP and can be removed now.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/powerpc/include/asm/floppy.h              |    4 ++--
 arch/powerpc/include/asm/xics.h                |    4 ++--
 arch/powerpc/kernel/smp.c                      |    2 +-
 arch/powerpc/platforms/cell/beat.c             |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
 arch/powerpc/platforms/cell/iommu.c            |    3 +--
 arch/powerpc/platforms/cell/pmu.c              |    2 +-
 arch/powerpc/platforms/cell/spu_base.c         |    9 +++------
 arch/powerpc/platforms/powermac/pic.c          |    1 -
 arch/powerpc/platforms/powermac/smp.c          |    4 ++--
 arch/powerpc/platforms/ps3/device-init.c       |    2 +-
 arch/powerpc/sysdev/mpic.c                     |    2 --
 arch/powerpc/sysdev/ppc4xx_soc.c               |    2 +-
 arch/powerpc/sysdev/xics/xics-common.c         |    5 ++---
 14 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/floppy.h b/arch/powerpc/include/asm/floppy.h
index 24bd34c..936a904 100644
--- a/arch/powerpc/include/asm/floppy.h
+++ b/arch/powerpc/include/asm/floppy.h
@@ -108,10 +108,10 @@ static int fd_request_irq(void)
 {
 	if (can_use_virtual_dma)
 		return request_irq(FLOPPY_IRQ, floppy_hardint,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 	else
 		return request_irq(FLOPPY_IRQ, floppy_interrupt,
-				   IRQF_DISABLED, "floppy", NULL);
+				   0, "floppy", NULL);
 }
 
 static int vdma_dma_setup(char *addr, unsigned long size, int mode, int io)
diff --git a/arch/powerpc/include/asm/xics.h b/arch/powerpc/include/asm/xics.h
index b183a40..c78e58a 100644
--- a/arch/powerpc/include/asm/xics.h
+++ b/arch/powerpc/include/asm/xics.h
@@ -15,8 +15,8 @@
 #define	DEFAULT_PRIORITY	5
 
 /*
- * Mark IPIs as higher priority so we can take them inside interrupts that
- * arent marked IRQF_DISABLED
+ * Mark IPIs as higher priority so we can take them inside interrupts
+ * FIXME: still true now?
  */
 #define IPI_PRIORITY		4
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 7bf2187..1ff95e0 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -170,7 +170,7 @@ int smp_request_message_ipi(int virq, int msg)
 		return 1;
 	}
 #endif
-	err = request_irq(virq, smp_ipi_action[msg], IRQF_DISABLED|IRQF_PERCPU,
+	err = request_irq(virq, smp_ipi_action[msg], IRQF_PERCPU,
 			  smp_ipi_name[msg], 0);
 	WARN(err < 0, "unable to request_irq %d for %s (rc %d)\n",
 		virq, smp_ipi_name[msg], err);
diff --git a/arch/powerpc/platforms/cell/beat.c b/arch/powerpc/platforms/cell/beat.c
index 48c690e..14ebf59 100644
--- a/arch/powerpc/platforms/cell/beat.c
+++ b/arch/powerpc/platforms/cell/beat.c
@@ -230,7 +230,7 @@ static int __init beat_register_event(void)
 		}
 		ev->virq = virq;
 
-		rc = request_irq(virq, ev->handler, IRQF_DISABLED,
+		rc = request_irq(virq, ev->handler, 0,
 				      ev->typecode, NULL);
 		if (rc != 0) {
 			printk(KERN_ERR "Beat: failed to request virtual IRQ"
diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index ae790ac..14be2bd 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -514,7 +514,7 @@ static __init int celleb_setup_pciex(struct device_node *node,
 	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
 				     oirq.size);
 	if (request_irq(virq, pciex_handle_internal_irq,
-			IRQF_DISABLED, "pciex", (void *)phb)) {
+			0, "pciex", (void *)phb)) {
 		pr_err("PCIEXC:Failed to request irq\n");
 		goto error;
 	}
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index 26a0671..afdcd5b 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -412,8 +412,7 @@ static void cell_iommu_enable_hardware(struct cbe_iommu *iommu)
 			IIC_IRQ_IOEX_ATI | (iommu->nid << IIC_IRQ_NODE_SHIFT));
 	BUG_ON(virq == NO_IRQ);
 
-	ret = request_irq(virq, ioc_interrupt, IRQF_DISABLED,
-			iommu->name, iommu);
+	ret = request_irq(virq, ioc_interrupt, 0, iommu->name, iommu);
 	BUG_ON(ret);
 
 	/* set the IOC segment table origin register (and turn on the iommu) */
diff --git a/arch/powerpc/platforms/cell/pmu.c b/arch/powerpc/platforms/cell/pmu.c
index 69ed0d7f..16dd36c 100644
--- a/arch/powerpc/platforms/cell/pmu.c
+++ b/arch/powerpc/platforms/cell/pmu.c
@@ -391,7 +391,7 @@ static int __init cbe_init_pm_irq(void)
 		}
 
 		rc = request_irq(irq, cbe_pm_irq,
-				 IRQF_DISABLED, "cbe-pmu-0", NULL);
+				 0, "cbe-pmu-0", NULL);
 		if (rc) {
 			printk("ERROR: Request for irq on node %d failed\n",
 			       node);
diff --git a/arch/powerpc/platforms/cell/spu_base.c b/arch/powerpc/platforms/cell/spu_base.c
index 3675da7..e94d3ec 100644
--- a/arch/powerpc/platforms/cell/spu_base.c
+++ b/arch/powerpc/platforms/cell/spu_base.c
@@ -442,8 +442,7 @@ static int spu_request_irqs(struct spu *spu)
 		snprintf(spu->irq_c0, sizeof (spu->irq_c0), "spe%02d.0",
 			 spu->number);
 		ret = request_irq(spu->irqs[0], spu_irq_class_0,
-				  IRQF_DISABLED,
-				  spu->irq_c0, spu);
+				  0, spu->irq_c0, spu);
 		if (ret)
 			goto bail0;
 	}
@@ -451,8 +450,7 @@ static int spu_request_irqs(struct spu *spu)
 		snprintf(spu->irq_c1, sizeof (spu->irq_c1), "spe%02d.1",
 			 spu->number);
 		ret = request_irq(spu->irqs[1], spu_irq_class_1,
-				  IRQF_DISABLED,
-				  spu->irq_c1, spu);
+				  0, spu->irq_c1, spu);
 		if (ret)
 			goto bail1;
 	}
@@ -460,8 +458,7 @@ static int spu_request_irqs(struct spu *spu)
 		snprintf(spu->irq_c2, sizeof (spu->irq_c2), "spe%02d.2",
 			 spu->number);
 		ret = request_irq(spu->irqs[2], spu_irq_class_2,
-				  IRQF_DISABLED,
-				  spu->irq_c2, spu);
+				  0, spu->irq_c2, spu);
 		if (ret)
 			goto bail2;
 	}
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 7667db4..3e62581 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -273,7 +273,6 @@ static struct irqaction xmon_action = {
 
 static struct irqaction gatwick_cascade_action = {
 	.handler	= gatwick_action,
-	.flags		= IRQF_DISABLED,
 	.name		= "cascade",
 };
 
diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
index 9a521dc..9b6a820 100644
--- a/arch/powerpc/platforms/powermac/smp.c
+++ b/arch/powerpc/platforms/powermac/smp.c
@@ -200,7 +200,7 @@ static int psurge_secondary_ipi_init(void)
 
 	if (psurge_secondary_virq)
 		rc = request_irq(psurge_secondary_virq, psurge_ipi_intr,
-			IRQF_DISABLED|IRQF_PERCPU, "IPI", NULL);
+			IRQF_PERCPU, "IPI", NULL);
 
 	if (rc)
 		pr_err("Failed to setup secondary cpu IPI\n");
@@ -408,7 +408,7 @@ static int __init smp_psurge_kick_cpu(int nr)
 
 static struct irqaction psurge_irqaction = {
 	.handler = psurge_ipi_intr,
-	.flags = IRQF_DISABLED|IRQF_PERCPU,
+	.flags = IRQF_PERCPU,
 	.name = "primary IPI",
 };
 
diff --git a/arch/powerpc/platforms/ps3/device-init.c b/arch/powerpc/platforms/ps3/device-init.c
index 6c4b583..3f175e8 100644
--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -825,7 +825,7 @@ static int ps3_probe_thread(void *data)
 
 	spin_lock_init(&dev.lock);
 
-	res = request_irq(irq, ps3_notification_interrupt, IRQF_DISABLED,
+	res = request_irq(irq, ps3_notification_interrupt, 0,
 			  "ps3_notification", &dev);
 	if (res) {
 		pr_err("%s:%u: request_irq failed %d\n", __func__, __LINE__,
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index d5d3ff3..5216d3e 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -800,8 +800,6 @@ static void mpic_end_ipi(struct irq_data *d)
 	 * IPIs are marked IRQ_PER_CPU. This has the side effect of
 	 * preventing the IRQ_PENDING/IRQ_INPROGRESS logic from
 	 * applying to them. We EOI them late to avoid re-entering.
-	 * We mark IPI's with IRQF_DISABLED as they must run with
-	 * irqs disabled.
 	 */
 	mpic_eoi(mpic);
 }
diff --git a/arch/powerpc/sysdev/ppc4xx_soc.c b/arch/powerpc/sysdev/ppc4xx_soc.c
index d3d6ce3..0debcc3 100644
--- a/arch/powerpc/sysdev/ppc4xx_soc.c
+++ b/arch/powerpc/sysdev/ppc4xx_soc.c
@@ -115,7 +115,7 @@ static int __init ppc4xx_l2c_probe(void)
 	}
 
 	/* Install error handler */
-	if (request_irq(irq, l2c_error_handler, IRQF_DISABLED, "L2C", 0) < 0) {
+	if (request_irq(irq, l2c_error_handler, 0, "L2C", 0) < 0) {
 		printk(KERN_ERR "Cannot install L2C error handler"
 		       ", cache is not enabled\n");
 		of_node_put(np);
diff --git a/arch/powerpc/sysdev/xics/xics-common.c b/arch/powerpc/sysdev/xics/xics-common.c
index 445c5a0..ae5cdc3 100644
--- a/arch/powerpc/sysdev/xics/xics-common.c
+++ b/arch/powerpc/sysdev/xics/xics-common.c
@@ -134,11 +134,10 @@ static void xics_request_ipi(void)
 	BUG_ON(ipi == NO_IRQ);
 
 	/*
-	 * IPIs are marked IRQF_DISABLED as they must run with irqs
-	 * disabled, and PERCPU.  The handler was set in map.
+	 * IPIs are marked IRQF_PERCPU. The handler was set in map.
 	 */
 	BUG_ON(request_irq(ipi, icp_ops->ipi_action,
-			   IRQF_DISABLED|IRQF_PERCPU, "IPI", NULL));
+			   IRQF_PERCPU, "IPI", NULL));
 }
 
 int __init xics_smp_probe(void)
-- 
1.7.4.1

