Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1HJJrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:47:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:43272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab1HJJrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:47:39 -0400
Date: Wed, 10 Aug 2011 09:47:25 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-4c09bafae37d870ab8efc50faeeb4855cb55b5b7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1312837414-3819-1-git-send-email-jolsa@redhat.com>
References: <1312837414-3819-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Do not delete session object prematurely
Git-Commit-ID: 4c09bafae37d870ab8efc50faeeb4855cb55b5b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 09:47:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c09bafae37d870ab8efc50faeeb4855cb55b5b7
Gitweb:     http://git.kernel.org/tip/4c09bafae37d870ab8efc50faeeb4855cb55b5b7
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 8 Aug 2011 23:03:34 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Aug 2011 13:31:38 -0300

perf sched: Do not delete session object prematurely

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
