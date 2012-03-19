Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162322Ab2CSUBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:01:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162300Ab2CSUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:01:16 -0400
Date: Mon, 19 Mar 2012 13:00:49 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-4c19ea453d81cf8bd9bd446e6b129998f79997e7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1331887340-32448-1-git-send-email-namhyung.kim@lge.com>
References: <1331887340-32448-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Fix event grouping on forked task
Git-Commit-ID: 4c19ea453d81cf8bd9bd446e6b129998f79997e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:00:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c19ea453d81cf8bd9bd446e6b129998f79997e7
Gitweb:     http://git.kernel.org/tip/4c19ea453d81cf8bd9bd446e6b129998f79997e7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 16 Mar 2012 17:42:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Mar 2012 16:13:45 -0300

perf stat: Fix event grouping on forked task

When event group is enabled for forked task (i.e. no target task was
specified) all events were disabled and marked ->enable_on_exec.
However they are not counted at all since only group leader will be
enabled on exec actually. So the result looked like below:

 $ ./perf stat --group -- sleep 1

 Performance counter stats for 'sleep 1':

          0.554926 task-clock                #    0.001 CPUs utilized
     <not counted> context-switches
     <not counted> CPU-migrations
     <not counted> page-faults
     <not counted> cycles
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
     <not counted> instructions
     <not counted> branches
     <not counted> branch-misses

       1.001228093 seconds time elapsed

Fix it by disabling group leader only.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887340-32448-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ea40e4e..c941bb6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -296,7 +296,7 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	if (system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
 						group, group_fd);
-	if (!target_pid && !target_tid) {
+	if (!target_pid && !target_tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
