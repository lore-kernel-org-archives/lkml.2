Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab2EKGax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:30:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57064 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab2EKGav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:30:51 -0400
Date: Thu, 10 May 2012 23:30:27 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4bd0f2d2c0cf14de9c84c2fe689120c6b0f667c8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1335417327-11796-5-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-5-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce perf_target__validate()
  helper
Git-Commit-ID: 4bd0f2d2c0cf14de9c84c2fe689120c6b0f667c8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:30:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bd0f2d2c0cf14de9c84c2fe689120c6b0f667c8
Gitweb:     http://git.kernel.org/tip/4bd0f2d2c0cf14de9c84c2fe689120c6b0f667c8
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 26 Apr 2012 14:15:18 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 2 May 2012 15:22:08 -0300

perf tools: Introduce perf_target__validate() helper

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
