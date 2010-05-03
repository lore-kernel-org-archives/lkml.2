Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0ECWkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 18:40:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:60838 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab0ECWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 18:40:04 -0400
Date: Mon, 3 May 2010 22:39:41 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1271945222-5283-2-git-send-email-bp@amd64.org>
References: <1271945222-5283-2-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cacheinfo: Unify AMD L3 cache index disable checking
Message-ID: <tip-b1ab1b4d9ab9812c77843abec79030292ef0a544@git.kernel.org>
Git-Commit-ID: b1ab1b4d9ab9812c77843abec79030292ef0a544
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 22:39:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1ab1b4d9ab9812c77843abec79030292ef0a544
Gitweb:     http://git.kernel.org/tip/b1ab1b4d9ab9812c77843abec79030292ef0a544
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Thu, 22 Apr 2010 16:06:58 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 22 Apr 2010 17:17:20 -0700

x86, cacheinfo: Unify AMD L3 cache index disable checking

All F10h CPUs starting with model 8 resp. 9, stepping 1, support L3
cache index disable. Concentrate the family, model, stepping checking at
one place and enable the feature implicitly on upcoming Fam10h models.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1271945222-5283-2-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
