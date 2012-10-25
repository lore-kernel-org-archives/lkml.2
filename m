Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242Ab2JYTsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:48:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:59173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2JYTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:48:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf tools: Don't stop synthesizing threads when one vanishes
Date: Thu, 25 Oct 2012 17:47:43 -0200
Message-Id: <1351194465-29083-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351194465-29083-1-git-send-email-acme@infradead.org>
References: <1351194465-29083-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The perf_event__synthesize_threads routine synthesizes all the existing
threads in the system, because we don't have any kernel facilities to
ask for PERF_RECORD_{FORK,MMAP,COMM} for existing threads.

It was returning an error as soon as one thread couldn't be synthesized,
which is a bit extreme when, for instance, a forkish workload is
running, like a kernel compile.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i7oas1eodpoer2bx38fwyasv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 0ae444e..ca9ca28 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -405,16 +405,15 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 
 		if (*end) /* only interested in proper numerical dirents */
 			continue;
-
-		if (__event__synthesize_thread(comm_event, mmap_event, pid, 1,
-					   process, tool, machine) != 0) {
-			err = -1;
-			goto out_closedir;
-		}
+		/*
+ 		 * We may race with exiting thread, so don't stop just because
+ 		 * one thread couldn't be synthesized.
+ 		 */
+		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
+					   process, tool, machine);
 	}
 
 	err = 0;
-out_closedir:
 	closedir(proc);
 out_free_mmap:
 	free(mmap_event);
-- 
1.7.1

