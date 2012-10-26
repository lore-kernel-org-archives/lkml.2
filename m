Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab2JZIyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:54:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51603 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757268Ab2JZIyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:54:46 -0400
Date: Fri, 26 Oct 2012 01:54:11 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-i7oas1eodpoer2bx38fwyasv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don'
 t stop synthesizing threads when one vanishes
Git-Commit-ID: ba361c92e73c771fcbbbd24c2c03c322e2de2e31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 01:54:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba361c92e73c771fcbbbd24c2c03c322e2de2e31
Gitweb:     http://git.kernel.org/tip/ba361c92e73c771fcbbbd24c2c03c322e2de2e31
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 17 Oct 2012 18:50:13 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Oct 2012 10:37:15 -0200

perf tools: Don't stop synthesizing threads when one vanishes

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
