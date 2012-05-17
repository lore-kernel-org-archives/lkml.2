Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343Ab2EQJFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:05:33 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:48579 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912Ab2EQJF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:05:28 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-48-4fb4bf54c387
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Revert 'perf evlist: Fix creation of cpu map'
References: <1337161549-9870-1-git-send-email-namhyung.kim@lge.com>
	<1337161549-9870-2-git-send-email-namhyung.kim@lge.com>
	<20120516152619.GD7864@infradead.org>
	<87txzf18yb.fsf@sejong.aot.lge.com>
Date: Thu, 17 May 2012 18:03:37 +0900
In-Reply-To: <87txzf18yb.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Thu, 17 May 2012 17:57:16 +0900")
Message-ID: <87pqa318nq.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 17 May 2012 17:57:16 +0900, Namhyung Kim wrote:
> On Wed, 16 May 2012 12:26:19 -0300, Arnaldo Carvalho de Melo wrote:
>> I'm applying it, but while trying to figure out if the logic was right I
>> tried:
>>
>> perf top -C 0 -u acme
>>
>> To check what is that this user is doing on that CPU, and its not
>> possible :-\
>>
>> UID switch overriding CPU!
>>
>
> Maybe I need to rethink about it since I wasn't aware of the
> per-task-per-cpu events at that time.
>
> AFAIK the uid switch is basically a same thing as pid/tid switch, so
> your complain should be extended to them too. And I think we can remove
> the check from perf_target__validate(). But before that something like
> below is needed also IMHO:
>

After applying the patch below and removing the check, I got:

namhyung@sejong:perf$ sudo ./perf top -C0 -u namhyung -s cpu,dso,sym --stdio


   PerfTop:       5 irqs/sec  kernel:100.0%  exact:  0.0% [1000Hz cycles],  (uid: namhyung, CPU: 0)
-------------------------------------------------------------------------------------------------------------------------------

    91.67%  1  [kernel]  [k] dequeue_entity          
     7.25%  5  [kernel]  [k] schedule_hrtimeout_range
     1.01%  1  [kernel]  [k] __perf_event_task_sched 
     0.06%  5  [kernel]  [k] native_write_msr_safe   
     0.01%  1  [kernel]  [k] native_write_msr_safe   
Failed to open /tmp/perf-1340.map, continuing without symbols


So definitely it needs more work...

Thanks,
Namhyung


>
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index ebcd15883ab8..8e3cf429dd18 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -900,6 +900,9 @@ static void perf_top__start_counters(struct perf_top *top)
>                         attr->read_format |= PERF_FORMAT_ID;
>                 }
>  
> +               if (perf_target__has_cpu(&top->target))
> +                       attr->sample_type |= PERF_SAMPLE_CPU;
> +
>                 if (symbol_conf.use_callchain)
>                         attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
>  
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index d7a2b4b9801d..d26b8fe0abd1 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -107,7 +107,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
>         if (opts->call_graph)
>                 attr->sample_type       |= PERF_SAMPLE_CALLCHAIN;
>  
> -       if (opts->target.system_wide)
> +       if (perf_target__has_cpu(&opts->target))
>                 attr->sample_type       |= PERF_SAMPLE_CPU;
>  
>         if (opts->period)
