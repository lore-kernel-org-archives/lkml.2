Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab2IUToR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:44:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:49306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab2IUTnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:43:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="225202015"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Linda Wang <lwang@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 09/11] x86, smap: Turn on Supervisor Mode Access Prevention
Date: Fri, 21 Sep 2012 12:43:13 -0700
Message-Id: <1348256595-29119-10-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

If Supervisor Mode Access Prevention is available and not disabled by
the user, turn it on.  Also fix the expansion of SMEP (Supervisor Mode
Execution Prevention.)

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    6 +++++-
 arch/x86/kernel/cpu/common.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index ad7e2e5..49c5c41 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1812,8 +1812,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			noexec=on: enable non-executable mappings (default)
 			noexec=off: disable non-executable mappings
 
+	nosmap		[X86]
+			Disable SMAP (Supervisor Mode Access Prevention)
+			even if it is supported by processor.
+
 	nosmep		[X86]
-			Disable SMEP (Supervisor Mode Execution Protection)
+			Disable SMEP (Supervisor Mode Execution Prevention)
 			even if it is supported by processor.
 
 	noexec32	[X86-64]
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cd43e52..7d35d65 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -278,6 +278,31 @@ static __cpuinit void setup_smep(struct cpuinfo_x86 *c)
 	}
 }
 
+static int disable_smap __cpuinitdata;
+static __init int setup_disable_smap(char *arg)
+{
+	disable_smap = 1;
+	return 1;
+}
+__setup("nosmap", setup_disable_smap);
+
+static __cpuinit void setup_smap(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SMAP)) {
+		if (unlikely(disable_smap)) {
+			setup_clear_cpu_cap(X86_FEATURE_SMAP);
+			clear_in_cr4(X86_CR4_SMAP);
+		} else {
+			set_in_cr4(X86_CR4_SMAP);
+			/*
+			 * Don't use clac() here since alternatives
+			 * haven't run yet...
+			 */
+			asm volatile(__stringify(__ASM_CLAC) ::: "memory");
+		}
+	}
+}
+
 /*
  * Some CPU features depend on higher CPUID levels, which may not always
  * be available due to CPUID level capping or broken virtualization
@@ -713,6 +738,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
+	setup_smap(c);
 
 	if (this_cpu->c_bsp_init)
 		this_cpu->c_bsp_init(c);
-- 
1.7.6.5

