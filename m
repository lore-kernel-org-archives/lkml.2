Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab2EGFLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:11:33 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49169 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2EGFKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:10:32 -0400
X-AuditID: 9c930197-b7badae000000cfd-cf-4fa75943579d
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/7] perf target: Introduce perf_target_errno
Date: Mon,  7 May 2012 14:09:00 +0900
Message-Id: <1336367344-28071-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_target_errno enumerations are used to indicate
specific error cases on perf target operations. It'd
help libperf being a more generic library.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/target.c |   33 ++++++++++++++++++++++-----------
 tools/perf/util/target.h |   25 ++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3fadf85dd7e3..5c59dcfc8f8d 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -10,36 +10,47 @@
 #include "debug.h"
 
 
-void perf_target__validate(struct perf_target *target)
+enum perf_target_errno perf_target__validate(struct perf_target *target)
 {
+	enum perf_target_errno ret = PERF_ERRNO_TARGET__SUCCESS;
+
 	if (target->pid)
 		target->tid = target->pid;
 
 	/* CPU and PID are mutually exclusive */
 	if (target->tid && target->cpu_list) {
-		ui__warning("WARNING: PID switch overriding CPU\n");
-		sleep(1);
 		target->cpu_list = NULL;
+		if (ret == PERF_ERRNO_TARGET__SUCCESS)
+			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_CPU;
 	}
 
 	/* UID and PID are mutually exclusive */
 	if (target->tid && target->uid_str) {
-		ui__warning("PID/TID switch overriding UID\n");
-		sleep(1);
 		target->uid_str = NULL;
+		if (ret == PERF_ERRNO_TARGET__SUCCESS)
+			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_UID;
 	}
 
 	/* UID and CPU are mutually exclusive */
 	if (target->uid_str && target->cpu_list) {
-		ui__warning("UID switch overriding CPU\n");
-		sleep(1);
 		target->cpu_list = NULL;
+		if (ret == PERF_ERRNO_TARGET__SUCCESS)
+			ret = PERF_ERRNO_TARGET__UID_OVERRIDE_CPU;
 	}
 
-	/* PID/UID and SYSTEM are mutually exclusive */
-	if ((target->tid || target->uid_str) && target->system_wide) {
-		ui__warning("PID/TID/UID switch overriding CPU\n");
-		sleep(1);
+	/* PID and SYSTEM are mutually exclusive */
+	if (target->tid && target->system_wide) {
 		target->system_wide = false;
+		if (ret == PERF_ERRNO_TARGET__SUCCESS)
+			ret = PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM;
 	}
+
+	/* UID and SYSTEM are mutually exclusive */
+	if (target->uid_str && target->system_wide) {
+		target->system_wide = false;
+		if (ret == PERF_ERRNO_TARGET__SUCCESS)
+			ret = PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM;
+	}
+
+	return ret;
 }
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 218291f921ed..eb0d2101154a 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -13,6 +13,29 @@ struct perf_target {
 	bool	     system_wide;
 };
 
-void perf_target__validate(struct perf_target *target);
+enum perf_target_errno {
+	PERF_ERRNO_TARGET__SUCCESS		= 0,
+
+	/*
+	 * Choose an arbitrary negative big number not to clash with standard
+	 * errno since SUS requires the errno has distinct positive values.
+	 * See 'Issue 6' in the link below.
+	 *
+	 * http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
+	 */
+	__PERF_ERRNO_TARGET__START		= -10000,
+
+
+	/* for perf_target__validate() */
+	PERF_ERRNO_TARGET__PID_OVERRIDE_CPU	= __PERF_ERRNO_TARGET__START,
+	PERF_ERRNO_TARGET__PID_OVERRIDE_UID,
+	PERF_ERRNO_TARGET__UID_OVERRIDE_CPU,
+	PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM,
+	PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM,
+
+	__PERF_ERRNO_TARGET__END,
+};
+
+enum perf_target_errno perf_target__validate(struct perf_target *target);
 
 #endif /* _PERF_TARGET_H */
-- 
1.7.10.1

