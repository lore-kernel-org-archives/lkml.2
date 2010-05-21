Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0EUJL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:11:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:36403 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0EUJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:24 -0400
Message-Id: <20100521090710.582740993@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:05 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 04/10] perf-record: Remove -M
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-record-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is not allowed to create cross-cpu (or cross-task) buffers,
this option is no longer valid.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-record.c |   36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

Index: linux-2.6/tools/perf/builtin-record.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-record.c
+++ linux-2.6/tools/perf/builtin-record.c
@@ -61,8 +61,6 @@ static bool			call_graph			=  false;
 static bool			inherit_stat			=  false;
 static bool			no_samples			=  false;
 static bool			sample_address			=  false;
-static bool			multiplex			=  false;
-static int			multiplex_fd			=     -1;
 
 static long			samples				=      0;
 static struct timeval		last_read;
@@ -381,27 +379,19 @@ try_again:
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
@@ -835,8 +825,6 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
-	OPT_BOOLEAN('M', "multiplex", &multiplex,
-		    "multiplex counter output in a single channel"),
 	OPT_END()
 };
 


