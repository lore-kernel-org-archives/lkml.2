Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab2F0Apv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:45:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56752 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2F0Aps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:45:48 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-ed-4fea57b6941d
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, kvm@vger.kernel.org
Subject: [PATCH 2/4] KVM: Use __print_hex() for kvm_emulate_insn tracepoint
Date: Wed, 27 Jun 2012 09:41:39 +0900
Message-Id: <1340757701-10711-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
References: <1340757701-10711-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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

Cc: kvm@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-wfw6y3b9ugtey8snaow9nmg5@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 arch/x86/kvm/trace.h   |   12 +-----------
 include/trace/ftrace.h |    1 +
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 911d2641f14c..62d02e3c3ed6 100644
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
index 769724944fc6..c6bc2faaf261 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -571,6 +571,7 @@ static inline void ftrace_test_probe_##call(void)			\
 
 #undef __print_flags
 #undef __print_symbolic
+#undef __print_hex
 #undef __get_dynamic_array
 #undef __get_str
 
-- 
1.7.10.2

