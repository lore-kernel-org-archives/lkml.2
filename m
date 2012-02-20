Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2BTB3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:29:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58391 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2BTB3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:29:33 -0500
X-AuditID: 9c93016f-b7c04ae000000eac-3c-4f41a1faa687
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH RESEND 2/2] perf tools: Add error message for EMFILE
Date: Mon, 20 Feb 2012 10:47:27 +0900
Message-Id: <1329702447-25045-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
References: <1329702447-25045-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a user tries to open so many event on multiple tasks/cpus,
perf_event_open syscall may fail with EMFILE. Provide an advice
for that case.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c |    5 +++++
 tools/perf/builtin-stat.c   |    4 ++++
 tools/perf/builtin-top.c    |    3 ++-
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 75d230fef202..b1112084a0ae 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -260,6 +260,11 @@ try_again:
 				ui__warning("The %s event is not supported.\n",
 					    event_name(pos));
 				exit(EXIT_FAILURE);
+			} else if (err == EMFILE) {
+				ui__warning("Too many events are opened.\n"
+					    "Try again after reducing the number of events,\n"
+					    "tasks and/or cpus.\n");
+				exit(EXIT_FAILURE);
 			}
 
 			printf("\n");
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ea40e4e8b227..e54cbc9fc4fd 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -477,6 +477,10 @@ static int run_perf_stat(int argc __used, const char **argv)
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
+			} else if (errno == EMFILE) {
+				error("Too many events are opened.\n"
+				      "\t Try again after reducing the number of events,\n"
+				      "\t tasks and/or cpus.");
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63aef8efc..d0d05943fade 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -923,7 +923,8 @@ try_again:
 				goto out_err;
 			} else if (err == EMFILE) {
 				ui__warning("Too many events are opened.\n"
-					    "Try again after reducing the number of events\n");
+					    "Try again after reducing the number of events,\n"
+					    "tasks and/or cpus.\n");
 				goto out_err;
 			}
 
-- 
1.7.9

