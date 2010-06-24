Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0FXF6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 01:58:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:36897 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0FXF6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 01:58:52 -0400
Subject: Re: perf regression: failed to stat syscalls events
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20100624014422.GA17476@localhost>
References: <20100624013915.GA16965@localhost>
	 <20100624014422.GA17476@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 07:58:45 +0200
Message-ID: <1277359125.1875.828.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 09:44 +0800, Wu Fengguang wrote:
> On Thu, Jun 24, 2010 at 09:39:15AM +0800, Wu Fengguang wrote:
> > Greetings,
> > 
> > I noticed that
> > 
> >         # perf stat -e syscalls:sys_enter_mmap true
> > 
> > refuse to work on 2.6.35-rc1. The last working kernel is 2.6.34.
> 
> Other events like lock:* or block:* or whatever continue to work.
> So this is a problem specific to syscalls:*.

Does your tree contain:

---
commit a8fb2608053547bc3152ea61a5ec7cdfce5d942c
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Jun 10 14:53:16 2010 -0400

    perf/tracing: Fix regression of perf losing kprobe events
    
    With the addition of the code to shrink the kernel tracepoint
    infrastructure, we lost kprobes being traced by perf. The reason
    is that I tested if the "tp_event->class->perf_probe" existed before
    enabling it. This prevents "ftrace only" events (like the function
    trace events) from being enabled by perf.
    
    Unfortunately, kprobe events do not use perf_probe. This causes
    kprobes to be missed by perf. To fix this, we add the test to
    see if "tp_event->class->reg" exists as well as perf_probe.
    
    Normal trace events have only "perf_probe" but no "reg" function,
    and kprobes and syscalls have the "reg" but no "perf_probe".
    The ftrace unique events do not have either, so this is a valid
    test. If a kprobe or syscall is not to be probed by perf, the
    "reg" function is called anyway, and will return a failure and
    prevent perf from probing it.
    
    Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e6f6588..8a2b73f 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -96,7 +96,9 @@ int perf_trace_init(struct perf_event *p_event)
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tp_event, &ftrace_events, list) {
 		if (tp_event->event.type == event_id &&
-		    tp_event->class && tp_event->class->perf_probe &&
+		    tp_event->class &&
+		    (tp_event->class->perf_probe ||
+		     tp_event->class->reg) &&
 		    try_module_get(tp_event->mod)) {
 			ret = perf_trace_event_init(tp_event, p_event);
 			break;

