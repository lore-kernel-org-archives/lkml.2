Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1ELADr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 20:03:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:38118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab1ELADq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 20:03:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,355,1301900400"; 
   d="scan'208";a="745964435"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 3/3 v2] x86, cpu: Enable/disable SMEP
Date: Wed, 11 May 2011 16:51:05 -0700
Message-Id: <1305157865-31727-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Enable/disable newly documented SMEP (Supervisor Mode Execution Protection) CPU
feature in kernel. CR4.SMEP (bit 20) is 0 at power-on. If the feature is
supported by CPU (X86_FEATURE_SMEP), enable SMEP by setting CR4.SMEP. New kernel
option nosmep disables the feature even if the feature is supported by CPU.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/cpu/common.c        |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cc85a92..56fb8c1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1664,6 +1664,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
+	nosmep		[X86]
+			Disable SMEP (Supervisor Mode Execution Protection)
+			even if it is supported by processor.
+
 	noexec32	[X86-64]
 			This affects only 32-bit executables.
 			noexec32=on: enable non-executable mappings (default)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2ced00..5f3cdd4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,6 +254,25 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
+static int disable_smep __initdata;
+static __init int setup_disable_smep(char *arg)
+{
+	disable_smep = 1;
+	return 1;
+}
+__setup("nosmep", setup_disable_smep);
+
+static __init void setup_smep(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SMEP)) {
+		if (unlikely(disable_smep)) {
+			setup_clear_cpu_cap(X86_FEATURE_SMEP);
+			clear_in_cr4(X86_CR4_SMEP);
+		} else
+			set_in_cr4(X86_CR4_SMEP);
+	}
+}
+
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
@@ -661,6 +680,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 	get_cpu_cap(c);
 
+	setup_smep(c);
+
 	if (this_cpu->c_early_init)
 		this_cpu->c_early_init(c);
 
@@ -738,6 +759,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 
 	get_cpu_cap(c);
 
+	setup_smep(c);
+
 	if (c->cpuid_level >= 0x00000001) {
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 #ifdef CONFIG_X86_32
-- 
1.7.2

