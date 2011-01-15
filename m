Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab1AOPlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:41:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:37065 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab1AOPlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 09/16] perf record: Move perf_mmap__write_tail to perf.h
Date: Sat, 15 Jan 2011 13:40:38 -0200
Message-Id: <1295106045-31192-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Close to perf_mmap__read_head() and the perf_mmap struct definition.
This is useful for any recorder, and we will need it in 'perf test'.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   13 +------------
 tools/perf/perf.h           |   12 ++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c24151f..f2a8f3b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -80,17 +80,6 @@ static const char		*cpu_list;
 
 static struct perf_mmap		mmap_array[MAX_NR_CPUS];
 
-static void mmap_write_tail(struct perf_mmap *md, unsigned long tail)
-{
-	struct perf_event_mmap_page *pc = md->base;
-
-	/*
-	 * ensure all reads are done before we write the tail out.
-	 */
-	/* mb(); */
-	pc->data_tail = tail;
-}
-
 static void advance_output(size_t size)
 {
 	bytes_written += size;
@@ -165,7 +154,7 @@ static void mmap_read(struct perf_mmap *md)
 	write_output(buf, size);
 
 	md->prev = old;
-	mmap_write_tail(md, old);
+	perf_mmap__write_tail(md, old);
 }
 
 static volatile int done = 0;
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 5fb5e1f..a5fc660 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -108,6 +108,18 @@ static inline unsigned int perf_mmap__read_head(struct perf_mmap *mm)
 	return head;
 }
 
+static inline void perf_mmap__write_tail(struct perf_mmap *md,
+					 unsigned long tail)
+{
+	struct perf_event_mmap_page *pc = md->base;
+
+	/*
+	 * ensure all reads are done before we write the tail out.
+	 */
+	/* mb(); */
+	pc->data_tail = tail;
+}
+
 /*
  * prctl(PR_TASK_PERF_EVENTS_DISABLE) will (cheaply) disable all
  * counters in the current task.
-- 
1.6.2.5

