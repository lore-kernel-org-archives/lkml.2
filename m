Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab2GFKsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 06:48:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831Ab2GFKs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 06:48:28 -0400
Date: Fri, 6 Jul 2012 03:47:54 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-wfw6y3b9ugtey8snaow9nmg5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de, avi@redhat.com
In-Reply-To: <1340757701-10711-2-git-send-email-namhyung@kernel.org>
References: <1340757701-10711-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/kvm: Use __print_hex()
  for kvm_emulate_insn tracepoint
Git-Commit-ID: b102f1d0f1cd0bb5ec82e5aeb1e33502d6ad6710
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 03:48:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b102f1d0f1cd0bb5ec82e5aeb1e33502d6ad6710
Gitweb:     http://git.kernel.org/tip/b102f1d0f1cd0bb5ec82e5aeb1e33502d6ad6710
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 27 Jun 2012 09:41:39 +0900
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 28 Jun 2012 13:52:15 -0400

tracing/kvm: Use __print_hex() for kvm_emulate_insn tracepoint

The kvm_emulate_insn tracepoint used __print_insn()
for printing its instructions. However it makes the
format of the event hard to parse as it reveals TP
internals.

Fortunately, kernel provides __print_hex for almost
same purpose, we can use it instead of open coding
it. The user-space can be changed to parse it later.

That means raw kernel tracing will not be affected
by this change:

 # cd /sys/kernel/debug/tracing/
 # cat events/kvm/kvm_emulate_insn/format
 name: kvm_emulate_insn
 ID: 29
 format:
	...
 print fmt: "%x:%llx:%s (%s)%s", REC->csbase, REC->rip, __print_hex(REC->insn, REC->len), \
 __print_symbolic(REC->flags, { 0, "real" }, { (1 << 0) | (1 << 1), "vm16" }, \
 { (1 << 0), "prot16" }, { (1 << 0) | (1 << 2), "prot32" }, { (1 << 0) | (1 << 3), "prot64" }), \
 REC->failed ? " failed" : ""

 # echo 1 > events/kvm/kvm_emulate_insn/enable
 # cat trace
 # tracer: nop
 #
 # entries-in-buffer/entries-written: 2183/2183   #P:12
 #
 #                              _-----=> irqs-off
 #                             / _----=> need-resched
 #                            | / _---=> hardirq/softirq
 #                            || / _--=> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
         qemu-kvm-1782  [002] ...1   140.931636: kvm_emulate_insn: 0:c102fa25:89 10 (prot32)
         qemu-kvm-1781  [004] ...1   140.931637: kvm_emulate_insn: 0:c102fa25:89 10 (prot32)

Link: http://lkml.kernel.org/n/tip-wfw6y3b9ugtey8snaow9nmg5@git.kernel.org
Link: http://lkml.kernel.org/r/1340757701-10711-2-git-send-email-namhyung@kernel.org

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: kvm@vger.kernel.org
Acked-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kvm/trace.h   |   12 +-----------
 include/trace/ftrace.h |    1 +
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d264..62d02e3 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -710,16 +710,6 @@ TRACE_EVENT(kvm_skinit,
 		  __entry->rip, __entry->slb)
 );
 
-#define __print_insn(insn, ilen) ({		                 \
-	int i;							 \
-	const char *ret = p->buffer + p->len;			 \
-								 \
-	for (i = 0; i < ilen; ++i)				 \
-		trace_seq_printf(p, " %02x", insn[i]);		 \
-	trace_seq_printf(p, "%c", 0);				 \
-	ret;							 \
-	})
-
 #define KVM_EMUL_INSN_F_CR0_PE (1 << 0)
 #define KVM_EMUL_INSN_F_EFL_VM (1 << 1)
 #define KVM_EMUL_INSN_F_CS_D   (1 << 2)
@@ -786,7 +776,7 @@ TRACE_EVENT(kvm_emulate_insn,
 
 	TP_printk("%x:%llx:%s (%s)%s",
 		  __entry->csbase, __entry->rip,
-		  __print_insn(__entry->insn, __entry->len),
+		  __print_hex(__entry->insn, __entry->len),
 		  __print_symbolic(__entry->flags,
 				   kvm_trace_symbol_emul_flags),
 		  __entry->failed ? " failed" : ""
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7697249..c6bc2fa 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -571,6 +571,7 @@ static inline void ftrace_test_probe_##call(void)			\
 
 #undef __print_flags
 #undef __print_symbolic
+#undef __print_hex
 #undef __get_dynamic_array
 #undef __get_str
 
