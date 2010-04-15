Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0DOQnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:43:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:47881 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0DOQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:43:18 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
       Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/5] x86, cacheinfo: Unify AMD L3 cache index disable checking
Date: Thu, 15 Apr 2010 18:40:59 +0200
Message-Id: <1271349663-16670-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271349663-16670-1-git-send-email-bp@amd64.org>
References: <1271349663-16670-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

All F10h CPUs starting with model 8 resp. 9, stepping 1, support L3
cache index disable. Concentrate the family, model, stepping checking at
one place and enable the feature implicitly on upcoming Fam10h models.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b3eeb66..acfb083 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -328,18 +328,22 @@ static unsigned int __cpuinit amd_calc_l3_indices(void)
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
-	if (index < 3)
+	if (boot_cpu_data.x86 != 0x10)
 		return;
 
-	if (boot_cpu_data.x86 == 0x11)
+	if (index < 3)
 		return;
 
 	/* see errata #382 and #388 */
-	if ((boot_cpu_data.x86 == 0x10) &&
-	    ((boot_cpu_data.x86_model < 0x8) ||
-	     (boot_cpu_data.x86_mask  < 0x1)))
+	if (boot_cpu_data.x86_model < 0x8)
 		return;
 
+	if ((boot_cpu_data.x86_model == 0x8 ||
+	     boot_cpu_data.x86_model == 0x9)
+		&&
+	     boot_cpu_data.x86_mask < 0x1)
+			return;
+
 	this_leaf->can_disable = true;
 	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
@@ -443,8 +447,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-		if (boot_cpu_data.x86 >= 0x10)
-			amd_check_l3_disable(index, this_leaf);
+		amd_check_l3_disable(index, this_leaf);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
 	}
-- 
1.7.1.rc1

