Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010Ab2EKGlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:41:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57260 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2EKGlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:41:01 -0400
Date: Thu, 10 May 2012 23:40:28 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-60bbddaaa33865633efa2800702e3b02495a0e94@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1336367344-28071-4-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-4-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target: Introduce perf_target_errno
Git-Commit-ID: 60bbddaaa33865633efa2800702e3b02495a0e94
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:40:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60bbddaaa33865633efa2800702e3b02495a0e94
Gitweb:     http://git.kernel.org/tip/60bbddaaa33865633efa2800702e3b02495a0e94
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 7 May 2012 14:09:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 16:46:35 -0300

perf target: Introduce perf_target_errno

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
