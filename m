Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2DZFQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 01:16:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54562 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2DZFQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 01:16:24 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-27-4f98da24f95a
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/13] perf evlist: Fix creation of cpu map
Date: Thu, 26 Apr 2012 14:15:21 +0900
Message-Id: <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, 'perf record -- sleep 1' creates a cpu map for all online
cpus since it turns out calling cpu_map__new(NULL). Fix it. Also it
is guaranteed that cpu_list is NULL if PID/TID is given by calling
perf_target__validate(), so we can make the conditional bit simpler.

This also fixes perf test 7 (Validate) failure on my 6 core machine:

  $ cat /sys/devices/system/cpu/online 
  0-11
  $ ./perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields:
  --- start ---
  perf_evlist__mmap: Operation not permitted
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/evlist.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a43e2c56d1c6..556d98af1a0b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -608,8 +608,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->uid != UINT_MAX ||
-	    (target->cpu_list == NULL && target->tid))
+	if (target->uid != UINT_MAX || target->tid)
+		evlist->cpus = cpu_map__dummy_new();
+	else if (!target->system_wide && target->cpu_list == NULL)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
-- 
1.7.10

