Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab1AMByI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 20:54:08 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:55687 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718Ab1AMByA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 20:54:00 -0500
Message-ID: <4D2E5B33.2080305@linux.vnet.ibm.com>
Date: Wed, 12 Jan 2011 17:53:55 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmU=?= =?UTF-8?B?Y2tlcg==?= 
	<fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [BUG] perf sched broken
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
In-Reply-To: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 01:29 AM, Stephane Eranian wrote:
> Hi,
>
> I am trying to use perf sched from tip-x86 but it fails for all my attempts.
>
> First of, I think the event list is stale. This is not so much the
> events themselves
> but rather the flags.
>
> Looks to me like the :r modifier is not supported anymore, so a patch like the
> one below is needed. That helps collect a trace. But then, you can dump
> the trace.

After looking at this in more detail, I agree with Stephane: the 'r' 
option appears to only be supported for hardware breakpoint events.  My 
patch just causes the 'r' to be properly processed and rejected as a 
legal option.

As I stated elsewhere in this thread, I don't have a problem running the 
perf commands below on a Fedora 14, 2.6.35 kernel, using the perf from 
2.6-tip master or x86/urgent.

I don't have a 2.6.37-tip kernel installed at the moment, but if you 
still think this could be a perf tool bug that occurs only when using it 
with a 2.6.37-tip kernel, let me know and I will devote some time to 
trying it out.

- Corey

>
> $ perf sched rec dd if=/dev/zero of=/dev/null count=1000000
> 1000000+0 records in
> 1000000+0 records out
> 512000000 bytes (512 MB) copied, 0.589981 s, 868 MB/s
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.481 MB perf.data (~20997 samples) ]
>
> $ perf sched rep
> run measurement overhead: 2934 nsecs
> sleep measurement overhead: 90502 nsecs
> the run test took 999149 nsecs
> the sleep test took 1092248 nsecs
>    Fatal: no trace data in the file
>
> $ perf sched trace -D
>   usage: perf sched [<options>] {record|latency|map|replay|trace}
>
>      -i, --input<file>     input file name
>      -v, --verbose         be more verbose (show symbol address, etc)
>      -D, --dump-raw-trace  dump raw trace in ASCII
>
> Note that this is not specific to pref sched. If I use perf record directly,
> I run into the same issue:
> $ perf record -R -a -c 1 -e sched:sched_switch -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.365 MB perf.data (~15962 samples) ]
> $./perf report -D
>    Fatal: no trace data in the file
>
> Now that perf trace is gone, how to I dump the trace?
>
>
> Drop :r modifier for tracepoints
>
> Signed-off-by: Stephane Eranian<eranian@google.com>
> ---
>
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index abd4b84..29e7ffd 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -1843,15 +1843,15 @@ static const char *record_args[] = {
>          "-f",
>          "-m", "1024",
>          "-c", "1",
> -       "-e", "sched:sched_switch:r",
> -       "-e", "sched:sched_stat_wait:r",
> -       "-e", "sched:sched_stat_sleep:r",
> -       "-e", "sched:sched_stat_iowait:r",
> -       "-e", "sched:sched_stat_runtime:r",
> -       "-e", "sched:sched_process_exit:r",
> -       "-e", "sched:sched_process_fork:r",
> -       "-e", "sched:sched_wakeup:r",
> -       "-e", "sched:sched_migrate_task:r",
> +       "-e", "sched:sched_switch",
> +       "-e", "sched:sched_stat_wait",
> +       "-e", "sched:sched_stat_sleep",
> +       "-e", "sched:sched_stat_iowait",
> +       "-e", "sched:sched_stat_runtime",
> +       "-e", "sched:sched_process_exit",
> +       "-e", "sched:sched_process_fork",
> +       "-e", "sched:sched_wakeup",
> +       "-e", "sched:sched_migrate_task",
>   };
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

