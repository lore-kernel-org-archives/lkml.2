Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab1I2Pej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:34:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52114 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1I2Pei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:34:38 -0400
Message-ID: <4E849008.8080403@gmail.com>
Date: Thu, 29 Sep 2011 09:34:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        nhorman@tuxdriver.com, eric.dumazet@gmail.com
Subject: Re: [PATCHv3 1/2] perf tools: Fix raw sample reading
References: <1317028312-5156-1-git-send-email-jolsa@redhat.com> <1317308709-9474-1-git-send-email-jolsa@redhat.com> <1317308709-9474-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1317308709-9474-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/29/2011 09:05 AM, Jiri Olsa wrote:
> Wrong pointer is being passed for raw data sanity checking,
> when parsing sample event.
> 
> This ends up with invalid event and perf record being stuck in
> __perf_session__process_events function during processing
> build IDs (process_buildids function).
> 
> Following command hangs up in my setup:
> 	./perf record -e raw_syscalls:sys_enter ls
> 
> The fix is to use proper pointer to the raw data instead
> of the 'u' union.
> 
> CC: David Ahern <dsahern@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/evsel.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index c5748c5..e389815 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -449,6 +449,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>  	}
>  
>  	if (type & PERF_SAMPLE_RAW) {
> +		const u64 *pdata;
> +
>  		u.val64 = *array;
>  		if (WARN_ONCE(swapped,
>  			      "Endianness of raw data not corrected!\n")) {
> @@ -462,11 +464,12 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>  			return -EFAULT;
>  
>  		data->raw_size = u.val32[0];
> +		pdata = (void *) array + sizeof(u32);
>  
> -		if (sample_overlap(event, &u.val32[1], data->raw_size))
> +		if (sample_overlap(event, pdata, data->raw_size))
>  			return -EFAULT;
>  
> -		data->raw_data = &u.val32[1];
> +		data->raw_data = (void *) pdata;
>  	}
>  
>  	return 0;

Oops. Thanks for fixing.

Reviewed-by: David Ahern <dsahern@gmail.com>
