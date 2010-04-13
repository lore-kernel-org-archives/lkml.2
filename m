Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab0DMSmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 14:42:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0DMSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 14:42:45 -0400
X-Authority-Analysis: v=1.1 cv=1q2Jdmkya6HpgEM2jHRumxnsV1n7rNYmAqK1mJgD7XY= c=1 sm=0 a=Q61JpV_JF5IA:10 a=IkcTkHD0fZMA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=1kAa7RvxoZsrGVbrS_cA:9 a=5bi16x1s1mJWsJHWCjoA:7 a=DjBAgspb7z2BMo7RP96hOTnPAoYA:4 a=QEXdDO2ut3YA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [ANNOUNCE] trace-cmd version 1.0 (binary reader of Ftrace)
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, John Kacur <jkacur@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jake Edge <jake@lwn.net>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, Jiri Olsa <jolsa@redhat.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Apr 2010 14:42:29 -0400
Message-ID: <1271184149.7962.77.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the official announcement of trace-cmd version 1.0.

You can download it from git at;

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
  trace-cmd-stable-v1

To build;

make

To install:

make install

default it will install into /usr/local/... to pick another location:

make prefix=/another/top/level install

to install documentation and man pages:

make install_doc

install_doc can also take the "prefix=" parameter.


Thanks to all that helped out in the pre-release!

What is trace-cmd?
------------------

trace-cmd is a user interface to Ftrace. Instead of needing to use the
debugfs directly, trace-cmd will handle of setting of options and
tracers and will record into a data file.


The record feature of trace-cmd uses the system call "splice". Splice
allows the user space to move pages directly from the Ftrace ring buffer
into a file or network without ever needing to go through userspace.
This move is a zero copy algorithm. A page is removed from the ring
buffer and sent directly to the destination. No copy is required making
the record extremely fast.

This method is even faster than mmap. mmap is quick to get the data from
the kernel to userspace, but if the data is to be saved to a file or to
the network, then a copy is still required to send the data from
userspace back to the kernel.


The trace data format file (see trace-cmd.dat(5)) records all the
necessary data to move the data file to other machines and be able to
read it there. The endianess and long size is also recorded such that
big endian trace data files can be read from little endian machines, and
vice versa.



  trace-cmd [COMMANDS] [OPTIONS]

Here's the basic commands:

============================

  record - this will start a trace and record the data into a tracing 
           file. (default called: trace.dat).

Example:

     trace-cmd record -p function ls /bin

This will enable the function tracer plugin, then exec the "ls" command
and record the trace into a file called 'trace.dat'.

     trace-cmd record -e sched -e 'irq_handler_*' -o mytrace.dat

This will enable the sched system events, the irq_handler_entry and
irq_handler_exit events, and record the data into mytrace.dat. It will
continue to record until Ctrl^C is hit.

     trace-cmd record -p function_graph -e sched_switch hackbench

This will enable the function graph tracer as well as the sched_switch
event and run hackbench, recording the trace into the trace.dat file.

     trace-cmd record -e all

This will enable all events and record into the trace.dat file. A Ctrl^C
is used to stop recording.

===============================

   report - this is used to read the trace data. (default file is 
            trace.dat)

Example:

   trace-cmd report
version = 6
cpus=2
       trace-cmd-25900 [001] 3280035.156957: sys_exit:             NR 42 = 0
              ls-25901 [000] 3280035.156958: sys_exit:             NR 4 = 1
       trace-cmd-25900 [001] 3280035.156966: mm_page_alloc:        page=0xffffea00009c3dc8 pfn=10239432 order=0 migratetype=2 gfp_flags=GFP_HIGHUSER_MOVABLE|GFP_ZERO
       trace-cmd-25900 [001] 3280035.156971: sys_enter:            NR 162 (ff9aec1c, 0, 806c484, 0, 0, ff9aec48)
       trace-cmd-25900 [001] 3280035.156974: hrtimer_init:         hrtimer 0xffff88007ce35ea8, clockid CLOCK_MONOTONIC, mode HRTIMER_MODE_REL
       trace-cmd-25900 [001] 3280035.156980: hrtimer_start:        hrtimer=0xffff88007ce35ea8 function=hrtimer_wakeup expires=3280035157479995 softexpires=3280035157479995

Full filtering is possible:

  trace-cmd report -i mytrace.dat -F 'sched_switch: prev_prio < 100 && next_pid != 0'
version = 6
cpus=2
       trace-cmd-25900 [001] 3280035.157641: sched_switch:         25900:44:S ==> 25901:140: ls
       trace-cmd-25900 [001] 3280035.158231: sched_switch:         25900:44:S ==> 25901:140: ls
       trace-cmd-25899 [000] 3280035.158524: sched_switch:         25899:44:S ==> 29189:120: firefox-bin
       trace-cmd-25900 [001] 3280035.158819: sched_switch:         25900:44:S ==> 25901:140: ls
       trace-cmd-25900 [001] 3280035.159405: sched_switch:         25900:44:S ==> 25901:140: ls

==================================

    start - just starts the tracer without recording.

This is a trace-cmd equivalent to enabling the tracer via debugfs. No
recording is initiated. The data simply stays in the kernel ring buffer
where the older data is overwritten by new data when the ring buffer is
full.

The options are pretty much the same as the trace-cmd record.

Example:

   trace-cmd start -e block -e skb

====================================

   stop - disables writing to the ring buffer

Example:

   trace-cmd stop

The above is equivalent to "echo 0  > tracing_on". It does not disable
tracing, just the writing to the ring buffer, so there still exists
overhead from the tracer.

=====================================

    extract - extract the data from the kernel ring buffer into a  
              trace.dat file

When Ftrace is started either directly by writing into the debugfs
directory, or by using trace-cmd start, then this allows you to pull
that data out of the ring buffer and write it to a trace file (default:
trace.dat).

Example:

    trace-cmd extract -o mytrace.dat

=====================================

    reset - disable all tracing

"trace-cmd stop" only disables writing to the ring buffer, but reset
will disable all tracing and remove the overhead of the tracer. Once
trace-cmd reset is used, all trace data in the kernel ring buffer is
removed, so do not use this if you expect to do an extract.

Example:

   trace-cmd reset

=======================================

     split - split a trace.dat file into smaller files

Sometimes the trace.dat file becomes quite large and only part of the
data is needed. The split command can split create a subset of events
from another trace.dat file. It can pull specific events out based on
time.

Example:

   trace-cmd split -e 1000 156.245232

The above creates a "trace.dat.1" file from trace.dat by saving 1000
events starting at the 156.245232 timestamp in trace.dat.

===========================================

     list - list the available plugins, events and trace options

===========================================

     listen - listen to a port to record trace data from another machine

This works with trace-cmd record -N option. It creates a process
(possible daemon) to listen to traces that are executed from other
machines.

Example:

 On a x86_64 box:

   trace-cmd listen -p 56789

 On a 32bit PPC:

   trace-cmd record -N x86:56789 -p function_graph -e all  mytest

The record -N option takes a "host:port" option and is used instead of
the -o option, and no trace.dat file is created. By default the trace
data is sent via UDP since it is the fastest method, but there is no way
to know if pages are lost. If reliable connection is required, the "-t"
option can be used to force TCP connection. This is reliable, but much
slower than UDP.

For more detailed information, read the man pages.

Have fun!

-- Steve



