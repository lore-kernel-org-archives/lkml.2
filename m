Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2EJRSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:18:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55878 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab2EJRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/16] perf stat: Use perf_evlist__create_maps
Date: Thu, 10 May 2012 14:17:37 -0300
Message-Id: <1336670265-20401-9-git-send-email-acme@infradead.org>
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

Use same function with perf record and top to share the code checks
combinations of different switches.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1336367344-28071-8-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d9ff246..e720ba7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -175,7 +175,9 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
 
 static struct perf_evlist	*evsel_list;
 
-static struct perf_target	target;
+static struct perf_target	target = {
+	.uid	= UINT_MAX,
+};
 
 static int			run_idx				=  0;
 static int			run_count			=  1;
@@ -1205,20 +1207,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	perf_target__validate(&target);
 
-	evsel_list->threads = thread_map__new_str(target.pid,
-						  target.tid, UINT_MAX);
-	if (evsel_list->threads == NULL) {
-		pr_err("Problems finding threads of monitor\n");
-		usage_with_options(stat_usage, options);
-	}
-
-	if (target.system_wide)
-		evsel_list->cpus = cpu_map__new(target.cpu_list);
-	else
-		evsel_list->cpus = cpu_map__dummy_new();
+	if (perf_evlist__create_maps(evsel_list, &target) < 0) {
+		if (!perf_target__no_task(&target))
+			pr_err("Problems finding threads of monitor\n");
+		if (!perf_target__no_cpu(&target))
+			perror("failed to parse CPUs map");
 
-	if (evsel_list->cpus == NULL) {
-		perror("failed to parse CPUs map");
 		usage_with_options(stat_usage, options);
 		return -1;
 	}
-- 
1.7.9.2.358.g22243

