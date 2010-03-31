Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0CaOto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:49:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51760 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0CaOtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:49:42 -0400
Date: Wed, 31 Mar 2010 16:50:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: [PATCH] x86, cacheinfo: Unify AMD L3 cache index disable checking
Message-ID: <20100331145022.GA32440@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.0.2


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
