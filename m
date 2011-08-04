Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1HDKJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:09:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1HDKIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:08:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/10] tracing/filter: Simplify tracepoint event lookup
Date: Thu,  4 Aug 2011 12:08:20 +0200
Message-Id: <1312452506-5100-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We dont need to perform lookup through the ftrace_events list,
instead we can use the 'tp_event' field.

Each perf_event contains tracepoint event field 'tp_event', which
got initialized during the tracepoint event initialization.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.1

