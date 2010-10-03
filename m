Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab0JCJ0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 05:26:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41010 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab0JCJ0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 05:26:17 -0400
Date: Sun, 3 Oct 2010 11:26:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Drake <dsd@laptop.org>
Cc: jbaron@redhat.com, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: Dynamic nop selection breaks boot on Geode LX
Message-ID: <20101003092612.GA3733@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Drake <dsd@laptop.org>, jbaron@redhat.com,
	Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
	linux-kernel@vger.kernel.org, rostedt@goodmis.org
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
 <20101003055013.GB25397@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101003055013.GB25397@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>
Date: Sun, Oct 03, 2010 at 07:50:13AM +0200

> Maybe on a Geode jmp label should use the 2-byte jmp + 3 1-byte nops
> unconditionally after adding a synthetic CPUID flag in init_amd_k6(), in
> the Geode part.

Maybe something like the following? (only tested in kvm)

--
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 220e2ea..e2ef56c 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -89,7 +89,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-					  /* 21 available, was AMD_C1E */
+#define X86_FEATURE_NO_NOPL	(3*32+21) /* "" Missing NOPL (e.g. Geode LX) */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
 #define X86_FEATURE_NONSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index cb0e6d3..3e1fa13 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -666,6 +666,9 @@ void __init arch_init_ideal_nop5(void)
 	 *
 	 * TODO: check the cpuid to determine the best nop.
 	 */
+	if (boot_cpu_has(X86_FEATURE_NO_NOPL))
+		goto early_done;
+
 	asm volatile (
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
@@ -688,6 +691,7 @@ void __init arch_init_ideal_nop5(void)
 		_ASM_EXTABLE(ftrace_test_nop5, 3b)
 		: "=r"(faulted) : "0" (faulted));
 
+early_done:
 	switch (faulted) {
 	case 0:
 		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7b875fd..d1e5cf4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -139,7 +139,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 
 	if (c->x86_model == 10) {
 		/* AMD Geode LX is model 10 */
-		/* placeholder for any needed mods */
+		set_cpu_cap(c, X86_FEATURE_NO_NOPL);
 		return;
 	}
 }

-- 
Regards/Gruss,
    Boris.
