Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759423Ab0J1T1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 15:27:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:55129 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753322Ab0J1T1I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 15:27:08 -0400
Date: Thu, 28 Oct 2010 15:27:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Rubin <mrubin@google.com>
Subject: Re: Benchmarks of kernel tracing options (ftrace, ktrace, lttng
	and perf)
Message-ID: <20101028192704.GA26131@Krystal>
References: <AANLkTim8c+FLo11XJbTmTjiuucn-9UJD0Vui=fvUgCd+@mail.gmail.com> <AANLkTikd6sawwJeBm76QLeowXj0GBAf=wpRVgG8x5MOp@mail.gmail.com> <AANLkTi=Dw-dxkUgYLZYBKb5sGYcdGcpS0OH_fEHW51Jr@mail.gmail.com> <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTi=6EBZeZ+56z_wbDuU1xTmC0saSTMDmqbqDS4Jr@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:24:35 up 35 days, 23:26,  3 users,  load average: 0.00, 0.08,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Sharp (dhsharp@google.com) wrote:
[...]
> I hope this produces a fair comparison. I've detailed my steps below
> for all of the tracers in case there are improvements to be made.
> 
[...]
> Results for amount of time to execute a tracepoint (includes previous results):
> ktrace: 200ns   (old)
> ftrace: 224ns   (old, w/ handcoded tracepoint, not syscall tracing)
> lttng: 449ns    (new)
> perf: 1047ns    (new)
> 
> Also interesting:
> ftrace: 587ns   (old, w/ syscall tracing)
> This just shows that syscall tracing is much slower than a normal tracepoint.

Hrm, not quite fair actually. LTTng enables a thread flag that causes
syscall_trace to be called on sycall entry/exit by default. Please try with the
following patch to remove the extra syscall overhead.

Thanks,

Mathieu

for google benchmarks: remove syscall tracing from LTTng modules

Syscall tracing is enabled by default when lttng is tracing, which causes the
full registers to be saved and a sycall_trace call upon syscall entry/exit.

This patch is for testing only.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 ltt-tracer.c |    2 --
 1 file changed, 2 deletions(-)

Index: lttng-modules/ltt-tracer.c
===================================================================
--- lttng-modules.orig/ltt-tracer.c
+++ lttng-modules/ltt-tracer.c
@@ -839,7 +839,6 @@ int ltt_trace_alloc(const char *trace_na
 	if (list_empty(&ltt_traces.head)) {
 		mod_timer(&ltt_async_wakeup_timer,
 				jiffies + LTT_PERCPU_TIMER_INTERVAL);
-		set_kernel_trace_flag_all_tasks();
 	}
 	list_add_rcu(&trace->list, &ltt_traces.head);
 	synchronize_trace();
@@ -917,7 +916,6 @@ static int _ltt_trace_destroy(struct ltt
 	list_del_rcu(&trace->list);
 	synchronize_trace();
 	if (list_empty(&ltt_traces.head)) {
-		clear_kernel_trace_flag_all_tasks();
 		/*
 		 * We stop the asynchronous delivery of reader wakeup, but
 		 * we must make one last check for reader wakeups pending

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
