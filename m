Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2AYOf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:35:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2AYOfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:35:22 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=t83RfUp3MNgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=8HmFGesX5zIfzJw5pZIA:9 a=tEZjjxiFV9Evg3296u0A:7 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120125143520.086175333@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 25 Jan 2012 09:32:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andi Kleen <ak@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Clark Williams <williams@redhat.com>,
        Luis Goncalves <lgoncalv@redhat.com>
Subject: [PATCH RT 1/2 v2] x86: Do not disable preemption in int3 on 32bit
References: <20120125143231.196670014@goodmis.org>
Content-Disposition: inline; filename=fix-rt-int3-x86_32-3.2-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preemption must be disabled before enabling interrupts in do_trap
on x86_64 because the stack in use for int3 and debug is a per CPU
stack set by th IST. But in 32bit, the stack still belongs to the
current task and there is no problem in scheduling out the task.

Keep preemption enabled on X86_32 when enabling interrupts for
do_trap().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/arch/x86/kernel/traps.c
===================================================================
--- linux-rt.git.orig/arch/x86/kernel/traps.c
+++ linux-rt.git/arch/x86/kernel/traps.c
@@ -89,7 +89,14 @@ static inline void conditional_sti(struc
 
 static inline void preempt_conditional_sti(struct pt_regs *regs)
 {
+#ifdef CONFIG_X86_64
+	/*
+	 * X86_64 uses a per CPU stack for certain traps like int3.
+	 * We must disable preemption, otherwise we can corrupt the
+	 * stack if the task is scheduled out with this stack.
+	 */
 	inc_preempt_count();
+#endif
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_enable();
 }
@@ -104,7 +111,9 @@ static inline void preempt_conditional_c
 {
 	if (regs->flags & X86_EFLAGS_IF)
 		local_irq_disable();
+#ifdef CONFIG_X86_64
 	dec_preempt_count();
+#endif
 }
 
 static void __kprobes

