Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935074Ab1IOVbz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:31:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:15544 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934998Ab1IOVby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,389,1312182000"; 
   d="scan'208";a="51994014"
From: Andi Kleen <andi@firstfloor.org>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] perf: Make perf stat/record print fatal signals of the target program
Date: Thu, 15 Sep 2011 14:31:40 -0700
Message-Id: <1316122302-24306-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When a program crashes under perf there is no message about it,
unlike when running it from bash. This can be confusing and lead
to wrong actions during debugging.

Print fatal signals in perf stat/record.

Thanks to Furat Afram for finding the problem originally

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-record.c |   19 +++++++++++++++++--
 tools/perf/builtin-stat.c   |    2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6b0519f..042117f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -73,6 +73,7 @@ static off_t			post_processing_offset;
 
 static struct perf_session	*session;
 static const char		*cpu_list;
+static const char               *progname;
 
 static void advance_output(size_t size)
 {
@@ -137,17 +138,29 @@ static void mmap_read(struct perf_mmap *md)
 
 static volatile int done = 0;
 static volatile int signr = -1;
+static volatile int child_finished = 0;
 
 static void sig_handler(int sig)
 {
+	if (sig == SIGCHLD)
+		child_finished = 1;
+
 	done = 1;
 	signr = sig;
 }
 
 static void sig_atexit(void)
 {
-	if (child_pid > 0)
-		kill(child_pid, SIGTERM);
+	int status;
+
+	if (child_pid > 0) {
+		if (!child_finished)
+			kill(child_pid, SIGTERM);
+
+		wait(&status);
+		if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), progname);
+	}
 
 	if (signr == -1 || signr == SIGUSR1)
 		return;
@@ -445,6 +458,8 @@ static int __cmd_record(int argc, const char **argv)
 	char buf;
 	struct machine *machine;
 
+	progname = argv[0];
+
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	atexit(sig_atexit);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5deb17d..69becc3 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -487,6 +487,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 	if (forks) {
 		close(go_pipe[1]);
 		wait(&status);
+		if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), argv[0]);
 	} else {
 		while(!done) sleep(1);
 	}
-- 
1.7.4.4

