Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585Ab2EKGoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:44:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761508Ab2EKGoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:44:21 -0400
Date: Thu, 10 May 2012 23:43:48 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-77a6f014e9ae330c747c66bebfddf29abf9b89e9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1336367344-28071-8-git-send-email-namhyung.kim@lge.com>
References: <1336367344-28071-8-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Use perf_evlist__create_maps
Git-Commit-ID: 77a6f014e9ae330c747c66bebfddf29abf9b89e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 23:43:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77a6f014e9ae330c747c66bebfddf29abf9b89e9
Gitweb:     http://git.kernel.org/tip/77a6f014e9ae330c747c66bebfddf29abf9b89e9
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 7 May 2012 14:09:04 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 17:52:22 -0300

perf stat: Use perf_evlist__create_maps

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
 1 files changed, 8 insertions(+), 14 deletions(-)

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
