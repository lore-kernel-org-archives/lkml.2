Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1ASFlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:41:15 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:41884 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1ASFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:41:12 -0500
Date: Wed, 19 Jan 2011 00:40:43 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: linux-pm@lists.linux-foundation.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] intel_idle: disable HW auto-demotion by default (v2)
In-reply-to: <alpine.LFD.2.02.1101182150400.14668@x980>
Message-id: <alpine.LFD.2.02.1101190035200.14668@x980>
References: <alpine.LFD.2.02.1101182150400.14668@x980>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

HW auto-demotion is a mechanism where the HW overrides
the OS C-state request, instead choosing a shallower state.
It is a useful feature for legacy Linux, which has clock
ticks in idle and may request states deeper than make sense.

However, modern Linux should get exactly the states it requests.

In particular, when a CPU is taken off-line, it must
not be demoted, else it can prevent the entire package from
reaching deep C-states.

https://bugzilla.kernel.org/show_bug.cgi?id=25252

boot with "intel_idle.auto_demote=1" to disable
disabling auto_demotion.

Signed-off-by: Len Brown <len.brown@intel.com>
---

(v2): use smp_call_function() rather than work_on_cpu()
update modparam name to match commit log.

 arch/x86/include/asm/msr-index.h |    4 ++++
 drivers/idle/intel_idle.c        |   30 ++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4d0dfa0..b75eeab 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -36,6 +36,10 @@
 #define MSR_IA32_PERFCTR1		0x000000c2
 #define MSR_FSB_FREQ			0x000000cd
 
+#define MSR_NHM_SNB_PKG_CST_CFG_CTL	0x000000e2
+#define NHM_C3_AUTO_DEMOTE		(1UL << 25)
+#define NHM_C1_AUTO_DEMOTE		(1UL << 26)
+
 #define MSR_MTRRcap			0x000000fe
 #define MSR_IA32_BBL_CR_CTL		0x00000119
 
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 7acb32e..1290e24 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -62,6 +62,7 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <asm/mwait.h>
+#include <asm/msr.h>
 
 #define INTEL_IDLE_VERSION "0.4"
 #define PREFIX "intel_idle: "
@@ -85,6 +86,16 @@ static int intel_idle(struct cpuidle_device *dev, struct cpuidle_state *state);
 static struct cpuidle_state *cpuidle_state_table;
 
 /*
+ * Disable HW auto demotion on tick-less idle kernels
+ */
+static unsigned int has_nhm_snb_hw_auto_demotion;
+#ifdef CONFIG_NO_HZ
+static unsigned int auto_demote;
+#else
+static unsigned int auto_demote = 1;
+#endif
+
+/*
  * Set this flag for states where the HW flushes the TLB for us
  * and so we don't need cross-calls to keep it consistent.
  * If this flag is set, SW flushes the TLB, so even if the
@@ -285,6 +296,20 @@ static struct notifier_block __cpuinitdata setup_broadcast_notifier = {
 	.notifier_call = setup_broadcast_cpuhp_notify,
 };
 
+static long auto_demotion_disable(void *unused)
+{
+	unsigned long long msr_bits;
+
+	rdmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+
+	msr_bits &= ~(NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE);
+
+	wrmsrl(MSR_NHM_SNB_PKG_CST_CFG_CTL, msr_bits);
+
+	return 0;
+}
+
+
 /*
  * intel_idle_probe()
  */
@@ -328,6 +353,7 @@ static int intel_idle_probe(void)
 	case 0x25:	/* Westmere */
 	case 0x2C:	/* Westmere */
 		cpuidle_state_table = nehalem_cstates;
+		has_nhm_snb_hw_auto_demotion = 1;
 		break;
 
 	case 0x1C:	/* 28 - Atom Processor */
@@ -338,6 +364,7 @@ static int intel_idle_probe(void)
 	case 0x2A:	/* SNB */
 	case 0x2D:	/* SNB Xeon */
 		cpuidle_state_table = snb_cstates;
+		has_nhm_snb_hw_auto_demotion = 1;
 		break;
 
 	default:
@@ -440,6 +467,8 @@ static int intel_idle_cpuidle_devices_init(void)
 			return -EIO;
 		}
 	}
+	if (has_nhm_snb_hw_auto_demotion && (auto_demote == 0))
+		smp_call_function(auto_demotion_disable, NULL, 1);
 
 	return 0;
 }
@@ -490,6 +519,7 @@ module_init(intel_idle_init);
 module_exit(intel_idle_exit);
 
 module_param(max_cstate, int, 0444);
+module_param(auto_demote, int, 0444);
 
 MODULE_AUTHOR("Len Brown <len.brown@intel.com>");
 MODULE_DESCRIPTION("Cpuidle driver for Intel Hardware v" INTEL_IDLE_VERSION);
-- 
1.7.4.rc2.3.g60a2e


