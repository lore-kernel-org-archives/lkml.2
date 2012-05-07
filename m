Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2EGFLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:11:36 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64230 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab2EGFKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:10:31 -0400
X-AuditID: 9c930197-b7badae000000cfd-c4-4fa75943134d
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/7] perf evlist: Fix creation of cpu map
Date: Mon,  7 May 2012 14:08:59 +0900
Message-Id: <1336367344-28071-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com>
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
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/evlist.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 30328623cae6..183b199b0d09 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,8 +609,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
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
1.7.10.1

