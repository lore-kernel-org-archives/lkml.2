Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2ISAIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:08:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2ISAIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:08:39 -0400
Date: Tue, 18 Sep 2012 17:08:28 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-212b02125f3725127148475059a70031bd031bdb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1347300665-6209-3-git-send-email-suresh.b.siddha@intel.com>
References: <1347300665-6209-3-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: enable eagerfpu by default for xsaveopt
Git-Commit-ID: 212b02125f3725127148475059a70031bd031bdb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 18 Sep 2012 17:08:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  212b02125f3725127148475059a70031bd031bdb
Gitweb:     http://git.kernel.org/tip/212b02125f3725127148475059a70031bd031bdb
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 6 Sep 2012 15:05:18 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Sep 2012 15:52:23 -0700

x86, fpu: enable eagerfpu by default for xsaveopt

xsaveopt/xrstor support optimized state save/restore by tracking the
INIT state and MODIFIED state during context-switch.

Enable eagerfpu by default for processors supporting xsaveopt.
Can be disabled by passing "eagerfpu=off" boot parameter.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1347300665-6209-3-git-send-email-suresh.b.siddha@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt |    2 +-
 arch/x86/include/asm/cpufeature.h   |    1 +
 arch/x86/kernel/xsave.c             |    3 +++
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 741d064..e8f7faa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1834,7 +1834,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			enabling legacy floating-point and sse state.
 
 	eagerfpu=	[X86]
-			on	enable eager fpu restore
+			on	enable eager fpu restore (default for xsaveopt)
 			off	disable eager fpu restore
 
 	nohlt		[BUGS=ARM,SH] Tells the kernel that the sleep(SH) or
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 5dd2b47..0debdb5 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -300,6 +300,7 @@ extern const char * const x86_power_flags[32];
 #define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 #define cpu_has_x2apic		boot_cpu_has(X86_FEATURE_X2APIC)
 #define cpu_has_xsave		boot_cpu_has(X86_FEATURE_XSAVE)
+#define cpu_has_xsaveopt	boot_cpu_has(X86_FEATURE_XSAVEOPT)
 #define cpu_has_osxsave		boot_cpu_has(X86_FEATURE_OSXSAVE)
 #define cpu_has_hypervisor	boot_cpu_has(X86_FEATURE_HYPERVISOR)
 #define cpu_has_pclmulqdq	boot_cpu_has(X86_FEATURE_PCLMULQDQ)
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index c0afd2c..e99f754 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -557,6 +557,9 @@ static void __init xstate_enable_boot_cpu(void)
 	prepare_fx_sw_frame();
 	setup_init_fpu_buf();
 
+	if (cpu_has_xsaveopt && !disable_eagerfpu)
+		setup_force_cpu_cap(X86_FEATURE_EAGER_FPU);
+
 	pr_info("enabled xstate_bv 0x%llx, cntxt size 0x%x\n",
 		pcntxt_mask, xstate_size);
 }
