Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2IJSNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:13:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:29484 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab2IJSMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:12:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,398,1344236400"; 
   d="scan'208";a="191253101"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH v2 2/5] x86, fpu: enable eagerfpu by default for xsaveopt
Date: Mon, 10 Sep 2012 11:11:02 -0700
Message-Id: <1347300665-6209-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xsaveopt/xrstor support optimized state save/restore by tracking the
INIT state and MODIFIED state during context-switch.

Enable eagerfpu by default for processors supporting xsaveopt.
Can be disabled by passing "eagerfpu=off" boot parameter.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/include/asm/cpufeature.h   |    1 +
 arch/x86/kernel/xsave.c             |    3 +++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6273099..b21bcbd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1835,7 +1835,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			enabling legacy floating-point and sse state.
 
 	eagerfpu=	[X86]
-			on	enable eager fpu restore
+			on	enable eager fpu restore (default for xsaveopt)
 			off	disable eager fpu restore
 
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index eb9f8d1..36c2dc4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -298,6 +298,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
+#define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 66369f4..a447a7c 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -556,6 +556,9 @@ static void __init xstate_enable_boot_cpu(void)
 	prepare_fx_sw_frame();
 	setup_init_fpu_buf();
 
+	if (cpu_has_xsaveopt && !disable_eagerfpu)
+		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
 }
-- 
1.7.6.5

