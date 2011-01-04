Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961Ab1ADODw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:03:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:46746 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab1ADODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:03:51 -0500
Date: Tue, 4 Jan 2011 12:03:38 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@elte.hu
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing
 improvements
Message-ID: <20110104140338.GA19989@ghostprotocols.net>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
 <20110104071629.GB13299@elte.hu>
 <AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 04, 2011 at 02:59:00PM +0100, Stephane Eranian escreveu:
> Arnaldo,
> 
> The version of perf at tip-x86 commit 9274b36, segfaults for me:
> 
> $ gdb perf
> (gdb) r stat date
> 
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x7fdc602eb6e0 (LWP 4590)]
> cmd_stat (argc=1, argv=0x7fff6fa2a9f0, prefix=<value optimized out>)
> at builtin-stat.c:206
> 206			update_stats(&ps->res_stats[i], count[i]);
> (gdb) bt
> #0  cmd_stat (argc=1, argv=0x7fff6fa2a9f0, prefix=<value optimized
> out>) at builtin-stat.c:206
> #1  0x0000000000405c8b in handle_internal_command (argc=2,
> argv=0x7fff6fa2a9f0) at perf.c:286
> #2  0x00000000004060b0 in main (argc=2, argv=0x7fff6fa2a680) at perf.c:403
> 
> Most like ps is NULL.

[acme@felicio linux]$ perf stat date | head -5
Tue Jan  4 12:03:05 BRST 2011

 Performance counter stats for 'date':

             4,525 cache-misses             #      7.640 M/sec
           343,171 cache-references         #    579.405 M/sec
            14,853 branch-misses            #      8.214 %    
           180,833 branches                 #    305.316 M/sec
           897,837 instructions             #      0.000 IPC    (scaled from 67.67%)
     <not counted> cycles                  
               201 page-faults              #      0.339 M/sec
                 1 CPU-migrations           #      0.002 M/sec
                 1 context-switches         #      0.002 M/sec
          0.592282 task-clock-msecs         #      0.583 CPUs 

        0.001015291  seconds time elapsed

[acme@felicio linux]$

Re-reading the code now, thanks!

- Arnaldo
 
> On Tue, Jan 4, 2011 at 8:16 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> >
> >> Hi Ingo, Peter et al,
> >>
> >>       Trying to simplify using the API for tools and more specifically for
> >> 'perf test' regression tests, please take a look, perhaps starting from the last
> >> changeset, that implements a regression test using the resulting library API.
> >>
> >>       It also reduces the 'perf' tool footprint by not using hard coded array
> >> sizes, more need to be done, but should be a good start, one changeset shows a
> >> good reduction in BSS use.
> >>
> >>       Suggestions for naming most welcome, I thought about using "event__",
> >> but that is taken, "perf_event__", but thought it would clash with "event_t",
> >> so used the jargon used for the '-e' parameters: "Event Selector", but don't
> >> like it that much, what do you think?
> >>
> >>       Writing the first regression test I think there are more ways to simplify,
> >> on top of these, like not requiring a thread_map, i.e. passing NULL for that
> >> parameter would mean: self-monitor, etc.
> >>
> >>         If you are pleased as-is, please pull from:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/test
> >>
> >> Regards,
> >>
> >> - Arnaldo
> >>
> >> Arnaldo Carvalho de Melo (11):
> >>   perf tools: Introduce event selectors
> >>   perf evsel: Adopt MATCH_EVENT macro from 'stat'
> >>   perf util: Move do_read from session to util
> >>   perf evsel: Delete the event selectors at exit
> >>   perf evsel: Steal the counter reading routines from stat
> >>   perf evsel: Introduce per cpu and per thread open helpers
> >>   perf tools: Refactor cpumap to hold nr and the map
> >>   perf tools: Refactor all_tids to hold nr and the map
> >>   perf evsel: Use {cpu,thread}_map to shorten list of parameters
> >>   perf evsel: Auto allocate resources needed for some methods
> >>   perf test: Add test for counting open syscalls
> >>
> >>  tools/perf/Makefile                |    4 +
> >>  tools/perf/builtin-record.c        |  152 +++++++--------
> >>  tools/perf/builtin-stat.c          |  368 +++++++++++++++---------------------
> >>  tools/perf/builtin-test.c          |   83 ++++++++
> >>  tools/perf/builtin-top.c           |  221 ++++++++++++----------
> >>  tools/perf/perf.c                  |    2 +
> >>  tools/perf/util/cpumap.c           |  123 +++++++++---
> >>  tools/perf/util/cpumap.h           |   10 +-
> >>  tools/perf/util/evsel.c            |  186 ++++++++++++++++++
> >>  tools/perf/util/evsel.h            |  115 +++++++++++
> >>  tools/perf/util/header.c           |   15 +-
> >>  tools/perf/util/header.h           |    3 +-
> >>  tools/perf/util/parse-events.c     |   58 ++++--
> >>  tools/perf/util/parse-events.h     |   18 ++-
> >>  tools/perf/util/session.c          |   22 +--
> >>  tools/perf/util/session.h          |    1 -
> >>  tools/perf/util/thread.c           |   43 +++--
> >>  tools/perf/util/thread.h           |   15 ++-
> >>  tools/perf/util/trace-event-info.c |   30 ++--
> >>  tools/perf/util/trace-event.h      |    5 +-
> >>  tools/perf/util/util.c             |   17 ++
> >>  tools/perf/util/util.h             |    1 +
> >>  tools/perf/util/xyarray.c          |   20 ++
> >>  tools/perf/util/xyarray.h          |   20 ++
> >>  24 files changed, 1013 insertions(+), 519 deletions(-)
> >>  create mode 100644 tools/perf/util/evsel.c
> >>  create mode 100644 tools/perf/util/evsel.h
> >>  create mode 100644 tools/perf/util/xyarray.c
> >>  create mode 100644 tools/perf/util/xyarray.h
> >
> > Pulled, thanks a lot Arnaldo!
> >
> >        Ingo
> >
