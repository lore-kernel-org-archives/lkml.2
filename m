Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0DMU1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:27:45 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:27484 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0DMU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:56 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i467h2a8h87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SE-02-H0J-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/12] perf, x86: setup NMI handler for IBS
Date: Tue, 13 Apr 2010 22:23:19 +0200
Message-ID: <1271190201-25705-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0714 (UTC) FILETIME=[9D074220:01CADB47]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements the perf nmi handler for ibs interrupts. The code was
copied from oprofile and should be merged somewhen.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |   10 ++++
 arch/x86/kernel/cpu/perf_event_amd.c |   87 ++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index a42d033..8f9674f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -383,12 +383,15 @@ static void release_pmc_hardware(void) {}
 
 static int reserve_ds_buffers(void);
 static void release_ds_buffers(void);
+static int reserve_ibs_hardware(void);
+static void release_ibs_hardware(void);
 
 static void hw_perf_event_destroy(struct perf_event *event)
 {
 	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
 		release_pmc_hardware();
 		release_ds_buffers();
+		release_ibs_hardware();
 		mutex_unlock(&pmc_reserve_mutex);
 	}
 }
@@ -537,6 +540,13 @@ static int __hw_perf_event_init(struct perf_event *event)
 				if (err)
 					release_pmc_hardware();
 			}
+			if (!err) {
+				err = reserve_ibs_hardware();
+				if (err) {
+					release_ds_buffers();
+					release_pmc_hardware();
+				}
+			}
 		}
 		if (!err)
 			atomic_inc(&active_events);
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 246304d..27daead 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -1,5 +1,7 @@
 #ifdef CONFIG_CPU_SUP_AMD
 
+#include <linux/pci.h>
+
 static DEFINE_RAW_SPINLOCK(amd_nb_lock);
 
 static __initconst const u64 amd_hw_cache_event_ids
@@ -106,6 +108,91 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
 };
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
+/* IBS - apic initialization, taken from oprofile, should be unified */
+
+static u8 ibs_eilvt_off;
+
+static inline void apic_init_ibs_nmi_per_cpu(void *arg)
+{
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_NMI, 0);
+}
+
+static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
+{
+	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int init_ibs_nmi(void)
+{
+#define IBSCTL_LVTOFFSETVAL		(1 << 8)
+#define IBSCTL				0x1cc
+	struct pci_dev *cpu_cfg;
+	int nodes;
+	u32 value = 0;
+
+	/* per CPU setup */
+	on_each_cpu(apic_init_ibs_nmi_per_cpu, NULL, 1);
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
+/* uninitialize the APIC for the IBS interrupts if needed */
+static void clear_ibs_nmi(void)
+{
+	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+}
+
+#else
+
+static inline int init_ibs_nmi(void) { return 1; }
+static inline void clear_ibs_nmi(void) { }
+
+#endif
+
+static int reserve_ibs_hardware(void)
+{
+	if (!x86_pmu.ibs)
+		return 0;
+	if (init_ibs_nmi())
+		/* something went wrong, disable ibs */
+		x86_pmu.ibs = 0;
+	return 0;
+}
+
+static void release_ibs_hardware(void)
+{
+	if (!x86_pmu.ibs)
+		return;
+	clear_ibs_nmi();
+}
+
 static u64 amd_pmu_event_map(int hw_event)
 {
 	return amd_perfmon_event_map[hw_event];
-- 
1.7.0.3


