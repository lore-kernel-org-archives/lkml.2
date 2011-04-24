Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1DXGVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 02:21:49 -0400
Received: from outmail004.snc4.facebook.com ([66.220.144.136]:42823 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751742Ab1DXGVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 02:21:46 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Apr 2011 02:21:46 EDT
Date: Sat, 23 Apr 2011 23:16:45 -0700
From: Arun Sharma <asharma@fb.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: arun@sharma-home.net, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, eranian@gmail.com,
        Arun Sharma <asharma@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] perf events: Add stalled cycles generic event - PERF_COUNT_HW_STALLED_CYCLES
Message-ID: <20110424061645.GA12013@radium.snc4.facebook.com>
References: <BANLkTikNWgzKefWxp6UUqQ-XdBvgG+QSNQ@mail.gmail.com> <20110422092322.GA1948@elte.hu> <BANLkTi=G7-v3ysxK2wY_3f8TecbD6ZjKog@mail.gmail.com> <20110422105211.GB1948@elte.hu> <20110422165007.GA18401@vps.sharma-home.net> <20110422203022.GA20573@elte.hu> <20110423201409.GA20072@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110423201409.GA20072@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 10:14:09PM +0200, Ingo Molnar wrote:
> 
> The new PERF_COUNT_HW_STALLED_CYCLES event tries to approximate
> cycles the CPU does nothing useful, because it is stalled on a
> cache-miss or some other condition.

Conceptually looks fine. I'd prefer a more precise name such as:
PERF_COUNT_EXECUTION_STALLED_CYCLES (to differentiate from frontend or
retirement stalls).

In the example below:

==> foo.c <==

foo()
{
}


bar()
{
}

==> test.c <==
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define FNV_PRIME_32 16777619
#define FNV_OFFSET_32 2166136261U
uint32_t hash1(const char *s)
{
    uint32_t hash = FNV_OFFSET_32, i;
    for(i = 0; i < 4; i++)
    {
        hash = hash ^ (s[i]); // xor next byte into the bottom of the hash
        hash = hash * FNV_PRIME_32; // Multiply by prime number found to work well
    }
    return hash;
} 

#define FNV_PRIME_WEAK_32 100
#define FNV_OFFSET_WEAK_32 200

uint32_t hash2(const char *s)
{
    uint32_t hash = FNV_OFFSET_WEAK_32, i;
    for(i = 0; i < 4; i++)
    {
        hash = hash ^ (s[i]); // xor next byte into the bottom of the hash
        hash = hash * FNV_PRIME_WEAK_32; // Multiply by prime number found to work well
    }
    return hash;
}

int main()
{
	int r = random();

	while(1) {
		r++;
#ifdef HARD
		if (hash1((const char *) &r) & 0x500)
#else
		if (hash2((const char *) &r) & 0x500)
#endif
			foo();
		else
			bar();
	}
}
==> Makefile <==

all:
	gcc -O2 test.c foo.c -UHARD -o test.easy
	gcc -O2 test.c foo.c -DHARD -o test.hard


# perf stat -e cycles,instructions ./test.hard
^C
 Performance counter stats for './test.hard':

     3,742,855,848 cycles                  
     4,179,896,309 instructions             #      1.117 IPC  

        1.754804730  seconds time elapsed


# perf stat -e cycles,instructions ./test.easy
^C
 Performance counter stats for './test.easy':

     3,932,887,528 cycles                  
     8,994,416,316 instructions             #      2.287 IPC  

        1.843832827  seconds time elapsed

i.e. fixing the branch mispredicts could result in
a nearly 2x speedup for the program.

Looking at:

# perf stat -e  cycles,instructions,branch-misses,cache-misses,RESOURCE_STALLS:ANY ./test.hard
^C
 Performance counter stats for './test.hard':

     3,413,713,048 cycles                    (scaled from 69.93%)
     3,772,611,782 instructions             #      1.105 IPC    (scaled from 80.01%)
        51,113,340 branch-misses             (scaled from 80.01%)
            12,370 cache-misses              (scaled from 80.02%)
        26,656,983 RESOURCE_STALLS:ANY       (scaled from 69.99%)

        1.626595305  seconds time elapsed

it's hard to spot the opporunity. On the other hand:

# ./analyze.py
Percent idle: 27%
        Retirement Stalls: 82%
        Backend Stalls: 0%
        Frontend Stalls: 62%
        Instruction Starvation: 62%
        icache stalls: 0%

does give me a signal about where to look. The script below is
a quick and dirty hack. I haven't really validated it with 
many workloads. I'm posting it here anyway hoping that it'd
result in better kernel support for these types of analyses.

Even if we cover this with various generic PERF_COUNT_*STALL events,
we'll still have a need for other events:

* Things that give info about instruction mixes.

  Ratio of {loads, stores, floating point, branches, conditional branches}
  to total instructions.

* Activity related to micro architecture specific caches

  People using -funroll-loops may have a significant performance opportunity.
  But it's hard to spot bottlenecks in the instruction decoder.

* Monitoring traffic on Hypertransport/QPI links

Like you observe, most people will not look at these events, so
focusing on getting the common events right makes sense. But I
still like access to all events (either via a mapping file or
a library such as libpfm4). Hiding them in "perf list" sounds
like a reasonable way of keeping complexity out.

 -Arun

PS: branch-misses:pp was spot on for the example above.

#!/usr/bin/env python

from optparse import OptionParser
from itertools import izip, chain, repeat
from subprocess import Popen, PIPE
import re, struct

def grouper(n, iterable, padvalue=None):
    "grouper(3, 'abcdefg', 'x') --> ('a','b','c'), ('d','e','f'), ('g','x','x')"
    return izip(*[chain(iterable, repeat(padvalue, n-1))]*n)

counter_re = re.compile('\s+(?P<count>\d+)\s+(?P<event>\S+)')
def sample(events):
    cmd = 'perf stat --no-big-num -a'
    ncounters = 4
    groups = grouper(ncounters, events)
    for g in groups:
        # filter padding
	g = [ e for e in g if e ]
        cmd += ' -e ' + ','.join(g)
    cmd += ' -- sleep ' + str(options.time)
    process = Popen(cmd, shell=True, stdout=PIPE, stderr=PIPE)
    out, err = process.communicate()
    ret = process.poll()
    if ret: raise "Perf failed: " + err
    ret = {}
    for line in err.split('\n'):
        m = counter_re.match(line)
	if not m: continue
	ret[m.group('event')] = long(m.group('count'))
    return ret

def measure_cycles():
    # disable C-states
    f = open("/dev/cpu_dma_latency", "wb")
    f.write(struct.pack("i", 0))
    f.flush()
    saved = options.time
    options.time = 1 # one sec is sufficient to measure clock
    cycles = sample(["cycles"])['cycles']
    cycles /= options.time
    f.close()
    options.time = saved
    return cycles

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-t", "--time", dest="time", default=1,
                      help="How long to sample events")
    parser.add_option("-q", "--quiet",
                      action="store_false", dest="verbose", default=True,
                      help="don't print status messages to stdout")
    
    (options, args) = parser.parse_args()
    cycles_per_sec = measure_cycles()
    c = sample(["cycles", "instructions", "UOPS_ISSUED:ANY:c=1", "UOPS_ISSUED:ANY:c=1:t=1",
                "RESOURCE_STALLS:ANY", "UOPS_RETIRED:ANY:c=1:t=1",
		"UOPS_EXECUTED:PORT015:t=1", "UOPS_EXECUTED:PORT234_CORE",
		"UOPS_ISSUED:ANY:t=1", "UOPS_ISSUED:FUSED:t=1", "UOPS_RETIRED:ANY:t=1",
	        "L1I:CYCLES_STALLED"])
    cycles = c["cycles"] * 1.0
    cycles_no_uops_issued = cycles - c["UOPS_ISSUED:ANY:c=1:t=1"]
    cycles_no_uops_retired = cycles - c["UOPS_RETIRED:ANY:c=1:t=1"]
    backend_stall_cycles = c["RESOURCE_STALLS:ANY"]
    icache_stall_cycles = c["L1I:CYCLES_STALLED"]

    # Cycle stall accounting
    print "Percent idle: %d%%" % ((1 - cycles/(int(options.time) * cycles_per_sec)) * 100)
    print "\tRetirement Stalls: %d%%" % ((cycles_no_uops_retired / cycles) * 100)
    print "\tBackend Stalls: %d%%" % ((backend_stall_cycles / cycles) * 100)
    print "\tFrontend Stalls: %d%%" % ((cycles_no_uops_issued / cycles) * 100)
    print "\tInstruction Starvation: %d%%" % (((cycles_no_uops_issued - backend_stall_cycles)/cycles) * 100)
    print "\ticache stalls: %d%%" % ((icache_stall_cycles/cycles) * 100)

    # Wasted work
    uops_executed = c["UOPS_EXECUTED:PORT015:t=1"] + c["UOPS_EXECUTED:PORT234_CORE"]
    uops_retired = c["UOPS_RETIRED:ANY:t=1"]
    uops_issued = c["UOPS_ISSUED:ANY:t=1"] + c["UOPS_ISSUED:FUSED:t=1"]

    print "\tPercentage useless uops: %d%%" % ((uops_executed - uops_retired) * 100.0/uops_retired)
    print "\tPercentage useless uops issued: %d%%" % ((uops_issued - uops_retired) * 100.0/uops_retired)
