Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab2HXNc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:32:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63704 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2HXNcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:32:22 -0400
MIME-Version: 1.0
In-Reply-To: <1344344165-369636-1-git-send-email-avagin@openvz.org>
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
Date: Fri, 24 Aug 2012 17:32:21 +0400
Message-ID: <CANaxB-wXqqoE3oO81qTgQaAX5ipg4WwVrDOaxLaj-ehW8UsHZg@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: Teach perf tool to profile sleep times (v2)
From: Andrey Wagin <avagin@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnaldo,

What do you think about this series?

It has been fixed according with your comments to the previous
patches. Are you going to take it?

2012/8/7 Andrew Vagin <avagin@openvz.org>:
> This functionality helps to analize where a task sleeps or waits locks.
> This feature can help to investigate a scalability problems.
>
> The main idea is that we can combine sched_switch and sched_stat_sleep events.
> sched_switch contains a callchain, when a task starts sleeping.
> sched_stat_sleep contains a time period for which a task slept.
>
> This series teaches "perf inject" to combine this events.
>
> All kernel related patches were committed committed in 3.6-rc1.
>
> Here is an example of a report:
> $ cat ~/foo.c
> ....
>           for (i = 0; i <  10; i++) {
>                   ts1.tv_sec = 0;
>                   ts1.tv_nsec = 10000000;
>                   nanosleep(&ts1, NULL);
>
>                   tv1.tv_sec = 0;
>                   tv1.tv_usec = 40000;
>                   select(0, NULL, NULL, NULL,&tv1);
>           }
> ...
>
> $ ./perf record -e sched:sched_stat_sleep -e sched:sched_switch \
>                 -e sched:sched_process_exit -gP -o ~/perf.data.raw ~/foo
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.015 MB /root/perf.data.raw (~661 samples) ]
> $ ./perf inject -v -s -i ~/perf.data.raw -o ~/perf.data
> $ ./perf report -i ~/perf.data
> # Samples: 40  of event 'sched:sched_switch'
> # Event count (approx.): 1005527702
> #
> # Overhead  Command      Shared Object          Symbol
> # ........  .......  .................  ..............
> #
>    100.00%      foo  [kernel.kallsyms]  [k] __schedule
>                 |
>                 --- __schedule
>                     schedule
>                    |
>                    |--79.81%-- schedule_hrtimeout_range_clock
>                    |          schedule_hrtimeout_range
>                    |          poll_schedule_timeout
>                    |          do_select
>                    |          core_sys_select
>                    |          sys_select
>                    |          system_call_fastpath
>                    |          __select
>                    |          __libc_start_main
>                    |
>                     --20.19%-- do_nanosleep
>                               hrtimer_nanosleep
>                               sys_nanosleep
>                               system_call_fastpath
>                               __GI___libc_nanosleep
>                               __libc_start_main
>
> Andrew Vagin (3):
>   perf: teach "perf inject" to work with files
>   perf: teach perf inject to merge sched_stat_* and sched_switch events
>   perf: mark a dso if it's used
>
>  tools/perf/builtin-inject.c |  139 ++++++++++++++++++++++++++++++++++++++++---
>  tools/perf/util/build-id.c  |    2 +-
>  tools/perf/util/build-id.h  |    5 ++
>  3 files changed, 137 insertions(+), 9 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
