Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab2IEXJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805Ab2IEXJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/17] perf tool: handle errors in synthesized event functions
Date: Wed,  5 Sep 2012 20:08:43 -0300
Message-Id: <1346886537-11621-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346886537-11621-1-git-send-email-acme@infradead.org>
References: <1346886537-11621-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
index 3a0f1a5..84ff6f1 100644
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
-- 
1.7.1

