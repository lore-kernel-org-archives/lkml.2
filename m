Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2J2PQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:16:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45463 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab2J2PQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:16:24 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, ming.m.lin@intel.com
Subject: [Patch v1 09/10] perf record: add support for mem access profiling
Date: Mon, 29 Oct 2012 16:15:51 +0100
Message-Id: <1351523752-4215-10-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351523752-4215-1-git-send-email-eranian@google.com>
References: <1351523752-4215-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the -l option to perf record to enable sampling
access cost sampling.

Data address sampling is obtained via the -d option.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c |    2 ++
 tools/perf/perf.h           |    1 +
 tools/perf/util/evsel.c     |    6 ++++++
 3 files changed, 9 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 53c9892..cafe5d9 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1040,6 +1040,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('l', "cost", &record.opts.cost,
+		    "event cost"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index c50985e..ea2db82 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -236,6 +236,7 @@ struct perf_record_opts {
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
 	bool	     period;
+	bool         cost;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c82a271..6f84fbc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -474,6 +474,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (opts->cost)
+		attr->sample_type	|= PERF_SAMPLE_COST;
+
+	if (opts->sample_address)
+		attr->sample_type	|= PERF_SAMPLE_DSRC;
+
 	if (opts->no_delay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
-- 
1.7.9.5

