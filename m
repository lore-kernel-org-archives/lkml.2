Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2DZFRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:17:38 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50162 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2DZFQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:26 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-32-4f98da26dec5
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 11/13] perf tools: Introduce perf_target__strerror()
Date: Thu, 26 Apr 2012 14:15:25 +0900
Message-Id: <1335417327-11796-12-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_target__strerror() sets @buf to a string that
describes the (perf_target-specific) error condition
that is passed via @errnum.

This is similar to strerror_r() and does same thing if
@errnum has a standard errno value.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |   18 ++++++++++++++--
 tools/perf/builtin-top.c    |   19 ++++++++++++++---
 tools/perf/util/debug.c     |    1 +
 tools/perf/util/target.c    |   49 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/target.h    |    3 +++
 5 files changed, 85 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e5d77452eef6..8caa84034a51 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -831,6 +831,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	struct perf_evsel *pos;
 	struct perf_evlist *evsel_list;
 	struct perf_record *rec = &record;
+	char errbuf[BUFSIZ];
 
 	perf_header__set_cmdline(argc, argv);
 
@@ -884,11 +885,24 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	perf_target__validate(&rec->opts.target);
+	err = perf_target__validate(&rec->opts.target);
+	if (err != PERF_TARGET__SUCCESS) {
+		perf_target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
+		ui__warning("%s", errbuf);
+	}
+
+	err = perf_target__parse_uid(&rec->opts.target);
+	if (err != PERF_TARGET__SUCCESS) {
+		int saved_errno = errno;
 
-	if (perf_target__parse_uid(&rec->opts.target) != PERF_TARGET__SUCCESS)
+		perf_target__strerror(&rec->opts.target, err, errbuf, BUFSIZ);
+		ui__warning("%s", errbuf);
+
+		err = -saved_errno;
 		goto out_free_fd;
+	}
 
+	err = -ENOMEM;
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 80fccc7bd1e0..6f584179ecc1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1150,7 +1150,8 @@ static const char * const top_usage[] = {
 int cmd_top(int argc, const char **argv, const char *prefix __used)
 {
 	struct perf_evsel *pos;
-	int status = -ENOMEM;
+	int status;
+	char errbuf[BUFSIZ];
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
@@ -1252,10 +1253,22 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	setup_browser(false);
 
-	perf_target__validate(&top.target);
+	status = perf_target__validate(&top.target);
+	if (status != PERF_TARGET__SUCCESS) {
+		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
+		ui__warning("%s", errbuf);
+	}
+
+	status = perf_target__parse_uid(&top.target);
+	if (status != PERF_TARGET__SUCCESS) {
+		int saved_errno = errno;
 
-	if (perf_target__parse_uid(&top.target) != PERF_TARGET__SUCCESS)
+		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
+		ui__warning("%s", errbuf);
+
+		status = -saved_errno;
 		goto out_delete_evlist;
+	}
 
 	if (perf_evlist__create_maps(top.evlist, &top.target) < 0)
 		usage_with_options(top_usage, options);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 26817daa2961..efb1fce259a4 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -11,6 +11,7 @@
 #include "event.h"
 #include "debug.h"
 #include "util.h"
+#include "target.h"
 
 int verbose;
 bool dump_trace = false, quiet = false;
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 140adfdfd520..196a24390bcf 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -89,3 +89,52 @@ enum perf_target_errno perf_target__parse_uid(struct perf_target *target)
 	target->uid = result->pw_uid;
 	return PERF_TARGET__SUCCESS;
 }
+
+/*
+ * This must have a same ordering as the enum perf_target_errno.
+ */
+static const char *perf_target__error_str[] = {
+	"Success",
+	"PID/TID switch overriding CPU",
+	"PID/TID switch overriding UID",
+	"UID switch overriding CPU",
+	"PID/TID switch overriding SYSTEM",
+	"UID switch overriding SYSTEM",
+	"Invalid User: %s",
+	"Problems obtaining information for user %s",
+};
+
+int perf_target__strerror(struct perf_target *target, int errnum,
+			  char *buf, size_t buflen)
+{
+	const char *msg;
+
+	if (errnum <  __PERF_TARGET__ERRNO_START) {
+		strerror_r(errnum, buf, buflen);
+		return 0;
+	}
+
+	if (errnum >= __PERF_TARGET__ERRNO_END)
+		return -1;
+
+	errnum -= __PERF_TARGET__ERRNO_START;
+	msg = perf_target__error_str[errnum];
+
+	switch (errnum) {
+	case PERF_TARGET__SUCCESS:
+	case PERF_TARGET__PID_OVERRIDE_CPU ... PERF_TARGET__UID_OVERRIDE_SYSTEM:
+		snprintf(buf, buflen, "%s", msg);
+		break;
+
+	case PERF_TARGET__INVALID_UID:
+	case PERF_TARGET__USER_NOT_FOUND:
+		snprintf(buf, buflen, msg, target->uid_str);
+		break;
+
+	default:
+		/* cannot reach here */
+		break;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index ec35fc043260..fff28c18f401 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -37,4 +37,7 @@ enum perf_target_errno {
 enum perf_target_errno perf_target__validate(struct perf_target *target);
 enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
 
+int perf_target__strerror(struct perf_target *target, int errnum, char *buf,
+			  size_t buflen);
+
 #endif /* _PERF_TARGET_H */
-- 
1.7.10

