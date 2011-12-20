Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1LTOcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:32:47 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:36912 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab1LTOck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:32:40 -0500
From: Andrew Vagin <avagin@openvz.org>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, asharma@fb.com, avagin@openvz.org, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Subject: [PATCH] perf: add ability to record event period
Date: Tue, 20 Dec 2011 17:32:45 +0300
Message-Id: <1324391565-1369947-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is that when SAMPLE_PERIOD is not set, kernel generates a
number of samples in proportion to an event's period. Number of these
samples may be too big and a kernel throttles all samples above a
defined limit.

E.g.: I want to trace when a process sleeps. I created a process, which
sleeps for 1ms and for 4ms.  perf got 100 events in both cases.

swapper 0 [000] 1141.371830: sched_stat_sleep: comm=foo pid=1801 delay=1386750 [ns]
swapper 0 [000] 1141.369444: sched_stat_sleep: comm=foo pid=1801 delay=4499585 [ns]

In the first case a kernel want to send 4499585 events and
in the second case it wants to send 1386750 events.
perf-reports shows that process sleeps in both places equal time.

Instead of this we can get only one sample with an attribute period. As
result we have less data transferring between kernel and user-space and
we avoid throttling of samples.

The patch "events: Don't divide events if it has field period" added a
kernel part of this functionality.

Signed-off-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Arun Sharma <asharma@fb.com>
---
 tools/perf/builtin-record.c |    1 +
 tools/perf/perf.h           |    1 +
 tools/perf/util/evsel.c     |    3 +++
 3 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 766fa0a..f8fd14f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -700,6 +700,7 @@ const struct option record_options[] = {
 	OPT_BOOLEAN('d', "data", &record.opts.sample_address,
 		    "Sample addresses"),
 	OPT_BOOLEAN('T', "timestamp", &record.opts.sample_time, "Sample timestamps"),
+	OPT_BOOLEAN('P', "period", &record.opts.period, "Sample period"),
 	OPT_BOOLEAN('n', "no-samples", &record.opts.no_samples,
 		    "don't sample"),
 	OPT_BOOLEAN('N', "no-buildid-cache", &record.no_buildid_cache,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ea804f5..64f8bee 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -200,6 +200,7 @@ struct perf_record_opts {
 	bool	     sample_time;
 	bool	     sample_id_all_avail;
 	bool	     system_wide;
+	bool	     period;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 4a8c8b0..60ad028 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -108,6 +108,9 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	if (opts->system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
+	if (opts->period)
+		attr->sample_type	|= PERF_SAMPLE_PERIOD;
+
 	if (opts->sample_id_all_avail &&
 	    (opts->sample_time || opts->system_wide ||
 	     !opts->no_inherit || opts->cpu_list))
-- 
1.7.1

