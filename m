Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1LUIla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 03:41:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab1LUIl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 03:41:28 -0500
Date: Wed, 21 Dec 2011 00:40:43 -0800
From: tip-bot for Andrew Vagin <avagin@openvz.org>
Message-ID: <tip-3e76ac78b08479e84a3eca3fb1b3066fb8230461@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, dsahern@gmail.com, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, dsahern@gmail.com, tglx@linutronix.de,
        asharma@fb.com, mingo@elte.hu
In-Reply-To: <1324391565-1369947-1-git-send-email-avagin@openvz.org>
References: <1324391565-1369947-1-git-send-email-avagin@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Add ability to record event period
Git-Commit-ID: 3e76ac78b08479e84a3eca3fb1b3066fb8230461
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 00:40:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e76ac78b08479e84a3eca3fb1b3066fb8230461
Gitweb:     http://git.kernel.org/tip/3e76ac78b08479e84a3eca3fb1b3066fb8230461
Author:     Andrew Vagin <avagin@openvz.org>
AuthorDate: Tue, 20 Dec 2011 17:32:45 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 20 Dec 2011 12:50:09 -0200

perf record: Add ability to record event period

The problem is that when SAMPLE_PERIOD is not set, the kernel generates
a number of samples in proportion to an event's period. Number of these
samples may be too big and the kernel throttles all samples above a
defined limit.

E.g.: I want to trace when a process sleeps. I created a process which
sleeps for 1ms and for 4ms.  perf got 100 events in both cases.

swapper 0 [000] 1141.371830: sched_stat_sleep: comm=foo pid=1801 delay=1386750 [ns]
swapper 0 [000] 1141.369444: sched_stat_sleep: comm=foo pid=1801 delay=4499585 [ns]

In the first case a kernel want to send 4499585 events and in the second
case it wants to send 1386750 events.  perf-reports shows that process
sleeps in both places equal time.

Instead of this we can get only one sample with an attribute period. As
result we have less data transferring between kernel and user-space and
we avoid throttling of samples.

The patch "events: Don't divide events if it has field period" added a
kernel part of this functionality.

Acked-by: Arun Sharma <asharma@fb.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: devel@openvz.org
Link: http://lkml.kernel.org/r/1324391565-1369947-1-git-send-email-avagin@openvz.org
Signed-off-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
