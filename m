Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab1ANH02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:26:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:60495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276Ab1ANH0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:26:18 -0500
Date: Fri, 14 Jan 2011 07:25:43 GMT
From: tip-bot for Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, kirr@mns.spb.ru, hpa@zytor.com, mingo@redhat.com,
        tzanussi@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, kirr@mns.spb.ru, acme@redhat.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf record: Add "nodelay" mode, disabled by default
Message-ID: <tip-acac03fa15a8684bb60489ed87b5aae5258c0838@git.kernel.org>
Git-Commit-ID: acac03fa15a8684bb60489ed87b5aae5258c0838
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 Jan 2011 07:25:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acac03fa15a8684bb60489ed87b5aae5258c0838
Gitweb:     http://git.kernel.org/tip/acac03fa15a8684bb60489ed87b5aae5258c0838
Author:     Kirill Smelkov <kirr@mns.spb.ru>
AuthorDate: Wed, 12 Jan 2011 17:59:36 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 13 Jan 2011 11:38:44 -0200

perf record: Add "nodelay" mode, disabled by default

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
