Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab2C3PU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:20:56 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab2C3PUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:20:45 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Jes Sorensen <jes@sgi.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Meyer <thomas@m3y3r.de>, Josh Triplett <josh@joshtriplett.org>,
        linux-ia64@vger.kernel.org, linux-altix@sgi.com,
        Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] IRQ,IA64: normalize return value of chip->irq_set_affinity() method
Date: Fri, 30 Mar 2012 23:11:36 +0800
Message-Id: <1333120296-13563-5-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
References: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IA64 platforms, interrupt controller chip's irq_set_affinity() method
always copies affinity mask to irq_data->affinity field but still returns
0(IRQ_SET_MASK_OK). That return value causes the interrupt core logic
unnecessarily copies the mask to irq_data->affinity field again.
So return IRQ_SET_MASK_OK_NOCOPY instead of IRQ_SET_MASK_OK to get rid of
the duplicated copy operation.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/ia64/kernel/iosapic.c   |    4 +++-
 arch/ia64/kernel/msi_ia64.c  |    4 ++--
 arch/ia64/sn/kernel/irq.c    |    2 +-
 arch/ia64/sn/kernel/msi_sn.c |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index ef4b5d8..47a4d1e 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -373,8 +373,10 @@ iosapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		iosapic_write(iosapic, IOSAPIC_RTE_LOW(rte_index), low32);
 	}
 
+	return IRQ_SET_MASK_OK_NOCOPY;
+#else
+	return IRQ_SET_MASK_OK;
 #endif
-	return 0;
 }
 
 /*
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index fb2f1e6..ca66c6a 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -41,7 +41,7 @@ static int ia64_set_msi_irq_affinity(struct irq_data *idata,
 	write_msi_msg(irq, &msg);
 	cpumask_copy(idata->affinity, cpumask_of(cpu));
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 #endif /* CONFIG_SMP */
 
@@ -157,7 +157,7 @@ static int dmar_msi_set_affinity(struct irq_data *data,
 	dmar_msi_write(irq, &msg);
 	cpumask_copy(data->affinity, mask);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 62cf4dd..aa58931 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -216,7 +216,7 @@ static int sn_set_affinity_irq(struct irq_data *data,
 				 sn_irq_lh[irq], list)
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 2b98b9e..ebb5b55 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -208,7 +208,7 @@ static int sn_set_msi_irq_affinity(struct irq_data *data,
 	write_msi_msg(irq, &msg);
 	cpumask_copy(data->affinity, cpu_mask);
 
-	return 0;
+	return IRQ_SET_MASK_OK_NOCOPY;
 }
 #endif /* CONFIG_SMP */
 
-- 
1.7.5.4

