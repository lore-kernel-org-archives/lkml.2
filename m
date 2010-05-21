Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0EUL3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 07:29:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:58571 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab0EUL3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 07:29:33 -0400
Date: Fri, 21 May 2010 11:29:06 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20100521090710.634824884@chello.nl>
References: <20100521090710.634824884@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf-record: Share per-cpu buffers
Message-ID: <tip-0e2e63dd608bf5844ffae7bf7d860de18a62724c@git.kernel.org>
Git-Commit-ID: 0e2e63dd608bf5844ffae7bf7d860de18a62724c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 11:29:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e2e63dd608bf5844ffae7bf7d860de18a62724c
Gitweb:     http://git.kernel.org/tip/0e2e63dd608bf5844ffae7bf7d860de18a62724c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 20 May 2010 14:45:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 21 May 2010 11:37:58 +0200

perf-record: Share per-cpu buffers

It seems a waste of space to create a buffer per
event, share it per-cpu.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100521090710.634824884@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   52 +++++++++++++++++++++++-------------------
 1 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 94e210f..9bc8905 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -82,7 +82,7 @@ struct mmap_data {
 	unsigned int		prev;
 };
 
-static struct mmap_data		*mmap_array[MAX_NR_CPUS][MAX_COUNTERS];
+static struct mmap_data		mmap_array[MAX_NR_CPUS];
 
 static unsigned long mmap_read_head(struct mmap_data *md)
 {
@@ -365,18 +365,29 @@ try_again:
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
@@ -477,16 +488,11 @@ static struct perf_event_header finished_round_event = {
 
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
@@ -861,9 +867,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
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
