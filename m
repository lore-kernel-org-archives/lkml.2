Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2EPO7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:59:35 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52606 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2EPO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:59:34 -0400
Date: Wed, 16 May 2012 11:59:27 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Perf record format portability
Message-ID: <20120516145927.GC7864@infradead.org>
References: <4FB275EB.5050904@linaro.org>
 <20120515155146.GB7864@infradead.org>
 <4FB38677.8070601@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB38677.8070601@linaro.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Jiri and Steven to the CC list.

Em Wed, May 16, 2012 at 02:50:31PM +0400, Dmitry Antipov escreveu:
> On 05/15/2012 07:51 PM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, May 15, 2012 at 07:27:39PM +0400, Dmitry Antipov escreveu:
> >>are there any thoughts on how much of the perf.data is portable and how much it should be?
> >>I'm interesting in recording scheduler activity on one machine and then replaying on
> >>another. As I can see, replaying x86 perf.data on ARM doesn't work. At least, should it
> >>work with a small subset of recorded events (for example, sched:sched_switch,
> >>sched:sched_process_exit, sched:sched_process_fork, sched:sched_wakeup
> >>and sched:sched_migrate_task) on the same architecture?
> >
> >Endianness issues? ARM EB? There are some patches by Jiri Olsa that may
> >help you if that is the case.
> 
> Thanks, will look at.
> 
> >It should be portable, are you using 'perf archive' too?
> 
> It doesn't work with cryptic messages like:
> 
> tar: .build-id/17/d6ca02b2c31df54bf62a4142c47e3c99a9eedf: Cannot stat: No such file or directory

It is a shell script, basically, after yum collect your events with
something like:

[acme@sandy ~]$ perf record -F 10000 sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.021 MB perf.data (~917 samples) ]

The resulting perf.data file will have samples taken on these DSOs,
with those respective hashes identifying each one:

[acme@sandy ~]$ perf buildid-list
4390a3d2dc84c37a8923ba4c910d6766abc42cbf [kernel.kallsyms]
ceb82e745b0ab8bb7ea28c068327be1fb068c923 /lib64/ld-2.12.so
e731c64000993d1fd1b443e6d5d6972d149440e8 /lib64/libc-2.12.so
[acme@sandy ~]$

In your case we can see that it is looking for build id
17d6ca02b2c31df54bf62a4142c47e3c99a9eedf on the build id cache.

Probably you either are running 'perf archive' on a different machine
than the one where you ran 'perf record' or using a different user on
the same machine, or, unlikely, perhaps you removed ~/.debug/ after
'record'.

The 'perf archive' tool was done quickly just as a proof of concept,
admitedly it needs to be improved to help diagnosing these problems.

> creating empty archive.
> 
> >What exactly is the error experienced?
> 
> Now I'm facing the simple problem with event IDs, which may be different from machine to
> machine. For example, /sys/kernel/debug/tracing/events/sched/sched_switch/id is 55 on my ARM
> board and 279 on my PC host, so 'perf report' displays all event names like "unknown:unknown",
> even with --kallsyms=XXX where XXX is 'cat /proc/kallsyms > XXX' from PC host.

With build-ids and 'perf archive' you shouldn't need specifying
kallsyms, it has a build-id and will be collected (record + archive) an
then transfered and expanded on the analysis machine (scp + tar xvf).

The tracing part even stashes a copy of kallsyms in perf.data (not
needed, but there for historical reasons). The problem is in translating
the perf_event_attr.config to the same name and format as in the machine
where you collected the events.`

Steve,

	Was the kernel trace events infrastructure designed with that in
mind? I.e. cross analysis? I must be missing something here, still
ENOCOFFEE :-\

	When doing cross arch event analisys I tested:

        PERF_TYPE_HARDWARE                      = 0,
        PERF_TYPE_SOFTWARE                      = 1,
        PERF_TYPE_HW_CACHE                      = 3,

Not:

        PERF_TYPE_TRACEPOINT                    = 2,
        PERF_TYPE_RAW                           = 4,
        PERF_TYPE_BREAKPOINT                    = 5,

- Arnaldo
