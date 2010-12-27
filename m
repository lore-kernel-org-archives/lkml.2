Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0L0WAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 17:00:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54783 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0L0WAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 17:00:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, Torok Edwin <edwintorok@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 2/4] perf record: Fix use of sample_id_all userspace with !sample_id_all kernels
Date: Mon, 27 Dec 2010 20:00:11 -0200
Message-Id: <1293487213-533-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1293487213-533-1-git-send-email-acme@infradead.org>
References: <1293487213-533-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Check if parse_single_tracepoint_event has already asked for PERF_SAMPLE_TIME.

This is kludgy but short term fix for problems introduced by eac23d1c that
broke 'perf script' by having different sample_types when using multiple
tracepoint events when we use a perf binary that tries to use sample_id_all on
an older kernel.

We need to move counter creation to perf_session, support different
sample_types, etc.

Ongoing work on the perf test infrastructure needs this so that we can create
counters to monitor threads generating specific events, etc.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Torok Edwin <edwintorok@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   24 +++++++++++++++++++-----
 1 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5149e3d..50efbd5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -243,6 +243,19 @@ static void create_counter(int counter, int cpu)
 		u64 time_running;
 		u64 id;
 	} read_data;
+	/*
+ 	 * Check if parse_single_tracepoint_event has already asked for
+ 	 * PERF_SAMPLE_TIME.
+ 	 *
+	 * XXX this is kludgy but short term fix for problems introduced by
+	 * eac23d1c that broke 'perf script' by having different sample_types
+	 * when using multiple tracepoint events when we use a perf binary
+	 * that tries to use sample_id_all on an older kernel.
+ 	 *
+ 	 * We need to move counter creation to perf_session, support
+ 	 * different sample_types, etc.
+ 	 */
+	bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -285,7 +298,8 @@ static void create_counter(int counter, int cpu)
 	if (system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
-	if (sample_time || system_wide || !no_inherit || cpu_list)
+	if (sample_id_all_avail &&
+	    (sample_time || system_wide || !no_inherit || cpu_list))
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (raw_samples) {
@@ -294,9 +308,6 @@ static void create_counter(int counter, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
-	if (!sample_type)
-		sample_type = attr->sample_type;
-
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -327,7 +338,7 @@ try_again:
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
 				sample_id_all_avail = false;
-				if (!sample_time && !raw_samples)
+				if (!sample_time && !raw_samples && !time_needed)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -428,6 +439,9 @@ try_again:
 			}
 		}
 	}
+
+	if (!sample_type)
+		sample_type = attr->sample_type;
 }
 
 static void open_counters(int cpu)
-- 
1.6.2.5

