Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab2GFORm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:17:42 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38808 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GFORl convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 6 Jul 2012 10:17:41 -0400
Message-Id: <4FF70FDB020000780008E199@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 06 Jul 2012 15:18:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: simplify mtrr_bp_init()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the x86_phys_bits cpuinfo field is uniformly available on
32- and 64-bit, the function no longer needs to determine this anew.

Additionally, both size_or_mask and size_and_mask can be set once at
the end of the function instead of individually in each special case,
as their value solely depends on the physical address size determined
to be used here.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/cpu/mtrr/main.c |   47 ++++++++++------------------------------
 1 file changed, 12 insertions(+), 35 deletions(-)

--- 3.5-rc5/arch/x86/kernel/cpu/mtrr/main.c
+++ 3.5-rc5-x86-mtrr-init-simplify/arch/x86/kernel/cpu/mtrr/main.c
@@ -592,67 +592,41 @@ int __initdata changed_by_mtrr_cleanup;
  */
 void __init mtrr_bp_init(void)
 {
-	u32 phys_addr;
+	unsigned int phys_addr = boot_cpu_data.x86_phys_bits;
 
 	init_ifs();
 
-	phys_addr = 32;
-
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;			/* 36 bits */
-		size_and_mask = 0x00f00000;
-		phys_addr = 36;
-
-		/*
-		 * This is an AMD specific MSR, but we assume(hope?) that
-		 * Intel will implement it to when they extend the address
-		 * bus of the Xeon.
-		 */
-		if (cpuid_eax(0x80000000) >= 0x80000008) {
-			phys_addr = cpuid_eax(0x80000008) & 0xff;
-			/* CPUID workaround for Intel 0F33/0F34 CPU */
-			if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-			    boot_cpu_data.x86 == 0xF &&
-			    boot_cpu_data.x86_model == 0x3 &&
-			    (boot_cpu_data.x86_mask == 0x3 ||
-			     boot_cpu_data.x86_mask == 0x4))
-				phys_addr = 36;
-
-			size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
-			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
-		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
-			   boot_cpu_data.x86 == 6) {
+
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
+		    boot_cpu_data.x86 == 6) {
 			/*
 			 * VIA C* family have Intel style MTRRs,
 			 * but don't support PAE
 			 */
-			size_or_mask = 0xfff00000;		/* 32 bits */
-			size_and_mask = 0;
 			phys_addr = 32;
-		}
+		} else if (phys_addr < 36)
+			phys_addr = 36;
 	} else {
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_AMD:
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
 				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
-				size_or_mask = 0xfff00000;	/* 32 bits */
-				size_and_mask = 0;
+				phys_addr = 32;
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
 			if (cpu_has_centaur_mcr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
-				size_or_mask = 0xfff00000;	/* 32 bits */
-				size_and_mask = 0;
+				phys_addr = 32;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
 			if (cpu_has_cyrix_arr) {
 				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
-				size_or_mask = 0xfff00000;	/* 32 bits */
-				size_and_mask = 0;
+				phys_addr = 32;
 			}
 			break;
 		default:
@@ -660,6 +634,9 @@ void __init mtrr_bp_init(void)
 		}
 	}
 
+	size_or_mask = ~((1ULL << (phys_addr - PAGE_SHIFT)) - 1);
+	size_and_mask = ~size_or_mask & 0xfffff00000ULL;
+
 	if (mtrr_if) {
 		set_num_var_ranges();
 		init_table();



