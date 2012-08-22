Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2HVXwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:52:18 -0400
Received: from queue02.mail.zen.net.uk ([212.23.3.27]:35802 "EHLO
	queue02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab2HVXwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:52:14 -0400
Message-ID: <1345679461.3601.20.camel@computer5.home>
Subject: Re: [PATCHv3 4/4] ARM: kprobes: make more tests conditional
From: Tixy <tixy@yxit.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@arm.com>, linux-kernel@vger.kernel.org
Date: Thu, 23 Aug 2012 00:51:01 +0100
In-Reply-To: <201208221841.29645.arnd@arndb.de>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
	 <201208221519.12056.arnd@arndb.de>
	 <alpine.LFD.2.02.1208221136180.1754@xanadu.home>
	 <201208221841.29645.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 18:41 +0000, Arnd Bergmann wrote:
> On Wednesday 22 August 2012, Nicolas Pitre wrote:
> > On Wed, 22 Aug 2012, Arnd Bergmann wrote:
> > > > 
> > > > The ldrex/strex instructions are available on ARMv6.  It's only the d 
> > > > variants (strexd/ldrexd) which are only available from ARMv6k.
> > > 
> > > Ok. How is the version below then? I haven't tested this one yet.
> > 
> > In fact, I think the b variants are ARMv6k+ as well.  Only the plain 
> > (non b non d) variants are available on ARMv6.
> 
> Ok, third attempt then. This leaves ldrex for ARMv6 but marks
> {st,ld}rex{b,h,d} as V6K specific (which includes ARMv7).

ARMv7 does set CPU_32v6K, because arch/arm/mm/Kconfig has

config CPU_V7
	bool "Support ARM V7 processor" if ARCH_INTEGRATOR || MACH_REALVIEW_EB || MACH_REALVIEW_PBX
	select CPU_32v6K
	select CPU_32v7

but this seems more for peripheral reasons not because all the various
CPU configs systematically select the earlier architecture variants,
e.g. CPU_V7 doesn't select CPU_32v6.

So I would have been inclined to test for

#if defined(CONFIG_CPU_32v6K) || (__LINUX_ARM_ARCH__ >= 7) 

but as the current patch is functionally correct I'm not going to
suggest a v4 patch :-)

If you do feel so inclined for a v4 however ;-) you could also make the
mls part of the patch tidier by moving the added #endif to instead
terminate the preceding "#if __LINUX_ARM_ARCH__ >= 6", i.e.

@@ -367,8 +367,10 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
 	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
+#endif
 
+#if __LINUX_ARM_ARCH__ >= 7
 	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
 	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
 	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")


this looks funny in patch form, but the resulting source file is more
consistent with other conditional tests.


> 	Arnd
> 
> 8<-----
> From 6eab418c61c18393006f30d189e2f28d6e403040 Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Thu, 16 Aug 2012 07:49:31 +0000
> Subject: [PATCH] ARM: kprobes: make more tests conditional
> 
> The mls instruction is not available in ARMv6K or below, so we
> should make the test conditional on at least ARMv7. ldrexd/strexd
> are available in ARMv6K or ARMv7, which we can test by checking
> the CONFIG_CPU_32v6K symbol. Just testing for ARMv6 is not enough.
> 
> /tmp/ccuMTZ8D.s: Assembler messages:
> /tmp/ccuMTZ8D.s:22188: Error: selected processor does not support ARM mode `mls r0,r1,r2,r3'
> /tmp/ccuMTZ8D.s:22222: Error: selected processor does not support ARM mode `mlshi r7,r8,r9,r10'
> /tmp/ccuMTZ8D.s:22252: Error: selected processor does not support ARM mode `mls lr,r1,r2,r13'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jon Medhurst <tixy@yxit.co.uk>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Cc: Leif Lindholm <leif.lindholm@arm.com>
> ---
>  arch/arm/kernel/kprobes-test-arm.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
> index 38c1a3b..58dd6c3 100644
> --- a/arch/arm/kernel/kprobes-test-arm.c
> +++ b/arch/arm/kernel/kprobes-test-arm.c
> @@ -367,9 +367,11 @@ void kprobe_arm_test_cases(void)
>  	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
>  	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
>  
> +#if __LINUX_ARM_ARCH__ >= 7
>  	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
>  	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
>  	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")
> +#endif
>  	TEST_UNSUPPORTED(".word 0xe06f3291 @ mls pc, r1, r2, r3")
>  	TEST_UNSUPPORTED(".word 0xe060329f @ mls r0, pc, r2, r3")
>  	TEST_UNSUPPORTED(".word 0xe0603f91 @ mls r0, r1, pc, r3")
> @@ -456,6 +458,7 @@ void kprobe_arm_test_cases(void)
>  	TEST_UNSUPPORTED(".word	0xe1700090") /* Unallocated space */
>  #if __LINUX_ARM_ARCH__ >= 6
>  	TEST_UNSUPPORTED("ldrex	r2, [sp]")
> +#ifdef CONFIG_CPU_32v6K
>  	TEST_UNSUPPORTED("strexd	r0, r2, r3, [sp]")
>  	TEST_UNSUPPORTED("ldrexd	r2, r3, [sp]")
>  	TEST_UNSUPPORTED("strexb	r0, r2, [sp]")
> @@ -463,6 +466,7 @@ void kprobe_arm_test_cases(void)
>  	TEST_UNSUPPORTED("strexh	r0, r2, [sp]")
>  	TEST_UNSUPPORTED("ldrexh	r2, [sp]")
>  #endif
> +#endif
>  	TEST_GROUP("Extra load/store instructions")
>  
>  	TEST_RPR(  "strh	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")


