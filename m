Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2BMHMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:12:17 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54445 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2BMHLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:34 -0500
X-AuditID: 9c930197-b7cdbae000001518-75-4f38b7a2f18a
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] perf tools: Check more combinations of PID/TID, UID and CPU switches
Date: Mon, 13 Feb 2012 16:27:38 +0900
Message-Id: <1329118064-9412-7-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some combinations of these switches that are not so
appropriate IMHO. Since there are implicit priorities between
them, they worked well anyway, but end up opening useless
duplicated events. For example, 'perf stat -t <pid> -a' will
open multiple events for the thread instead of one.

Add explicit checks and warn user in check_target_maps().

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/usage.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index d235013600e5..08423c037a7e 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -133,4 +133,17 @@ void check_target_maps(struct perf_maps_opts *maps)
 		maps->uid_str = NULL;
 	}
 
+	/* UID and CPU are mutually exclusive */
+	if (maps->uid_str && maps->cpu_list) {
+		ui__warning("UID switch overriding CPU\n");
+		sleep(1);
+		maps->cpu_list = NULL;
+	}
+
+	/* PID/UID and SYSTEM are mutually exclusive */
+	if ((maps->target_tid > 0 || maps->uid_str) && maps->system_wide) {
+		ui__warning("PID/TID/UID switch overriding CPU\n");
+		sleep(1);
+		maps->system_wide = false;
+	}
 }
-- 
1.7.9

