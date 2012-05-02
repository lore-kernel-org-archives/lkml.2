Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2EBT1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:27:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:56710 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2EBTZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:25:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/15] perf tools: Introduce perf_target__validate() helper
Date: Wed,  2 May 2012 16:24:54 -0300
Message-Id: <1335986702-9408-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335986702-9408-1-git-send-email-acme@infradead.org>
References: <1335986702-9408-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf_target__validate function is used to check given PID/TID/UID/CPU
target options and warn if some combination is impossible. Also this can
make some arguments of parse_target_uid() function useless as it is checked
before the call via our new helper.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1335417327-11796-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 +++------
 tools/perf/builtin-stat.c   |    3 +--
 tools/perf/builtin-top.c    |   15 +++------------
 tools/perf/util/usage.c     |   29 +++++++++++++++++++++--------
 tools/perf/util/util.h      |    4 +++-
 5 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4dcf270..3596cca 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -884,16 +884,13 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	rec->opts.target.uid = parse_target_uid(rec->opts.target.uid_str,
-						rec->opts.target.tid,
-						rec->opts.target.pid);
+	perf_target__validate(&rec->opts.target);
+
+	rec->opts.target.uid = parse_target_uid(rec->opts.target.uid_str);
 	if (rec->opts.target.uid_str != NULL &&
 	    rec->opts.target.uid == UINT_MAX - 1)
 		goto out_free_fd;
 
-	if (rec->opts.target.pid)
-		rec->opts.target.tid = rec->opts.target.pid;
-
 	if (perf_evlist__create_maps(evsel_list, rec->opts.target.pid,
 				     rec->opts.target.tid, rec->opts.target.uid,
 				     rec->opts.target.cpu_list) < 0)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1ca767d..bb77232 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1203,8 +1203,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (add_default_attributes())
 		goto out;
 
-	if (target.pid)
-		target.tid = target.pid;
+	perf_target__validate(&target);
 
 	evsel_list->threads = thread_map__new_str(target.pid,
 						  target.tid, UINT_MAX);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2c1c207..4f47952 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1252,21 +1252,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_browser(false);
 
-	top.target.uid = parse_target_uid(top.target.uid_str, top.target.tid,
-					  top.target.pid);
+	perf_target__validate(&top.target);
+
+	top.target.uid = parse_target_uid(top.target.uid_str);
 	if (top.target.uid_str != NULL && top.target.uid == UINT_MAX - 1)
 		goto out_delete_evlist;
 
-	/* CPU and PID are mutually exclusive */
-	if (top.target.tid && top.target.cpu_list) {
-		printf("WARNING: PID switch overriding CPU\n");
-		sleep(1);
-		top.target.cpu_list = NULL;
-	}
-
-	if (top.target.pid)
-		top.target.tid = top.target.pid;
-
 	if (perf_evlist__create_maps(top.evlist, top.target.pid,
 				     top.target.tid, top.target.uid,
 				     top.target.cpu_list) < 0)
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 52bb07c..0a1a885 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -83,7 +83,7 @@ void warning(const char *warn, ...)
 	va_end(params);
 }
 
-uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
+uid_t parse_target_uid(const char *str)
 {
 	struct passwd pwd, *result;
 	char buf[1024];
@@ -91,13 +91,6 @@ uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
 	if (str == NULL)
 		return UINT_MAX;
 
-	/* UID and PID are mutually exclusive */
-	if (tid || pid) {
-		ui__warning("PID/TID switch overriding UID\n");
-		sleep(1);
-		return UINT_MAX;
-	}
-
 	getpwnam_r(str, &pwd, buf, sizeof(buf), &result);
 
 	if (result == NULL) {
@@ -120,3 +113,23 @@ uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
 
 	return result->pw_uid;
 }
+
+void perf_target__validate(struct perf_target *target)
+{
+	if (target->pid)
+		target->tid = target->pid;
+
+	/* CPU and PID are mutually exclusive */
+	if (target->tid && target->cpu_list) {
+		ui__warning("WARNING: PID switch overriding CPU\n");
+		sleep(1);
+		target->cpu_list = NULL;
+	}
+
+	/* UID and PID are mutually exclusive */
+	if (target->tid && target->uid_str) {
+		ui__warning("PID/TID switch overriding UID\n");
+		sleep(1);
+		target->uid_str = NULL;
+	}
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0f99f39..3f05d62 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -246,10 +246,12 @@ unsigned long convert_unit(unsigned long value, char *unit);
 int readn(int fd, void *buf, size_t size);
 
 struct perf_event_attr;
+struct perf_target;
 
 void event_attr_init(struct perf_event_attr *attr);
 
-uid_t parse_target_uid(const char *str, const char *tid, const char *pid);
+uid_t parse_target_uid(const char *str);
+void perf_target__validate(struct perf_target *target);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.7.9.2.358.g22243

