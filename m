Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0EYJDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:03:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:39736 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0EYJDT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:03:19 -0400
Subject: Re: [tip:perf/core] perf, trace: Fix IRQ-disable removal from
 perf/tracepoint interaction
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, fweisbec@gmail.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-23ef672d1e8236e6fe606a39963ba2d576972d84@git.kernel.org>
References: <20100524042958.GA10628@drongo>
	 <tip-23ef672d1e8236e6fe606a39963ba2d576972d84@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 May 2010 11:02:55 +0200
Message-ID: <1274778175.5882.623.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 08:06 +0000, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  23ef672d1e8236e6fe606a39963ba2d576972d84
> Gitweb:     http://git.kernel.org/tip/23ef672d1e8236e6fe606a39963ba2d576972d84
> Author:     Peter Zijlstra <peterz@infradead.org>
> AuthorDate: Sun, 23 May 2010 20:16:27 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 25 May 2010 09:02:08 +0200
> 
> perf, trace: Fix IRQ-disable removal from perf/tracepoint interaction
> 
> On x86 perf_arch_fetch_caller_regs() stores pt_regs::flags, which is the
> same as used in local_save_flags().
> 
> So to avoid another local_save_flags() for the ftrace code, I wanted to
> reuse it, and totally forgot the !x86 side of things.
> 
> [ Possibly we could remove the local_save_flags() from the
>   perf_arch_fetch_caller_regs() as I'm not sure we actually use
>   pt_regs::flags (Frederic?) and leave the ftrace thing to use
>   local_save_flags(). ]
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Acked-by: Paul Mackerras <paulus@samba.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <20100524042958.GA10628@drongo>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Could you replace this with:


---
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

