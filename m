Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640Ab0J2TBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:01:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:49975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761560Ab0J2TBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:01:38 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=1NZDQ48ZZwIA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=oGMlB6cnAAAA:8 a=Op-mwl0xAAAA:8 a=20KFwNOVAAAA:8 a=7d_E57ReAAAA:8 a=meVymXHHAAAA:8 a=lX7lPQoMTCHELtWkhWsA:9 a=ymEWPR7M_glonWn4VjQA:7 a=WelBHQxTFoeG5ZEr6TvEBeQhBG4A:4 a=CY6gl2JlH4YA:10 a=d4CUUju0HPYA:10 a=jEp0ucaQiEUA:10 a=D6-X0JM3zdQA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101029190136.250239408@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 29 Oct 2010 15:00:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Drake <dsd@laptop.org>, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6/7] x86, ftrace: Use safe noops, drop trap test
References: <20101029190050.674141729@goodmis.org>
Content-Disposition: inline; filename=0006-x86-ftrace-Use-safe-noops-drop-trap-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Always use a safe 5-byte noop sequence.  Drop the trap test, since it
is known to return false negatives on some virtualization platforms on
32 bits.  The resulting code is both simpler and safer.

Cc: Daniel Drake <dsd@laptop.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/alternative.c |   69 +++++++++--------------------------------
 1 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index a36bb90..0b30214 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -644,65 +644,26 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 
-unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
+#ifdef CONFIG_X86_64
+unsigned char ideal_nop5[5] = { 0x66, 0x66, 0x66, 0x66, 0x90 };
+#else
+unsigned char ideal_nop5[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
+#endif
 
 void __init arch_init_ideal_nop5(void)
 {
-	extern const unsigned char ftrace_test_p6nop[];
-	extern const unsigned char ftrace_test_nop5[];
-	extern const unsigned char ftrace_test_jmp[];
-	int faulted = 0;
-
 	/*
-	 * There is no good nop for all x86 archs.
-	 * We will default to using the P6_NOP5, but first we
-	 * will test to make sure that the nop will actually
-	 * work on this CPU. If it faults, we will then
-	 * go to a lesser efficient 5 byte nop. If that fails
-	 * we then just use a jmp as our nop. This isn't the most
-	 * efficient nop, but we can not use a multi part nop
-	 * since we would then risk being preempted in the middle
-	 * of that nop, and if we enabled tracing then, it might
-	 * cause a system crash.
+	 * There is no good nop for all x86 archs.  This selection
+	 * algorithm should be unified with the one in find_nop_table(),
+	 * but this should be good enough for now.
 	 *
-	 * TODO: check the cpuid to determine the best nop.
+	 * For cases other than the ones below, use the safe (as in
+	 * always functional) defaults above.
 	 */
-	asm volatile (
-		"ftrace_test_jmp:"
-		"jmp ftrace_test_p6nop\n"
-		"nop\n"
-		"nop\n"
-		"nop\n"  /* 2 byte jmp + 3 bytes */
-		"ftrace_test_p6nop:"
-		P6_NOP5
-		"jmp 1f\n"
-		"ftrace_test_nop5:"
-		".byte 0x66,0x66,0x66,0x66,0x90\n"
-		"1:"
-		".section .fixup, \"ax\"\n"
-		"2:	movl $1, %0\n"
-		"	jmp ftrace_test_nop5\n"
-		"3:	movl $2, %0\n"
-		"	jmp 1b\n"
-		".previous\n"
-		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
-		_ASM_EXTABLE(ftrace_test_nop5, 3b)
-		: "=r"(faulted) : "0" (faulted));
-
-	switch (faulted) {
-	case 0:
-		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
-		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
-		break;
-	case 1:
-		pr_info("converting mcount calls to 66 66 66 66 90\n");
-		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
-		break;
-	case 2:
-		pr_info("converting mcount calls to jmp . + 5\n");
-		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
-		break;
-	}
-
+#ifdef CONFIG_X86_64
+	/* Don't use these on 32 bits due to broken virtualizers */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		memcpy(ideal_nop5, p6_nops[5], 5);
+#endif
 }
 #endif
-- 
1.7.1


