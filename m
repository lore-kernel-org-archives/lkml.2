Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1AEREV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:04:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:35822 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1AERES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:04:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf script: Use the default lost event handler
Date: Wed,  5 Jan 2011 15:04:05 -0200
Message-Id: <1294247046-32352-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294247046-32352-1-git-send-email-acme@infradead.org>
References: <1294247046-32352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That already does what was being done here. The warning is now unconditionally
given by __perf_session__process_pipe_events, just like for non pipe processing.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 43480fd..27d568d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -99,16 +99,6 @@ static int process_sample_event(event_t *event, struct sample_data *sample,
 	return 0;
 }
 
-static u64 nr_lost;
-
-static int process_lost_event(event_t *event, struct sample_data *sample __used,
-			      struct perf_session *session __used)
-{
-	nr_lost += event->lost.lost;
-
-	return 0;
-}
-
 static struct perf_event_ops event_ops = {
 	.sample	= process_sample_event,
 	.comm	= event__process_comm,
@@ -116,7 +106,6 @@ static struct perf_event_ops event_ops = {
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
 	.build_id = event__process_build_id,
-	.lost = process_lost_event,
 	.ordering_requires_timestamps = true,
 	.ordered_samples = true,
 };
@@ -136,10 +125,8 @@ static int __cmd_script(struct perf_session *session)
 
 	ret = perf_session__process_events(session, &event_ops);
 
-	if (debug_mode) {
+	if (debug_mode)
 		pr_err("Misordered timestamps: %llu\n", nr_unordered);
-		pr_err("Lost events: %llu\n", nr_lost);
-	}
 
 	return ret;
 }
-- 
1.6.2.5

