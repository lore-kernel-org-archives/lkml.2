Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2DZFQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:16:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44699 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2DZFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:24 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-25-4f98da24ca85
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 06/13] perf tools: Check more combinations of PID/TID, UID and CPU switches
Date: Thu, 26 Apr 2012 14:15:20 +0900
Message-Id: <1335417327-11796-7-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some combinations of these switches that are not so
appropriate IMHO. Since there are implicit priorities between
them and they worked well anyway, but it ends up opening useless
duplicated events. For example, 'perf stat -t <pid> -a' will
open multiple events for the thread instead of one.

Add explicit checks and warn user in perf_target__validate().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/usage.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index 0a1a885a5914..228f0a558872 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -132,4 +132,18 @@ void perf_target__validate(struct perf_target *target)
 		sleep(1);
 		target->uid_str = NULL;
 	}
+
+	/* UID and CPU are mutually exclusive */
+	if (target->uid_str && target->cpu_list) {
+		ui__warning("UID switch overriding CPU\n");
+		sleep(1);
+		target->cpu_list = NULL;
+	}
+
+	/* PID/UID and SYSTEM are mutually exclusive */
+	if ((target->tid || target->uid_str) && target->system_wide) {
+		ui__warning("PID/TID/UID switch overriding CPU\n");
+		sleep(1);
+		target->system_wide = false;
+	}
 }
-- 
1.7.10

