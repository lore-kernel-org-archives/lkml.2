Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2BMHMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:12:19 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43543 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab2BMHLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:35 -0500
X-AuditID: 9c930197-b7cdbae000001518-7b-4f38b7a2c315
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/11] perf tools: Fix creation of cpu map
Date: Mon, 13 Feb 2012 16:27:39 +0900
Message-Id: <1329118064-9412-8-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, 'perf record -- sleep 1' creates a cpu map for all online
cpus since it turns out calling cpu_map__new(NULL). Fix it. Also it
is guaranteed that cpu_list is NULL if PID/TID is given by calling
check_target_maps(), so we can make the conditional bit simpler.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/evlist.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3d763c95fd62..b444f311897c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -602,8 +602,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (maps->uid != UINT_MAX ||
-	    (maps->cpu_list == NULL && maps->target_tid != -1))
+	if (maps->uid != UINT_MAX || maps->target_tid != -1)
+		evlist->cpus = cpu_map__dummy_new();
+	else if (!maps->system_wide && maps->cpu_list == NULL)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(maps->cpu_list);
-- 
1.7.9

