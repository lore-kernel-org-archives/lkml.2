Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2AKR13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 12:27:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:9550 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab2AKRYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 12:24:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106055473"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Arjan van de Ven" <arjan.van.de.ven@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Randy Dunlap" <rdunlap@xenotime.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>, "x86" <x86@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 09/12] x86/common.c: Init CPU0 data during CPU0 online
Date: Wed, 11 Jan 2012 09:04:50 -0800
Message-Id: <1326301493-28760-10-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
References: <1326301493-28760-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

During CPU0 online, enable x2apic, re-init mcheck, set_numa_node, add numa mask,
and enable sep cpu for CPU0.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index aa9088c..861d0e9 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -160,6 +160,7 @@ extern struct pt_regs *idle_regs(struct pt_regs *);
 
 extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
+extern void identify_boot_cpu_online(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d43cad7..300e3e2 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -911,6 +911,18 @@ void __init identify_boot_cpu(void)
 #endif
 }
 
+void __cpuinit identify_boot_cpu_online(void)
+{
+	mcheck_cpu_init(&boot_cpu_data);
+
+#ifdef CONFIG_NUMA
+	numa_add_cpu(smp_processor_id());
+#endif
+#ifdef CONFIG_X86_32
+	enable_sep_cpu();
+#endif
+}
+
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
@@ -1189,7 +1201,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (percpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1221,8 +1233,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
-- 
1.6.0.3

