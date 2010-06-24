Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab0FXVlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:41:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab0FXVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=xnKsY3TMfIkWwkZkaQf0WGc/PLV76xc5AKg12VoxFvTUXqn65raEpxnbiWCJOlQ+23
         pYLRX86m9xoTKqp6Wf1rgtS4c/Sii0xtp6GyCDIhqtiXv1QnyxrNBs9YKP0OiZqO4opX
         ZgzowQ96uyq/fiA28JZGdz0Ii4vReVnXz3Dxs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/7] perf: Don't print traces when debugging ordering
Date: Thu, 24 Jun 2010 23:40:57 +0200
Message-Id: <1277415658-10036-7-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Errors due to ordering bugs are easily lost in the middle
of traces.

When we are in this mode, don't print the traces so that
we don't miss the debugging messages.
But display a comforting message if we didn't encounter any
ordering problem.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/builtin-trace.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dddf3f0..83df8db 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -13,6 +13,7 @@ static char const		*script_name;
 static char const		*generate_script_lang;
 static bool			debug_ordering;
 static u64			last_timestamp;
+static u64			nr_unordered;
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -96,8 +97,10 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 				pr_err("Samples misordered, previous: %llu "
 					"this: %llu\n", last_timestamp,
 					data.time);
+				nr_unordered++;
 			}
 			last_timestamp = data.time;
+			return 0;
 		}
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
@@ -132,9 +135,16 @@ static void sig_handler(int sig __unused)
 
 static int __cmd_trace(struct perf_session *session)
 {
+	int ret;
+
 	signal(SIGINT, sig_handler);
 
-	return perf_session__process_events(session, &event_ops);
+	ret = perf_session__process_events(session, &event_ops);
+
+	if (debug_ordering)
+		pr_err("Misordered timestamps: %llu\n", nr_unordered);
+
+	return ret;
 }
 
 struct script_spec {
-- 
1.6.2.3

