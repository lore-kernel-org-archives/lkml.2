Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0EUJNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:13:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:36406 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab0EUJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:11:24 -0400
Message-Id: <20100521090710.634824884@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 11:02:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/10] perf-record: Share per-cpu buffers
References: <20100521090201.326791353@chello.nl>
Content-Disposition: inline; filename=perf-record-output-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems a waste of space to create a buffer per event, share it per-cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-record.c |   52 +++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

Index: linux-2.6/tools/perf/builtin-record.c
===================================================================
--- linux-2.6.orig/tools/perf/builtin-record.c
+++ linux-2.6/tools/perf/builtin-record.c
@@ -85,7 +85,7 @@ struct mmap_data {
 	unsigned int		prev;
 };
 
-static struct mmap_data		*mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct mmap_data		mmap_array[MAX_NR_CPUS];
 
 static unsigned long mmap_read_head(struct mmap_data *md)
 {
@@ -380,18 +380,29 @@ try_again:
 		if (group && group_fd == -1)
 			group_fd = fd[nr_cpu][counter][thread_index];
 
-		event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
-		event_array[nr_poll].events = POLLIN;
-		nr_poll++;
-
-		mmap_array[nr_cpu][counter][thread_index].counter = counter;
-		mmap_array[nr_cpu][counter][thread_index].prev = 0;
-		mmap_array[nr_cpu][counter][thread_index].mask = mmap_pages*page_size - 1;
-		mmap_array[nr_cpu][counter][thread_index].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
-		if (mmap_array[nr_cpu][counter][thread_index].base == MAP_FAILED) {
-			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-			exit(-1);
+		if (counter || thread_index) {
+			ret = ioctl(fd[nr_cpu][counter][thread_index],
+					PERF_EVENT_IOC_SET_OUTPUT,
+					fd[nr_cpu][0][0]);
+			if (ret) {
+				error("failed to set output: %d (%s)\n", errno,
+						strerror(errno));
+				exit(-1);
+			}
+		} else {
+			mmap_array[nr_cpu].counter = counter;
+			mmap_array[nr_cpu].prev = 0;
+			mmap_array[nr_cpu].mask = mmap_pages*page_size - 1;
+			mmap_array[nr_cpu].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter][thread_index], 0);
+			if (mmap_array[nr_cpu].base == MAP_FAILED) {
+				error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+				exit(-1);
+			}
+
+			event_array[nr_poll].fd = fd[nr_cpu][counter][thread_index];
+			event_array[nr_poll].events = POLLIN;
+			nr_poll++;
 		}
 
 		if (filter != NULL) {
@@ -492,16 +503,11 @@ static struct perf_event_header finished
 
 static void mmap_read_all(void)
 {
-	int i, counter, thread;
+	int i;
 
 	for (i = 0; i < nr_cpu; i++) {
-		for (counter = 0; counter < nr_counters; counter++) {
-			for (thread = 0; thread < thread_num; thread++) {
-				if (mmap_array[i][counter][thread].base)
-					mmap_read(&mmap_array[i][counter][thread]);
-			}
-
-		}
+		if (mmap_array[i].base)
+			mmap_read(&mmap_array[i]);
 	}
 
 	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
@@ -876,9 +882,7 @@ int cmd_record(int argc, const char **ar
 	for (i = 0; i < MAX_NR_CPUS; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = zalloc(
-				sizeof(struct mmap_data)*thread_num);
-			if (!fd[i][j] || !mmap_array[i][j])
+			if (!fd[i][j])
 				return -ENOMEM;
 		}
 	}


