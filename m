Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0EQTbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:31:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:54394 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab0EQTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:31:49 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/4] perf options: Type check OPT_BOOLEAN and fix the offenders
Date: Mon, 17 May 2010 16:31:17 -0300
Message-Id: <1274124678-24781-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274124678-24781-1-git-send-email-acme@infradead.org>
References: <1274124678-24781-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c        |    4 ++--
 tools/perf/builtin-lock.c       |    3 +--
 tools/perf/builtin-test.c       |    2 +-
 tools/perf/perf.h               |    3 ++-
 tools/perf/util/parse-options.h |    3 ++-
 5 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index a4c7cae..b1c6b38 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -22,8 +22,8 @@
 static char			*file_name;
 static char			name_buffer[256];
 
-int				perf_host = 1;
-int				perf_guest;
+bool				perf_host = 1;
+bool				perf_guest;
 
 static const char * const kvm_usage[] = {
 	"perf kvm [<options>] {top|record|report|diff|buildid-list}",
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index e18dfdc..821c158 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -792,8 +792,7 @@ static void print_result(void)
 	print_bad_events(bad, total);
 }
 
-static int			info_threads;
-static int			info_map;
+static bool info_threads, info_map;
 
 static void dump_threads(void)
 {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 0339612..035b9fa 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -257,7 +257,7 @@ static const char * const test_usage[] = {
 };
 
 static const struct option test_options[] = {
-	OPT_BOOLEAN('v', "verbose", &verbose,
+	OPT_INTEGER('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_END()
 };
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 02821fe..ef7aa0a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -80,6 +80,7 @@ void get_term_dimensions(struct winsize *ws);
 
 #include "../../include/linux/perf_event.h"
 #include "util/types.h"
+#include <stdbool.h>
 
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
@@ -131,6 +132,6 @@ struct ip_callchain {
 	u64 ips[0];
 };
 
-extern int perf_host, perf_guest;
+extern bool perf_host, perf_guest;
 
 #endif
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 9ca348e..5838e2d 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -2,6 +2,7 @@
 #define __PERF_PARSE_OPTIONS_H
 
 #include <linux/kernel.h>
+#include <stdbool.h>
 
 enum parse_opt_type {
 	/* special types */
@@ -101,7 +102,7 @@ struct option {
 #define OPT_ARGUMENT(l, h)          { .type = OPTION_ARGUMENT, .long_name = (l), .help = (h) }
 #define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
 #define OPT_BIT(s, l, v, h, b)      { .type = OPTION_BIT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (b) }
-#define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_BOOLEAN(s, l, v, h)     { .type = OPTION_BOOLEAN, .short_name = (s), .long_name = (l), .value = check_vtype(v, bool *), .help = (h) }
 #define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_SET_INT(s, l, v, h, i)  { .type = OPTION_SET_INT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
-- 
1.6.2.5

