Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558Ab1LPQM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:12:59 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:7091 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752068Ab1LPQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:12:44 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz853kzz1202hzz8275bhz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB110-01-6GZ-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bebl@mageta.org>,
        Benjamin Block <benjamin.block@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 1/5] x86, perf: Implement software-activation of lwp
Date: Fri, 16 Dec 2011 17:12:19 +0100
Message-ID: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <20111216160757.GL665@escobedo.osrc.amd.com>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Block <benjamin.block@amd.com>

Adds activation of lwp for ring3-software. With this patch and
scheduler-support (xsave-patches done by Hans Rosenfeld) a
userspace-application can use the lwp-instructions (llwpcb,
slwpcb, ..) to activate lwp.

Support for the threshold-interrupt is not given and thus the
corresponding bits are not set. It is therefore unavailable for
userspace-applications.

Signed-off-by: Benjamin Block <benjamin.block@amd.com>
Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/msr-index.h         |    1 +
 arch/x86/kernel/cpu/Makefile             |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_lwp.c |  138 ++++++++++++++++++++++++++++++
 3 files changed, 140 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_lwp.c

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2d9cf3c..557a6fd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -136,6 +136,7 @@
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
 #define MSR_AMD64_IBSBRTARGET		0xc001103b
+#define MSR_AMD64_LWP_CFG		0xc0000105
 #define MSR_AMD64_LWP_CBADDR		0xc0000106
 
 /* Fam 15h MSRs */
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..9973465 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
-obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o perf_event_amd_lwp.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
diff --git a/arch/x86/kernel/cpu/perf_event_amd_lwp.c b/arch/x86/kernel/cpu/perf_event_amd_lwp.c
new file mode 100644
index 0000000..9aa9a91
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_lwp.c
@@ -0,0 +1,138 @@
+#include <linux/perf_event.h>
+#include <linux/module.h>
+
+#include <asm/cpufeature.h>
+#include <asm/processor.h>
+
+/* masks only the events as of spec r3.08 (lwp v1) */
+#define LWP_EVENT_MASK		0x7E
+
+struct lwp_capabilities {
+#define LWP_CAPS_LWP			0
+#define LWP_CAPS_THRESHOLD		31
+	unsigned long supported_events;
+	unsigned long available_events;
+
+	u8 size_lwpcb;
+	u8 size_event;
+	u8 size_max_event_id;
+	u8 size_event_offset;
+
+#define LWP_CAPS_FILTER_BRANCH		28
+#define LWP_CAPS_FILTER_IP		29
+#define LWP_CAPS_FILTER_CACHE_LVL	30
+#define LWP_CAPS_FILTER_CACHE_LAT	31
+	unsigned long features;
+};
+
+union lwp_cfg_msr {
+	struct {
+		u32 allowed_events;
+		u8 core_id;
+		u8 interrupt_vector;
+		u16 reserved;
+	} cfg;
+	u64 msr_value;
+};
+
+static struct lwp_capabilities	lwp_caps;
+
+static void get_lwp_caps(struct lwp_capabilities *caps)
+{
+	u32 sizes;
+
+	memset(caps, 0, sizeof(*caps));
+	cpuid(0x8000001C, (u32 *) &caps->available_events, &sizes,
+			(u32 *) &caps->features,
+			(u32 *) &caps->supported_events);
+
+	caps->size_lwpcb = (u8) sizes;
+	caps->size_event = (u8) (sizes >> 0x8);
+	caps->size_max_event_id = (u8) (sizes >> 0x10);
+	caps->size_event_offset = (u8) (sizes >> 0x18);
+}
+
+static void lwp_start_cpu(void *c)
+{
+	struct lwp_capabilities *caps = (struct lwp_capabilities *) c;
+	union lwp_cfg_msr msr;
+
+	msr.msr_value = 0;
+	/* allow supported events of lwpv1 [1..6] */
+	msr.cfg.allowed_events |= ((u32) caps->supported_events) &
+					LWP_EVENT_MASK;
+	/*
+	 * The value showing up in the core-id field of a event-record.
+	 * I currently only 8 bits wide.
+	 */
+	msr.cfg.core_id = (u8) smp_processor_id();
+
+	/*
+	 * We currently do not support the threshold-interrupt so
+	 * bit 31 and [40..47] of msr.msr_value keep 0
+	 *
+	 * msr.cfg.allowed_events |= (1U << 31);
+	 * msr.cfg.interrupt_vector = xxx;
+	 */
+
+	wrmsrl(MSR_AMD64_LWP_CFG, msr.msr_value);
+}
+
+static int __cpuinit
+lwp_cpu_notifier(struct notifier_block *self, unsigned long action,
+		void *hcpu)
+{
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_STARTING:
+		lwp_start_cpu(&lwp_caps);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+static __init int amd_lwp_init(void)
+{
+	if (!static_cpu_has(X86_FEATURE_LWP))
+		return -ENODEV;
+
+	/* read the _supported_ events */
+	get_lwp_caps(&lwp_caps);
+
+	/* we currently only support lwp v1; spec r3.08 */
+	if (!test_bit(LWP_CAPS_LWP, &lwp_caps.supported_events) ||
+			(((lwp_caps.features >> 9) & 0x7F) != 1))
+		return -ENODEV;
+
+	if (!test_bit(LWP_CAPS_THRESHOLD, &lwp_caps.supported_events))
+		return -ENODEV;
+
+	get_online_cpus();
+
+	barrier();
+
+	perf_cpu_notifier(lwp_cpu_notifier);
+	smp_call_function(lwp_start_cpu, &lwp_caps, 1);
+
+	put_online_cpus();
+
+	/*
+	 * The values returned by cpuid are corresponding to the values in
+	 * MSR_AMD64_LWP_CFG and determine what events are available. As we
+	 * have just changed MSR_AMD64_LWP_CFG, we have to re-read the lwp_caps.
+	 */
+	get_lwp_caps(&lwp_caps);
+
+	printk(KERN_INFO "perf: AMD LWP caps: "
+			"[%#lx],[%#hhx|%#hhx|%#hhx|%#hhx],[%#lx],[%#lx]",
+			lwp_caps.available_events, lwp_caps.size_lwpcb,
+			lwp_caps.size_event, lwp_caps.size_max_event_id,
+			lwp_caps.size_event_offset, lwp_caps.features,
+			lwp_caps.supported_events);
+
+	return 0;
+}
+
+device_initcall(amd_lwp_init);
-- 
1.7.7


