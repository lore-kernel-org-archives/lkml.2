Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2HHAi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 20:38:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65263 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2HHAi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 20:38:27 -0400
X-AuditID: 9c930197-b7b66ae000006a2c-9e-5021b500e9ac
From: Namhyung Kim <namhyung@kernel.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/4] perf: Teach perf tool to profile sleep times (v2)
References: <1344344165-369636-1-git-send-email-avagin@openvz.org>
Date: Wed, 08 Aug 2012 09:32:26 +0900
In-Reply-To: <1344344165-369636-1-git-send-email-avagin@openvz.org> (Andrew
	Vagin's message of "Tue, 7 Aug 2012 16:56:01 +0400")
Message-ID: <87mx26z0it.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew

On Tue,  7 Aug 2012 16:56:01 +0400, Andrew Vagin wrote:
> This functionality helps to analize where a task sleeps or waits locks.
> This feature can help to investigate a scalability problems.
>
Looks like a nice feature.


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
> 		-e sched:sched_process_exit -gP -o ~/perf.data.raw ~/foo
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.015 MB /root/perf.data.raw (~661 samples) ]
> $ ./perf inject -v -s -i ~/perf.data.raw -o ~/perf.data
> $ ./perf report -i ~/perf.data

The usage like this is too specific and hard to use IMHO. How about
putting it somehow into perf sched or new command?

/me don't have an idea though. :-)


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

Seems to be outdated.

Thanks,
Namhyung


>  tools/perf/builtin-inject.c |  139 ++++++++++++++++++++++++++++++++++++++++---
>  tools/perf/util/build-id.c  |    2 +-
>  tools/perf/util/build-id.h  |    5 ++
>  3 files changed, 137 insertions(+), 9 deletions(-)
