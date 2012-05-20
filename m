Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab2ETCR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:17:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:47691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab2ETCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:16:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/6] perf target: Add uses_mmap field
Date: Sat, 19 May 2012 23:16:33 -0300
Message-Id: <1337480196-761-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337480196-761-1-git-send-email-acme@infradead.org>
References: <1337480196-761-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If perf doesn't mmap on event (like perf stat), it should not create
per-task-per-cpu events. So just use a dummy cpu map to create a
per-task event for this case.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337161549-9870-3-git-send-email-namhyung.kim@lge.com
[ committer note: renamed .need_mmap to .uses_mmap ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/builtin-test.c   |    1 +
 tools/perf/builtin-top.c    |    3 +++
 tools/perf/util/evlist.c    |    2 ++
 tools/perf/util/target.h    |    1 +
 5 files changed, 10 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d19058a..8a3dfac 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -754,6 +754,9 @@ static struct perf_record record = {
 		.user_freq	     = UINT_MAX,
 		.user_interval	     = ULLONG_MAX,
 		.freq		     = 1000,
+		.target		     = {
+			.uses_mmap   = true,
+		},
 	},
 	.write_mode = WRITE_FORCE,
 	.file_new   = true,
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 9d9abbb..4eaa665 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1167,6 +1167,7 @@ static int test__PERF_RECORD(void)
 	struct perf_record_opts opts = {
 		.target = {
 			.uid = UINT_MAX,
+			.uses_mmap = true,
 		},
 		.no_delay   = true,
 		.freq	    = 10,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 553560a..3e981a7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1162,6 +1162,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		.freq		     = 1000, /* 1 KHz */
 		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
+		.target		     = {
+			.uses_mmap   = true,
+		},
 	};
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const struct option options[] = {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 87889f3..4ac5f5a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -611,6 +611,8 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 
 	if (perf_target__has_task(target))
 		evlist->cpus = cpu_map__dummy_new();
+	else if (!perf_target__has_cpu(target) && !target->uses_mmap)
+		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
 
diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
index c43f632..a4be857 100644
--- a/tools/perf/util/target.h
+++ b/tools/perf/util/target.h
@@ -11,6 +11,7 @@ struct perf_target {
 	const char   *uid_str;
 	uid_t	     uid;
 	bool	     system_wide;
+	bool	     uses_mmap;
 };
 
 enum perf_target_errno {
-- 
1.7.9.2.358.g22243

