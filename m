Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab1ERB5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:57:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:10398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932505Ab1ERB5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,228,1304319600"; 
   d="scan'208";a="437959959"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Avi Kivity" <avi@redhat.com>,
        "Arjan van de Ven" <arjan@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Andi Kleen" <andi@firstfloor.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH v3 4/4] x86/kernel/cpu/common.c: Disable SMEP by kernel option nosmep
Date: Tue, 17 May 2011 18:44:29 -0700
Message-Id: <1305683069-25394-5-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305683069-25394-1-git-send-email-fenghua.yu@intel.com>
References: <1305683069-25394-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

SMEP is enabled unconditionally on all CPUs that support it. The nosmep boot
option would turn it off shortly afterwards.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/cpu/common.c        |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cc85a92..76c67e5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1664,6 +1664,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
+	nosmep		[X86]
+			Disable SMEP (Supervisor Mode Execution Protection)
+			even if it is supported by the processor.
+
 	noexec32	[X86-64]
 			This affects only 32-bit executables.
 			noexec32=on: enable non-executable mappings (default)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e2ced00..9dcec58 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,6 +254,27 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
+static int disable_smep __initdata;
+
+static __init int setup_nosmep(char *arg)
+{
+	disable_smep = 1;
+	return 1;
+}
+__setup("nosmep", setup_nosmep);
+
+/*
+ * If SMEP is supported by the processor, SMEP has been enabled in CR4 earlier.
+ * But if kernel option "nosmep" is given, we disable SMEP here.
+ */
+static __init void config_smep(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SMEP) && disable_smep) {
+		setup_clear_cpu_cap(X86_FEATURE_SMEP);
+		clear_in_cr4(X86_CR4_SMEP);
+	}
+}
+
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
@@ -737,6 +758,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 	get_cpu_vendor(c);
 
 	get_cpu_cap(c);
+	config_smep(c);
 
 	if (c->cpuid_level >= 0x00000001) {
 		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
-- 
1.7.2

