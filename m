Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1EKTao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:30:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:5862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab1EKTaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:30:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,354,1301900400"; 
   d="scan'208";a="468449"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Bruce Schlobohm" <bruce.schlobohm@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 3/3] x86, cpu: Enable/disable SMEP
Date: Wed, 11 May 2011 12:18:00 -0700
Message-Id: <1305141480-843-4-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
References: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
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
 arch/x86/kernel/cpu/common.c        |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

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
index e2ced00..f06b2d5 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -254,6 +254,25 @@ static inline void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 }
 #endif
 
+static int disable_smep;
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
@@ -867,6 +886,8 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	/* Init Machine Check Exception if available. */
 	mcheck_cpu_init(c);
 
+	setup_smep(c);
+
 	select_idle_routine(c);
 
 #ifdef CONFIG_NUMA
-- 
1.7.2

