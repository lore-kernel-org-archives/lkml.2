Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1IVWNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:13:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158Ab1IVWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:31 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=HaD_c0cTkqQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=DNV8g0CO8eLDY5YTDmgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221028.453627091@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 14/21] tracing: Add preempt disable for filter self test
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0014-tracing-Add-preempt-disable-for-filter-self-test.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The self testing for event filters does not really need preemption
disabled as there are no races at the time of testing, but the functions
it calls uses rcu_dereference_sched() which will complain if preemption
is not disabled.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 6a642e2..816d3d0 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -2101,6 +2101,11 @@ static __init int ftrace_test_event_filter(void)
 			break;
 		}
 
+		/*
+		 * The preemption disabling is not really needed for self
+		 * tests, but the rcu dereference will complain without it.
+		 */
+		preempt_disable();
 		if (*d->not_visited)
 			walk_pred_tree(filter->preds, filter->root,
 				       test_walk_pred_cb,
@@ -2108,6 +2113,7 @@ static __init int ftrace_test_event_filter(void)
 
 		test_pred_visited = 0;
 		err = filter_match_preds(filter, &d->rec);
+		preempt_enable();
 
 		__free_filter(filter);
 
-- 
1.7.5.4


