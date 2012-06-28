Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2F1CYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 22:24:04 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43462 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab2F1CYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 22:24:01 -0400
X-AuditID: 9c93016f-b7c85ae00000559e-04-4febc03e4d07
From: Namhyung Kim <namhyung@kernel.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: perf support user-space hw_breakpoint?
References: <CACV3sb+EqVR0Z7qtCOpFtmRS+7xvv0b4S0Jrk7o7b__89_WVcA@mail.gmail.com>
	<87bok7x0e1.fsf@sejong.aot.lge.com>
	<CACV3sbKJiORogfjjRfyFz4Vw7Re8EYZ7K+vuU6GCb5d7w=ZgzQ@mail.gmail.com>
Date: Thu, 28 Jun 2012 11:20:09 +0900
In-Reply-To: <CACV3sbKJiORogfjjRfyFz4Vw7Re8EYZ7K+vuU6GCb5d7w=ZgzQ@mail.gmail.com>
	(Jovi Zhang's message of "Thu, 28 Jun 2012 09:02:02 +0800")
Message-ID: <87txxwxjmu.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 09:02:02 +0800, Jovi Zhang wrote:
> On Mon, Jun 25, 2012 at 4:26 PM, Namhyung Kim <namhyung@kernel.org> wrote:
>> BTW, when I perf record on a hwbp, it failed with ENOSPC.
>> I guess it's because each per-task-per-cpu event tried to
>> create an event so it'd get more than supported by h/w.
>> The strace told me that the fifth call to perf_event_open
>> failed on my 6-core machine.
>>
> I have same result as you in my linux box.
> This should be a bug cause by commit d1cb9f(perf target: Add uses_mmap field)
>
> Namhyung, How about below patch?
>

NAK. This uses_mmap field is needed to setup per-task-per-cpu events for
perf record (mostly). Without it, perf suffered from severe scalability
issues. Maybe we can change it not to create per-task-per-cpu events iff
for hwbp events only, but I'm not sure it's the right thing.

Thanks,
Namhyung


>
> From 4b77b99df9ca3b99be4ccf8c4256e622aae9203f Mon Sep 17 00:00:00 2001
> From: Jovi Zhang <bookjovi@gmail.com>
> Date: Thu, 28 Jun 2012 07:49:41 +0800
> Subject: [PATCH] perf: revert commit d1cb9f(perf target: Add uses_mmap field)
>
> In my x86 4 cores cpu linux machine, using hw_breakpoint output as follows:
>
> Before add uses_mmap field:
>  [root@jovi perf]# ./perf record -g -e mem:0x080652c8 -e mem:0x1098 --
> /usr/bin/ls >/dev/null
>  [ perf record: Woken up 1 times to write data ]
>  [ perf record: Captured and wrote 0.015 MB perf.data (~640 samples) ]
>
> After add uses_mmap field:
>  [root@jovi perf]# ./perf record -e mem:0x080652c8 -e mem:0x1098 --
> /usr/bin/ls >/dev/null
>    Error: sys_perf_event_open() syscall returned with 28 (No space
> left on device).  /bin/dmesg may provide additional information.
>
>    Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
>
> Adding uses_mmap field in target structure will cause perf-record
> creat per-task-per-cpu
> event for each evsel, this will break hw_breakpoint(have limit debug
> registers in cpu),
> in above example, we should create dummy cpumap for hw_breakpoint
> event, not per-task-per-cpu,
> fix it.
>
> Noticed-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> ---
> tools/perf/builtin-record.c |    3 ---
> tools/perf/builtin-test.c   |    1 -
> tools/perf/builtin-top.c    |    3 ---
> tools/perf/util/evlist.c    |    4 +---
> tools/perf/util/target.h    |    1 -
> 5 files changed, 1 insertion(+), 11 deletions(-)
>
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index f95840d..8128213 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -754,9 +754,6 @@ static struct perf_record record = {
>                .user_freq           = UINT_MAX,
>                .user_interval       = ULLONG_MAX,
>                .freq                = 4000,
> -               .target              = {
> -                       .uses_mmap   = true,
> -               },
>        },
>        .write_mode = WRITE_FORCE,
>        .file_new   = true,
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index 5a8727c..338a0cc 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -647,7 +647,6 @@ static int test__PERF_RECORD(void)
>        struct perf_record_opts opts = {
>                .target = {
>                        .uid = UINT_MAX,
> -                       .uses_mmap = true,
>                },
>                .no_delay   = true,
>                .freq       = 10,
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 6bb0277..cc78e06 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1165,9 +1165,6 @@ int cmd_top(int argc, const char **argv, const
> char *prefix __used)
>                .freq                = 4000, /* 4 KHz */
>                .mmap_pages          = 128,
>                .sym_pcnt_filter     = 5,
> -               .target              = {
> -                       .uses_mmap   = true,
> -               },
>        };
>        char callchain_default_opt[] = "fractal,0.5,callee";
>        const struct option options[] = {
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 7400fb3..e791029 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -622,9 +622,7 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
>        if (evlist->threads == NULL)
>                return -1;
>
> -       if (perf_target__has_task(target))
> -               evlist->cpus = cpu_map__dummy_new();
> -       else if (!perf_target__has_cpu(target) && !target->uses_mmap)
> +       if (perf_target__has_task(target) || !perf_target__has_cpu(target))
>                evlist->cpus = cpu_map__dummy_new();
>        else
>                evlist->cpus = cpu_map__new(target->cpu_list);
> diff --git a/tools/perf/util/target.h b/tools/perf/util/target.h
> index a4be857..c43f632 100644
> --- a/tools/perf/util/target.h
> +++ b/tools/perf/util/target.h
> @@ -11,7 +11,6 @@ struct perf_target {
>        const char   *uid_str;
>        uid_t        uid;
>        bool         system_wide;
> -       bool         uses_mmap;
> };
>
> enum perf_target_errno {
> --
> 1.7.9.7
