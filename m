Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1ADIT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:19:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:50068 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab1ADIT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:19:57 -0500
Date: Tue, 4 Jan 2011 08:19:30 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, edwintorok@gmail.com,
        imunsie@au1.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, edwintorok@gmail.com,
        imunsie@au1.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix use of sample_id_all userspace with !sample_id_all kernels
Message-ID: <tip-a43d3f08c64125edbdfdc3d3aa512d3e37321f37@git.kernel.org>
Git-Commit-ID: a43d3f08c64125edbdfdc3d3aa512d3e37321f37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 Jan 2011 08:19:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a43d3f08c64125edbdfdc3d3aa512d3e37321f37
Gitweb:     http://git.kernel.org/tip/a43d3f08c64125edbdfdc3d3aa512d3e37321f37
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 25 Dec 2010 12:12:25 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 25 Dec 2010 12:12:25 -0200

perf record: Fix use of sample_id_all userspace with !sample_id_all kernels

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
