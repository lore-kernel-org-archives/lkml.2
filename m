Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab1AZH1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:27:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:53000 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab1AZH1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:27:10 -0500
Date: Wed, 26 Jan 2011 07:26:47 GMT
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        cl@linux-foundation.org
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, rostedt@goodmis.org, tj@kernel.org,
        tglx@linutronix.de, cl@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1295973114.3588.312.camel@edumazet-laptop>
References: <1295973114.3588.312.camel@edumazet-laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] percpu, x86: Fix percpu_xchg_op()
Message-ID: <tip-889a7a6a5d5e64063effd40056bdc7b8fb336bd1@git.kernel.org>
Git-Commit-ID: 889a7a6a5d5e64063effd40056bdc7b8fb336bd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:26:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  889a7a6a5d5e64063effd40056bdc7b8fb336bd1
Gitweb:     http://git.kernel.org/tip/889a7a6a5d5e64063effd40056bdc7b8fb336bd1
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Tue, 25 Jan 2011 17:31:54 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:10:49 +0100

percpu, x86: Fix percpu_xchg_op()

These recent percpu commits:

  2485b6464cf8: x86,percpu: Move out of place 64 bit ops into X86_64 section
  8270137a0d50: cpuops: Use cmpxchg for xchg to avoid lock semantics

Caused this 'perf top' crash:

 Kernel panic - not syncing: Fatal exception in interrupt
 Pid: 0, comm: swapper Tainted: G     D
 2.6.38-rc2-00181-gef71723 #413 Call Trace: <IRQ> [<ffffffff810465b5>]
    ? panic
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
 ...

Looking at assembly code, I found:

list = this_cpu_xchg(irq_work_list, NULL);

gives this wrong code : (gcc-4.1.2 cross compiler)

ffffffff810bc45e:
	mov    %gs:0xead0,%rax
	cmpxchg %rax,%gs:0xead0
	jne    ffffffff810bc45e <irq_work_run+0x3e>
	test   %rax,%rax
	je     ffffffff810bc4aa <irq_work_run+0x8a>

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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <1295973114.3588.312.camel@edumazet-laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
