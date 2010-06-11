Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab0FKA6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:58:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab0FKA6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:58:42 -0400
X-Authority-Analysis: v=1.1 cv=I1wgP7vb7Y9JOn/mmmkmB2mXFOTL2SFQ5cjyLjGRNmo= c=1 sm=0 a=0Mm38hNcEkIA:10 a=yQWWgrYGNuUA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=JQabhkxi76LdMh2Btf8A:9 a=y8upe5iaLBl-GMNto0ctlA_Jc38A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL][v2.6.35] perf/tracing: Fix regression of perf
 losing kprobe events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Jun 2010 20:58:39 -0400
Message-ID: <1276217919.28329.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Steven Rostedt (1):
      perf/tracing: Fix regression of perf losing kprobe events

----
 kernel/trace/trace_event_perf.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)
---------------------------
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


