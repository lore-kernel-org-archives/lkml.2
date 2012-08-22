Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2HVOaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:30:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab2HVOaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:30:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jon Medhurst <tixy@yxit.co.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@arm.com>
Subject: [PATCH 4/4] ARM: kprobes: make more tests conditional
Date: Wed, 22 Aug 2012 16:29:40 +0200
Message-Id: <1345645780-2749-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345645780-2749-1-git-send-email-arnd@arndb.de>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:fbNlxuXaJqi5u/VWf5ElycFhIdCCYJ9gHg9CMRg1nEy
 yOAtW2wAj+CGkQE8FHHLTZ9m4UtFMPENrFwb2Kt4CXkvr+/NLX
 mAywY7Jyc2EI7+mY19qRR4fHYR44qixg+ow5V7V3ljU0UTwhOI
 Ypfgpotp3Er6LbRqA+ms5MY9B9h+1xwMbukh7i/FHPwzTtQeEq
 GSr+9mnZzLz9xwNXG05aQdr/HE4jtuQMYR4jLNubVT4gpBsgif
 5MpltKrvTMYuEbHl0Icaz5SIg3apZ/54fw+oEXogDrzJzshMmJ
 MOPjrhqfFCZNJjX6c/QXKm861aikImwKxv7TuMDNDg5NEeaSHV
 66LFKXbPhCVyMD3BdFhDxqoPhXAkFWWCZnp6M/taWdER3qvowL
 9AdlpZc56rz7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mls instruction is not available in ARMv6K or below, so we
should make the test conditional on at least ARMv7. ldrex/strex
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
 arch/arm/kernel/kprobes-test-arm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 38c1a3b..3e87ff7 100644
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
@@ -454,7 +456,7 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word	0xe1500090") /* Unallocated space */
 	TEST_UNSUPPORTED(".word	0xe1600090") /* Unallocated space */
 	TEST_UNSUPPORTED(".word	0xe1700090") /* Unallocated space */
-#if __LINUX_ARM_ARCH__ >= 6
+#ifdef CONFIG_CPU_32v6K
 	TEST_UNSUPPORTED("ldrex	r2, [sp]")
 	TEST_UNSUPPORTED("strexd	r0, r2, r3, [sp]")
 	TEST_UNSUPPORTED("ldrexd	r2, r3, [sp]")
-- 
1.7.10

