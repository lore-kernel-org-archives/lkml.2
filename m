Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab2IGF4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:56:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2IGF4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:56:31 -0400
Date: Thu, 6 Sep 2012 22:56:13 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-d25380cd3be38baff4ab31935b9d19b7f58ba7ac@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346005487-62961-2-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  flush_sample_queue needs to handle errors from handlers
Git-Commit-ID: d25380cd3be38baff4ab31935b9d19b7f58ba7ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 22:56:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d25380cd3be38baff4ab31935b9d19b7f58ba7ac
Gitweb:     http://git.kernel.org/tip/d25380cd3be38baff4ab31935b9d19b7f58ba7ac
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 26 Aug 2012 12:24:41 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:17:30 -0300

perf session: flush_sample_queue needs to handle errors from handlers

Allows errors to propogate through event processing code and back to
commands.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f7bb7ae..9453758 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -692,7 +692,7 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_tool *tool,
 				      u64 file_offset);
 
-static void flush_sample_queue(struct perf_session *s,
+static int flush_sample_queue(struct perf_session *s,
 			       struct perf_tool *tool)
 {
 	struct ordered_samples *os = &s->ordered_samples;
@@ -705,7 +705,7 @@ static void flush_sample_queue(struct perf_session *s,
 	int ret;
 
 	if (!tool->ordered_samples || !limit)
-		return;
+		return 0;
 
 	list_for_each_entry_safe(iter, tmp, head, list) {
 		if (iter->timestamp > limit)
@@ -715,9 +715,12 @@ static void flush_sample_queue(struct perf_session *s,
 						s->header.needs_swap);
 		if (ret)
 			pr_err("Can't parse sample, err = %d\n", ret);
-		else
-			perf_session_deliver_event(s, iter->event, &sample, tool,
-						   iter->file_offset);
+		else {
+			ret = perf_session_deliver_event(s, iter->event, &sample, tool,
+							 iter->file_offset);
+			if (ret)
+				return ret;
+		}
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -737,6 +740,8 @@ static void flush_sample_queue(struct perf_session *s,
 	}
 
 	os->nr_samples = 0;
+
+	return 0;
 }
 
 /*
@@ -782,10 +787,11 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event __used,
 				  struct perf_session *session)
 {
-	flush_sample_queue(session, tool);
-	session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
+	int ret = flush_sample_queue(session, tool);
+	if (!ret)
+		session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
 
-	return 0;
+	return ret;
 }
 
 /* The queue is ordered by time */
@@ -1443,7 +1449,7 @@ more:
 	err = 0;
 	/* do the final flush for ordered samples */
 	session->ordered_samples.next_flush = ULLONG_MAX;
-	flush_sample_queue(session, tool);
+	err = flush_sample_queue(session, tool);
 out_err:
 	perf_session__warn_about_errors(session, tool);
 	perf_session_free_sample_buffers(session);
