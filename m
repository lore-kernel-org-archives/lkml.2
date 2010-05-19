Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab0ESVlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:41:10 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:38617 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab0ESVlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:41:05 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L2OS86-02-UV6-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 5/7] perf, x86: setup NMI handler for IBS
Date: Wed, 19 May 2010 23:20:22 +0200
Message-ID: <1274304024-6551-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the perf nmi handler for ibs interrupts. The code was
copied from oprofile and should be merged somewhen.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |    5 ++
 arch/x86/kernel/cpu/perf_event_amd.c |   85 ++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e186d3b..91c48b2 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -533,6 +533,8 @@ static int x86_pmu_hw_config(struct perf_event *event)
 	return x86_setup_perfctr(event);
 }
 
+static inline void init_ibs_nmi(void);
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -554,6 +556,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 				if (err)
 					release_pmc_hardware();
 			}
+			if (!err)
+				init_ibs_nmi();
 		}
 		if (!err)
 			atomic_inc(&active_events);
@@ -1294,6 +1298,7 @@ static void __init pmu_check_apic(void)
 		return;
 
 	x86_pmu.apic = 0;
+	x86_pmu.ibs = 0;
 	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 	pr_info("no hardware sampling interrupt available.\n");
 }
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index cda8475..4f6a73a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,5 +1,7 @@
 #ifdef CONFIG_CPU_SUP_AMD
 
+#include <linux/pci.h>
+
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
 static __initconst const u64 amd_hw_cache_event_ids
@@ -106,6 +108,85 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
 };
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
+/* IBS - apic initialization, taken from oprofile, should be unified */
+
+/*
+ * Currently there is no early pci ecs access implemented, so this
+ * can't be put into amd_pmu_init(). For now we initialize it in
+ * __hw_perf_event_init().
+ */
+
+static int __init_ibs_nmi(void)
+{
+#define IBSCTL_LVTOFFSETVAL		(1 << 8)
+#define IBSCTL				0x1cc
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+	u8 ibs_eilvt_off;
+
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+
+	nodes = 0;
+	cpu_cfg = NULL;
+	do {
+		cpu_cfg = pci_get_device(PCI_VENDOR_ID_AMD,
+					 PCI_DEVICE_ID_AMD_10H_NB_MISC,
+					 cpu_cfg);
+		if (!cpu_cfg)
+			break;
+		++nodes;
+		pci_write_config_dword(cpu_cfg, IBSCTL, ibs_eilvt_off
+				       | IBSCTL_LVTOFFSETVAL);
+		pci_read_config_dword(cpu_cfg, IBSCTL, &value);
+		if (value != (ibs_eilvt_off | IBSCTL_LVTOFFSETVAL)) {
+			pci_dev_put(cpu_cfg);
+			printk(KERN_DEBUG "Failed to setup IBS LVT offset, "
+				"IBSCTL = 0x%08x", value);
+			return 1;
+		}
+	} while (1);
+
+	if (!nodes) {
+		printk(KERN_DEBUG "No CPU node configured for IBS");
+		return 1;
+	}
+
+	return 0;
+}
+
+static inline void init_ibs_nmi(void)
+{
+	if (!x86_pmu.ibs)
+		return;
+
+	if (__init_ibs_nmi())
+		/* something went wrong, disable ibs */
+		x86_pmu.ibs = 0;
+}
+
+static inline void apic_init_ibs(void)
+{
+	if (x86_pmu.ibs)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static inline void apic_clear_ibs(void)
+{
+	if (x86_pmu.ibs)
+		setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
+#else
+
+static inline void init_ibs_nmi(void) { }
+static inline void apic_init_ibs(void) { }
+static inline void apic_clear_ibs(void) { }
+
+#endif
+
 static u64 amd_pmu_event_map(int hw_event)
 {
 	return amd_perfmon_event_map[hw_event];
@@ -346,6 +427,8 @@ static void amd_pmu_cpu_starting(int cpu)
 	cpuc->amd_nb->refcnt++;
 
 	raw_spin_unlock(&amd_nb_lock);
+
+	apic_init_ibs();
 }
 
 static void amd_pmu_cpu_dead(int cpu)
@@ -369,6 +452,8 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 
 	raw_spin_unlock(&amd_nb_lock);
+
+	apic_clear_ibs();
 }
 
 static __initconst const struct x86_pmu amd_pmu = {
-- 
1.7.1


