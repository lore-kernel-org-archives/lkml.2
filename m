Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0EYJba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:31:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:46057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab0EYJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:31:28 -0400
Date: Tue, 25 May 2010 09:30:38 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1274778175.5882.623.camel@twins>
References: <1274778175.5882.623.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, trace: Fix !x86 build bug
Message-ID: <tip-87f44bbc246c5244c76a701f8eefba7788bce64a@git.kernel.org>
Git-Commit-ID: 87f44bbc246c5244c76a701f8eefba7788bce64a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 25 May 2010 09:30:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87f44bbc246c5244c76a701f8eefba7788bce64a
Gitweb:     http://git.kernel.org/tip/87f44bbc246c5244c76a701f8eefba7788bce64a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 25 May 2010 11:02:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 May 2010 11:28:49 +0200

perf, trace: Fix !x86 build bug

Patch b7e2ecef92 (perf, trace: Optimize tracepoints by removing
IRQ-disable from perf/tracepoint interaction) made the
unfortunate mistake of assuming the world is x86 only, correct
this.

The problem was that perf_fetch_caller_regs() did
local_save_flags() into regs->flags, and I re-used that to
remove another local_save_flags(), forgetting !x86 doesn't have
regs->flags.

Do the reverse, remove the local_save_flags() from
perf_fetch_caller_regs() and let the ftrace site do the
local_save_flags() instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: acme@redhat.com
Cc: efault@gmx.de
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
LKML-Reference: <1274778175.5882.623.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    6 +++++-
 kernel/trace/trace_event_perf.c  |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fd4db0d..c775860 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1717,7 +1717,11 @@ void perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip, int ski
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
