Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2DZFRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:17:54 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54562 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2DZFQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:25 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-2f-4f98da251f4f
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/13] perf target: Introduce perf_target__parse_uid()
Date: Thu, 26 Apr 2012 14:15:24 +0900
Message-Id: <1335417327-11796-11-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use the modern perf_target__parse_uid() and get rid of
the old parse_target_uid().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-top.c    |    3 +--
 tools/perf/util/target.c    |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/target.h    |    5 +++++
 tools/perf/util/usage.c     |   31 -------------------------------
 tools/perf/util/util.h      |    3 ---
 6 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d16590942cec..e5d77452eef6 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -886,9 +886,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	perf_target__validate(&rec->opts.target);
 
-	rec->opts.target.uid = parse_target_uid(rec->opts.target.uid_str);
-	if (rec->opts.target.uid_str != NULL &&
-	    rec->opts.target.uid == UINT_MAX - 1)
+	if (perf_target__parse_uid(&rec->opts.target) != PERF_TARGET__SUCCESS)
 		goto out_free_fd;
 
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2a0ec09b9b77..80fccc7bd1e0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1254,8 +1254,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	perf_target__validate(&top.target);
 
-	top.target.uid = parse_target_uid(top.target.uid_str);
-	if (top.target.uid_str != NULL && top.target.uid == UINT_MAX - 1)
+	if (perf_target__parse_uid(&top.target) != PERF_TARGET__SUCCESS)
 		goto out_delete_evlist;
 
 	if (perf_evlist__create_maps(top.evlist, &top.target) < 0)
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 04cc374b7c32..140adfdfd520 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -9,6 +9,8 @@
 #include "target.h"
 #include "debug.h"
 
+#include <pwd.h>
+
 
 enum perf_target_errno perf_target__validate(struct perf_target *target)
 {
@@ -54,3 +56,36 @@ enum perf_target_errno perf_target__validate(struct perf_target *target)
 
 	return ret;
 }
+
+enum perf_target_errno perf_target__parse_uid(struct perf_target *target)
+{
+	struct passwd pwd, *result;
+	char buf[1024];
+	const char *str = target->uid_str;
+
+	target->uid = UINT_MAX;
+	if (str == NULL)
+		return PERF_TARGET__SUCCESS;
+
+	/* Try user name first */
+	getpwnam_r(str, &pwd, buf, sizeof(buf), &result);
+
+	if (result == NULL) {
+		/*
+		 * The user name not found. Maybe it's a UID number.
+		 */
+		char *endptr;
+		int uid = strtol(str, &endptr, 10);
+
+		if (*endptr != '\0')
+			return PERF_TARGET__INVALID_UID;
+
+		getpwuid_r(uid, &pwd, buf, sizeof(buf), &result);
+
+		if (result == NULL)
+			return PERF_TARGET__USER_NOT_FOUND;
+	}
+
+	target->uid = result->pw_uid;
+	return PERF_TARGET__SUCCESS;
+}
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index c3914c8a9890..ec35fc043260 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -27,9 +27,14 @@ enum perf_target_errno {
 	PERF_TARGET__PID_OVERRIDE_SYSTEM,
 	PERF_TARGET__UID_OVERRIDE_SYSTEM,
 
+	/* for perf_target__parse_uid() */
+	PERF_TARGET__INVALID_UID,
+	PERF_TARGET__USER_NOT_FOUND,
+
 	__PERF_TARGET__ERRNO_END
 };
 
 enum perf_target_errno perf_target__validate(struct perf_target *target);
+enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
 
 #endif /* _PERF_TARGET_H */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index e851abc22ccc..4007aca8e0ca 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -82,34 +82,3 @@ void warning(const char *warn, ...)
 	warn_routine(warn, params);
 	va_end(params);
 }
-
-uid_t parse_target_uid(const char *str)
-{
-	struct passwd pwd, *result;
-	char buf[1024];
-
-	if (str == NULL)
-		return UINT_MAX;
-
-	getpwnam_r(str, &pwd, buf, sizeof(buf), &result);
-
-	if (result == NULL) {
-		char *endptr;
-		int uid = strtol(str, &endptr, 10);
-
-		if (*endptr != '\0') {
-			ui__error("Invalid user %s\n", str);
-			return UINT_MAX - 1;
-		}
-
-		getpwuid_r(uid, &pwd, buf, sizeof(buf), &result);
-
-		if (result == NULL) {
-			ui__error("Problems obtaining information for user %s\n",
-				  str);
-			return UINT_MAX - 1;
-		}
-	}
-
-	return result->pw_uid;
-}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 52be74c359d3..27a11a78ad39 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -74,7 +74,6 @@
 #include <netinet/tcp.h>
 #include <arpa/inet.h>
 #include <netdb.h>
-#include <pwd.h>
 #include <inttypes.h>
 #include "../../../include/linux/magic.h"
 #include "types.h"
@@ -249,8 +248,6 @@ struct perf_event_attr;
 
 void event_attr_init(struct perf_event_attr *attr);
 
-uid_t parse_target_uid(const char *str);
-
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
-- 
1.7.10

