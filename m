Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab2LKW4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:56:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43859 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2LKWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 36/37] perf record: Export the callchain parsing routine and help
Date: Tue, 11 Dec 2012 19:48:22 -0300
Message-Id: <1355266103-17238-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used by perf top, that will first setup the symbol system to
deal with callchains and then call these routines to ask the kernel
for callchains.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jg0dh8rmlx7x11e7u7mnasvd@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   11 ++++++-----
 tools/perf/util/callchain.h |    5 +++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d035040..028de72 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -868,7 +868,8 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* LIBUNWIND_SUPPORT */
 
-static int parse_callchain_opt(const struct option *opt, const char *arg, int unset)
+int record_parse_callchain_opt(const struct option *opt,
+			       const char *arg, int unset)
 {
 	struct perf_record_opts *opts = opt->value;
 	char *tok, *name, *saveptr = NULL;
@@ -973,9 +974,9 @@ static struct perf_record record = {
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
 #ifdef LIBUNWIND_SUPPORT
-static const char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
 #else
-static const char callchain_help[] = CALLCHAIN_HELP "[fp]";
+const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
 #endif
 
 /*
@@ -1020,8 +1021,8 @@ const struct option record_options[] = {
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
-			     "mode[,dump_size]", callchain_help,
-			     &parse_callchain_opt, "fp"),
+			     "mode[,dump_size]", record_callchain_help,
+			     &record_parse_callchain_opt, "fp"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index eb34057..3ee9f67 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -143,4 +143,9 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 	cursor->curr = cursor->curr->next;
 	cursor->pos++;
 }
+
+struct option;
+
+int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
+extern const char record_callchain_help[];
 #endif	/* __PERF_CALLCHAIN_H */
-- 
1.7.9.2.358.g22243

