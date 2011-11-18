Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab1KRXF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:05:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab1KRXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:05:56 -0500
Date: Fri, 18 Nov 2011 15:05:29 -0800
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Message-ID: <tip-ed0449af5373abd766c79fbf83254bebc996bd23@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lizf@cn.fujitsu.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4EAF46CF.8040408@cn.fujitsu.com>
References: <4EAF46CF.8040408@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Restore system filter behavior
Git-Commit-ID: ed0449af5373abd766c79fbf83254bebc996bd23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:05:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed0449af5373abd766c79fbf83254bebc996bd23
Gitweb:     http://git.kernel.org/tip/ed0449af5373abd766c79fbf83254bebc996bd23
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 1 Nov 2011 09:09:35 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 2 Nov 2011 13:56:25 -0400

tracing: Restore system filter behavior

Though not all events have field 'prev_pid', it was allowed to do this:

  # echo 'prev_pid == 100' > events/sched/filter

but commit 75b8e98263fdb0bfbdeba60d4db463259f1fe8a2 (tracing/filter: Swap
entire filter of events) broke it without any reason.

Link: http://lkml.kernel.org/r/4EAF46CF.8040408@cn.fujitsu.com

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
