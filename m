Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0JMVrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 17:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0JMVrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 17:47:20 -0400
Date: Wed, 13 Oct 2010 17:46:15 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/9] [GIT PULL] tracing: updates for 2.6.37
Message-ID: <20101013214614.GC2878@redhat.com>
References: <20101006033445.465428951@goodmis.org> <20101008081655.GC13754@elte.hu> <20101008084541.GA23742@elte.hu> <1286596787.23994.1285.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286596787.23994.1285.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 11:59:47PM -0400, Steven Rostedt wrote:
> On Fri, 2010-10-08 at 10:45 +0200, Ingo Molnar wrote:
> > hm, i'm getting:
> > 
> > arch/x86/kernel/alternative.c: Assembler messages:
> > arch/x86/kernel/alternative.c:674: Error: symbol `ftrace_test_jmp' is already defined
> > arch/x86/kernel/alternative.c:678: Error: symbol `ftrace_test_p6nop' is already defined
> > arch/x86/kernel/alternative.c:680: Error: symbol `ftrace_test_nop5' is already defined
> > 
> > Config attached.
> 
> I'll see if I can get to this early next week. I'll be leaving to NYC on
> Monday for the End Users Summit. I'll try to look at this while there.
> 
> Thanks!
> 
> -- Steve
> 

just saw this...looks like this is broken for gcc < 4.5. Anyways, the
patch below fixes the compilation by making arch_init_ideal_nop5()
static (and moving its definition ahead of its usage). I'm not quite
sure why this makes the compiler happy...applies on top of this series.

thanks,

-Jason


make arch_init_ideal_nop5() static. fixes compilation error:

arch/x86/kernel/alternative.c: Assembler messages:
arch/x86/kernel/alternative.c:674: Error: symbol `ftrace_test_jmp' is already defined
arch/x86/kernel/alternative.c:678: Error: symbol `ftrace_test_p6nop' is already defined
arch/x86/kernel/alternative.c:680: Error: symbol `ftrace_test_nop5' is already defined

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 arch/x86/include/asm/alternative.h |    1 -
 arch/x86/kernel/alternative.c      |  130 ++++++++++++++++++------------------
 2 files changed, 65 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 76561d2..2a7f618 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -186,7 +186,6 @@ extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 #if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
 #define IDEAL_NOP_SIZE_5 5
 extern unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
-extern void arch_init_ideal_nop5(void);
 #else
 static inline void arch_init_ideal_nop5(void) {}
 #endif
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index d8b5b21..2331b68 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -452,6 +452,71 @@ extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
+
+unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
+
+static void __init arch_init_ideal_nop5(void)
+{
+	extern const unsigned char ftrace_test_p6nop[];
+	extern const unsigned char ftrace_test_nop5[];
+	extern const unsigned char ftrace_test_jmp[];
+	int faulted = 0;
+
+	/*
+	 * There is no good nop for all x86 archs.
+	 * We will default to using the P6_NOP5, but first we
+	 * will test to make sure that the nop will actually
+	 * work on this CPU. If it faults, we will then
+	 * go to a lesser efficient 5 byte nop. If that fails
+	 * we then just use a jmp as our nop. This isn't the most
+	 * efficient nop, but we can not use a multi part nop
+	 * since we would then risk being preempted in the middle
+	 * of that nop, and if we enabled tracing then, it might
+	 * cause a system crash.
+	 *
+	 * TODO: check the cpuid to determine the best nop.
+	 */
+	asm volatile (
+		"ftrace_test_jmp:"
+		"jmp ftrace_test_p6nop\n"
+		"nop\n"
+		"nop\n"
+		"nop\n"  /* 2 byte jmp + 3 bytes */
+		"ftrace_test_p6nop:"
+		P6_NOP5
+		"jmp 1f\n"
+		"ftrace_test_nop5:"
+		".byte 0x66,0x66,0x66,0x66,0x90\n"
+		"1:"
+		".section .fixup, \"ax\"\n"
+		"2:	movl $1, %0\n"
+		"	jmp ftrace_test_nop5\n"
+		"3:	movl $2, %0\n"
+		"	jmp 1b\n"
+		".previous\n"
+		_ASM_EXTABLE(ftrace_test_p6nop, 2b)
+		_ASM_EXTABLE(ftrace_test_nop5, 3b)
+		: "=r"(faulted) : "0" (faulted));
+
+	switch (faulted) {
+	case 0:
+		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
+		memcpy(ideal_nop5, ftrace_test_p6nop, IDEAL_NOP_SIZE_5);
+		break;
+	case 1:
+		pr_info("converting mcount calls to 66 66 66 66 90\n");
+		memcpy(ideal_nop5, ftrace_test_nop5, IDEAL_NOP_SIZE_5);
+		break;
+	case 2:
+		pr_info("converting mcount calls to jmp . + 5\n");
+		memcpy(ideal_nop5, ftrace_test_jmp, IDEAL_NOP_SIZE_5);
+		break;
+	}
+
+}
+#endif
+
 void __init alternative_instructions(void)
 {
 	unsigned long flags;
@@ -645,68 +710,3 @@ void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
 	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
 	return addr;
 }
-
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(HAVE_JUMP_LABEL)
-
-unsigned char ideal_nop5[IDEAL_NOP_SIZE_5];
-
-void __init arch_init_ideal_nop5(void)
-{
-	extern const unsigned char ftrace_test_p6nop[];
-	extern const unsigned char ftrace_test_nop5[];
-	extern const unsigned char ftrace_test_jmp[];
-	int faulted = 0;
-
-	/*
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
-	 *
-	 * TODO: check the cpuid to determine the best nop.
-	 */
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
-}
-#endif
-- 
1.7.0.1

