Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab1AYQcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:32:04 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58740 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1AYQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:32:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c0r/u8eWyPXz7XfeMgDTKrPsBD4SXxp7HsTYFwjeWHw03A72Oh08wmKIZQNZ5IEjs7
         akOoYbM3uIIMDAoNqN3FTSaI2gzyy8C7xe4AYA7HDBrnsKtb69MxN2YGFlK1LlAqtKqG
         RIjjKlXp9fq+FGHR+57cVRxUr6KpHg17x/GdU=
Subject: [PATCH] x86,percpu: fix percpu_xchg_op()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110125001658.GA17623@elte.hu>
References: <20110124133400.GA1228@elte.hu>
	 <AANLkTinsVNy9a1bR0AgD7=Vupoujt03RuZ32v39XSknx@mail.gmail.com>
	 <20110124200738.GA10833@elte.hu>
	 <AANLkTi=C0L=21zhH_L+cRPv2ZCRE9L93tKtC9ELrcTBW@mail.gmail.com>
	 <AANLkTi=V61L6vgFZ_4u20dZvv2=tvi-XJMc2HqOnjMo4@mail.gmail.com>
	 <20110124203802.GC29975@ghostprotocols.net>
	 <20110124212526.GA13724@elte.hu>
	 <20110124220032.GE29975@ghostprotocols.net>
	 <20110125001658.GA17623@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Jan 2011 17:31:54 +0100
Message-ID: <1295973114.3588.312.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

So I wanted to play again with perf ;)

I had several crashes on a x86_64 machine, while "perf top" was running,
on latest linux-2.6 tree.

Crash was in irq_work(), calling a NULL entry->func()


Code: Bad RIP value.
RIP [<       (null)>]   (null)
 RSP <ffff8800df203e50>
CR2: 0000000000000000
---[ end trace fd7ad949f6766354 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 0, comm: swapper Tainted: G     D  2.6.38-rc2-00181-gef71723 #413
Call Trace:
<IRQ> [<ffffffff810465b5>] ? panic
    ? kmsg_dump
    ? kmsg_dump
    ? oops_end
    ? no_context
    ? __bad_area_nosemaphore
    ? perf_output_begin
    ? bad_area_nosemaphore
    ? do_page_fault
    ? __task_pid_nr_ns
    ? perf_event_tid
    ? __perf_event_header__init_id
    ? validate_chain
    ? perf_output_sample
    ? trace_hardirqs_off
    ? page_fault
    ? irq_work_run
    ? update_process_times
    ? tick_sched_timer
    ? tick_sched_timer
    ? __run_hrtimer
    ? hrtimer_interrupt
    ? account_system_vtime
    ? smp_apic_timer_interrupt
    ? apic_timer_interrupt
<EOI>  ? restore_args
     ? poll_idle
     ? poll_idle
     ? menu_select
     ? cpuidle_call
 ...

Looking at assembly code, I found 

list = this_cpu_xchg(irq_work_list, NULL);

gives this wrong code : (gcc-4.1.2 cross compiler)

ffffffff810bc45e:
	mov    %gs:0xead0,%rax
	cmpxchg %rax,%gs:0xead0
	jne    ffffffff810bc45e <irq_work_run+0x3e>
	test   %rax,%rax
	je     ffffffff810bc4aa <irq_work_run+0x8a>	

Following patch cures the problem for me

Thanks

[PATCH] x86,percpu: fix percpu_xchg_op()

Tell gcc we dirty eax/rax register in percpu_xchg_op()

Compiler must use another register to store pxo_new__ 

We also dont need to reload percpu value after a jump,
since a 'failed' cmpxchg already updated eax/rax

Wrong generated code was :
	xor     %rax,%rax   /* load 0 into %rax */
1:	mov     %gs:0xead0,%rax
	cmpxchg %rax,%gs:0xead0
	jne     1b
	test    %rax,%rax

After patch :

	xor     %rdx,%rdx   /* load 0 into %rdx */
	mov     %gs:0xead0,%rax
1:	cmpxchg %rdx,%gs:0xead0
	jne     1b:
	test    %rax,%rax

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/percpu.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 3788f46..7e17295 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -273,34 +273,34 @@ do {									\
 	typeof(var) pxo_new__ = (nval);					\
 	switch (sizeof(var)) {						\
 	case 1:								\
-		asm("\n1:mov "__percpu_arg(1)",%%al"			\
-		    "\n\tcmpxchgb %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%al"			\
+		    "\n1:\tcmpxchgb %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "q" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 2:								\
-		asm("\n1:mov "__percpu_arg(1)",%%ax"			\
-		    "\n\tcmpxchgw %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%ax"			\
+		    "\n1:\tcmpxchgw %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 4:								\
-		asm("\n1:mov "__percpu_arg(1)",%%eax"			\
-		    "\n\tcmpxchgl %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%eax"			\
+		    "\n1:\tcmpxchgl %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\
 	case 8:								\
-		asm("\n1:mov "__percpu_arg(1)",%%rax"			\
-		    "\n\tcmpxchgq %2, "__percpu_arg(1)			\
+		asm("\n\tmov "__percpu_arg(1)",%%rax"			\
+		    "\n1:\tcmpxchgq %2, "__percpu_arg(1)		\
 		    "\n\tjnz 1b"					\
-			    : "=a" (pxo_ret__), "+m" (var)		\
+			    : "=&a" (pxo_ret__), "+m" (var)		\
 			    : "r" (pxo_new__)				\
 			    : "memory");				\
 		break;							\


