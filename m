Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0DSQhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:37:10 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:53243
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751018Ab0DSQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:37:06 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lab9bhzz1202hzzz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0L14SNS-02-3OA-02
X-M-MSG: 
Date: Mon, 19 Apr 2010 18:04:39 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/12] perf, x86: setup NMI handler for IBS
Message-ID: <20100419160439.GP11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-11-git-send-email-robert.richter@amd.com>
 <1271336255.1674.8.camel@laptop>
 <20100415131130.GK11907@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100415131130.GK11907@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 Apr 2010 16:04:40.0386 (UTC) FILETIME=[04710220:01CADFDA]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.04.10 15:11:30, Robert Richter wrote:
> On 15.04.10 14:57:35, Peter Zijlstra wrote:
> > > +/* uninitialize the APIC for the IBS interrupts if needed */
> > > +static void clear_ibs_nmi(void)
> > > +{
> > > +	on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
> > > +}
> > 
> > 
> > That on_each_cpu() looks wonky, why isn't this in the hotplug hooks?
> 
> Right, it should be there. Will update this patch.

Peter,

please see my updated version below.

-Robert

---

>From bcb2c4aec6bf09fc7c05f31dde9dacd57b9c679c Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 19 Apr 2010 15:32:37 +0200
Subject: [PATCH] perf, x86: setup NMI handler for IBS

This implements the perf nmi handler for ibs interrupts. The code was
copied from oprofile and should be merged somewhen.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c     |    5 ++
 arch/x86/kernel/cpu/perf_event_amd.c |   85 ++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 940107f..0ad8c45 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -516,6 +516,8 @@ static int x86_pmu_hw_config(struct perf_event *event)
 	return x86_setup_perfctr(event);
 }
 
+static inline void init_ibs_nmi(void);
+
 /*
  * Setup the hardware configuration for a given attr_type
  */
@@ -537,6 +539,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 				if (err)
 					release_pmc_hardware();
 			}
+			if (!err)
+				init_ibs_nmi();
 		}
 		if (!err)
 			atomic_inc(&active_events);
@@ -1381,6 +1385,7 @@ static void __init pmu_check_apic(void)
 		return;
 
 	x86_pmu.apic = 0;
+	x86_pmu.ibs = 0;
 	pr_info("no APIC, boot with the \"lapic\" boot parameter to force-enable it.\n");
 	pr_info("no hardware sampling interrupt available.\n");
 }
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 246304d..a6ce6f8 100644
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
+	if (!x86_pmu.ibs)
+		return 0;
+
+	ibs_eilvt_off = setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 0);
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
@@ -343,6 +424,8 @@ static void amd_pmu_cpu_starting(int cpu)
 	cpuc->amd_nb->refcnt++;
 
 	raw_spin_unlock(&amd_nb_lock);
+
+	apic_init_ibs();
 }
 
 static void amd_pmu_cpu_dead(int cpu)
@@ -366,6 +449,8 @@ static void amd_pmu_cpu_dead(int cpu)
 	}
 
 	raw_spin_unlock(&amd_nb_lock);
+
+	apic_clear_ibs();
 }
 
 static __initconst const struct x86_pmu amd_pmu = {
-- 
1.7.0.3

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

