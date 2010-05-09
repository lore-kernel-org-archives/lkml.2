Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0EIUpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:45:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53132 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0EIUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=fow5K9NKlfefCVFMIhwmrBOEMtFuNOc/OC5dPbmC8Xt6rRd7BWKrbUAgiGVSeDoEBR
         FS8k27KTYqjavYD4BswAbpaKMQIFvWdsvsGp5uSykwK7jXTnL8Mr2alHYTL9LFUZ57Uf
         mSnYm99DOpfV8DVLbGlP+ej0pJdcUdJ/b/AAE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 02/10] perf: Cleanup perf lock broken states
Date: Sun,  9 May 2010 22:43:30 +0200
Message-Id: <1273437818-8130-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use enum to get a human view of bad_hist indexes and
put bad histogram output in its own function.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-lock.c |   49 ++++++++++++++++++++++++++------------------
 1 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index c4eb854..1e93179 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -387,7 +387,15 @@ static struct lock_seq_stat *get_seq(struct thread_stat *ts, void *addr)
 	return seq;
 }
 
-static int bad_hist[4];
+enum broken_state {
+	BROKEN_ACQUIRE,
+	BROKEN_ACQUIRED,
+	BROKEN_CONTENDED,
+	BROKEN_RELEASE,
+	BROKEN_MAX,
+};
+
+static int bad_hist[BROKEN_MAX];
 
 static void
 report_lock_acquire_event(struct trace_acquire_event *acquire_event,
@@ -437,7 +445,7 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 broken:
 		/* broken lock sequence, discard it */
 		ls->discard = 1;
-		bad_hist[0]++;
+		bad_hist[BROKEN_ACQUIRE]++;
 		list_del(&seq->list);
 		free(seq);
 		goto end;
@@ -481,7 +489,6 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	case SEQ_STATE_CONTENDED:
 		contended_term = timestamp - seq->prev_event_time;
 		ls->wait_time_total += contended_term;
-
 		if (contended_term < ls->wait_time_min)
 			ls->wait_time_min = contended_term;
 		else if (ls->wait_time_max < contended_term)
@@ -492,7 +499,7 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	case SEQ_STATE_READ_ACQUIRED:
 		/* broken lock sequence, discard it */
 		ls->discard = 1;
-		bad_hist[1]++;
+		bad_hist[BROKEN_ACQUIRED]++;
 		list_del(&seq->list);
 		free(seq);
 		goto end;
@@ -540,7 +547,7 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 	case SEQ_STATE_CONTENDED:
 		/* broken lock sequence, discard it */
 		ls->discard = 1;
-		bad_hist[2]++;
+		bad_hist[BROKEN_CONTENDED]++;
 		list_del(&seq->list);
 		free(seq);
 		goto end;
@@ -594,7 +601,7 @@ report_lock_release_event(struct trace_release_event *release_event,
 	case SEQ_STATE_RELEASED:
 		/* broken lock sequence, discard it */
 		ls->discard = 1;
-		bad_hist[3]++;
+		bad_hist[BROKEN_RELEASE]++;
 		goto free_seq;
 		break;
 	default:
@@ -713,6 +720,21 @@ process_raw_event(void *data, int cpu, u64 timestamp, struct thread *thread)
 		process_lock_release_event(data, event, cpu, timestamp, thread);
 }
 
+static void print_bad_events(int bad, int total)
+{
+	/* Output for debug, this have to be removed */
+	int i;
+	const char *name[4] =
+		{ "acquire", "acquired", "contended", "release" };
+
+	pr_info("\n=== output for debug===\n\n");
+	pr_info("bad:%d, total:%d\n", bad, total);
+	pr_info("bad rate:%f\n", (double)(bad / total));
+	pr_info("histogram of events caused bad sequence\n");
+	for (i = 0; i < BROKEN_MAX; i++)
+		pr_info(" %10s: %d\n", name[i], bad_hist[i]);
+}
+
 /* TODO: various way to print, coloring, nano or milli sec */
 static void print_result(void)
 {
@@ -762,20 +784,7 @@ static void print_result(void)
 		pr_info("\n");
 	}
 
-	{
-		/* Output for debug, this have to be removed */
-		int i;
-		const char *name[4] =
-			{ "acquire", "acquired", "contended", "release" };
-
-		pr_debug("\n=== output for debug===\n\n");
-		pr_debug("bad:%d, total:%d\n", bad, total);
-		pr_debug("bad rate:%f\n", (double)(bad / total));
-
-		pr_debug("histogram of events caused bad sequence\n");
-		for (i = 0; i < 4; i++)
-			pr_debug(" %10s: %d\n", name[i], bad_hist[i]);
-	}
+	print_bad_events(bad, total);
 }
 
 static int			info_threads;
-- 
1.6.2.3

