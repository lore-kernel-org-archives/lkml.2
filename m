Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0EUBIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:08:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab0EUBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:08:51 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf record: remove unneeded gettimeofday() call
Date: Thu, 20 May 2010 22:08:40 -0300
Message-Id: <1274404121-6115-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274404121-6115-1-git-send-email-acme@infradead.org>
References: <1274404121-6115-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russ Anderson <rja@sgi.com>

Perf record repeatedly calls gettimeofday() which adds noise to the performance
measurements.  Since gettimeofday() is only used for the error printf, delete
it.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100518225240.GC25589@sgi.com>
Signed-off-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 66b8ecd..e672269 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -65,9 +65,6 @@ static bool			multiplex			=  false;
 static int			multiplex_fd			=     -1;
 
 static long			samples				=      0;
-static struct timeval		last_read;
-static struct timeval		this_read;
-
 static u64			bytes_written			=      0;
 
 static struct pollfd		*event_array;
@@ -147,8 +144,6 @@ static void mmap_read(struct mmap_data *md)
 	void *buf;
 	int diff;
 
-	gettimeofday(&this_read, NULL);
-
 	/*
 	 * If we're further behind than half the buffer, there's a chance
 	 * the writer will bite our tail and mess up the samples under us.
@@ -159,23 +154,13 @@ static void mmap_read(struct mmap_data *md)
 	 */
 	diff = head - old;
 	if (diff < 0) {
-		struct timeval iv;
-		unsigned long msecs;
-
-		timersub(&this_read, &last_read, &iv);
-		msecs = iv.tv_sec*1000 + iv.tv_usec/1000;
-
-		fprintf(stderr, "WARNING: failed to keep up with mmap data."
-				"  Last read %lu msecs ago.\n", msecs);
-
+		fprintf(stderr, "WARNING: failed to keep up with mmap data\n");
 		/*
 		 * head points to a known good entry, start there.
 		 */
 		old = head;
 	}
 
-	last_read = this_read;
-
 	if (old != head)
 		samples++;
 
-- 
1.6.2.5

