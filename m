Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1ADOaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:30:05 -0500
Received: from smtp-out.google.com ([74.125.121.67]:46143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1ADOaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cdh4G3zZeV5Sd9eubJ9LIc/u7dNwJ8DpOsqe5OvHOzI08tXlq/FgM7ImF1vg5uzvwp
         s7fQYn/qhVuw931NeAIQ==
MIME-Version: 1.0
In-Reply-To: <20110104141958.GC19989@ghostprotocols.net>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
	<20110104071629.GB13299@elte.hu>
	<AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
	<20110104140338.GA19989@ghostprotocols.net>
	<AANLkTi=osr9ZB9OzPxZ_99FU1A5JzCA3rMM64fxws34S@mail.gmail.com>
	<20110104141958.GC19989@ghostprotocols.net>
Date: Tue, 4 Jan 2011 15:29:59 +0100
Message-ID: <AANLkTi=uYpdirz_iJUNJoGcsG9_j0Uj+1H_O9bGQfUe+@mail.gmail.com>
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing improvements
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Indeed counts is bogus:

./perf stat -i -e cycles date

evt:0x7d4250 counts=0x7d4450 <-- from perf_evsel__alloc_counts()

Tue Jan  4 15:28:36 CET 2011

counter=0x7d4250 counts=(nil) <-- from read_counter_aggr()

Segmentation fault


On Tue, Jan 4, 2011 at 3:19 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Tue, Jan 04, 2011 at 03:09:08PM +0100, Stephane Eranian escreveu:
>> Arnaldo,
>> Looks like what's wrong is not ps but count:
>>
>> Program received signal SIGSEGV, Segmentation fault.
>> [Switching to Thread 0x7f96967fd6e0 (LWP 5156)]
>> 0x0000000000412b58 in read_counter_aggr (counter=0x7d4820) at builtin-stat.c:206
>> 206                   update_stats(&ps->res_stats[i], count[i]);
>> (gdb) print ps
>> $1 = (struct perf_stat *) 0x7d48a0
>> (gdb) print *ps
>> $2 = {res_stats = {{n = 0, mean = 0, M2 = 0}, {n = 0, mean = 0, M2 =
>> 0}, {n = 0, mean = 0, M2 = 0}}}
>> (gdb) print count
>> $3 = (u64 *) 0x12
>> (gdb) print *count
>> Cannot access memory at address 0x12
>> (gdb) print count
>> $4 = (u64 *) 0x12
>
> Count is:
>
> u64 *count = counter->counts->aggr.values;
>
> And counter->counts type is:
>
> struct perf_counts_values {
>        union {
>                struct {
>                        u64 val;
>                        u64 ena;
>                        u64 run;
>                };
>                u64 values[3];
>        };
> };
>
> struct perf_counts {
>        s8                        scaled;
>        struct perf_counts_values aggr;
>        struct perf_counts_values cpu[];
> };
>
> So for counter->counts->aggr.values to be 0x12 counter->counts must be
> NULL...
>
>>
>> On Tue, Jan 4, 2011 at 3:03 PM, Arnaldo Carvalho de Melo
>> <acme@infradead.org> wrote:
>> > Em Tue, Jan 04, 2011 at 02:59:00PM +0100, Stephane Eranian escreveu:
>> >> Arnaldo,
>> >>
>> >> The version of perf at tip-x86 commit 9274b36, segfaults for me:
>> >>
>> >> $ gdb perf
>> >> (gdb) r stat date
>> >>
>> >> Program received signal SIGSEGV, Segmentation fault.
>> >> [Switching to Thread 0x7fdc602eb6e0 (LWP 4590)]
>> >> cmd_stat (argc=1, argv=0x7fff6fa2a9f0, prefix=<value optimized out>)
>> >> at builtin-stat.c:206
>> >> 206                   update_stats(&ps->res_stats[i], count[i]);
>> >> (gdb) bt
>> >> #0  cmd_stat (argc=1, argv=0x7fff6fa2a9f0, prefix=<value optimized
>> >> out>) at builtin-stat.c:206
>> >> #1  0x0000000000405c8b in handle_internal_command (argc=2,
>> >> argv=0x7fff6fa2a9f0) at perf.c:286
>> >> #2  0x00000000004060b0 in main (argc=2, argv=0x7fff6fa2a680) at perf.c:403
>> >>
>> >> Most like ps is NULL.
>> >
>> > [acme@felicio linux]$ perf stat date | head -5
>> > Tue Jan  4 12:03:05 BRST 2011
>> >
>> >  Performance counter stats for 'date':
>> >
>> >             4,525 cache-misses             #      7.640 M/sec
>> >           343,171 cache-references         #    579.405 M/sec
>> >            14,853 branch-misses            #      8.214 %
>> >           180,833 branches                 #    305.316 M/sec
>> >           897,837 instructions             #      0.000 IPC    (scaled from 67.67%)
>> >     <not counted> cycles
>> >               201 page-faults              #      0.339 M/sec
>> >                 1 CPU-migrations           #      0.002 M/sec
>> >                 1 context-switches         #      0.002 M/sec
>> >          0.592282 task-clock-msecs         #      0.583 CPUs
>> >
>> >        0.001015291  seconds time elapsed
>> >
>> > [acme@felicio linux]$
>> >
>> > Re-reading the code now, thanks!
>> >
>> > - Arnaldo
>> >
>> >> On Tue, Jan 4, 2011 at 8:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >> >
>> >> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
>> >> >
>> >> >> Hi Ingo, Peter et al,
>> >> >>
>> >> >>       Trying to simplify using the API for tools and more specifically for
>> >> >> 'perf test' regression tests, please take a look, perhaps starting from the last
>> >> >> changeset, that implements a regression test using the resulting library API.
>> >> >>
>> >> >>       It also reduces the 'perf' tool footprint by not using hard coded array
>> >> >> sizes, more need to be done, but should be a good start, one changeset shows a
>> >> >> good reduction in BSS use.
>> >> >>
>> >> >>       Suggestions for naming most welcome, I thought about using "event__",
>> >> >> but that is taken, "perf_event__", but thought it would clash with "event_t",
>> >> >> so used the jargon used for the '-e' parameters: "Event Selector", but don't
>> >> >> like it that much, what do you think?
>> >> >>
>> >> >>       Writing the first regression test I think there are more ways to simplify,
>> >> >> on top of these, like not requiring a thread_map, i.e. passing NULL for that
>> >> >> parameter would mean: self-monitor, etc.
>> >> >>
>> >> >>         If you are pleased as-is, please pull from:
>> >> >>
>> >> >> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/test
>> >> >>
>> >> >> Regards,
>> >> >>
>> >> >> - Arnaldo
>> >> >>
>> >> >> Arnaldo Carvalho de Melo (11):
>> >> >>   perf tools: Introduce event selectors
>> >> >>   perf evsel: Adopt MATCH_EVENT macro from 'stat'
>> >> >>   perf util: Move do_read from session to util
>> >> >>   perf evsel: Delete the event selectors at exit
>> >> >>   perf evsel: Steal the counter reading routines from stat
>> >> >>   perf evsel: Introduce per cpu and per thread open helpers
>> >> >>   perf tools: Refactor cpumap to hold nr and the map
>> >> >>   perf tools: Refactor all_tids to hold nr and the map
>> >> >>   perf evsel: Use {cpu,thread}_map to shorten list of parameters
>> >> >>   perf evsel: Auto allocate resources needed for some methods
>> >> >>   perf test: Add test for counting open syscalls
>> >> >>
>> >> >>  tools/perf/Makefile                |    4 +
>> >> >>  tools/perf/builtin-record.c        |  152 +++++++--------
>> >> >>  tools/perf/builtin-stat.c          |  368 +++++++++++++++---------------------
>> >> >>  tools/perf/builtin-test.c          |   83 ++++++++
>> >> >>  tools/perf/builtin-top.c           |  221 ++++++++++++----------
>> >> >>  tools/perf/perf.c                  |    2 +
>> >> >>  tools/perf/util/cpumap.c           |  123 +++++++++---
>> >> >>  tools/perf/util/cpumap.h           |   10 +-
>> >> >>  tools/perf/util/evsel.c            |  186 ++++++++++++++++++
>> >> >>  tools/perf/util/evsel.h            |  115 +++++++++++
>> >> >>  tools/perf/util/header.c           |   15 +-
>> >> >>  tools/perf/util/header.h           |    3 +-
>> >> >>  tools/perf/util/parse-events.c     |   58 ++++--
>> >> >>  tools/perf/util/parse-events.h     |   18 ++-
>> >> >>  tools/perf/util/session.c          |   22 +--
>> >> >>  tools/perf/util/session.h          |    1 -
>> >> >>  tools/perf/util/thread.c           |   43 +++--
>> >> >>  tools/perf/util/thread.h           |   15 ++-
>> >> >>  tools/perf/util/trace-event-info.c |   30 ++--
>> >> >>  tools/perf/util/trace-event.h      |    5 +-
>> >> >>  tools/perf/util/util.c             |   17 ++
>> >> >>  tools/perf/util/util.h             |    1 +
>> >> >>  tools/perf/util/xyarray.c          |   20 ++
>> >> >>  tools/perf/util/xyarray.h          |   20 ++
>> >> >>  24 files changed, 1013 insertions(+), 519 deletions(-)
>> >> >>  create mode 100644 tools/perf/util/evsel.c
>> >> >>  create mode 100644 tools/perf/util/evsel.h
>> >> >>  create mode 100644 tools/perf/util/xyarray.c
>> >> >>  create mode 100644 tools/perf/util/xyarray.h
>> >> >
>> >> > Pulled, thanks a lot Arnaldo!
>> >> >
>> >> >        Ingo
>> >> >
>> >
>
