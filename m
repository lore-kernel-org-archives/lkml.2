Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639Ab0FPUnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:43:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:48844 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0FPUnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:43:09 -0400
Date: Wed, 16 Jun 2010 20:42:43 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com,
       venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, venki@google.com,
       len.brown@intel.com
In-Reply-To: <alpine.LFD.2.00.1006032310160.6669@localhost.localdomain>
References: <alpine.LFD.2.00.1006032310160.6669@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Look for IA32_ENERGY_PERF_BIAS support
Message-ID: <tip-23016bf0d25d62c45d8b8f61d55b290d704f7a79@git.kernel.org>
Git-Commit-ID: 23016bf0d25d62c45d8b8f61d55b290d704f7a79
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Jun 2010 20:42:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23016bf0d25d62c45d8b8f61d55b290d704f7a79
Gitweb:     http://git.kernel.org/tip/23016bf0d25d62c45d8b8f61d55b290d704f7a79
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Thu, 3 Jun 2010 23:22:28 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 Jun 2010 13:37:32 -0700

x86: Look for IA32_ENERGY_PERF_BIAS support

The new IA32_ENERGY_PERF_BIAS MSR allows system software to give
hardware a hint whether OS policy favors more power saving,
or more performance.  This allows the OS to have some influence
on internal hardware power/performance tradeoffs where the OS
has previously had no influence.

The support for this feature is indicated by CPUID.06H.ECX.bit3,
as documented in the Intel Architectures Software Developer's Manual.

This patch discovers support of this feature and displays it
as "epb" in /proc/cpuinfo.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <alpine.LFD.2.00.1006032310160.6669@localhost.localdomain>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h          |    1 +
 arch/x86/include/asm/msr-index.h           |    2 ++
 arch/x86/kernel/cpu/addon_cpuid_features.c |    1 +
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4681459..2a904f4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -162,6 +162,7 @@
 #define X86_FEATURE_IDA		(7*32+ 0) /* Intel Dynamic Acceleration */
 #define X86_FEATURE_ARAT	(7*32+ 1) /* Always Running APIC Timer */
 #define X86_FEATURE_CPB		(7*32+ 2) /* AMD Core Performance Boost */
+#define X86_FEATURE_EPB		(7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 
 /* Virtualization flags: Linux defined */
 #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b49d8ca..e57bc20 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -238,6 +238,8 @@
 
 #define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
 
+#define MSR_IA32_ENERGY_PERF_BIAS	0x000001b0
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 10fa568..7369b4c 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -33,6 +33,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_IDA,   		CR_EAX, 1, 0x00000006 },
 		{ X86_FEATURE_ARAT,  		CR_EAX, 2, 0x00000006 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006 },
+		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006 },
 		{ X86_FEATURE_CPB,   		CR_EDX, 9, 0x80000007 },
 		{ X86_FEATURE_NPT,   		CR_EDX, 0, 0x8000000a },
 		{ X86_FEATURE_LBRV,  		CR_EDX, 1, 0x8000000a },
