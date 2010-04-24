Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab0DXCGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 22:06:42 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61498 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab0DXCFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 22:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=QfjbpAjY6btjikPLjkVjhC2OeQyapdK21EumcbzIikOBEmu0lmdLNQ2omPqUC8qP/o
         P6of348lC98mEiA5+ahwsNICD/veCSZycFyqkxK8AyveQppnG0mERTFfT6Tx03LkQaEQ
         1DaeoYevpXLe5x0IJcZbXIxo0tiUgH1LPzbQ0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 8/9] perf: Add a perf trace option to check samples ordering reliability
Date: Sat, 24 Apr 2010 04:05:41 +0200
Message-Id: <1272074742-3654-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
References: <1272074742-3654-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To ensure sample events time reordering is reliable, add a -d option
to perf trace to check that automatically.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1d034f6..77f556f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -11,6 +11,8 @@
 
 static char const		*script_name;
 static char const		*generate_script_lang;
+static bool			debug_ordering;
+static u64			last_timestamp;
 
 static int default_start_script(const char *script __unused,
 				int argc __unused,
@@ -87,6 +89,14 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	}
 
 	if (session->sample_type & PERF_SAMPLE_RAW) {
+		if (debug_ordering) {
+			if (data.time < last_timestamp) {
+				pr_err("Samples misordered, previous: %llu "
+					"this: %llu\n", last_timestamp,
+					data.time);
+			}
+			last_timestamp = data.time;
+		}
 		/*
 		 * FIXME: better resolve from pid from the struct trace_entry
 		 * field, although it should be the same than this perf
@@ -532,6 +542,8 @@ static const struct option options[] = {
 		   "generate perf-trace.xx script in specified language"),
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
+	OPT_BOOLEAN('d', "debug-ordering", &debug_ordering,
+		   "check that samples time ordering is monotonic"),
 
 	OPT_END()
 };
-- 
1.6.2.3

