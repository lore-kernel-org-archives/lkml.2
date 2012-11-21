Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2KUMwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:52:05 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35056 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2KUMv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:59 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 13/19] perf record: add support for mem access profiling
Date: Wed, 21 Nov 2012 13:49:39 +0100
Message-Id: <1353502185-26521-14-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
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
index 5783c32..8243405 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1041,6 +1041,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('l', "cost", &record.opts.weight,
+		    "event cost"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 054182e..3b79dcf 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -250,6 +250,7 @@ struct perf_record_opts {
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
 	bool	     period;
+	bool         weight;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 951d4d1..65ca661 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -474,6 +474,12 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (opts->weight)
+		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+
+	if (opts->sample_address)
+		attr->sample_type	|= PERF_SAMPLE_DSRC;
+
 	if (opts->no_delay) {
 		attr->watermark = 0;
 		attr->wakeup_events = 1;
-- 
1.7.9.5

