Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966770Ab2EPJry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:47:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51193 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2EPJro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:47:44 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-50-4fb377bcbb3c
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf target: Add need_mmap field
Date: Wed, 16 May 2012 18:45:49 +0900
Message-Id: <1337161549-9870-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If perf doesn't mmap on event (like perf stat), it
should not create per-task-per-cpu events. So just
use a dummy cpu map to create a per-task event for
this case.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/builtin-test.c   |    1 +
 tools/perf/builtin-top.c    |    3 +++
 tools/perf/util/evlist.c    |    2 ++
 tools/perf/util/target.h    |    1 +
 5 files changed, 10 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d19058a7b84c..185e59a4715d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -754,6 +754,9 @@ static struct perf_record record = {
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
 		.freq		     = 1000,
+		.target		     = {
+			.need_mmap   = true,
+		},
 	},
 	.write_mode = WRITE_FORCE,
 	.file_new   = true,
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 9d9abbbe23be..cd326f2b5488 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1167,6 +1167,7 @@ static int test__PERF_RECORD(void)
 	struct perf_record_opts opts = {
 		.target = {
 			.uid = UINT_MAX,
+			.need_mmap = true,
 		},
 		.no_delay   = true,
 		.freq	    = 10,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 553560a8b1be..ebcd15883ab8 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1162,6 +1162,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		.freq		     = 1000, /* 1 KHz */
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
+		.target		     = {
+			.need_mmap   = true,
+		},
 	};
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const struct option options[] = {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 87889f325678..ba43c3a4046c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -611,6 +611,8 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 
 	if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
+	else if (!perf_target__has_cpu(target) && !target->need_mmap)
+		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
 
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index c43f632955fa..ffa247d3ede3 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -11,6 +11,7 @@ struct perf_target {
 	const char   *uid_str;
 	uid_t	     uid;
 	bool	     system_wide;
+	bool	     need_mmap;
 };
 
 enum perf_target_errno {
-- 
1.7.10.1

