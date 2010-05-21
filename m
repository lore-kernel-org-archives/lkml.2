Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab0EUOZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:25:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56994 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab0EUOZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:25:16 -0400
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1274451498.1674.1706.camel@laptop>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl>
	 <1274450643.26328.3749.camel@gandalf.stny.rr.com>
	 <1274451498.1674.1706.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 16:25:13 +0200
Message-ID: <1274451913.1674.1707.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 16:18 +0200, Peter Zijlstra wrote:
> 
> > That tp_event->perf_refcount is global to the event not to the perf
> > event.
> 
> Oh, bugger, yes. I seem to have lost it on destroy..


---
Subject: perf, trace: Fix perf_trace_destroy(), mutex went missing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri May 21 16:22:33 CEST 2010

Steve spotted I forgot to do the destroy under event_mutex.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/trace/trace_event_perf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/trace/trace_event_perf.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_event_perf.c
+++ linux-2.6/kernel/trace/trace_event_perf.c
@@ -125,8 +125,9 @@ void perf_trace_destroy(struct perf_even
 	struct ftrace_event_call *tp_event = p_event->tp_event;
 	int i;
 
+	mutex_lock(&event_mutex);
 	if (--tp_event->perf_refcount > 0)
-		return;
+		goto out;
 
 	tp_event->perf_event_disable(tp_event);
 
@@ -145,6 +146,8 @@ void perf_trace_destroy(struct perf_even
 			perf_trace_buf[i] = NULL;
 		}
 	}
+out:
+	mutex_unlock(&event_mutex);
 }
 
 __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,


