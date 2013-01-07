Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3AGS24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:28:56 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:57399 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab3AGS2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:28:51 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v5 13/18] perf record: add support for mem access profiling
Date: Mon,  7 Jan 2013 19:27:52 +0100
Message-Id: <1357583277-4553-14-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357583277-4553-1-git-send-email-eranian@google.com>
References: <1357583277-4553-1-git-send-email-eranian@google.com>
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
index f3151d3..341f9c1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1059,6 +1059,8 @@ const struct option record_options[] = {
 	OPT_CALLBACK('j', "branch-filter", &record.opts.branch_stack,
 		     "branch filter mask", "branch stack filter modes",
 		     parse_branch_stack),
+	OPT_BOOLEAN('l', "cost", &record.opts.weight,
+		    "event cost"),
 	OPT_END()
 };
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 2c340e7..c976553 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -240,6 +240,7 @@ struct perf_record_opts {
 	bool	     sample_id_all_missing;
 	bool	     exclude_guest_missing;
 	bool	     period;
+	bool         weight;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9f334dd..ad0c649 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -501,6 +501,12 @@ void perf_evsel__config(struct perf_evsel *evsel,
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

