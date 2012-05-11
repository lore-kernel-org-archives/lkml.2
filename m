Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab2EKGlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:41:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2EKGlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:41:40 -0400
Date: Thu, 10 May 2012 23:41:18 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-dfe78adaaca90417ece98edbd3eb1c9661334406@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1336367344-28071-5-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-5-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target: Introduce perf_target__parse_uid()
Git-Commit-ID: dfe78adaaca90417ece98edbd3eb1c9661334406
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:41:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfe78adaaca90417ece98edbd3eb1c9661334406
Gitweb:     http://git.kernel.org/tip/dfe78adaaca90417ece98edbd3eb1c9661334406
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 7 May 2012 14:09:01 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 16:46:48 -0300

perf target: Introduce perf_target__parse_uid()

Add and use the modern perf_target__parse_uid() and get rid of the old
parse_target_uid().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1336367344-28071-5-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    4 +---
 tools/perf/builtin-top.c    |    3 +--
 tools/perf/util/target.c    |   35 +++++++++++++++++++++++++++++++++++
 tools/perf/util/target.h    |    5 +++++
 tools/perf/util/usage.c     |   31 -------------------------------
 tools/perf/util/util.h      |    3 ---
 6 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d165909..d26a279 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -886,9 +886,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 
 	perf_target__validate(&rec->opts.target);
 
-	rec->opts.target.uid = parse_target_uid(rec->opts.target.uid_str);
-	if (rec->opts.target.uid_str != NULL &&
-	    rec->opts.target.uid == UINT_MAX - 1)
+	if (perf_target__parse_uid(&rec->opts.target) < 0)
 		goto out_free_fd;
 
 	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e40f86e..c9137ba 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1254,8 +1254,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 
 	perf_target__validate(&top.target);
 
-	top.target.uid = parse_target_uid(top.target.uid_str);
-	if (top.target.uid_str != NULL && top.target.uid == UINT_MAX - 1)
+	if (perf_target__parse_uid(&top.target) < 0)
 		goto out_delete_evlist;
 
 	if (top.target.tid == 0 && top.target.pid == 0 &&
diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 5c59dcf..02a6bed 100644
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
+		return PERF_ERRNO_TARGET__SUCCESS;
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
+			return PERF_ERRNO_TARGET__INVALID_UID;
+
+		getpwuid_r(uid, &pwd, buf, sizeof(buf), &result);
+
+		if (result == NULL)
+			return PERF_ERRNO_TARGET__USER_NOT_FOUND;
+	}
+
+	target->uid = result->pw_uid;
+	return PERF_ERRNO_TARGET__SUCCESS;
+}
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index eb0d210..d4aabda 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -33,9 +33,14 @@ enum perf_target_errno {
 	PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM,
 	PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM,
 
+	/* for perf_target__parse_uid() */
+	PERF_ERRNO_TARGET__INVALID_UID,
+	PERF_ERRNO_TARGET__USER_NOT_FOUND,
+
 	__PERF_ERRNO_TARGET__END,
 };
 
 enum perf_target_errno perf_target__validate(struct perf_target *target);
+enum perf_target_errno perf_target__parse_uid(struct perf_target *target);
 
 #endif /* _PERF_TARGET_H */
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index e851abc..4007aca 100644
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
index 52be74c..27a11a7 100644
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
 
