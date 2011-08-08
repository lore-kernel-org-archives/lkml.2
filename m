Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1HHVD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1HHVDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:03:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, sched: Do not delete session object prematurely
Date: Mon,  8 Aug 2011 23:03:34 +0200
Message-Id: <1312837414-3819-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The session object is released prematurely when processing
events for latency command. The session's thread objects are
used within the output_lat_thread function.

Runnning following commands:

 # perf sched record
 # perf sched latency

the latter displays incorrect data and might cause access
violation.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-sched.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index dcfe887..3d5702c 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1637,23 +1637,29 @@ static struct perf_event_ops event_ops = {
 	.ordered_samples	= true,
 };
 
-static int read_events(void)
+static void read_events(bool destroy, struct perf_session **psession)
 {
 	int err = -EINVAL;
 	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
 							 0, false, &event_ops);
 	if (session == NULL)
-		return -ENOMEM;
+		die("No Memory");
 
 	if (perf_session__has_traces(session, "record -R")) {
 		err = perf_session__process_events(session, &event_ops);
+		if (err)
+			die("Failed to process events, error %d", err);
+
 		nr_events      = session->hists.stats.nr_events[0];
 		nr_lost_events = session->hists.stats.total_lost;
 		nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
 	}
 
-	perf_session__delete(session);
-	return err;
+	if (destroy)
+		perf_session__delete(session);
+
+	if (psession)
+		*psession = session;
 }
 
 static void print_bad_events(void)
@@ -1689,9 +1695,10 @@ static void print_bad_events(void)
 static void __cmd_lat(void)
 {
 	struct rb_node *next;
+	struct perf_session *session;
 
 	setup_pager();
-	read_events();
+	read_events(false, &session);
 	sort_lat();
 
 	printf("\n ---------------------------------------------------------------------------------------------------------------\n");
@@ -1717,6 +1724,7 @@ static void __cmd_lat(void)
 	print_bad_events();
 	printf("\n");
 
+	perf_session__delete(session);
 }
 
 static struct trace_sched_handler map_ops  = {
@@ -1731,7 +1739,7 @@ static void __cmd_map(void)
 	max_cpu = sysconf(_SC_NPROCESSORS_CONF);
 
 	setup_pager();
-	read_events();
+	read_events(true, NULL);
 	print_bad_events();
 }
 
@@ -1744,7 +1752,7 @@ static void __cmd_replay(void)
 
 	test_calibrations();
 
-	read_events();
+	read_events(true, NULL);
 
 	printf("nr_run_events:        %ld\n", nr_run_events);
 	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
-- 
1.7.1

