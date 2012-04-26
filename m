Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab2DZPFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:05:31 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:56817 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2DZPF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:05:27 -0400
Message-ID: <4F996433.7040003@gmail.com>
Date: Thu, 26 Apr 2012 09:05:23 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung.kim@lge.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/13] perf evlist: Fix creation of cpu map
References: <1335417327-11796-1-git-send-email-namhyung.kim@lge.com> <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
In-Reply-To: <1335417327-11796-8-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/25/12 11:15 PM, Namhyung Kim wrote:
> Currently, 'perf record -- sleep 1' creates a cpu map for all online
> cpus since it turns out calling cpu_map__new(NULL). Fix it. Also it
> is guaranteed that cpu_list is NULL if PID/TID is given by calling
> perf_target__validate(), so we can make the conditional bit simpler.
>
> This also fixes perf test 7 (Validate) failure on my 6 core machine:
>
>    $ cat /sys/devices/system/cpu/online
>    0-11
>    $ ./perf test -v 7
>     7: Validate PERF_RECORD_* events&  perf_sample fields:
>    --- start ---
>    perf_evlist__mmap: Operation not permitted
>    ---- end ----
>    Validate PERF_RECORD_* events&  perf_sample fields: FAILED!

Works fine for me with latest tip:
$ cat /sys/devices/system/cpu/online
0-15

$ /tmp/perf/perf test -v 7
  7: Validate PERF_RECORD_* events & perf_sample fields:
--- start ---
64740167922229 0 PERF_RECORD_SAMPLE
64740167926354 0 PERF_RECORD_SAMPLE
64740167928389 0 PERF_RECORD_SAMPLE
64740167930832 0 PERF_RECORD_SAMPLE
64740168404145 0 PERF_RECORD_COMM: sleep:16523
64740168424672 0 PERF_RECORD_MMAP 16523/16523: [0x400000(0x6000) @ 0]: 
/bin/sleep
64740168441676 0 PERF_RECORD_MMAP 16523/16523: [0x7f83de5bb000(0x224000) 
@ 0]: /lib64/ld-2.14.90.so
64740168458460 0 PERF_RECORD_MMAP 16523/16523: [0x7fff009ff000(0x1000) @ 
0x7fff009ff000]: [vdso]
64740168586358 0 PERF_RECORD_MMAP 16523/16523: [0x7f83de203000(0x3b8000) 
@ 0]: /lib64/libc-2.14.90.so
64741168625653 0 PERF_RECORD_EXIT(16523:16523):(16523:16523)
---- end ----
Validate PERF_RECORD_* events & perf_sample fields: Ok

Is the failure a by-product of the other patches in this set?

David

>
> Signed-off-by: Namhyung Kim<namhyung.kim@lge.com>
> ---
>   tools/perf/util/evlist.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index a43e2c56d1c6..556d98af1a0b 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -608,8 +608,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
>   	if (evlist->threads == NULL)
>   		return -1;
>
> -	if (target->uid != UINT_MAX ||
> -	    (target->cpu_list == NULL&&  target->tid))
> +	if (target->uid != UINT_MAX || target->tid)
> +		evlist->cpus = cpu_map__dummy_new();
> +	else if (!target->system_wide&&  target->cpu_list == NULL)
>   		evlist->cpus = cpu_map__dummy_new();
>   	else
>   		evlist->cpus = cpu_map__new(target->cpu_list);

