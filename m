Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0C1FLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 01:11:20 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54849 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0C1FLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 01:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=o0hFxa1xfH1mfNcvzriO2Cm3jsbEqKaJItCJFJdW6wG2j4bA4VHie93RZXbS5f/oZy
         c6ae4ygF0O/MtRzvA02qPiCN0qlxXzJ5t7GDTxjwMy7b+RPDQ2CvJwOFrrNc2/WwGa2t
         W2fTmlunFCkD0/XXdQAgmUHsH47r5Ad86AiQw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/2] perf: Correctly align perf event tracing buffer
Date: Sun, 28 Mar 2010 07:11:05 +0200
Message-Id: <1269753066-17246-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace event buffer used by perf to record raw sample events
is typed as an array of char and may then not be aligned to 8
by alloc_percpu().

But we need it to be aligned to 8 in sparc64 because we cast
this buffer into a random structure type built by the TRACE_EVENT()
macro to store the traces. So if a random 64 bits field is accessed
inside, it may be not under an expected good alignment.

Use an array of long instead to force the appropriate alignment, and
perform a compile time check to ensure the size in byte of the buffer
is a multiple of sizeof(long) so that its actual size doesn't get
shrinked under us.

This fixes unaligned accesses reported while using perf lock
in sparc 64.

Suggested-by: David Miller <davem@davemloft.net>
Suggested-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_event_perf.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 0709e4f..69941f3 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -15,7 +15,12 @@ EXPORT_PER_CPU_SYMBOL_GPL(perf_trace_regs);
 static char *perf_trace_buf;
 static char *perf_trace_buf_nmi;
 
-typedef typeof(char [PERF_MAX_TRACE_SIZE]) perf_trace_t ;
+/*
+ * Force it to be aligned to unsigned long to avoid misaligned accesses
+ * suprises
+ */
+typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
+	perf_trace_t;
 
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
@@ -128,6 +133,8 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	char *trace_buf, *raw_data;
 	int pc, cpu;
 
+	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
+
 	pc = preempt_count();
 
 	/* Protect the per cpu buffer, begin the rcu read side */
@@ -150,7 +157,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	raw_data = per_cpu_ptr(trace_buf, cpu);
 
 	/* zero the dead bytes from align to not leak stack to user */
-	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
+	memset(&raw_data[size - sizeof(u64)], 0, sizeof(u64));
 
 	entry = (struct trace_entry *)raw_data;
 	tracing_generic_entry_update(entry, *irq_flags, pc);
-- 
1.6.2.3

