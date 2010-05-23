Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0EWSQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:16:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:46967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0EWSQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:16:31 -0400
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from
 perf/tracepoint interaction
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100523121159.GB3194@brick.ozlabs.ibm.com>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.419716197@chello.nl>
	 <20100523121159.GB3194@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 20:16:27 +0200
Message-ID: <1274638587.1674.1729.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-23 at 22:11 +1000, Paul Mackerras wrote:
> On Fri, May 21, 2010 at 11:02:02AM +0200, Peter Zijlstra wrote:
> 
> >  	entry = (struct trace_entry *)raw_data;
> > -	tracing_generic_entry_update(entry, *irq_flags, pc);
> > +	tracing_generic_entry_update(entry, regs->flags, pc);
> >  	entry->type = type;
> 
> This is breaking on powerpc -- we don't have a "flags" element in
> struct pt_regs.  What is it trying to do?  Get the interrupt enable
> state, as local_irq_save(flags) would provide?

Yes, I fouled that up.

On x86 perf_arch_fetch_caller_regs() stores pt_regs::flags, which is the
same as used in local_save_flags().

So to avoid another local_save_flags() for the ftrace code, I wanted to
reuse it, and totally forgot the !x86 side of things.

Possibly we could remove the local_save_flags() from the
perf_arch_fetch_caller_regs() as I'm not sure we actually use
pt_regs::flags (Frederic?) and leave the ftrace thing to use
local_save_flags().

Something like:


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


