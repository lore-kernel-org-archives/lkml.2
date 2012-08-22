Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab2HVSlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:41:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56564 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab2HVSlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:41:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 4/4] ARM: kprobes: make more tests conditional
Date: Wed, 22 Aug 2012 18:41:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@arm.com>, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@yxit.co.uk>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de> <201208221519.12056.arnd@arndb.de> <alpine.LFD.2.02.1208221136180.1754@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208221136180.1754@xanadu.home>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201208221841.29645.arnd@arndb.de>
X-Provags-ID: V02:K0:oPGJIfZTkySydI/IOCmHSO1KOQJ+5VZsT+UOssNeXQd
 /e3EFFP6CZb9w+VcIOxXW3mdf7fsixaVN2YjkljSJgN2PKzbZn
 gFPyeU23sd78wU7n7QICjkHErTQgNkjlq2SRT9Hu4yH3idTeVB
 HiuOfH/g2Emvn2dI9NkfbRpQntKPBQZMxtITI6Xobhhnwjps2J
 CGGrbEylZiddGtZYDEgmvYUOXidZMPcQ1g+ka2i0ZaMm/qWzPh
 meaDwNi3rOiMUG63KMJbzpUOEO9leLcRrqRxvdF3UrUxvoomuC
 vKhu812KoU2W7hq6nFVcKA7QjiRzTOjH0SkaF0HI52jdcb5pBz
 h/Ct4BCTDglmjbHyk4fI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Nicolas Pitre wrote:
> On Wed, 22 Aug 2012, Arnd Bergmann wrote:
> > > 
> > > The ldrex/strex instructions are available on ARMv6.  It's only the d 
> > > variants (strexd/ldrexd) which are only available from ARMv6k.
> > 
> > Ok. How is the version below then? I haven't tested this one yet.
> 
> In fact, I think the b variants are ARMv6k+ as well.  Only the plain 
> (non b non d) variants are available on ARMv6.

Ok, third attempt then. This leaves ldrex for ARMv6 but marks
{st,ld}rex{b,h,d} as V6K specific (which includes ARMv7).

	Arnd

8<-----
>From 6eab418c61c18393006f30d189e2f28d6e403040 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 16 Aug 2012 07:49:31 +0000
Subject: [PATCH] ARM: kprobes: make more tests conditional

The mls instruction is not available in ARMv6K or below, so we
should make the test conditional on at least ARMv7. ldrexd/strexd
are available in ARMv6K or ARMv7, which we can test by checking
the CONFIG_CPU_32v6K symbol. Just testing for ARMv6 is not enough.

/tmp/ccuMTZ8D.s: Assembler messages:
/tmp/ccuMTZ8D.s:22188: Error: selected processor does not support ARM mode `mls r0,r1,r2,r3'
/tmp/ccuMTZ8D.s:22222: Error: selected processor does not support ARM mode `mlshi r7,r8,r9,r10'
/tmp/ccuMTZ8D.s:22252: Error: selected processor does not support ARM mode `mls lr,r1,r2,r13'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jon Medhurst <tixy@yxit.co.uk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Leif Lindholm <leif.lindholm@arm.com>
---
 arch/arm/kernel/kprobes-test-arm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 38c1a3b..58dd6c3 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -367,9 +367,11 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
 	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
 
+#if __LINUX_ARM_ARCH__ >= 7
 	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
 	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
 	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")
+#endif
 	TEST_UNSUPPORTED(".word 0xe06f3291 @ mls pc, r1, r2, r3")
 	TEST_UNSUPPORTED(".word 0xe060329f @ mls r0, pc, r2, r3")
 	TEST_UNSUPPORTED(".word 0xe0603f91 @ mls r0, r1, pc, r3")
@@ -456,6 +458,7 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word	0xe1700090") /* Unallocated space */
 #if __LINUX_ARM_ARCH__ >= 6
 	TEST_UNSUPPORTED("ldrex	r2, [sp]")
+#ifdef CONFIG_CPU_32v6K
 	TEST_UNSUPPORTED("strexd	r0, r2, r3, [sp]")
 	TEST_UNSUPPORTED("ldrexd	r2, r3, [sp]")
 	TEST_UNSUPPORTED("strexb	r0, r2, [sp]")
@@ -463,6 +466,7 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED("strexh	r0, r2, [sp]")
 	TEST_UNSUPPORTED("ldrexh	r2, [sp]")
 #endif
+#endif
 	TEST_GROUP("Extra load/store instructions")
 
 	TEST_RPR(  "strh	r",0, VAL1,", [r",1, 48,", -r",2, 24,"]")
-- 
1.7.10



