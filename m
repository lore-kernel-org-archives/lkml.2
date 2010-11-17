Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934835Ab0KQMsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 07:48:09 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35439 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934824Ab0KQMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 07:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=TsgiVQW7b5jt7PlBLltF0yw9iqSCrYI6/tqPbPyZGq7S/bd0FH+lafMM0aw7DxQgj6
         geMWlUz+GN3Xe5xTIwHNrn0zsBpLcqk/oSFjbjB+Udza9icDSRwVoFfubWYKzRYFw9V5
         3YtxtqoFED7UvvPJ8bHL9d2VWxRMasKw0iDlk=
Date: Wed, 17 Nov 2010 14:47:58 +0200
From: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [ANNOUNCE] New utility: 'trace'
Message-ID: <20101117144758.38bf4f05@deb0>
In-Reply-To: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 22:04:40 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> After years of efforts we have not succeeded in meeting (let alone
> exceeding) the utility of decades-old user-space tracing tools such as
> strace - except for a few new good tools such as PowerTop and
> LatencyTop.
> 
> 'trace' is our shot at improving the situation: it aims at providing a
> simple to use and straightforward tracing tool based on the perf
> infrastructure and on the well-known perf profiling workflow:

Interesting, I just tried it using the -tip kernel.
Looks like a good start, but there are some features I'm missing, see below.

> The combo diffstat of the tool is appended at the end of the mail.

How did you generate that? In other words is there a git command I can
use to apply the mm_pagefault/vfs_getname/trace patches on top of
2.6.36? Doing a git merge tip/tmp.perf/trace merged 2.6.37 for me.
For now I'm running a -tip kernel to test.

>      - Unintrusive tracing

Nice! At a quick glance it didn't seem to impact performance much, I'll
have to do some measurements.

> 
>      - It will record filterable information about the session:
> 
>         * syscalls

There is no strace-like "not finished":
               clamd/11086 ( 0.000 ms): pread(0x9, 0x7f142f7f1000, 0x2000, 0xa8000, 0x2000, 0xa8)              => 0x1
               clamd/11087 ( 0.014 ms): futex(uaddr: 0x7f143fad3260, op: 0x80, val: 0x2, utime: 0x0, uaddr2: 0x7f143fad3260, val3: 0x2b4f) => 0x0
               clamd/11087 ( 0.001 ms): futex(uaddr: 0x7f143fad3260, op: 0x81, val: 0x1, utime: 0xfe0, uaddr2: 0x7f143fad3260, val3: 0x2b4f) => 0x0
               clamd/11086 ( 0.011 ms):  ... [continued]: pread() =>          0x2000

I assume that the first pread with 0ms time got interrupted, and it resumed/continued later. Is that the case?
Is the 0x1 return value bogus then? If so it would be less confusing if you output what strace usually does (".. not finished" IIRC).

>         * task lifetime events (fork/clone/exit)
>         * pagefaults
> 	* various mm events (mmap)
> 	* scheduling events
> 
>         * (support for more events is being worked on)

Is it possible to use 'trace record' and 'perf record' at the same time?
I.e to do both strace-like (trace) and oprofile-like (perf record)
recording?

> 
>      - Iterative analysis of an existing session/trace without having
>        to re-run the trace, with different filters and options (trace
>        data is saved on disk)
> 
>      - Concurrent and multi-user safe trace recording: multiple users
>        can trace, or the same user can trace in multiple different
>        tracing sessions.
> 
>      - Available to plain users - the permission model is not
>        completely done yet, it needs a temporary workaround currently:
> 
> 	echo -1 > /proc/sys/kernel/perf_event_paranoid

I see --call-graph in the trace record -h output, but it doesn't seem to work on x86_64 for me.
Do I need to pass some additional parameters to trace report, do I need additional CONFIG_ turned on?
I have:
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_STACKTRACE=y
CONFIG_USER_STACKTRACE_SUPPORT=y
# CONFIG_STACK_TRACER is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set

Does it use the same code for callgraphs as ftrace, so I could choose userspace stacktrace?

> 
> Todo list:
> 
>      - Improve output formatting
>      - Utilize more events: networking, block IO
>      - Add more higher level trace points
>      - Implement 'trace diff' utility to simplify the comparison of
> traces
>      - Improve the permission model (work in progress)
>      - Implement -p NNN (trace existing pid) option

1. I miss sorting. 
Sure I can do something like this: trace report -d <N> |
sort -g -k2 -t\(, but I have to choose <N> first, and it has to output
all the data before sorting can begin (including the text part).
It would be better if I 'trace' itself could sort based on the syscall
latency time, and show me the slowest syscalls first.

2. Another feature I miss is ability to sum up syscall times per syscall, and output a summary.

3. The -s output is not very intuitive, the sched tracer output in /sys/debug/tracing was more intuitive IIRC,
showing that you swithced from process A to process B. I would like to see that in the -s output
(and if switching to a process not traced, it should say so).

4. Also it would be useful to know if during a long syscall (futex, pread, etc.) the CPU time was wasted, or 
another thread of same process got scheduled in. Calculating the overhead of doing that would be interesting too.
I think this could be done with a tool that postprocesses the results, but maybe its easier to do in the tool itself.
For example:
 thread1: futex(...) [... not finished]
 thread2: (delta1 ms) ... scheduled in place of thread1 (switch thread1 -> thread2)
 thread2: ... do stuff ...
 thread1: (delta2 ms) ... scheduled in place of thread2 (switch thread2 -> thread1)
 thread1: (delta3 ms) [... continued] futex() => ...

I would be interested to see delta1, and delta2, perhaps totalled up per syscall, per thread or per process. 

5. Also it would be good if it could tell what a futex is used for:
  1122.567                clamd/11082 (139.120 ms): futex(uaddr: 0x1b59d44, op: 0x80, val: 0x883, utime: 0x0, uaddr2: 0x0, val3: 0x441) => 0x0
  1712.922                clamd/11082 (309.925 ms): futex(uaddr: 0x1b59d44, op: 0x80, val: 0x891, utime: 0x0, uaddr2: 0x0, val3: 0x448) => 0x0
  2014.289                clamd/11082 (244.312 ms): futex(uaddr: 0x1b59d44, op: 0x80, val: 0x895, utime: 0x0, uaddr2: 0x0, val3: 0x44a) => 0x0
  3639.956                clamd/11082 (104.370 ms): futex(uaddr: 0x1b59d44, op: 0x80, val: 0x919, utime: 0x0, uaddr2: 0x0, val3: 0x48c) => 0x0
  4371.086                clamd/11082 (158.304 ms): futex(uaddr: 0x1b59d44, op: 0x80, val: 0x951, utime: 0x0, uaddr2: 0x0, val3: 0x4a8) => 0x0
  5204.773                clamd/11082 (133.566 ms): futex(uaddr: 0x1b59d44, op: 0x80, val: 0x999, utime: 0x0, uaddr2: 0x0, val3: 0x4cc) => 0x0

Using /proc/`pidof clamd`/maps I found out that 0x1b59d44 is on the heap. Such large delays are probably
due to a pthread_cond_wait/cond_timed_wait, and after spending a bit of time in gdb I found out exactly which condition var it is:
(gdb) p &thr_pool->queueable_bulk_cond.__data.__futex
$10 = (unsigned int *) 0x1b59d44

But I don't want to repeat that for each futex call with a different address.
It would be good if 'trace' could figure out what kind of futex wait this is (i.e. mutex lock or condition variable wait), I hope
the kernel has a wait to tell them apart. 
Large delays for waiting on condition variables is expected, and I want to exclude them from my trace.
However I do want to see if there are large delays on mutex locks, that is definetely something I am interested in.
Now of course 'strace' can't make the difference between these two, but 'trace' being a kernel feature might have more information.

Of course it'd be even better if it could show the name of the condition variable, but if the condition variable is on the heap that is hard to do.
I'll have to see if there is a way to script gdb to lookup the variable associated with an address (by looking through the local and global vars on the current thread).

> 
> Main differences to strace:
> 
>      - Low impact recording
> 
>      - Arguments are printed in plain hex representation, except for
>        important arguments like filenames, which are resolved after
>        the syscall is recorded.  'trace' wont do full decoding like
>        strace does.

Did you consider providing a tool to post-process the output and
perform that decoding?

> Another thing that is recorded are page fault events. These can be
> analyzed via the -p option:

  Error: switch `p' requires a value
-P works though.

Best regards,
--Edwin
