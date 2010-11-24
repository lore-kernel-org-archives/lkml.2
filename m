Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab0KXWYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:24:50 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38066 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0KXWYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:24:49 -0500
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: [PATCH] perf tools: fix regression in "perf stat" when no events are given on the command line
Date: Wed, 24 Nov 2010 14:19:38 -0800
Message-Id: <1290637178-389-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My recent patch changed the behavior "perf stat" so that it does not
run the load program if any of the given events cannot be opened.

Unfortunately, this broke the behavior of the "perf stat <load program>"
use case where no events are provided.  In this case, perf stat opens a set
of default events, and if it encounters errors when opening one or more
events, perf stat exits with an error.  It shouldn't do this because not
all of the default hardware events are implemented for all architectures.

What is desireable in this case is for perf stat to tolerate errors when
opening the default events.  This patch accomplishes that.

Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 tools/perf/builtin-stat.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 970a7f2..8b5edd9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -83,6 +83,7 @@ static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
 static bool			big_num				=  false;
+static bool			tolerate_open_errors		=  false;
 static const char		*cpu_list;
 
 
@@ -174,8 +175,10 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 			if (fd[cpu][counter][0] < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
-				error(ERR_PERF_OPEN, counter,
-					 fd[cpu][counter][0], strerror(errno));
+				if (!tolerate_open_errors)
+					error(ERR_PERF_OPEN, counter,
+					      fd[cpu][counter][0],
+					      strerror(errno));
 			} else {
 				++ncreated;
 			}
@@ -192,9 +195,10 @@ static int create_perf_stat_counter(int counter, bool *perm_err)
 			if (fd[0][counter][thread] < 0) {
 				if (errno == EPERM || errno == EACCES)
 					*perm_err = true;
-				error(ERR_PERF_OPEN, counter,
-					 fd[0][counter][thread],
-					 strerror(errno));
+				if (!tolerate_open_errors)
+					error(ERR_PERF_OPEN, counter,
+					      fd[0][counter][thread],
+					      strerror(errno));
 			} else {
 				++ncreated;
 			}
@@ -405,10 +409,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 			      "\t Consider tweaking"
 			      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 			      system_wide ? "system-wide " : "");
-		die("Not all events could be opened.\n");
-		if (child_pid != -1)
-			kill(child_pid, SIGTERM);
-		return -1;
+		if (!tolerate_open_errors) {
+			die("Not all events could be opened.\n");
+			if (child_pid != -1)
+				kill(child_pid, SIGTERM);
+			return -1;
+		}
 	}
 
 	/*
@@ -693,6 +699,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 
 	/* Set attrs and nr_counters if no event is selected and !null_run */
 	if (!null_run && !nr_counters) {
+		tolerate_open_errors = true;
 		memcpy(attrs, default_attrs, sizeof(default_attrs));
 		nr_counters = ARRAY_SIZE(default_attrs);
 	}
-- 
1.7.0.4

