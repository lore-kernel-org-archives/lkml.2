Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0EUL3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:29:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:58559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab0EUL3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:29:17 -0400
Date: Fri, 21 May 2010 11:28:48 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.582740993@chello.nl>
References: <20100521090710.582740993@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf-record: Remove -M
Message-ID: <tip-57adc51dce9102b6641269dd04f5b99aac83b820@git.kernel.org>
Git-Commit-ID: 57adc51dce9102b6641269dd04f5b99aac83b820
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:28:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  57adc51dce9102b6641269dd04f5b99aac83b820
Gitweb:     http://git.kernel.org/tip/57adc51dce9102b6641269dd04f5b99aac83b820
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 14:39:55 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:57 +0200

perf-record: Remove -M

Since it is not allowed to create cross-cpu (or
cross-task) buffers, this option is no longer valid.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.582740993@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e672269..94e210f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -61,8 +61,6 @@ static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
-static bool			multiplex			=  false;
-static int			multiplex_fd			=     -1;
 
 static long			samples				=      0;
 static u64			bytes_written			=      0;
@@ -366,27 +364,19 @@ try_again:
 		 */
 		if (group && group_fd == -1)
 			group_fd = fd[nr_cpu][counter][thread_index];
-		if (multiplex && multiplex_fd == -1)
-			multiplex_fd = fd[nr_cpu][counter][thread_index];
 
-		if (multiplex && fd[nr_cpu][counter][thread_index] != multiplex_fd) {
-
-			ret = ioctl(fd[nr_cpu][counter][thread_index], PERF_EVENT_IOC_SET_OUTPUT, multiplex_fd);
-			assert(ret != -1);
-		} else {
-			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
-			event_array[nr_poll].events = POLLIN;
-			nr_poll++;
-
-			mmap_array[nr_cpu][counter][thread_index].counter = counter;
-			mmap_array[nr_cpu][counter][thread_index].prev = 0;
-			mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
-			mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
-				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
-			if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
-				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-				exit(-1);
-			}
+		event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
+		event_array[nr_poll].events = POLLIN;
+		nr_poll++;
+
+		mmap_array[nr_cpu][counter][thread_index].counter = counter;
+		mmap_array[nr_cpu][counter][thread_index].prev = 0;
+		mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
+		mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
+			PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
+		if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
+			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+			exit(-1);
 		}
 
 		if (filter != NULL) {
@@ -820,8 +810,6 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
-	OPT_BOOLEAN('M', "multiplex", &multiplex,
-		    "multiplex counter output in a single channel"),
 	OPT_END()
 };
 
