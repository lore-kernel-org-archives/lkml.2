Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab0JCRM2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 13:12:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754104Ab0JCRM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 13:12:27 -0400
Date: Sun, 3 Oct 2010 19:12:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Drake <dsd@laptop.org>
Cc: jbaron@redhat.com, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: Dynamic nop selection breaks boot on Geode LX
Message-ID: <20101003171221.GB13233@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Drake <dsd@laptop.org>, jbaron@redhat.com,
	Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
	linux-kernel@vger.kernel.org, rostedt@goodmis.org
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
 <20101003055013.GB25397@liondog.tnic>
 <AANLkTikhJ6sE=CZ9HytG0p9DN9A0D+kqYB-sP8EfBN85@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikhJ6sE=CZ9HytG0p9DN9A0D+kqYB-sP8EfBN85@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Drake <dsd@laptop.org>
Date: Sun, Oct 03, 2010 at 05:32:12PM +0100

> On 3 October 2010 06:50, Borislav Petkov <bp@alien8.de> wrote:
> > maybe because the Geode doesn't have both the
> > P6_NOP5 and the NOP with 4 0x66 prefixes:
> > http://kerneltrap.org/mailarchive/linux-kernel/2010/8/27/4612336
> >
> > and for some reason the trap can't find the fixup address. You say
> > "hangs" so you don't even get an "invalid opcode" OOPS?
> 
> The XO doesn't have standard VGA, so it is difficult to debug such
> early crashes. This is crashing so early that kernel messages don't
> even start to get sent over serial.
> 
> To debug these things, I checkpoint the code with various calls which
> send individual characters over serial:
> 
> static void log_serial(char c)
> {
>    while ((inb(0x3fd) & 0x20) == 0) ;
>    outb(c, 0x3f8);
>    while ((inb(0x3fd) & 0x40) == 0) ;
> }
> 
> So, I'm not really sure if/how it crashed or oops'd. However, I can
> confirm that panic() does not get reached, since I put a character log
> in there and it doesn't get sent. Let me know if you want me to put
> character logging in other places.

Nice! Debugging a machine like that looks like a lot of jumping through
hoops. But let me ask you this: did you bisect linux-next to come up
with the offending patch in your other mail?

> I applied your two patches by hand and it doesn't solve the
> issue, because the init_amd_k6() code is called long after
> arch_init_ideal_nop5()

Dang, we'll have to push the CPUID feature check into the early-routine
which runs before than arch_init_ideal_nop5() in setup_arch(), updated
patch is below. Just to make sure we're matching the right model, does
/proc/cpuinfo say family 5, model 10 on the machine?

Thanks.

--
From: Borislav Petkov <bp@alien8.de>
Date: Sun, 3 Oct 2010 11:11:54 +0200
Subject: [PATCH] jmp label: Fix boot hang on Geode LX

Since Geode LX doesn't implement the NOPL versions of NOP, fallback to
using JMP as a NOP on it.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 arch/x86/kernel/alternative.c     |    6 ++++++
 arch/x86/kernel/cpu/amd.c         |   12 ++++++------
 3 files changed, 13 insertions(+), 7 deletions(-)

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
index cb0e6d3..d5fad2b 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -666,6 +666,11 @@ void __init arch_init_ideal_nop5(void)
 	 *
 	 * TODO: check the cpuid to determine the best nop.
 	 */
+	if (boot_cpu_has(X86_FEATURE_NO_NOPL)) {
+		faulted = 2;
+		goto early_done;
+	}
+
 	asm volatile (
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
@@ -688,6 +693,7 @@ void __init arch_init_ideal_nop5(void)
 		_ASM_EXTABLE(ftrace_test_nop5, 3b)
 		: "=r"(faulted) : "0" (faulted));
 
+early_done:
 	switch (faulted) {
 	case 0:
 		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7b875fd..8931977 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -136,12 +136,6 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 
 		return;
 	}
-
-	if (c->x86_model == 10) {
-		/* AMD Geode LX is model 10 */
-		/* placeholder for any needed mods */
-		return;
-	}
 }
 
 static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
@@ -413,6 +407,12 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
+	if (c->x86 == 5 && c->x86_model == 10) {
+		/* AMD Geode LX is model 10 */
+		set_cpu_cap(c, X86_FEATURE_NO_NOPL);
+		return;
+	}
+
 	/* We need to do the following only once */
 	if (c != &boot_cpu_data)
 		return;
-- 
1.7.2.3


-- 
Regards/Gruss,
    Boris.
