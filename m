Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab1AERiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:38:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:32972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab1AERis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:38:48 -0500
Date: Wed, 5 Jan 2011 17:37:43 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Use the default lost event handler
Message-ID: <tip-6d8afb56300c53a250c6de0f973ef502e54aabf3@git.kernel.org>
Git-Commit-ID: 6d8afb56300c53a250c6de0f973ef502e54aabf3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 Jan 2011 17:37:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d8afb56300c53a250c6de0f973ef502e54aabf3
Gitweb:     http://git.kernel.org/tip/6d8afb56300c53a250c6de0f973ef502e54aabf3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 4 Jan 2011 16:27:30 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Jan 2011 14:53:43 -0200

perf script: Use the default lost event handler

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
