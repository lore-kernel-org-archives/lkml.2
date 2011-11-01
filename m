Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab1KABH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 21:07:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49994 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab1KABHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 21:07:55 -0400
Message-ID: <4EAF46CF.8040408@cn.fujitsu.com>
Date: Tue, 01 Nov 2011 09:09:35 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: Restore system filter behavior
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 09:07:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-01 09:08:01,
	Serialize complete at 2011-11-01 09:08:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though not all events have field 'prev_pid', it was allowed to do this:

  # echo 'prev_pid == 100' > events/sched/filter

but commit 75b8e98263fdb0bfbdeba60d4db463259f1fe8a2 (tracing/filter: Swap
entire filter of events) broke it without any reason.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |    2 ++
 kernel/trace/trace_events_filter.c |    7 ++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 96efa67..c3da42d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -172,6 +172,7 @@ enum {
 	TRACE_EVENT_FL_FILTERED_BIT,
 	TRACE_EVENT_FL_RECORDED_CMD_BIT,
 	TRACE_EVENT_FL_CAP_ANY_BIT,
+	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 };
 
 enum {
@@ -179,6 +180,7 @@ enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
 	TRACE_EVENT_FL_RECORDED_CMD	= (1 << TRACE_EVENT_FL_RECORDED_CMD_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
+	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 };
 
 struct ftrace_event_call {
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 816d3d0..86040d9 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1649,7 +1649,9 @@ static int replace_system_preds(struct event_subsystem *system,
 		 */
 		err = replace_preds(call, NULL, ps, filter_string, true);
 		if (err)
-			goto fail;
+			call->flags |= TRACE_EVENT_FL_NO_SET_FILTER;
+		else
+			call->flags &= ~TRACE_EVENT_FL_NO_SET_FILTER;
 	}
 
 	list_for_each_entry(call, &ftrace_events, list) {
@@ -1658,6 +1660,9 @@ static int replace_system_preds(struct event_subsystem *system,
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
+		if (call->flags & TRACE_EVENT_FL_NO_SET_FILTER)
+			continue;
+
 		filter_item = kzalloc(sizeof(*filter_item), GFP_KERNEL);
 		if (!filter_item)
 			goto fail_mem;
-- 
1.7.3.1
