Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1I2Ws0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:48:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:43966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1I2WsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:48:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/16] perf tools: Make stat/record print fatal signals of the target program
Date: Thu, 29 Sep 2011 19:48:06 -0300
Message-Id: <1317336490-19437-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336490-19437-1-git-send-email-acme@infradead.org>
References: <1317336490-19437-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When a program crashes under perf there is no message about it, unlike
when running it from bash. This can be confusing and lead to wrong
actions during debugging.

Print fatal signals in perf stat/record.

Thanks to Furat Afram for finding the problem originally

Link: http://lkml.kernel.org/r/1316122302-24306-1-git-send-email-andi@firstfloor.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index b567319..7ce65f5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -495,6 +495,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 	if (forks) {
 		close(go_pipe[1]);
 		wait(&status);
+		if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), argv[0]);
 	} else {
 		while(!done) sleep(1);
 	}
-- 
1.6.2.5

