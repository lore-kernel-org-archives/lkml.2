Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab1JSOx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:53:27 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38430 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab1JSOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/9] x86, RAS: Start reorganizing RAS features support
Date: Wed, 19 Oct 2011 16:50:59 +0200
Message-Id: <1319035866-29570-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Start relocating RAS features into a centralized location under
arch/x86/kernel/cpu/ras/. Readjust Kconfig items and makefiles
accordingly.

This patch moves the MCE error thresholding code to its new place. No
functionality change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig                                   |   10 ++--------
 arch/x86/include/asm/mce.h                         |    2 +-
 arch/x86/kernel/cpu/Makefile                       |    2 +-
 arch/x86/kernel/cpu/mcheck/Makefile                |    1 -
 arch/x86/kernel/cpu/ras/Kconfig                    |   16 ++++++++++++++++
 arch/x86/kernel/cpu/ras/Makefile                   |    1 +
 arch/x86/kernel/cpu/ras/amd/Makefile               |    1 +
 .../{mcheck/mce_amd.c => ras/amd/thresholding.c}   |    0
 8 files changed, 22 insertions(+), 11 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/ras/Kconfig
 create mode 100644 arch/x86/kernel/cpu/ras/Makefile
 create mode 100644 arch/x86/kernel/cpu/ras/amd/Makefile
 rename arch/x86/kernel/cpu/{mcheck/mce_amd.c => ras/amd/thresholding.c} (100%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index afb7a19..1a70aad 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -856,13 +856,7 @@ config X86_MCE_INTEL
 	   Additional support for intel specific MCE features such as
 	   the thermal monitor.
 
-config X86_MCE_AMD
-	def_bool y
-	prompt "AMD MCE features"
-	depends on X86_MCE && X86_LOCAL_APIC
-	---help---
-	   Additional support for AMD specific MCE features such as
-	   the DRAM Error Threshold.
+source "arch/x86/kernel/cpu/ras/Kconfig"
 
 config X86_ANCIENT_MCE
 	bool "Support for old Pentium 5 / WinChip machine checks"
@@ -873,7 +867,7 @@ config X86_ANCIENT_MCE
 	  line.
 
 config X86_MCE_THRESHOLD
-	depends on X86_MCE_AMD || X86_MCE_INTEL
+	depends on X86_AMD_ERROR_THRESHOLDING || X86_MCE_INTEL
 	def_bool y
 
 config X86_MCE_INJECT
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index c9321f3..545e8e4 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -174,7 +174,7 @@ static inline void cmci_rediscover(int dying) {}
 static inline void cmci_recheck(void) {}
 #endif
 
-#ifdef CONFIG_X86_MCE_AMD
+#ifdef CONFIG_X86_AMD_ERROR_THRESHOLDING
 void mce_amd_feature_init(struct cpuinfo_x86 *c);
 #else
 static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6042981..b2832b8 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
-obj-$(CONFIG_X86_MCE)			+= mcheck/
+obj-$(CONFIG_X86_MCE)			+= mcheck/ ras/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
 obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index bb34b03..ccd1997 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -2,7 +2,6 @@ obj-y				=  mce.o mce-severity.o
 
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
-obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
 obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
 
diff --git a/arch/x86/kernel/cpu/ras/Kconfig b/arch/x86/kernel/cpu/ras/Kconfig
new file mode 100644
index 0000000..e58c4ea
--- /dev/null
+++ b/arch/x86/kernel/cpu/ras/Kconfig
@@ -0,0 +1,16 @@
+menu "AMD RAS features"
+	depends on X86_MCE && CPU_SUP_AMD
+
+config X86_AMD_ERROR_THRESHOLDING
+	def_bool y
+	prompt "Error Thresholding"
+	depends on X86_LOCAL_APIC
+	---help---
+	   Support hardware-maintained counters of some types of hw errors.
+	   Currently, there three groups: DRAM, Link and L3 errors. For more
+	   detailed information see the section on Error Thresholding in
+	   the respective AMD BKDG.
+
+endmenu
+
+
diff --git a/arch/x86/kernel/cpu/ras/Makefile b/arch/x86/kernel/cpu/ras/Makefile
new file mode 100644
index 0000000..dd7a321
--- /dev/null
+++ b/arch/x86/kernel/cpu/ras/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_MCE)		+= amd/
diff --git a/arch/x86/kernel/cpu/ras/amd/Makefile b/arch/x86/kernel/cpu/ras/amd/Makefile
new file mode 100644
index 0000000..3c1678f
--- /dev/null
+++ b/arch/x86/kernel/cpu/ras/amd/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_X86_AMD_ERROR_THRESHOLDING)	+= thresholding.o
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/ras/amd/thresholding.c
similarity index 100%
rename from arch/x86/kernel/cpu/mcheck/mce_amd.c
rename to arch/x86/kernel/cpu/ras/amd/thresholding.c
-- 
1.7.4.rc2

