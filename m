Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2FDSbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:31:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:2164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796Ab2FDS3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160493125"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Suresh B Siddha" <suresh.b.siddha@intel.com>,
        "Tony Luck" <tony.luck@intel.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Arjan Dan De Ven" <arjan@linux.intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "linux-pm" <linux-pm@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 2/6] x86/head_32.S/head_64.S: Kernel entry code after waking up offline CPU via mwait or nmi
Date: Mon,  4 Jun 2012 11:17:51 -0700
Message-Id: <1338833876-29721-3-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
References: <1338833876-29721-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

start_cpu() is CPU entry point after it's waken up via mwait or nmi. It's called
from play_dead(). Everything has been set up already except stack. We just set
up stack here. Then call start_secondary().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h |    1 +
 arch/x86/kernel/head_32.S  |   12 ++++++++++++
 arch/x86/kernel/head_64.S  |   14 ++++++++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4564c8e..c2ad71c 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -28,6 +28,7 @@ struct x86_cpu {
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
+extern void __cpuinit start_cpu(void);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index d42ab17..55981a7 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -266,6 +266,18 @@ num_subarch_entries = (. - subarch_entries) / 4
 	jmp default_entry
 #endif /* CONFIG_PARAVIRT */
 
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Boot CPU entry point. It's called from play_dead(). Everything has been set
+ * up already except stack. We just set up stack here. Then call
+ * start_secondary().
+ */
+ENTRY(start_cpu)
+	movl stack_start, %ecx
+	movl %ecx, %esp
+	jmp  *(initial_code)
+#endif
+
 /*
  * Non-boot CPU entry point; entered from trampoline.S
  * We can't lgdt here, because lgdt itself uses a data segment, but
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 94bf9cc..84a8e1d 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -251,6 +251,20 @@ ENTRY(secondary_startup_64)
 	pushq	$__KERNEL_CS	# set correct cs
 	pushq	%rax		# target address in negative space
 	lretq
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * Boot CPU entry point. It's called from play_dead(). Everything has been set
+ * up already except stack. We just set up stack here. Then call
+ * start_secondary().
+ */
+ENTRY(start_cpu)
+	movq stack_start(%rip),%rsp
+	movq	initial_code(%rip),%rax
+	pushq	$0		# fake return address to stop unwinder
+	pushq	$__KERNEL_CS	# set correct cs
+	pushq	%rax		# target address in negative space
+	lretq
+#endif
 
 	/* SMP bootup changes these two */
 	__REFDATA
-- 
1.6.0.3

