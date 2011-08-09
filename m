Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1HITnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:43:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:50062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1HITnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:43:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf sched: Do not delete session object prematurely
Date: Tue,  9 Aug 2011 16:43:07 -0300
Message-Id: <1312918988-24146-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312918988-24146-1-git-send-email-acme@infradead.org>
References: <1312918988-24146-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The session object is released prematurely when processing events for
latency command. The session's thread objects are used within the
output_lat_thread function.

Runnning following commands:

 # perf sched record
 # perf sched latency

the latter displays incorrect data and might cause access violation.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1312837414-3819-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.6.2.5

