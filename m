Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1ALOFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:05:02 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:54932 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab1ALOE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:04:58 -0500
Date: Wed, 12 Jan 2011 17:06:13 +0300
From: Kirill Smelkov <kirr@mns.spb.ru>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Q: perf log mode?
Message-ID: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello up there,

I'm trying to use perf together with e.g. kprobes as a tool to show what
is happening with my system in "live-log" mode. The problem is, for
seldom events, actual info output is largely delayed because perf reads
sample data in whole pages. Could something be done with it or am I'm
missing something? Here is detailed description:


Say I'm interested in ICMP packet processing, so I (1) install
kprobe in icmp_rcv:

    $ perf probe -L icmp_rcv | grep -U8 '^ *43\>'
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


(2) Write/generate processing script for it:

    $ cat trace-icmp.py
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


then (3) try to see events log (this is the best variant I could come up
with up to now):

    $ perf record -a -R -c 1 -m 1 -e probe:icmp_rcv -o - | \
      perf script -i - -s trace-icmp.py


As I wrote in the introduction, most of the time there is no output, and
seldom a bunch of events comes in one go, e.g.

    probe__icmp_rcv          0 16443.348252154        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16450.348146741        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16455.348151997        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16456.348148274        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16458.348144398        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16461.348152021        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16464.348140741        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16470.348143846        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16472.348144669        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16475.348151825        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16478.348140674        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16479.348150712        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16481.348147982        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16485.348147250        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16486.348150900        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16491.348154918        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          0 16497.348155844        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          1 16446.348146828        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          1 16447.348153243        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          1 16449.348151942        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          1 16454.348148286        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          1 16462.348159458        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          1 16465.348151748        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16442.349363280        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16448.348142037        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16451.348153582        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16453.348147189        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16460.348146440        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16466.348144503        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16473.348156748        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16474.348151359        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16487.348151515        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16488.348151928        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16489.348151897        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16492.348148233        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          2 16498.348153051        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16444.348149546        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16445.348146280        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16452.348138865        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16457.348151554        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16459.348149756        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16463.348150932        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16467.348146132        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16468.348140904        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16469.348143768        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16471.348148436        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16476.348145084        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16477.348146054        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16480.348144285        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16482.348144761        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16483.348148015        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16484.348147443        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16490.348141855        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16493.348152237        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16494.348140068        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16495.348158109        0 swapper               __probe_ip=3240938970, type=0
    probe__icmp_rcv          3 16496.348127986        0 swapper               __probe_ip=3240938970, type=0


Judging from timestamps, the events were coming with 1-2 seconds period
(ping <host> running) and for e.g. first event we got 96-43=53 seconds
delay (which is happening already at `perf record` stage -- I've
monitored it's raw output).

Is it somehow possible to display events instantly as they are coming?


Thanks,
Kirill
