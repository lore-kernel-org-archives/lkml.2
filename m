Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1AMOLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:11:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54104 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900Ab1AMOL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:11:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf record: Add "nodelay" mode, disabled by default
Date: Thu, 13 Jan 2011 12:11:16 -0200
Message-Id: <1294927876-23553-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294927876-23553-1-git-send-email-acme@infradead.org>
References: <1294927876-23553-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kirill Smelkov <kirr@mns.spb.ru>

Sometimes there is a need to use perf in "live-log" mode. The problem
is, for seldom events, actual info output is largely delayed because
perf-record reads sample data in whole pages.

So for such scenarious, add flag for perf-record to go in "nodelay"
mode. To track e.g. what's going on in icmp_rcv while ping is running
Use it with something like this:

(1) $ perf probe -L icmp_rcv | grep -U8 '^ *43\>'
                                    goto error;
                    }
         38         if (!pskb_pull(skb, sizeof(*icmph)))
                            goto error;
                    icmph = icmp_hdr(skb);

         43         ICMPMSGIN_INC_STATS_BH(net, icmph->type);
                    /*
                     *      18 is the highest 'known' ICMP type. Anything else is a mystery
                     *
                     *      RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
                     *                discarded.
                     */
         50         if (icmph->type > NR_ICMP_TYPES)
                            goto error;

    $ perf probe icmp_rcv:43 'type=icmph->type'

(2) $ cat trace-icmp.py
    [...]
    def trace_begin():
            print "in trace_begin"

    def trace_end():
            print "in trace_end"

    def probe__icmp_rcv(event_name, context, common_cpu,
            common_secs, common_nsecs, common_pid, common_comm,
            __probe_ip, type):
                    print_header(event_name, common_cpu, common_secs, common_nsecs,
                            common_pid, common_comm)

                    print "__probe_ip=%u, type=%u\n" % \
                    (__probe_ip, type),
    [...]

(3) $ perf record -a -D -e probe:icmp_rcv -o - | \
      perf script -i - -s trace-icmp.py

Thanks to Peter Zijlstra for pointing how to do it.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-record.txt |    3 +++
 tools/perf/builtin-record.c              |    8 ++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 52462ae..e032716 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -61,6 +61,9 @@ OPTIONS
 -r::
 --realtime=::
 	Collect data with this RT SCHED_FIFO priority.
+-D::
+--no-delay::
+	Collect data without buffering.
 -A::
 --append::
 	Append to the output file to do incremental profiling.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1210e64..df6064a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -49,6 +49,7 @@ static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
 static int			group				=      0;
 static int			realtime_prio			=      0;
+static bool			nodelay				=  false;
 static bool			raw_samples			=  false;
 static bool			sample_id_all_avail		=   true;
 static bool			system_wide			=  false;
@@ -307,6 +308,11 @@ static void create_counter(struct perf_evsel *evsel, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (nodelay) {
+		attr->watermark = 0;
+		attr->wakeup_events = 1;
+	}
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -843,6 +849,8 @@ const struct option record_options[] = {
 		    "record events on existing thread id"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
+	OPT_BOOLEAN('D', "no-delay", &nodelay,
+		    "collect data without buffering"),
 	OPT_BOOLEAN('R', "raw-samples", &raw_samples,
 		    "collect raw sample records from all opened counters"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
-- 
1.6.2.5

