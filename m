Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2EJRVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:21:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55864 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2EJRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/16] perf target: Introduce perf_target_errno
Date: Thu, 10 May 2012 14:17:33 -0300
Message-Id: <1336670265-20401-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The perf_target_errno enumerations are used to indicate specific error
cases on perf target operations. It'd help libperf being a more generic
library.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1336367344-28071-4-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/target.c |   33 ++++++++++++++++++++++-----------
 tools/perf/util/target.h |   25 ++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/target.c b/tools/perf/util/target.c
index 3fadf85..5c59dcf 100644
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
index 218291f..eb0d210 100644
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
1.7.9.2.358.g22243

