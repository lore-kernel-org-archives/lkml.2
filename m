Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1ALO6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:58:21 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:45867 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1ALO6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:58:18 -0500
Date: Wed, 12 Jan 2011 17:59:36 +0300
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: Q: perf log mode?
Message-ID: <20110112145936.GA13992@tugrik.mns.mnsspb.ru>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru> <1294841288.19601.49.camel@laptop> <20110112144240.GA1755@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112144240.GA1755@nowhere>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 03:42:43PM +0100, Frederic Weisbecker wrote:
> On Wed, Jan 12, 2011 at 03:08:08PM +0100, Peter Zijlstra wrote:
> > On Wed, 2011-01-12 at 17:06 +0300, Kirill Smelkov wrote:
> > > I'm trying to use perf together with e.g. kprobes as a tool to show what
> > > is happening with my system in "live-log" mode. The problem is, for
> > > seldom events, actual info output is largely delayed because perf reads
> > > sample data in whole pages. Could something be done with it or am I'm
> > > missing something? Here is detailed description: 
> > 
> > perf_event_attr = {
> > 	.watermark = 0,
> > 	.wakeup_events = 1,
> > };

Ah, thanks for pointing it out!


> Which is perhaps something we want as a default when perf record -c 1
> and the output is the pipe mode.

Maybe not always, because as I understand it, tracepoints are handled
with -c 1, but there could be lots of them, and in such cases buffering
helps.


Anyway, maybe something like this could be useful?


---- 8< ----
From: Kirill Smelkov <kirr@mns.spb.ru>
Date: Wed, 12 Jan 2011 17:43:16 +0300
Subject: [PATCH] perf record: Add support for "nodelay" mode

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
1.7.4.rc1.7.g2cf08

