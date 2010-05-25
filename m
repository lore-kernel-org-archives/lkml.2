Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab0EYHbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:31:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab0EYHa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:30:58 -0400
Subject: [PATCH 01a/10] perf, trace: Fix !x86 build issue
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100521090710.419716197@chello.nl>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.419716197@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 09:30:43 +0200
Message-ID: <1274772643.5882.304.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf, trace: Fix !x86 build issue
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue May 25 09:22:38 CEST 2010

Patch b7e2ecef92 (perf, trace: Optimize tracepoints by removing
IRQ-disable from perf/tracepoint interaction) made the unfortunate
mistake of assuming the world is x86 only, correct this.

The problem was that perf_fetch_caller_regs() did local_save_flags()
into regs->flags, and I re-used that to remove another
local_save_flags(), forgetting !x86 doesn't have regs->flags.

Do the reverse, remove the local_save_flags() from
perf_fetch_caller_regs() and let the ftrace site do the
local_save_flags() instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++++-
 kernel/trace/trace_event_perf.c  |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1717,7 +1717,11 @@ void perf_arch_fetch_caller_regs(struct 
 	 */
 	regs->bp = rewind_frame_pointer(skip + 1);
 	regs->cs = __KERNEL_CS;
-	local_save_flags(regs->flags);
+	/*
+	 * We abuse bit 3 to pass exact information, see perf_misc_flags
+	 * and the comment with PERF_EFLAGS_EXACT.
+	 */
+	regs->flags = 0;
 }
 
 unsigned long perf_instruction_pointer(struct pt_regs *regs)
Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
@@ -157,6 +157,7 @@ __kprobes void *perf_trace_buf_prepare(i
 				       struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
+	unsigned long flags;
 	char *raw_data;
 	int pc;
 
@@ -174,7 +175,8 @@ __kprobes void *perf_trace_buf_prepare(i
 	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
-	tracing_generic_entry_update(entry, regs->flags, pc);
+	local_save_flags(flags);
+	tracing_generic_entry_update(entry, flags, pc);
 	entry->type = type;
 
 	return raw_data;

