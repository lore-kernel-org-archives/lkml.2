Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab0KPVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:09:29 -0500
Received: from www.tglx.de ([62.245.132.106]:50655 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386Ab0KPVJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:09:25 -0500
Date: Tue, 16 Nov 2010 22:04:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [ANNOUNCE] New utility: 'trace'
Message-ID: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce a new tracing tool called 'trace'.

This tool follows up on Linus's (not so) recent observations that
Linux tracing is still not really offering good tracing tools to
ordinary users. There's no easy to use workflow and the tools that
exist are not expressive enough to solve everyday problem.

After years of efforts we have not succeeded in meeting (let alone
exceeding) the utility of decades-old user-space tracing tools such as
strace - except for a few new good tools such as PowerTop and
LatencyTop.

'trace' is our shot at improving the situation: it aims at providing a
simple to use and straightforward tracing tool based on the perf
infrastructure and on the well-known perf profiling workflow:

   trace record firefox          # trace firefox and all child tasks,
                                   put it into trace.data

   trace summary                 # show quick overview of the trace,
                                   based on trace.data

   trace report                  # detailed traces, based on trace.data

The main workflow approach is to trace once, and then to analyze the
trace in an iterative fashion, by drilling down from a high-level
overview to more and more detailed trace events - with numerous
filtering capabilities available to make this progression effective
and intuitive. (further below there are a number of real examples of
what you can do - but try out the tool to see all the capabilities.)

To try it out, pick up the -tip tree:

   http://people.redhat.com/mingo/tip.git/README

   ( NOTE: you will need to install the audit-libs-dev /
     audit-libs-devel package if you dont have it installed. We'll
     remove this library dependency in a future iteration of the
     tool. )

And do:

   cd tools/perf/
   make -j install

Once you've done that you should have the 'trace' tool available.

Build the -tip kernel and reboot into it to get the most out of the
tool - but even on default kernels it will try to cope. Syscall events
(CONFIG_FTRACE_SYSCALLS=y) is a must for most methods of analysis
though. (with the above -tip tree you'll get it all configured by
default)

If you've booted the new kernel you can run 'trace check' to double
check that all events used by the tool are available:

 $ trace check

 Checking whether the kernel has all required events ...
  ... Checking event  raw_syscalls:sys_enter:r      : ok
  ...
  ... Checking event  sched:sched_stat_runtime:r    : ok
 Good: all required event types are supported by this kernel.
 The 'trace' utility will be fully functional.

The combo diffstat of the tool is appended at the end of the mail. The
overwhelming majority of changes is on the tooling side - it uses
existing perf events facilities and features to implement the tool.

Here's a bit more general description of the 'trace' tool's capabilities:

     - Trace sessions (single tasks or groups of processes/threads
                       (auto-follow), system-wide and per cpu
                       tracing).

     - Unintrusive tracing

     - It will record filterable information about the session:

        * syscalls
        * task lifetime events (fork/clone/exit)
        * pagefaults
	* various mm events (mmap)
	* scheduling events

        * (support for more events is being worked on)

     - Iterative analysis of an existing session/trace without having
       to re-run the trace, with different filters and options (trace
       data is saved on disk)

     - Concurrent and multi-user safe trace recording: multiple users
       can trace, or the same user can trace in multiple different
       tracing sessions.

     - Available to plain users - the permission model is not
       completely done yet, it needs a temporary workaround currently:

	echo -1 > /proc/sys/kernel/perf_event_paranoid

Todo list:

     - Improve output formatting
     - Utilize more events: networking, block IO
     - Add more higher level trace points
     - Implement 'trace diff' utility to simplify the comparison of traces
     - Improve the permission model (work in progress)
     - Implement -p NNN (trace existing pid) option

Main differences to strace:

     - Low impact recording

     - Arguments are printed in plain hex representation, except for
       important arguments like filenames, which are resolved after
       the syscall is recorded.  'trace' wont do full decoding like
       strace does.

     - Ability to record pagefaults and resolve them fully back to
       within the corresponding mapping:

        * file : offset
        * [heap] : offset
        * [stack] : offset
        * [anon] : offset
        * [vdso] : offset

     - Ability to repeat analysis with different filters and options

Here are a few real-life examples of how to use the 'trace' tool.

Firstly, to record a trace, simply prefix whatever command you'd like
to be traced with 'trace record':

  $ trace record firefox
  # trace recorded [2.570 MB] - try 'trace summary' to get an overview

The new trace.data file in the current directory contains the tracing
session, and it can be analyzed after it has been recorded - without
having to repeat tracing again.

For example, you can get a summary of all events:

  $ trace summary

    .--------------------------------.
 __(    Summary of tasks traced       )_______________________________

               [ task - pid ]     [ events ] [ ratio ]  [ runtime ]
 _____________________________________________________________________

       run-mozilla.sh - 1740   :     14108   [ 57.2% ]     37.341 ms
              firefox - 1741   :       851   [  3.5% ]      0.708 ms
                uname - 1742   :       842   [  3.4% ]      0.527 ms
              firefox - 1747   :      1793   [  7.3% ]      3.568 ms
                mkdir - 1748   :       713   [  2.9% ]      1.289 ms
              firefox - 1750   :       497   [  2.0% ]      2.050 ms
                :1751 - 1751   :       368   [  1.5% ]      0.000 ms
                  sed - 1752   :      1034   [  4.2% ]      0.479 ms
                :1753 - 1753   :       494   [  2.0% ]      2.059 ms
                :1754 - 1754   :       377   [  1.5% ]      0.331 ms
                  sed - 1755   :      1035   [  4.2% ]      0.378 ms
       run-mozilla.sh - 1756   :       848   [  3.4% ]      0.467 ms
              dirname - 1757   :       845   [  3.4% ]      0.531 ms
       run-mozilla.sh - 1758   :       840   [  3.4% ]      0.501 ms
 ____________________________________________________________________

                   14   tasks  :     24645   [100.0% ]     50.228 ms
  $

( Note that the table is augmented with colors to highligh
  high-overhead entries and other information. Those colors are not
  visible in the cut & paste screens here :-) )

To get to the detailed trace (see further below about subsystem level
filtering and higher level overview):

 $ trace report

 #
 # trace events of 'firefox':
 #
             firefox/28132 ( 0.000 ms):  ... [continued]: execve() => 0x0
             firefox/28132 ( 0.001 ms): brk(brk: 0x0)                                                          => 0x6e2000
             firefox/28132 ( 0.010 ms): mmap(addr: 0x0, len: 0x1000, prot: 0x3, flags: 0x22, fd: 0xffffffff, off: 0x0) => 0x7fb3f442c000
             firefox/28132 ( 0.006 ms): access(filename: 0x7fb3f422aa60, mode: 0x4) (fpath: /etc/ld.so.preload)  => 0xfffffffffffffffe
             firefox/28132 ( 0.004 ms): open(filename: 0x7fb3f4227f4b, flags: 0x0, mode: 0x1) (fpath: /etc/ld.so.cache)  => 0x3
             firefox/28132 ( 0.001 ms): fstat(3:</etc/ld.so.cache>, statbuf: 0x7fffafe4ef80)                   => 0x0

To see the events of the 'mozilla-xremote' task alone, the -t option
can be used:

  $ trace report -t mozilla-xremote

 ( 0.000 ms):  ... [continued]: clone() => 0x0
 ( 0.003 ms): close(255:<...>)                                                       => 0x0
 ( 0.002 ms): rt_sigprocmask(how: 0x2, set: 0x6e1a60, oset: 0x0, sigsetsize: 0x8)    => 0x0
 ( 0.001 ms): rt_sigaction(sig: 0x14, act: 0x7fffcc4caa80, oact: 0x7fffcc4ca9e0, sigsetsize: 0x8) => 0x0
 ( 0.001 ms): rt_sigaction(sig: 0x15, act: 0x7fffcc4caa80, oact: 0x7fffcc4ca9e0, sigsetsize: 0x8) => 0x0
 ( 0.001 ms): rt_sigaction(sig: 0x16, act: 0x7fffcc4caa90, oact: 0x7fffcc4ca9f0, sigsetsize: 0x8) => 0x0
 ( 0.001 ms): rt_sigaction(sig: 0x2, act: 0x7fffcc4cabb0, oact: 0x7fffcc4cab10, sigsetsize: 0x8) => 0x0
 ( 0.001 ms): rt_sigaction(sig: 0x3, act: 0x7fffcc4cabb0, oact: 0x7fffcc4cab10, sigsetsize: 0x8) => 0x0
 ( 0.001 ms): rt_sigaction(sig: 0x11, act: 0x7fffcc4cabb0, oact: 0x7fffcc4cab10, sigsetsize: 0x8) => 0x0
 ( 0.010 ms): open(filename: 0x6e95b0, flags: 0x241, mode: 0x1b6) (fpath: /dev/null)  => 0x3
 ( 0.001 ms): dup2(oldfd: 0x3, newfd: 0x1)                                           => 0x1
 ( 0.001 ms): close(3:</dev/null>)                                                   => 0x0

Note how the comm/pid column has been collapsed - because there's only
a single task to display - this keeps the output simpler.

But such traces are generally still too large and detailed to be
really suitable for at-a-glance analysis, so 'trace' offers further
filters which allow you to drill down into any traced workload.

For example subsystem filters will output activities of a given kernel
subsystem.

Current subsystems tags are:

   aio, arch-x86, events, fd, fs, fs-attr, IO, IO-locking,
   IPC-locking, IPC-mm, IPC-net, locking, misc, mm, net, process,
   sched, security, signal, stat, system, task, timer, tty.

This is a first rough categorization of events - more is possible and
more will be done. (Suggestions are welcome!)

For example to utilize the 'process' event category, simply add it
after 'trace report':

  $ trace report process

 # (restricting syscalls to: process)
             firefox/ 6722 ( 0.000 ms):  ... [continued]: execve() => 0x0
             firefox/ 6722 ( 0.257 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x0, 0x1a42)                => 0x1a43
            basename/ 6723 ( 0.000 ms):  ... [continued]: clone() => 0x0
            basename/ 6723 ( 0.215 ms): execve(0x6e9c40, 0x6e8d20, 0x6e8b00, 0x7fffcc4ca980, 0x0, 0x0) (fpath: /bin/basename)  => 0x0
            basename/ 6723 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.021 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4cad6c, options: 0x0, ru: 0x0) => 0x1a43
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4ca8dc, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.267 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x0, 0x1a42)                => 0x1a44
      run-mozilla.sh/ 6724 ( 0.000 ms):  ... [continued]: clone() => 0x0
      run-mozilla.sh/ 6724 ( 0.166 ms): execve(0x6ea150, 0x6ea400, 0x6ec660, 0x7fffcc4ca830, 0x0, 0x7f1aa2a611e8) (fpath: /bin/uname)  => 0x0
      run-mozilla.sh/ 6724 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.020 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4cac1c, options: 0x0, ru: 0x0) => 0x1a44
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4ca79c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.246 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x0, 0x1a42)                => 0x1a45
     mozilla-xremote/ 6725 ( 0.000 ms):  ... [continued]: clone() => 0x0
     mozilla-xremote/ 6725 ( 0.204 ms): execve(0x6ef210, 0x6e95d0, 0x6ecda0, 0x7fffcc4caa30, 0x1, 0x2a) (fpath: /usr/lib64//xulrunner-2/mozilla-xremote-client)  => 0x0
     mozilla-xremote/ 6725 ( 0.000 ms): exit_group(error_code: 0x1)                                           
             firefox/ 6722 ( 3.262 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4cac7c, options: 0x0, ru: 0x0) => 0x1a45
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4ca7dc, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.247 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x0, 0x1a42)                => 0x1a46
      run-mozilla.sh/ 6726 ( 0.000 ms):  ... [continued]: clone() => 0x0
      run-mozilla.sh/ 6726 ( 0.150 ms): execve(0x6edca0, 0x6e9ab0, 0x6ecda0, 0x7fffcc4c9ca0, 0x1, 0x7f1aa2a611e8) (fpath: /bin/mkdir)  => 0x0
      run-mozilla.sh/ 6726 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 1.148 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9eec, options: 0x0, ru: 0x0) => 0x1a46
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9a5c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.243 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x0, 0x1a42)                => 0x1a47
             firefox/ 6727 ( 0.000 ms):  ... [continued]: clone() => 0x0
             firefox/ 6727 ( 0.289 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x1a47, 0x1a47)             => 0x1a48
             firefox/ 6728 ( 0.000 ms):  ... [continued]: clone() => 0x0
             firefox/ 6727 ( 0.259 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x1a47, 0x1a47)             => 0x1a49
                 sed/ 6729 ( 0.000 ms):  ... [continued]: clone() => 0x0
             firefox/ 6728 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6727 ( 0.151 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9dfc, options: 0x0, ru: 0x0) => 0x1a48
                 sed/ 6729 ( 0.161 ms): execve(0x6e9ed0, 0x6f25e0, 0x6ecda0, 0x7fffcc4c9bb0, 0x0, 0x0) (fpath: /bin/sed)  => 0x0
                 sed/ 6729 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6727 ( 1.413 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9dfc, options: 0x0, ru: 0x0) => 0x1a49
             firefox/ 6727 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9c1c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6727 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.041 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4ca2bc, options: 0x0, ru: 0x0) => 0x1a47
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9e1c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.264 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x0, 0x1a42)                => 0x1a4a
      run-mozilla.sh/ 6730 ( 0.000 ms):  ... [continued]: clone() => 0x0
      run-mozilla.sh/ 6730 ( 0.277 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x1a4a, 0x1a4a)             => 0x1a4b
               :6731/ 6731 ( 0.000 ms):  ... [continued]: clone() => 0x0
      run-mozilla.sh/ 6730 ( 0.248 ms): clone(0x1200011, 0x0, 0x0, 0x7f1aa32a69f0, 0x1a4a, 0x1a4a)             => 0x1a4c
                 sed/ 6732 ( 0.000 ms):  ... [continued]: clone() => 0x0
               :6731/ 6731 ( 0.000 ms): exit_group(error_code: 0x0)                                           
      run-mozilla.sh/ 6730 ( 0.214 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9fdc, options: 0x0, ru: 0x0) => 0x1a4b
                 sed/ 6732 ( 0.229 ms): execve(0x6e9e50, 0x6f25e0, 0x6ecda0, 0x7fffcc4c9d90, 0x0, 0x0) (fpath: /bin/sed)  => 0x0
                 sed/ 6732 ( 0.000 ms): exit_group(error_code: 0x0)                                           
      run-mozilla.sh/ 6730 ( 1.413 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9fdc, options: 0x0, ru: 0x0) => 0x1a4c
      run-mozilla.sh/ 6730 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9ddc, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
      run-mozilla.sh/ 6730 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.043 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4ca49c, options: 0x0, ru: 0x0) => 0x1a4a
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4ca01c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.174 ms): execve(0x6f0ee0, 0x6f0550, 0x6ef580, 0x7fffcc4cae50, 0x0, 0x0) (fpath: /usr/lib64/firefox-4/run-mozilla.sh)  => 0x0
             firefox/ 6722 ( 0.489 ms): clone(0x1200011, 0x0, 0x0, 0x7f2b57e7d9f0, 0x0, 0x1a42)                => 0x1a4d
            basename/ 6733 ( 0.000 ms):  ... [continued]: clone() => 0x0
            basename/ 6733 ( 0.154 ms): execve(0x6ea830, 0x6eacd0, 0x6e9070, 0x7fffc740ac50, 0x0, 0x7f2b576381e8) (fpath: /bin/basename)  => 0x0
            basename/ 6733 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.020 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffc740b03c, options: 0x0, ru: 0x0) => 0x1a4d
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffc740ab9c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.243 ms): clone(0x1200011, 0x0, 0x0, 0x7f2b57e7d9f0, 0x0, 0x1a42)                => 0x1a4e
      run-mozilla.sh/ 6734 ( 0.000 ms):  ... [continued]: clone() => 0x0
      run-mozilla.sh/ 6734 ( 0.154 ms): execve(0x6ea790, 0x6eabd0, 0x6e9070, 0x7fffc740ac50, 0x0, 0x7f2b576381e8) (fpath: /usr/bin/dirname)  => 0x0
      run-mozilla.sh/ 6734 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.074 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffc740b03c, options: 0x0, ru: 0x0) => 0x1a4e
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffc740ab9c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.237 ms): clone(0x1200011, 0x0, 0x0, 0x7f2b57e7d9f0, 0x0, 0x1a42)                => 0x1a4f
               uname/ 6735 ( 0.000 ms):  ... [continued]: clone() => 0x0
               uname/ 6735 ( 0.158 ms): execve(0x6e9780, 0x6e9b00, 0x6e97a0, 0x7fffc740a330, 0x0, 0x7f2b576381e8) (fpath: /bin/uname)  => 0x0
               uname/ 6735 ( 0.000 ms): exit_group(error_code: 0x0)                                           
             firefox/ 6722 ( 0.020 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffc740a71c, options: 0x0, ru: 0x0) => 0x1a4f
             firefox/ 6722 ( 0.001 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffc740a29c, options: 0x1, ru: 0x0) => 0xfffffffffffffff6
             firefox/ 6722 ( 0.194 ms): execve(0x6f8ae0, 0x6f9c00, 0x6f8ed0, 0x7fffc740a8f0, 0x0, 0x40) (fpath: /usr/lib64/firefox-4/firefox)  => 0x0
             firefox/ 6722 ( 0.000 ms): exit_group(error_code: 0x1)                                           

(Multiple categories can be specified too - for example 'process,io'.)

Note that this is the complete output already, no abbreviations - this
dump alone is already short enough and suitable to get an overview of
what happened in this Firefox session.

Other useful filters are 'trace report io' - this filters out IO
events (syscalls for the time being), or 'trace report fs' to see FS
related activities.

Another common approach to analyzing traces is to figure out which
portion of a trace took the most time. 'trace' allows such analysis
via a duration filter. For example, to see all events that took longer
than 0.5 milliseconds:

  $ trace report -d 0.5

             firefox/ 6722 ( 1.273 ms): read(3:</usr/bin/firefox>, buf: 0x7fffcc4caf40, count: 0x80)           => 0x8
             firefox/ 6722 ( 1.213 ms): read(3:</usr/bin/firefox>, buf: 0x7fffcc4cadf0, count: 0x80)           => 0x7
             firefox/ 6722 ( 3.262 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4cac7c, options: 0x0, ru: 0x0) => 0x1a45
             firefox/ 6722 ( 1.148 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9eec, options: 0x0, ru: 0x0) => 0x1a46
             firefox/ 6722 ( 2.360 ms): read(3:</usr/bin/firefox>, buf: 0x7fffcc4ca490, count: 0x80)           => 0x3
             firefox/ 6727 ( 1.413 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9dfc, options: 0x0, ru: 0x0) => 0x1a49
             firefox/ 6722 ( 2.431 ms): read(3:</usr/bin/firefox>, buf: 0x7fffcc4ca670, count: 0x80)           => 0x6
      run-mozilla.sh/ 6730 ( 1.413 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffcc4c9fdc, options: 0x0, ru: 0x0) => 0x1a4c
             firefox/ 6722 ( 1.054 ms): read(3:</usr/lib64/firefox-4/run-mozilla.sh>, buf: 0x7fffc740b210, count: 0x80) => 0xf
             firefox/ 6722 ( 1.053 ms): read(3:</usr/lib64/firefox-4/run-mozilla.sh>, buf: 0x7fffc740b210, count: 0x80) => 0x15
             firefox/ 6722 ( 1.157 ms): read(3:</usr/lib64/firefox-4/run-mozilla.sh>, buf: 0x7fffc740a8f0, count: 0x80) => 0x6

Another thing that is recorded are page fault events. These can be analyzed via the 
-p option:

  $ trace report -p

  [...]
             firefox/ 6722 ( 0.001 ms):      #PF       4793: [                    g_str_hash]: => /usr/lib64/libgdk-x11-2.0.so.0.2302.0 offset: 0xa5000 page: 165 (R.U)
             firefox/ 6722 ( 0.001 ms):      #PF       4794: [         gdk_event_handler_set]: => /usr/lib64/libgdk-x11-2.0.so.0.2302.0 offset: 0x25bc0 page: 37 (R.U)
             firefox/ 6722 ( 0.001 ms): rt_sigaction(sig: 0xd, act: 0x7fff163c34c0, oact: 0x7fff163c3420, sigsetsize: 0x8) => 0x0
             firefox/ 6722 ( 0.001 ms):      #PF       4795: [                  7f4dddedd860]: => /usr/lib64/libgtk-x11-2.0.so.0.2302.0 offset: 0x72860 page: 114 (R.U)
             firefox/ 6722 ( 0.001 ms):      #PF       4796: [                  7f4dde0163a0]: => /usr/lib64/libgtk-x11-2.0.so.0.2302.0 offset: 0x1ab3a0 page: 427 (R.U)
             firefox/ 6722 ( 0.001 ms):      #PF       4797: [                  7f4dde0163a4]: => [anon 0x7f4dde4ee000] offset: 0x220 page: 0 (R.U)
             firefox/ 6722 ( 0.002 ms):      #PF       4798: [                  7f4dde0163b0]: => [anon 0x7f4dde4ee000] offset: 0x220 page: 0 (W.U)
             firefox/ 6722 ( 0.001 ms):      #PF       4799: [                  7f4dde011c50]: => /usr/lib64/libgtk-x11-2.0.so.0.2302.0 offset: 0x1a6c50 page: 422 (R.U)
  [...]

Note that both data faults and code faults are traced and interpreted
- and if the fault lies in an executable area (binary or shared
library) then the tool will figure out the function that caused the
fault.

The file name of the faulting address is displayed as well, and the
offset into that file.

Here is an example of the 'duration filter', where only events that
took longer than 20 msecs are displayed, including absolute timestamps
(with syscalls, pagefaults and scheduler events included):

 $ trace report -t -P -s -d 20
#
# trace events of 'firefox':
# (duration filter: 20.000 msecs)
#
    29.205       run-mozilla.sh/11425 (22.723 ms): => blocked [state: 0x02 cputime: 0.044 ms #PF: 0] stat(filename: 0x1734860, statbuf: 0x7fff313370b0) (fpath: /usr/lib64/firefox-3.6/firefox)
    32.347       run-mozilla.sh/11425 (25.864 ms): stat(filename: 0x1734860, statbuf: 0x7fff313370b0) (fpath: /usr/lib64/firefox-3.6/firefox)  => 0x0
    69.612      mozilla-plugin-/11428 (23.321 ms): => blocked [state: 0x02 cputime: 0.041 ms #PF: 0] stat(filename: 0x8f1ba0, statbuf: 0x7fff06a44a40) (fpath: /usr/lib64/nspluginwrapper/plugi
    74.800      mozilla-plugin-/11428 (28.509 ms): stat(filename: 0x8f1ba0, statbuf: 0x7fff06a44a40) (fpath: /usr/lib64/nspluginwrapper/plugin-config)  => 0x0
   307.225      mozilla-plugin-/11428 (216.985 ms): => unblock [PF: 0]
   307.238      mozilla-plugin-/11428 (217.002 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fff06a44c7c, options: 0x0, ru: 0x0) => 0x2ca6
   307.459       run-mozilla.sh/11425 (274.198 ms): => unblock [PF: 0]
   307.466       run-mozilla.sh/11425 (274.209 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fff313372ec, options: 0x0, ru: 0x0) => 0x2ca4
   534.117       run-mozilla.sh/11425 (221.398 ms): => unblock [PF: 0]
   534.128       run-mozilla.sh/11425 (221.413 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fff313370ec, options: 0x0, ru: 0x0) => 0x2ca7
   556.522       run-mozilla.sh/11425 (21.759 ms): execve(0x173c110, 0x173b800, 0x173acc0, 0x7fff31337040, 0x0, 0x0) (fpath: /usr/lib64/firefox-3.6/run-mozilla.sh)  => 0x0
   597.105       run-mozilla.sh/11435 (23.718 ms):      #PF         64: [                      __execve]: => /usr/lib64/firefox-3.6/firefox offset: 0x6d8 page: 0 (W.K)
   597.230       run-mozilla.sh/11435 (30.228 ms): execve(0x1a7c860, 0x1a81560, 0x1a88140, 0x7fffd937b050, 0x0, 0x7f30498921e8) (fpath: /usr/lib64/firefox-3.6/firefox)  => 0x0
   628.920       run-mozilla.sh/11435 (20.541 ms): open(filename: 0x7fff35246ec4, flags: 0x0, mode: 0x1b6) (fpath: /etc/gre.d/gre64.conf)  => 0x3
   767.480       run-mozilla.sh/11435 (29.628 ms):      #PF        579: [                        memset]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0x1ce7a0 page: 462 (W.U)
  1179.170       run-mozilla.sh/11435 (26.734 ms): => unblock [PF: 1]
  1179.270       run-mozilla.sh/11435 (26.864 ms):      #PF       2944: [                  7fb7a42db4e0]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0xe814e0 page: 3713 (R.U) ... [unfini
  1179.270       run-mozilla.sh/11435 (26.864 ms): => blocked [state: 0x02 cputime: 0.010 ms #PF: 1] 
  1193.124       run-mozilla.sh/11435 (40.718 ms):      #PF       2944: [                  7fb7a42db4e0]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0xe814e0 page: 3713 (R.U)
  1730.468       run-mozilla.sh/11435 (20.649 ms): access(filename: 0x7fb7a5981040, mode: 0x4) (fpath: /usr/share/X11/locale/en_US.UTF-8/XLC_LOCALE)  => 0x0
  1984.050       run-mozilla.sh/11425 (1417.131 ms): => unblock [PF: 0]
  1984.070       run-mozilla.sh/11425 (1417.155 ms): wait4(upid: 0xffffffffffffffff, stat_addr: 0x7fffd937b32c, options: 0x0, ru: 0x0) => 0x2cab

Here is an example of looking at a specific task (pid 11435),
scheduler events in a timeframe around an interesting event which we
picked from the above duration filtered output.

 $ trace report -t -P -s -f 11435 -T 1152.4,1196
 #
 # trace events of 'firefox':
 #
  1152.401 ( 0.002 ms):      #PF       2942: [                  7fb7a3005e20]: => /usr/lib64/libssl3.so offset: 0x29e20 page: 41 (R.U)
  1152.404 ( 0.001 ms):      #PF       2943: [                  7fb7a39375d0]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0x4dd5d0 page: 1245 (R.U)
  1152.436 ( 0.031 ms):      #PF       2944: [                  7fb7a42db4e0]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0xe814e0 page: 3713 (R.U) ... [unfinished]
  1152.436 ( 0.031 ms): => blocked [state: 0x02 cputime: 0.216 ms #PF: 1] 
  1179.170 (26.734 ms): => unblock [PF: 1]
  1179.270 (26.864 ms): => blocked [state: 0x02 cputime: 0.010 ms #PF: 1] 
  1193.120 (13.850 ms): => unblock [PF: 1]
  1193.124 (40.718 ms):      #PF       2944: [                  7fb7a42db4e0]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0xe814e0 page: 3713 (R.U)
  1193.187 ( 0.061 ms):      #PF       2945: [                  7fb7a42c270c]: => /usr/lib64/xulrunner-1.9.2/libxul.so offset: 0xe6870c page: 3688 (R.U) ... [unfinished]
  1193.187 ( 0.061 ms): => blocked [state: 0x02 cputime: 0.067 ms #PF: 1] 

At this point we'd like to ask for feedback from other users of tracing tools,
which workflow components would you like to see in addition to what the 'trace'
tool is offering?

Comments, bug reports, suggestions welcome,

Thanks,

	Thomas, Ingo
---
 arch/x86/mm/fault.c                                |   32 +-
 fs/namei.c                                         |    7 +-
 include/trace/events/kmem.h                        |   39 +
 include/trace/events/sched.h                       |   80 +
 include/trace/events/vfs.h                         |   32 +
 init/Kconfig                                       |    3 +
 kernel/perf_event.c                                |    2 +-
 kernel/sched.c                                     |    2 +
 kernel/trace/trace.c                               |   17 +
 .../{perf-trace-perl.txt => perf-script-perl.txt}  |   28 +-
 ...erf-trace-python.txt => perf-script-python.txt} |   88 +-
 tools/perf/Documentation/perf-script.txt           |  111 ++
 tools/perf/Documentation/perf-trace.txt            |   96 +-
 tools/perf/Makefile                                |   14 +-
 tools/perf/builtin-lock.c                          |    6 +-
 tools/perf/builtin-record.c                        |   91 +-
 tools/perf/builtin-sched.c                         |    6 +-
 tools/perf/builtin-script.c                        |  826 +++++++++
 tools/perf/builtin-trace.c                         | 1839 +++++++++++++-------
 tools/perf/builtin.h                               |    3 +-
 tools/perf/command-list.txt                        |    1 +
 tools/perf/perf.c                                  |   13 +-
 .../perf/scripts/python/Perf-Trace-Util/Context.c  |    2 +-
 tools/perf/syscall-attr.h                          |  303 ++++
 tools/perf/util/event.c                            |    6 +-
 tools/perf/util/header.c                           |   76 +-
 tools/perf/util/header.h                           |    1 +
 tools/perf/util/map.c                              |   26 +-
 tools/perf/util/parse-events.c                     |   18 +-
 tools/perf/util/parse-events.h                     |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |    6 +-
 .../util/scripting-engines/trace-event-python.c    |    4 +-
 tools/perf/util/session.c                          |   28 +-
 tools/perf/util/session.h                          |    5 +
 34 files changed, 2969 insertions(+), 843 deletions(-)

