Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935291Ab1IOW54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 18:57:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:43409 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935256Ab1IOW5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48919101"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] perf tools: Add -l flag to top/record to account to parent
Date: Thu, 15 Sep 2011 15:56:52 -0700
Message-Id: <1316127412-1912-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
References: <1316127412-1912-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a new -l flag to top and record to account kernel locks
to the parent.

The main beneficiary is top because it doesn't support callgraphs.
This allows to use perf top to identify locking problems:
you can see the actual caller now instead of just "__spin_lock"

For record it can be a lower overhead alternative to -g

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-report.txt |    4 ++++
 tools/perf/Documentation/perf-top.txt    |    4 ++++
 tools/perf/builtin-record.c              |    6 ++++++
 tools/perf/builtin-top.c                 |    6 ++++++
 4 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 04253c0..e78c9d4 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -60,6 +60,10 @@ OPTIONS
 --parent=<regex>::
         regex filter to identify parent, see: '--sort parent'
 
+-l::
+--lock-parent::
+	account kernel locks to parent function.
+
 -x::
 --exclude-other::
         Only display entries with parent-match.
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index f6eb1cd..a0b0e16 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -70,6 +70,10 @@ Default is to monitor all CPUS.
 --mmap-pages=<pages>::
 	Number of mmapped data pages.
 
+-l::
+--lock-parent::
+        Account kernel locks to parent function.
+
 -p <pid>::
 --pid=<pid>::
 	Profile events on existing Process ID.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6b0519f..8cc2585 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -68,6 +68,7 @@ static struct perf_evlist	*evsel_list;
 static long			samples				=      0;
 static u64			bytes_written			=      0;
 
+static bool			lock_parent			=   false;
 static int			file_new			=      1;
 static off_t			post_processing_offset;
 
@@ -161,6 +162,9 @@ static void config_attr(struct perf_evsel *evsel, struct perf_evlist *evlist)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
+	if (lock_parent)
+		attr->lock_parent = 1;
+
 	attr->inherit		= !no_inherit;
 	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -751,6 +755,8 @@ const struct option record_options[] = {
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
+	OPT_BOOLEAN('l', "lock-parent", &lock_parent,
+		    "account kernel locks to parent function"),
 	OPT_UINTEGER('F', "freq", &user_freq, "profile at this frequency"),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &group,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a43433f..2ac73b0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -95,6 +95,7 @@ static struct winsize		winsize;
 static const char		*sym_filter			=   NULL;
 struct sym_entry		*sym_filter_entry_sched		=   NULL;
 static int			sym_pcnt_filter			=      5;
+static bool			lock_parent			=   false;
 
 /*
  * Source functions
@@ -861,6 +862,9 @@ static void start_counters(struct perf_evlist *evlist)
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
+		if (lock_parent)
+			attr->lock_parent = 1;
+
 		if (top.freq) {
 			attr->sample_type |= PERF_SAMPLE_PERIOD;
 			attr->freq	  = 1;
@@ -1005,6 +1009,8 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
+	OPT_BOOLEAN('l', "lock-parent", &lock_parent,
+		    "Account kernel locks to parent function"),
 	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
-- 
1.7.4.4

