Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2DZFSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:18:10 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44699 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2DZFQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:25 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-2b-4f98da2571ca
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 09/13] perf target: Introduce perf_target_errno
Date: Thu, 26 Apr 2012 14:15:23 +0900
Message-Id: <1335417327-11796-10-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_target_errno enumerations are used to indicate
specific error cases on perf target operations. It'd
help libperf being a more generic library.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/target.c |   33 ++++++++++++++++++++++-----------
 tools/perf/util/target.h |   20 +++++++++++++++++++-
 2 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3fadf85dd7e3..04cc374b7c32 100644
--- a/tools/perf/util/target.c
+++ b/tools/perf/util/target.c
@@ -10,36 +10,47 @@
 #include "debug.h"
 
 
-void perf_target__validate(struct perf_target *target)
+enum perf_target_errno perf_target__validate(struct perf_target *target)
 {
+	enum perf_target_errno ret = PERF_TARGET__SUCCESS;
+
 	if (target->pid)
 		target->tid = target->pid;
 
 	/* CPU and PID are mutually exclusive */
 	if (target->tid && target->cpu_list) {
-		ui__warning("WARNING: PID switch overriding CPU\n");
-		sleep(1);
 		target->cpu_list = NULL;
+		if (ret == PERF_TARGET__SUCCESS)
+			ret = PERF_TARGET__PID_OVERRIDE_CPU;
 	}
 
 	/* UID and PID are mutually exclusive */
 	if (target->tid && target->uid_str) {
-		ui__warning("PID/TID switch overriding UID\n");
-		sleep(1);
 		target->uid_str = NULL;
+		if (ret == PERF_TARGET__SUCCESS)
+			ret = PERF_TARGET__PID_OVERRIDE_UID;
 	}
 
 	/* UID and CPU are mutually exclusive */
 	if (target->uid_str && target->cpu_list) {
-		ui__warning("UID switch overriding CPU\n");
-		sleep(1);
 		target->cpu_list = NULL;
+		if (ret == PERF_TARGET__SUCCESS)
+			ret = PERF_TARGET__UID_OVERRIDE_CPU;
 	}
 
-	/* PID/UID and SYSTEM are mutually exclusive */
-	if ((target->tid || target->uid_str) && target->system_wide) {
-		ui__warning("PID/TID/UID switch overriding CPU\n");
-		sleep(1);
+	/* PID and SYSTEM are mutually exclusive */
+	if (target->tid && target->system_wide) {
 		target->system_wide = false;
+		if (ret == PERF_TARGET__SUCCESS)
+			ret = PERF_TARGET__PID_OVERRIDE_SYSTEM;
 	}
+
+	/* UID and SYSTEM are mutually exclusive */
+	if (target->uid_str && target->system_wide) {
+		target->system_wide = false;
+		if (ret == PERF_TARGET__SUCCESS)
+			ret = PERF_TARGET__UID_OVERRIDE_SYSTEM;
+	}
+
+	return ret;
 }
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index 1348065ada5e..c3914c8a9890 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -12,6 +12,24 @@ struct perf_target {
 	bool	     system_wide;
 };
 
-void perf_target__validate(struct perf_target *target);
+enum perf_target_errno {
+	/*
+	 * XXX: Just choose an arbitrary big number standard errno can't have
+	 */
+	__PERF_TARGET__ERRNO_START		= 0x10000,
+
+	PERF_TARGET__SUCCESS			= __PERF_TARGET__ERRNO_START,
+
+	/* for perf_target__validate() */
+	PERF_TARGET__PID_OVERRIDE_CPU,
+	PERF_TARGET__PID_OVERRIDE_UID,
+	PERF_TARGET__UID_OVERRIDE_CPU,
+	PERF_TARGET__PID_OVERRIDE_SYSTEM,
+	PERF_TARGET__UID_OVERRIDE_SYSTEM,
+
+	__PERF_TARGET__ERRNO_END
+};
+
+enum perf_target_errno perf_target__validate(struct perf_target *target);
 
 #endif /* _PERF_TARGET_H */
-- 
1.7.10

