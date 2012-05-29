Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2E2LhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:37:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3723 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab2E2LhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:37:23 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Aua4qMZyJ18A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=zVF3SNT0W3Oze7jcm2UA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338291441.13348.291.camel@gandalf.stny.rr.com>
Subject: Re: BUG - function tracing with breakpoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Tue, 29 May 2012 07:37:21 -0400
In-Reply-To: <1337979086.13348.269.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337902816.13348.224.camel@gandalf.stny.rr.com>
	 <4FBEC9E6.8040301@linux.intel.com>
	 <1337909963.13348.232.camel@gandalf.stny.rr.com>
	 <1337910106.13348.234.camel@gandalf.stny.rr.com>
	 <1337956262.13348.257.camel@gandalf.stny.rr.com>
	 <1337959746.13348.264.camel@gandalf.stny.rr.com>
	 <4FBFC421.3020901@linux.intel.com>
	 <1337971575.13348.268.camel@gandalf.stny.rr.com>
	 <1337979086.13348.269.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 16:51 -0400, Steven Rostedt wrote:
> 
> /me continues his search.

Found it!

The int3 handler uses paranoidzeroentry_ist:

.macro paranoidzeroentry_ist sym do_sym ist
ENTRY(\sym)
	INTR_FRAME
	PARAVIRT_ADJUST_EXCEPTION_FRAME
	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
	subq $ORIG_RAX-R15, %rsp
	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
	call save_paranoid
	TRACE_IRQS_OFF
	movq %rsp,%rdi		/* pt_regs pointer */
	xorl %esi,%esi		/* no error code */
	subq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
	call \do_sym
	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\ist)
	jmp paranoid_exit	/* %ebx: no swapgs flag */
	CFI_ENDPROC
END(\sym)

Which calls paranoid_exit, which does:

paranoid_restore:
	TRACE_IRQS_IRETQ 0
	RESTORE_ALL 8
	jmp irq_return

The problem is with TRACE_IRQS_IRETQ which happens to call into lockdep.
Now we are still using the debug stack here outside that little
subtraction trick of the INIT_TSS_IST.

.macro TRACE_IRQS_IRETQ offset=ARGOFFSET
#ifdef CONFIG_TRACE_IRQFLAGS
	bt   $9,EFLAGS-\offset(%rsp)	/* interrupts off? */
	jnc  1f
	TRACE_IRQS_ON
1:
#endif
.endm


#  define TRACE_IRQS_ON		call trace_hardirqs_on_thunk;

THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1

which eventually leads to:

trace_hardirqs_on_caller {
	__trace_hardirqs_on_caller(ip) {
		mark_locks_held() {
			mark_lock() {
				save_trace() {
					save_stack_trace()...


Unfortunately, the save_stack_trace() is traced by the function tracer.
Which means that it will hit a breakpoint and jump into the breakpoint
code. But here it will reset the stack and corrupt the current stack,
causing strange hard-to-debug bugs.

There's no reason to function trace stack dumps, and this stops the bug
from triggering when I apply it.

Dave, can you give this a try too?

Thanks!

-- Steve

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 532d2e0..0026999 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -14,6 +14,10 @@ CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
 CFLAGS_REMOVE_pvclock.o = -pg
 CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_dumpstack.o = -pg
+CFLAGS_REMOVE_dumpstack_32.o = -pg
+CFLAGS_REMOVE_dumpstack_64.o = -pg
+CFLAGS_REMOVE_stacktrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 


