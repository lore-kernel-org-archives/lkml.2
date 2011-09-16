Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1IPPqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 11:46:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:10411 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1IPPqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 11:46:52 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, avagin@openvz.org
Subject: [PATCH] perf: fix counter of ftrace events
Date: Fri, 16 Sep 2011 19:46:34 +0400
Message-Id: <1316187994-670129-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each event adds some points to its counters. By default it adds 1,
and a number of points may be transmited in event's parameters.

E.g. sched:sched_stat_runtime adds how long process has been running.

But this functionality was broken by v2.6.31-rc5-392-gf413cdb
and now the event's parameters doesn't affect on a number of points.

TP_perf_assign isn't defined, so __perf_count(c) isn't executed and
__count is always equal to 1.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/trace/ftrace.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7f89fbf..d6385ee 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -712,6 +712,9 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #undef __perf_count
 #define __perf_count(c) __count = (c)
 
+#undef TP_perf_assign
+#define TP_perf_assign(args...) args
+
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 static notrace void							\
-- 
1.7.1

