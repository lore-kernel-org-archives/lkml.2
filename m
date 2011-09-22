Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1IVWKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:10:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1IVWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:30 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=naW5hn2M3_8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=cNoPasxiBr65vVOEx98A:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221026.663865810@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/21] tracing/filter: Simplify tracepoint event lookup
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-filter-Simplify-tracepoint-event-lookup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

We dont need to perform lookup through the ftrace_events list,
instead we can use the 'tp_event' field.

Each perf_event contains tracepoint event field 'tp_event', which
got initialized during the tracepoint event initialization.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-5-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 97b93f3..0948905 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1894,17 +1894,14 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	int err;
 	struct event_filter *filter;
 	struct filter_parse_state *ps;
-	struct ftrace_event_call *call = NULL;
+	struct ftrace_event_call *call;
 
 	mutex_lock(&event_mutex);
 
-	list_for_each_entry(call, &ftrace_events, list) {
-		if (call->event.type == event_id)
-			break;
-	}
+	call = event->tp_event;
 
 	err = -EINVAL;
-	if (&call->list == &ftrace_events)
+	if (!call)
 		goto out_unlock;
 
 	err = -EEXIST;
-- 
1.7.5.4


