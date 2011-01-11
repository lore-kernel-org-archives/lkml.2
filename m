Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab1AKSk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 13:40:29 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:44150 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab1AKSkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 13:40:25 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJMyLE2rR7Ht/2dsb2JhbACkOXOjZphuhUwEhGiGJoMgggps
Message-ID: <4D2CA417.7030407@cisco.com>
Date: Tue, 11 Jan 2011 11:40:23 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/6] perf tools: Emit clearer message for sys_perf_event_open
 ENOENT return
References: <1294705692-9537-1-git-send-email-acme@infradead.org> <1294705692-9537-4-git-send-email-acme@infradead.org>
In-Reply-To: <1294705692-9537-4-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/10/11 17:28, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Improve sys_perf_event_open ENOENT return handling in top and record, just
> like 5a3446b does for stat.
> 
> Cc: David Ahern <daahern@cisco.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-record.c |    3 +++
>  tools/perf/builtin-top.c    |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 7bc0490..7069bd3 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -331,6 +331,9 @@ try_again:
>  			else if (err ==  ENODEV && cpu_list) {
>  				die("No such device - did you specify"
>  					" an out-of-range profile CPU?\n");
> +			} else if (err == ENOENT) {
> +				die("%s event is not supported. ",
> +				     event_name(evsel));

I think this interferes with the fallback from hardware profiling to
software profiling. .e.g., in a VM with no PMU.

David


>  			} else if (err == EINVAL && sample_id_all_avail) {
>  				/*
>  				 * Old kernel, no attr->sample_id_type_all field
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index 1e67ab9..6ce4042 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1247,6 +1247,8 @@ try_again:
>  				die("Permission error - are you root?\n"
>  					"\t Consider tweaking"
>  					" /proc/sys/kernel/perf_event_paranoid.\n");
> +			if (err == ENOENT)
> +				die("%s event is not supported. ", event_name(evsel));
>  			/*
>  			 * If it's cycles then fall back to hrtimer
>  			 * based cpu-clock-tick sw counter, which
