Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab1HXWEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:04:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57631 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1HXWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:04:04 -0400
Message-ID: <4E55754E.8010108@gmail.com>
Date: Wed, 24 Aug 2011 16:03:58 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf script: add option to display time change between
 events
References: <1313687121-25689-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1313687121-25689-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Disregard. The time delta needs to be on a per-cpu basis. I'll redo.


On 08/18/2011 11:05 AM, David Ahern wrote:
> Add a 'dt' field option to show time change between events dumped to user:
> 
>          swapper     0 [000] 0.003780: netif_receive_skb: dev=wlan0 skbaddr=...
>             vpnc 23605 [000] 0.000347: netif_rx: dev=tun0 skbaddr=...
>             vpnc 23605 [000] 0.000007: netif_receive_skb: dev=tun0 skbaddr=...
>  thunderbird-bin 22435 [000] 0.001043: net_dev_queue: dev=tun0 skbaddr=...
>  thunderbird-bin 22435 [000] 0.000012: net_dev_xmit: dev=tun0 skbaddr=...
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/Documentation/perf-script.txt |    2 +-
>  tools/perf/builtin-script.c              |   20 +++++++++++++++++++-
>  2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index db01786..4f996ab 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -115,7 +115,7 @@ OPTIONS
>  -f::
>  --fields::
>          Comma separated list of fields to print. Options are:
> -        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr.
> +        comm, tid, pid, time, dt, cpu, event, trace, ip, sym, dso, addr.
>          Field list can be prepended with the type, trace, sw or hw,
>          to indicate to which event type the field list applies.
>          e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 09024ec..541b30a 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -37,6 +37,7 @@ enum perf_output_field {
>  	PERF_OUTPUT_SYM             = 1U << 8,
>  	PERF_OUTPUT_DSO             = 1U << 9,
>  	PERF_OUTPUT_ADDR            = 1U << 10,
> +	PERF_OUTPUT_DT              = 1U << 11,
>  };
>  
>  struct output_option {
> @@ -54,6 +55,7 @@ struct output_option {
>  	{.str = "sym",   .field = PERF_OUTPUT_SYM},
>  	{.str = "dso",   .field = PERF_OUTPUT_DSO},
>  	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
> +	{.str = "dt",    .field = PERF_OUTPUT_DT},
>  };
>  
>  /* default set to maintain compatibility with current format */
> @@ -207,6 +209,11 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
>  				       PERF_OUTPUT_TIME))
>  		return -EINVAL;
>  
> +	if (PRINT_FIELD(DT) &&
> +		perf_event_attr__check_stype(attr, PERF_SAMPLE_TIME, "DT",
> +				       PERF_OUTPUT_DT))
> +		return -EINVAL;
> +
>  	if (PRINT_FIELD(CPU) &&
>  		perf_event_attr__check_stype(attr, PERF_SAMPLE_CPU, "CPU",
>  				       PERF_OUTPUT_CPU))
> @@ -288,6 +295,17 @@ static void print_sample_start(struct perf_sample *sample,
>  		printf("%5lu.%06lu: ", secs, usecs);
>  	}
>  
> +	if (PRINT_FIELD(DT)) {
> +		static u64 prev_sample_time;
> +
> +		nsecs =  prev_sample_time ? sample->time - prev_sample_time : 0;
> +		prev_sample_time = sample->time;
> +		secs = nsecs / NSECS_PER_SEC;
> +		nsecs -= secs * NSECS_PER_SEC;
> +		usecs = nsecs / NSECS_PER_USEC;
> +		printf("%lu.%06lu: ", secs, usecs);
> +	}
> +
>  	if (PRINT_FIELD(EVNAME)) {
>  		if (attr->type == PERF_TYPE_TRACEPOINT) {
>  			type = trace_parse_common_type(sample->raw_data);
> @@ -1080,7 +1098,7 @@ static const struct option options[] = {
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
>  	OPT_CALLBACK('f', "fields", NULL, "str",
> -		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
> +		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,dt,cpu,event,trace,ip,sym,dso,addr",
>  		     parse_output_fields),
>  	OPT_STRING('c', "cpu", &cpu_list, "cpu", "list of cpus to profile"),
>  
