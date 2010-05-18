Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0ERWwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:52:46 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50609 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0ERWwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:52:44 -0400
Date: Tue, 18 May 2010 17:52:40 -0500
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       Russ Anderson <rja@sgi.com>
Subject: [BUGFIX] perf record: remove unneeded gettimeofday() call
Message-ID: <20100518225240.GC25589@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf record repeatedly calls gettimeofday() which adds noise to the performance 
measurements.  Since gettimeofday() is only used for the error printf,
delete it.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
 tools/perf/builtin-record.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

Index: linux/tools/perf/builtin-record.c
===================================================================
--- linux.orig/tools/perf/builtin-record.c	2010-05-18 16:03:58.000000000 -0500
+++ linux/tools/perf/builtin-record.c	2010-05-18 17:28:00.765537656 -0500
@@ -64,9 +64,6 @@ static bool			multiplex			=  false;
 static int			multiplex_fd			=     -1;
 
 static long			samples				=      0;
-static struct timeval		last_read;
-static struct timeval		this_read;
-
 static u64			bytes_written			=      0;
 
 static struct pollfd		*event_array;
@@ -146,8 +143,6 @@ static void mmap_read(struct mmap_data *
 	void *buf;
 	int diff;
 
-	gettimeofday(&this_read, NULL);
-
 	/*
 	 * If we're further behind than half the buffer, there's a chance
 	 * the writer will bite our tail and mess up the samples under us.
@@ -158,23 +153,13 @@ static void mmap_read(struct mmap_data *
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
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
