Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab2HINsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:48:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3944 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab2HINso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:48:44 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=6BT9eh2GF10A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=91Vx31u4lCIN2Xx8wLIA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1344520123.6935.36.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 4/4] ftrace/x86: Add support for -mfentry to x86_64
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Date: Thu, 09 Aug 2012 09:48:43 -0400
In-Reply-To: <1344519970.6935.34.camel@gandalf.stny.rr.com>
References: <20120807193845.146666357@goodmis.org>
	 <20120807194100.130477900@goodmis.org>
	 <1344519970.6935.34.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-09 at 09:46 -0400, Steven Rostedt wrote:
> Peter and Masami
> 
> During my final tests, I found that this change breaks the
> !DYNAMIC_FTRACE config. That is, when we don't do the run-time updates
> of mcount calls to nops, the compiler will use fentry but the code still
> uses mcount.
> 
> I fixed this in the patch below. But as you two have acked and reviewed
> it, I can't add your tags if I have changed the code. Can you ack/review
> it again.
> 
> Thanks!
> 

This is the changes that were made against the original patch:

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 2add3bb..a698521 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -68,18 +68,19 @@
 	.section .entry.text, "ax"
 
 #ifdef CONFIG_FUNCTION_TRACER
-#ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifdef CC_USING_FENTRY
-ENTRY(__fentry__)
-	retq
-END(__fentry__)
+# define function_hook	__fentry__
 #else
-ENTRY(mcount)
-	retq
-END(mcount)
+# define function_hook	mcount
 #endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+ENTRY(function_hook)
+	retq
+END(function_hook)
+
 /* skip is set if stack has been adjusted */
 .macro ftrace_caller_setup skip=0
 	MCOUNT_SAVE_FRAME \skip
@@ -188,7 +189,8 @@ END(ftrace_regs_caller)
 
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
-ENTRY(mcount)
+
+ENTRY(function_hook)
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
@@ -210,7 +212,11 @@ trace:
 	MCOUNT_SAVE_FRAME
 
 	movq RIP(%rsp), %rdi
+#ifdef CC_USING_FENTRY
+	movq SS+16(%rsp), %rsi
+#else
 	movq 8(%rbp), %rsi
+#endif
 	subq $MCOUNT_INSN_SIZE, %rdi
 
 	call   *ftrace_trace_function
@@ -218,7 +224,7 @@ trace:
 	MCOUNT_RESTORE_FRAME
 
 	jmp ftrace_stub
-END(mcount)
+END(function_hook)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_TRACER */
 


