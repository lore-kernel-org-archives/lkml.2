Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1BOEpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 23:45:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52971 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab1BOEpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 23:45:00 -0500
Date: Tue, 15 Feb 2011 05:44:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/14] [GIT PULL][v2.6.39] tracing/filter: More robust
 filtering
Message-ID: <20110215044425.GA9994@elte.hu>
References: <20110208015617.902200587@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110208015617.902200587@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Steve,

* Steven Rostedt <rostedt@goodmis.org> wrote:

> Steven Rostedt (14):
>       tracing/filter: Have no filter return a match
>       tracing/filter: Move OR and AND logic out of fn() method
>       tracing/filter: Dynamically allocate preds
>       tracing/filter: Call synchronize_sched() just once for system filters
>       tracing/filter: Allocate the preds in an array
>       tracing/filter: Free pred array on disabling of filter
>       tracing/filter: Use a tree instead of stack for filter_match_preds()
>       tracing/filter: Optimize short ciruit check
>       tracing/filter: Check the created pred tree
>       tracing/filter: Optimize filter by folding the tree
>       tracing/filter: Move MAX_FILTER_PRED to local tracing directory
>       tracing/filter: Increase the max preds to 2^14
>       tracing/filter: Swap entire filter of events
>       tracing/filter: Remove synchronize_sched() from __alloc_preds()

I finally got around testing the various tracing filter features we have.

Here is what i've done. Firstly, i have put my 'naive but curious user trying to 
make use of filters' hat on.

I did:

	perf list | grep Tracepoint | less

to get a list of tracepoints.

 #
 #  Btw., unrelated feature request, it would be nice if the following shorcut did the 
 #  obvious thing:
 #
 #	perf list Tracepoint
 #

I picked one of the interesting looking tracepoints:

  syscalls:sys_enter_close                   [Tracepoint event]

first roadblock: 

I had absolutely no idea how to proceed from here any further. I knew it from 'perf 
list --help' that I could stick 'syscalls:sys_enter_close' into -e expressions, but 
i had no idea how to utilize filter expressions at all.

I could stick it into perf stat though, and it gave me:

 aldebaran:~> perf stat -a -e syscalls:sys_enter_close sleep 1

  Performance counter stats for 'sleep 1':

             12,240 syscalls:sys_enter_close

         1.004366276  seconds time elapsed

Which is fine enough and just about right. Trying something more complex like 
'firefox' seems to mis-count the number of close() syscalls though, when compared 
to 'strace -c':

 aldebaran:~> strace -f -q -c firefox 2>&1 | head
  Error: cannot open display: :0
  % time     seconds  usecs/call     calls    errors syscall
  ...
  32.35    0.000011           0       271         4 close
  ...

 aldebaran:~> perf stat -e syscalls:sys_enter_close firefox
 Error: cannot open display: :0

  Performance counter stats for 'firefox':

                146 syscalls:sys_enter_close

         0.048227674  seconds time elapsed

Note the 271 calls by strace, versus 146 calls by perf. One of them must be wrong - 
or they are counting different things.

Using the syscalls:sys_enter_close event to filter i had to put my kernel hacker hat 
on and do:

 aldebaran:~> cat /debug/tracing/events/syscalls/sys_enter_close/format 
 name: sys_enter_close
 ID: 404
 format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;
	field:int common_lock_depth;	offset:8;	size:4;	signed:1;

	field:int nr;	offset:12;	size:4;	signed:1;
	field:unsigned int fd;	offset:16;	size:8;	signed:0;

 print fmt: "fd: 0x%08lx", ((unsigned long)(REC->fd))

And putting my kernel tracing hacker hat on i knew that the only interesting piece 
of information for a filter would be the 'fd' word.

Putting my naive user hat back on and knowing the 'fd' trick, i tried to filter out 
all close(10) calls from a 'hackbench' run. I knew that they existed:

 aldebaran:~> strace -f ./hackbench 1 2>&1 | grep 'close(10)'
 [pid 15277] close(10)                   = 0

So i first tried to use them in 'perf stat':

 aldebaran:~> perf stat -e syscalls:sys_enter_close --filter 'fd == 10' ./hackbench 1
   Error: unknown option `filter'

Ouch, no go - how come this does not work for perf stat? It makes quite a bit of 
sense to use it there as well.

Anyway, knowing that it might work for 'perf record', i tried it there:

 aldebaran:~> perf record -e syscalls:sys_enter_close --filter 'fd == 10' ./hackbench 1
 Time: 0.079
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.007 MB perf.data (~325 samples) ]

Cool i thought, it has 325 samples, success!

Lets look at it via 'perf report' i thought:

 aldebaran:~> perf report
 aldebaran:~> 

ouch. The TUI flickered something which went away immediately (feature request: 
don't do that - at least try to mumble something about non-existent data or so).

As a naive user i had no idea whether this was a perf report bug or whether i did 
something wrong.

As a kernel hacker i knew that this meant that the events in the perf.data werent 
enough to display anything. As a kernel tracing hacker i knew i had to look at 'perf 
report -D' output:

 aldebaran:~> perf report -D | tail -15
           TOTAL events:        107
            MMAP events:         59
            LOST events:          0
            COMM events:          2
            EXIT events:          3
        THROTTLE events:          0
      UNTHROTTLE events:          0
            FORK events:         40
            READ events:          0
          SAMPLE events:          0
            ATTR events:          0
      EVENT_TYPE events:          0
    TRACING_DATA events:          0
        BUILD_ID events:          0
  FINISHED_ROUND events:          3

ouch - no SAMPLE or TRACING_DATA events at all!

Lets try it without the filter:

 aldebaran:~> perf record -e syscalls:sys_enter_close ./hackbench 1
 Time: 0.043
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.010 MB perf.data (~448 samples) ]
 aldebaran:~> perf report -D | tail -15
           TOTAL events:        148
            MMAP events:         59
            LOST events:          0
            COMM events:          2
            EXIT events:          3
        THROTTLE events:          0
      UNTHROTTLE events:          0
            FORK events:         40
            READ events:          0
          SAMPLE events:         41
            ATTR events:          0
      EVENT_TYPE events:          0
    TRACING_DATA events:          0
        BUILD_ID events:          0
  FINISHED_ROUND events:          3

Got 41 SAMPLE events there.

So the --filter stuff does not seem to work at all for syscall events.

I tried my luck with another event: irq:irq_handler_entry. This seemed to work better:

aldebaran:~> perf record -a -e irq:irq_handler_entry sleep 1; perf report -D | tail -15[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.335 MB perf.data (~14630 samples) ]
           TOTAL events:       4635
            MMAP events:       2689
            LOST events:          0
            COMM events:        548
            EXIT events:         64
        THROTTLE events:          0
      UNTHROTTLE events:          0
            FORK events:         31
            READ events:          0
          SAMPLE events:       1299
            ATTR events:          0
      EVENT_TYPE events:          0
    TRACING_DATA events:          0
        BUILD_ID events:          0
  FINISHED_ROUND events:          4

and produced a real trace:

         swapper-0     [000] 49985.641036: irq_handler_entry: irq=16 name=uhci_hcd:usb3
         swapper-0     [000] 49985.641038: irq_handler_entry: irq=16 name=eth2
          distcc-20461 [000] 49985.641088: irq_handler_entry: irq=16 name=uhci_hcd:usb3
          distcc-20461 [000] 49985.641090: irq_handler_entry: irq=16 name=eth2
         swapper-0     [000] 49985.641140: irq_handler_entry: irq=16 name=uhci_hcd:usb3
         swapper-0     [000] 49985.641141: irq_handler_entry: irq=16 name=eth2
         swapper-0     [000] 49985.641186: irq_handler_entry: irq=16 name=uhci_hcd:usb3

So i thought i could finally test all the cool --filter stuff!

I wanted to trace the timer irq, so i tried:

aldebaran:~> perf record -a -e irq:irq_handler_entry --filter 'irq==0' sleep 1; perf report -D | tail -15
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.744 MB perf.data (~32519 samples) ]
           TOTAL events:      10360
            MMAP events:       6870
            LOST events:          0
            COMM events:       1205
            EXIT events:       1332
        THROTTLE events:          0
      UNTHROTTLE events:          0
            FORK events:        656
            READ events:          0
          SAMPLE events:        293
            ATTR events:          0
      EVENT_TYPE events:          0
    TRACING_DATA events:          0
        BUILD_ID events:          0
  FINISHED_ROUND events:          4

I had to do the -D trick because otherwise I had no idea whether there were any REAL 
samples recorded...

But 'perf script' output gave me:

             cc1-27479 [000] 50100.959394: irq_handler_entry: irq=16 name=eth2
             cc1-27479 [000] 50100.959636: irq_handler_entry: irq=16 name=uhci_hcd:usb3
             cc1-27479 [000] 50100.959638: irq_handler_entry: irq=16 name=eth2
             cc1-27479 [000] 50100.959711: irq_handler_entry: irq=0 name=timer
             cc1-27479 [000] 50100.959880: irq_handler_entry: irq=16 name=uhci_hcd:usb3
             cc1-27479 [000] 50100.959883: irq_handler_entry: irq=16 name=eth2

Hm, filtering didnt work. Lets try to filter only that irq 16 thing then:

 aldebaran:~> perf record -a -e irq:irq_handler_entry --filter 'irq==16' sleep 1; perf report -D | tail -15
 [ perf record: Woken up 1 times to write data ]
 [ perf record: Captured and wrote 0.299 MB perf.data (~13053 samples) ]
           TOTAL events:       4118
            MMAP events:       2993
            LOST events:          0
            COMM events:        589
            EXIT events:        144
        THROTTLE events:          0
      UNTHROTTLE events:          0
            FORK events:         73
            READ events:          0
          SAMPLE events:        314
            ATTR events:          0
      EVENT_TYPE events:          0
    TRACING_DATA events:          0
        BUILD_ID events:          0
  FINISHED_ROUND events:          5

Ok, this finally seems to have worked! I saw:

             cc1-3833  [000] 50250.934705: irq_handler_entry: irq=16 name=uhci_hcd:usb3
             cc1-3833  [000] 50250.934708: irq_handler_entry: irq=16 name=eth2
              as-3834  [000] 50250.943321: irq_handler_entry: irq=16 name=uhci_hcd:usb3
              as-3834  [000] 50250.943325: irq_handler_entry: irq=16 name=eth2
              as-3834  [000] 50250.943367: irq_handler_entry: irq=16 name=uhci_hcd:usb3

Except that it didnt - sometimes the trace started with:

             cc1-3833  [000] 50250.916784: irq_handler_entry: irq=19 name=ahci
             cc1-3833  [000] 50250.916790: irq_handler_entry: irq=19 name=uhci_hcd:usb7
             cc1-3833  [000] 50250.917680: irq_handler_entry: irq=0 name=timer
             cc1-3833  [000] 50250.918112: irq_handler_entry: irq=19 name=ahci
             cc1-3833  [000] 50250.918119: irq_handler_entry: irq=19 name=uhci_hcd:usb7
             cc1-3833  [000] 50250.930152: irq_handler_entry: irq=16 name=uhci_hcd:usb3
             cc1-3833  [000] 50250.930156: irq_handler_entry: irq=16 name=eth2
             cc1-3833  [000] 50250.930367: irq_handler_entry: irq=16 name=uhci_hcd:usb3
             cc1-3833  [000] 50250.930369: irq_handler_entry: irq=16 name=eth2

ouch - both irq 19 and irq 0 entries there - clearly not what i expected to see.

Anyway, i ignored the extra lines i did not want to see and tried to use the filter 
stuff some more, to match on the 'name' field. Wanting to see both usb3 and usb7 
interrupts i typed the obvious:

  aldebaran:~> perf record -a -e irq:irq_handler_entry --filter 'name==uhci_hcd:usb' sleep 1

But got nothing but a (not so obvious) timer irq:

  aldebaran:~> perf script
            :32749-32749 [000] 50514.340198: irq_handler_entry: irq=0 name=timer

Ok, i thought "these guys must be doing this via wildcards, lets try that":

  aldebaran:~> perf record -a -e irq:irq_handler_entry --filter 'name==uhci_hcd:usb*'

That didnt work either.

So ... i have to say that this tracing filter business is unusable crap from a user 
POV right now and i see no reason to pull *anything* in this area until it does not 
get improved to *much* better levels of usability and utility.

Nobody could *ever* have tested this with a 'naive but curious user' hat on and this 
is really sad. We need to do much better!

Thanks,

	Ingo
