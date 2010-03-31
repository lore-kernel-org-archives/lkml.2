Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0CaT4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:56:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41166 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab0CaT4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:56:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>
Cc: davej@redhat.com, trenn@suse.de, linux@dominikbrodowski.net,
       cpufreq@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       <x86@kernel.org>
Subject: [PATCH 3/6] x86: Unify APERF/MPERF support
Date: Wed, 31 Mar 2010 21:56:43 +0200
Message-Id: <1270065406-1814-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1270065406-1814-1-git-send-email-bp@amd64.org>
References: <1270065406-1814-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Initialize this CPUID flag feature in common code. It could be made a
standalone function later, maybe, if more functionality is duplicated.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Reviewed-by: Thomas Renninger <trenn@suse.de>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    8 ++++++++
 arch/x86/kernel/cpu/intel.c                |    6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index ead2a1c..fd1fc19 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -54,6 +54,14 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		if (regs[cb->reg] & (1 << cb->bit))
 			set_cpu_cap(c, cb->feature);
 	}
+
+	/*
+	 * common AMD/Intel features
+	 */
+	if (c->cpuid_level >= 6) {
+		if (cpuid_ecx(6) & 0x1)
+			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
+	}
 }
 
 /* leaf 0xb SMT level */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7e1cca1..3830258 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -352,12 +352,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
-	if (c->cpuid_level > 6) {
-		unsigned ecx = cpuid_ecx(6);
-		if (ecx & 0x01)
-			set_cpu_cap(c, X86_FEATURE_APERFMPERF);
-	}
-
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 	if (cpu_has_ds) {
-- 
1.7.0

