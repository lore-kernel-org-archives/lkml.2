Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab1KDWWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:22:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:9875 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1KDWVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="71337201"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "H Peter Anvin" <hpa@zytor.com>,
        "Ingo Molnar" <mingo@elte.hu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Tony Luck" <tony.luck@intel.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Len Brown" <len.brown@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 4/9] x86/common.c: Init BSP data during BSP online
Date: Fri,  4 Nov 2011 15:03:56 -0700
Message-Id: <1320444241-834-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
References: <1320444241-834-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

During BSP online, enable x2apic, set_numa_node, add numa mask, and enable
sep cpu for BSP.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/processor.h |    1 +
 arch/x86/kernel/cpu/common.c     |   13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b650435..4057161 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -162,6 +162,7 @@ extern struct pt_regs *idle_regs(struct pt_regs *);
 
 extern void early_cpu_init(void);
 extern void identify_boot_cpu(void);
+extern void identify_boot_cpu_online(void);
 extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index aa003b1..faa3bda 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -916,6 +916,14 @@ void __init identify_boot_cpu(void)
 #endif
 }
 
+void __cpuinit identify_boot_cpu_online(void)
+{
+	numa_add_cpu(smp_processor_id());
+#ifdef CONFIG_X86_32
+	enable_sep_cpu();
+#endif
+}
+
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
@@ -1163,7 +1171,7 @@ void __cpuinit cpu_init(void)
 	oist = &per_cpu(orig_ist, cpu);
 
 #ifdef CONFIG_NUMA
-	if (cpu != 0 && percpu_read(numa_node) == 0 &&
+	if (percpu_read(numa_node) == 0 &&
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
@@ -1195,8 +1203,7 @@ void __cpuinit cpu_init(void)
 	barrier();
 
 	x86_configure_nx();
-	if (cpu != 0)
-		enable_x2apic();
+	enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
-- 
1.6.0.3

