Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0EYIHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 04:07:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:58451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab0EYIH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 04:07:28 -0400
Date: Tue, 25 May 2010 08:06:45 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100524042958.GA10628@drongo>
References: <20100524042958.GA10628@drongo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Fix IRQ-disable removal from perf/tracepoint interaction
Message-ID: <tip-23ef672d1e8236e6fe606a39963ba2d576972d84@git.kernel.org>
Git-Commit-ID: 23ef672d1e8236e6fe606a39963ba2d576972d84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 25 May 2010 08:06:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23ef672d1e8236e6fe606a39963ba2d576972d84
Gitweb:     http://git.kernel.org/tip/23ef672d1e8236e6fe606a39963ba2d576972d84
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Sun, 23 May 2010 20:16:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 May 2010 09:02:08 +0200

perf, trace: Fix IRQ-disable removal from perf/tracepoint interaction

On x86 perf_arch_fetch_caller_regs() stores pt_regs::flags, which is the
same as used in local_save_flags().

So to avoid another local_save_flags() for the ftrace code, I wanted to
reuse it, and totally forgot the !x86 side of things.

[ Possibly we could remove the local_save_flags() from the
  perf_arch_fetch_caller_regs() as I'm not sure we actually use
  pt_regs::flags (Frederic?) and leave the ftrace thing to use
  local_save_flags(). ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100524042958.GA10628@drongo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    1 -
 kernel/trace/trace_event_perf.c  |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fd4db0d..856aeeb 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1717,7 +1717,6 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
 	 */
 	regs->bp = rewind_frame_pointer(skip + 1);
 	regs->cs = __KERNEL_CS;
-	local_save_flags(regs->flags);
 }
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 26b8607..cb6f365 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -157,6 +157,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 				       struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
+	unsigned long flags;
 	char *raw_data;
 	int pc;
 
@@ -174,7 +175,8 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
-	tracing_generic_entry_update(entry, regs->flags, pc);
+	local_save_flags(flags);
+	tracing_generic_entry_update(entry, flags, pc);
 	entry->type = type;
 
 	return raw_data;
