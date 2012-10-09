Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab2JIPZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:25:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2JIPX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Leif Lindholm <leif.lindholm@arm.com>
Subject: [PATCH 1/9] ARM: kprobes: make more tests conditional
Date: Tue,  9 Oct 2012 17:22:55 +0200
Message-Id: <1349796183-30648-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Wa+JW5/d4bRMZNqKbTGOzIojBUFL8WvQbXMPWE+NAM6
 2t9NMJQyM1U98g5LyInzsstCF/+Er22q2yJGKS3pO+2Gy17eRj
 3JW+CaWSMaOQ+CmqwR00gFcDKz5JyIfPQBbN2dOHwIYqzpKKAk
 L6N5Tp6+aI9qMPsGcxLASHYVxXy31zSHzaM9LM8kl8YsB17oOX
 i/rQzdDiGTAtfgQYpOtWaacC44+nSlRT/K/kqEWkiw5HOodSh9
 ZNZsU9B2S1qwTq8cFwP5RdoCFsG/6a8ckrE31xb2bPCBs82tsv
 +pgPcntQnOZHkWDBX+pQYMR7Y9K3yFWUx0Ym2vqBnJF6J4UT1h
 X5pxU8KulVFpzpQnmTysYUzwoBC9WG0/WbBAa1vpclLp7mbJDg
 fQToJraZvFh7IWk77hpuMssI2+OU6d6h8w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mls instruction is not available in ARMv6K or below, so we
should make the test conditional on at least ARMv7. ldrexd/strexd
are available in ARMv6K or ARMv7, which we can test by checking
the CONFIG_CPU_32v6K symbol.

/tmp/ccuMTZ8D.s: Assembler messages:
/tmp/ccuMTZ8D.s:22188: Error: selected processor does not support ARM mode `mls r0,r1,r2,r3'
/tmp/ccuMTZ8D.s:22222: Error: selected processor does not support ARM mode `mlshi r7,r8,r9,r10'
/tmp/ccuMTZ8D.s:22252: Error: selected processor does not support ARM mode `mls lr,r1,r2,r13'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Jon Medhurst <tixy@yxit.co.uk>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Leif Lindholm <leif.lindholm@arm.com>
---
 arch/arm/kernel/kprobes-test-arm.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/kprobes-test-arm.c b/arch/arm/kernel/kprobes-test-arm.c
index 38c1a3b..8393129 100644
--- a/arch/arm/kernel/kprobes-test-arm.c
+++ b/arch/arm/kernel/kprobes-test-arm.c
@@ -366,7 +366,9 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word 0xe04f0392 @ umaal r0, pc, r2, r3")
 	TEST_UNSUPPORTED(".word 0xe0500090 @ undef")
 	TEST_UNSUPPORTED(".word 0xe05fff9f @ undef")
+#endif
 
+#if __LINUX_ARM_ARCH__ >= 7
 	TEST_RRR(  "mls		r0, r",1, VAL1,", r",2, VAL2,", r",3,  VAL3,"")
 	TEST_RRR(  "mlshi	r7, r",8, VAL3,", r",9, VAL1,", r",10, VAL2,"")
 	TEST_RR(   "mls		lr, r",1, VAL2,", r",2, VAL3,", r13")
@@ -456,6 +458,8 @@ void kprobe_arm_test_cases(void)
 	TEST_UNSUPPORTED(".word	0xe1700090") /* Unallocated space */
 #if __LINUX_ARM_ARCH__ >= 6
 	TEST_UNSUPPORTED("ldrex	r2, [sp]")
+#endif
+#if (__LINUX_ARM_ARCH__ >= 7) || defined(CONFIG_CPU_32v6K)
 	TEST_UNSUPPORTED("strexd	r0, r2, r3, [sp]")
 	TEST_UNSUPPORTED("ldrexd	r2, r3, [sp]")
 	TEST_UNSUPPORTED("strexb	r0, r2, [sp]")
-- 
1.7.10

