Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab2CTTv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 15:51:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64827 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2CTTvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 15:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <1332272870.18960.450.camel@twins>
References: <1332271396-21756-1-git-send-email-ashay.r@gmail.com>
	<20120320194241.GA24870@infradead.org>
	<4F68DE88.1040301@gmail.com>
	<1332272870.18960.450.camel@twins>
Date: Tue, 20 Mar 2012 14:51:23 -0500
Message-ID: <CANn2t1n3fiVGqMKm=a7k3bKgKRzVdo3zu54ZKiCMqtDFbS4MeA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Fix number of events displayed in header
From: Ashay Rane <ashay.r@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-perf-users@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Ashay Rane <ashay.rane@tacc.utexas.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The problem I am seeing is that the `perf record' output does not
comform with the output of `perf stat'. For example, for `hackbench 10
process 1000', I see 19 x 10^9 cycles reported by `perf stat'.
However, `perf report -n' prints "Events: 2K cycles" and `perf report
-n --dso hackbench' prints "Events: 47 cycles".

The difference in the reported counts occurs for PMU events too.

$ perf stat -e cycles ./hackbench 10 process 1000
Running with 10*40 (== 400) tasks.
Time: 4.039

 Performance counter stats for './hackbench 10 process 1000':

    19,060,433,134 cycles                    #    0.000 GHz

       4.078210213 seconds time elapsed

$ perf record -e cycles ./hackbench 10 process 1000
Running with 10*40 (== 400) tasks.
Time: 4.053
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.165 MB perf.data (~7205 samples) ]

$ perf report -n --stdio --dso hackbench
# dso: hackbench
# ========
# captured on: Mon Mar 12 15:14:57 2012
# hostname : iHitch
# os release : 3.2.8-1-ARCH
# perf version : 3.2-3
# arch : x86_64
# nrcpus online : 2
# nrcpus avail : 2
# cpudesc : Intel(R) Core(TM)2 Duo CPU P8600 @ 2.40GHz
# cpuid : GenuineIntel,6,23,10
# total memory : 2979384 kB
# cmdline : /usr/bin/perf record -e cycles ./hackbench 10 process 1000
# event : name = cycles, type = 0, config = 0x0, config1 = 0x0,
config2 = 0x0, excl_usr = 0, excl_kern = 0, id = { 1611, 1612 }
# HEADER_CPU_TOPOLOGY info available, use -I to display
# HEADER_NUMA_TOPOLOGY info available, use -I to display
# ========
#
# Events: 47  cycles
#
# Overhead  Samples      Command     Symbol
# ........ ..........  .........  .........
#
    56.16%         24  hackbench  receiver
    40.21%         21  hackbench  sender
     3.63%          2  hackbench  write@plt


#
# (For a higher level overview, try: perf report --sort comm,dso)
#

$

2012/3/20 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Tue, 2012-03-20 at 13:46 -0600, David Ahern wrote:
>>
>> Does not seem appropriate to change from number of sample events to
>> period for all event types. This change assumes the event is cycles,
>> cpu-clock or task-clock.
>
> I'm not seeing that assumption. That said, I don't see the point of the
> change either.
