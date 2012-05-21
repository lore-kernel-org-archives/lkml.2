Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2EUHj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:39:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab2EUHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:39:26 -0400
Date: Mon, 21 May 2012 00:39:09 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-d1cb9fce92c41454bd594fb0920575fc63301878@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1337161549-9870-3-git-send-email-namhyung.kim@lge.com>
References: <1337161549-9870-3-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf target: Add uses_mmap field
Git-Commit-ID: d1cb9fce92c41454bd594fb0920575fc63301878
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 00:39:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1cb9fce92c41454bd594fb0920575fc63301878
Gitweb:     http://git.kernel.org/tip/d1cb9fce92c41454bd594fb0920575fc63301878
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 16 May 2012 18:45:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 May 2012 12:32:54 -0300

perf target: Add uses_mmap field

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
 5 files changed, 10 insertions(+), 0 deletions(-)

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
