Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1JXK6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:58:18 -0400
Received: from dns1.mips.com ([12.201.5.69]:57961 "EHLO dns1.mips.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1JXK6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:58:17 -0400
From: Deng-Cheng Zhu <dczhu@mips.com>
To: <linux-kernel@vger.kernel.org>
CC: Deng-Cheng Zhu <dczhu@mips.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [RFC PATCH 1/2] tools/perf: Don't set attr->disabled when doing grouping
Date: Mon, 24 Oct 2011 18:56:59 +0800
Message-ID: <1319453820-12992-2-git-send-email-dczhu@mips.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1319453820-12992-1-git-send-email-dczhu@mips.com>
References: <1319453820-12992-1-git-send-email-dczhu@mips.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EMS-Proccessed: 6LP3oGfGVdcdb8o1aBnt6w==
X-EMS-STAMP: 5RbeMdbUgyWvGDRwGKvvfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Events will be created at the state PERF_EVENT_STATE_OFF if attr->disabled
is set. When these events go to arch level validate_group(), the function
won't do anything real because they are filtered out by the state check.

Signed-off-by: Deng-Cheng Zhu <dczhu@mips.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/builtin-record.c |    6 +++---
 tools/perf/builtin-stat.c   |    3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f4c3fbe..67e8e4c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -161,7 +161,6 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
-	attr->disabled		= 1;
 	attr->inherit		= !no_inherit;
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -222,10 +221,11 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	attr->mmap		= track;
 	attr->comm		= track;
 
-	if (target_pid == -1 && target_tid == -1 && !system_wide) {
+	if (!group)
 		attr->disabled = 1;
+
+	if (target_pid == -1 && target_tid == -1 && !system_wide)
 		attr->enable_on_exec = 1;
-	}
 }
 
 static bool perf_evlist__equal(struct perf_evlist *evlist,
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5deb17d..ca95475 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -284,7 +284,8 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, group);
 
 	if (target_pid == -1 && target_tid == -1) {
-		attr->disabled = 1;
+		if (!group)
+			attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-- 
1.7.1

