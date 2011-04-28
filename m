Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1D1G4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:56:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55654 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1D1G4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:56:04 -0400
Date: Thu, 28 Apr 2011 06:55:24 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n1eqio7hjpn1dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Add --sync/-S option
Git-Commit-ID: f9cef0a90c4e7637f1ec98474a1a099aec45eb65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Apr 2011 06:55:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9cef0a90c4e7637f1ec98474a1a099aec45eb65
Gitweb:     http://git.kernel.org/tip/f9cef0a90c4e7637f1ec98474a1a099aec45eb65
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 28 Apr 2011 18:17:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 Apr 2011 08:39:39 +0200

perf stat: Add --sync/-S option

--sync will tell perf stat to run sync() before starting a command.

This allows IO-heavy tests to be used with --repeat, without one
iteration impacting the other.

Elapsed time will stabilize for example:

  before:        3.971525714  seconds time elapsed  ( +-  8.56% )
  after:         3.211098537  seconds time elapsed  ( +-  1.52% )

So measurements will be more accurate.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n1eqio7hjpn1dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 003caa8..5658a77 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -128,6 +128,7 @@ static pid_t			target_tid			= -1;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			detailed_run			=  false;
+static bool			sync_run			=  false;
 static bool			big_num				=  true;
 static int			big_num_opt			=  -1;
 static const char		*cpu_list;
@@ -819,6 +820,8 @@ static const struct option options[] = {
 		    "null run - dont start any counters"),
 	OPT_BOOLEAN('d', "detailed", &detailed_run,
 		    "detailed run - start a lot of events"),
+	OPT_BOOLEAN('S', "sync", &sync_run,
+		    "call sync() before starting a run"),
 	OPT_CALLBACK_NOOPT('B', "big-num", NULL, NULL, 
 			   "print large numbers with thousands\' separators",
 			   stat__set_big_num),
@@ -944,6 +947,10 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
 			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
+
+		if (sync_run)
+			sync();
+
 		status = run_perf_stat(argc, argv);
 	}
 
