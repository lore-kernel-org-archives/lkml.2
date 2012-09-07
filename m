Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab2IGF51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:57:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab2IGF5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:57:25 -0400
Date: Thu, 6 Sep 2012 22:57:08 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-1e6d53223884225f0c3f9f1a3ac54a224d97ab24@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346005487-62961-3-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tool:
  handle errors in synthesized event functions
Git-Commit-ID: 1e6d53223884225f0c3f9f1a3ac54a224d97ab24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 22:57:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e6d53223884225f0c3f9f1a3ac54a224d97ab24
Gitweb:     http://git.kernel.org/tip/1e6d53223884225f0c3f9f1a3ac54a224d97ab24
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 26 Aug 2012 12:24:42 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:17:30 -0300

perf tool: handle errors in synthesized event functions

Handle error from process callback and propagate back to caller.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-3-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   35 ++++++++++++++++++++++++++---------
 1 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3a0f1a5..84ff6f16 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -120,7 +120,9 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 	if (!full) {
 		event->comm.tid = pid;
 
-		process(tool, event, &synth_sample, machine);
+		if (process(tool, event, &synth_sample, machine) != 0)
+			return -1;
+
 		goto out;
 	}
 
@@ -151,7 +153,10 @@ static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
 
 		event->comm.tid = pid;
 
-		process(tool, event, &synth_sample, machine);
+		if (process(tool, event, &synth_sample, machine) != 0) {
+			tgid = -1;
+			break;
+		}
 	}
 
 	closedir(tasks);
@@ -167,6 +172,7 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 {
 	char filename[PATH_MAX];
 	FILE *fp;
+	int rc = 0;
 
 	snprintf(filename, sizeof(filename), "/proc/%d/maps", pid);
 
@@ -231,18 +237,22 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 			event->mmap.pid = tgid;
 			event->mmap.tid = pid;
 
-			process(tool, event, &synth_sample, machine);
+			if (process(tool, event, &synth_sample, machine) != 0) {
+				rc = -1;
+				break;
+			}
 		}
 	}
 
 	fclose(fp);
-	return 0;
+	return rc;
 }
 
 int perf_event__synthesize_modules(struct perf_tool *tool,
 				   perf_event__handler_t process,
 				   struct machine *machine)
 {
+	int rc = 0;
 	struct rb_node *nd;
 	struct map_groups *kmaps = &machine->kmaps;
 	union perf_event *event = zalloc((sizeof(event->mmap) +
@@ -284,11 +294,14 @@ int perf_event__synthesize_modules(struct perf_tool *tool,
 
 		memcpy(event->mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(tool, event, &synth_sample, machine);
+		if (process(tool, event, &synth_sample, machine) != 0) {
+			rc = -1;
+			break;
+		}
 	}
 
 	free(event);
-	return 0;
+	return rc;
 }
 
 static int __event__synthesize_thread(union perf_event *comm_event,
@@ -392,12 +405,16 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
 
-		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
-					   process, tool, machine);
+		if (__event__synthesize_thread(comm_event, mmap_event, pid, 1,
+					   process, tool, machine) != 0) {
+			err = -1;
+			goto out_closedir;
+		}
 	}
 
-	closedir(proc);
 	err = 0;
+out_closedir:
+	closedir(proc);
 out_free_mmap:
 	free(mmap_event);
 out_free_comm:
