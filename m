Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0EUIxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:53:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:55489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab0EUIxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:53:16 -0400
Date: Fri, 21 May 2010 08:52:43 GMT
From: tip-bot for Russ Anderson <rja@sgi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, rja@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: rja@sgi.com, mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100518225240.GC25589@sgi.com>
References: <20100518225240.GC25589@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: remove unneeded gettimeofday() call
Message-ID: <tip-ef365cefbc53d8674a18520a1d4c2e5590127299@git.kernel.org>
Git-Commit-ID: ef365cefbc53d8674a18520a1d4c2e5590127299
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 May 2010 08:52:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef365cefbc53d8674a18520a1d4c2e5590127299
Gitweb:     http://git.kernel.org/tip/ef365cefbc53d8674a18520a1d4c2e5590127299
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Tue, 18 May 2010 17:52:40 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 20 May 2010 21:53:58 -0300

perf record: remove unneeded gettimeofday() call

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
 
