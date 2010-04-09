Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0DIWTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:19:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:32924 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab0DIWTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:19:44 -0400
Date: Fri, 9 Apr 2010 22:19:24 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       trenn@suse.de, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trenn@suse.de, borislav.petkov@amd.com
In-Reply-To: <1270065406-1814-4-git-send-email-bp@amd64.org>
References: <1270065406-1814-4-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Unify APERF/MPERF support
Message-ID: <tip-d65ad45cd82a0db9544469b8c54f5dc5cafbb2d8@git.kernel.org>
Git-Commit-ID: d65ad45cd82a0db9544469b8c54f5dc5cafbb2d8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 09 Apr 2010 22:19:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d65ad45cd82a0db9544469b8c54f5dc5cafbb2d8
Gitweb:     http://git.kernel.org/tip/d65ad45cd82a0db9544469b8c54f5dc5cafbb2d8
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 31 Mar 2010 21:56:43 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 9 Apr 2010 14:05:50 -0700

x86: Unify APERF/MPERF support

Initialize this CPUID flag feature in common code. It could be made a
standalone function later, maybe, if more functionality is duplicated.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1270065406-1814-4-git-send-email-bp@amd64.org>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
