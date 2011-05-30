Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577Ab1E3TNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:13:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62789 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab1E3TNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hR5Zs0KpUWXfUSgVyWsJR6FxNR0Vus6w+feEurJWpG7VU6mZLG33fFxNh0vSn0vjof
         mIa1BaQwqH+LsEuQr6Oe88PyYDEJQLksloFQ1pqBjJ7ecxin3AEY3zZwWEojExccB7uM
         pCkuo/QZynlRcVBBHPzeZUdwNWI3fo8G2fFX8=
Message-ID: <4DE3EC6D.9070905@gmail.com>
Date: Mon, 30 May 2011 13:13:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH] perf script: add printing of sample address
References: <1306782503-22002-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1306782503-22002-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/30/2011 01:08 PM, David Ahern wrote:
> Resolve to a function or variable if possible and if the sym option
> is enabled.
> 

Forgot to add that this one applies on top of:
http://lkml.org/lkml/2011/5/27/385

David

> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/Documentation/perf-script.txt |    4 +-
>  tools/perf/builtin-script.c              |   84 +++++++++++++++++++++++++++---
>  tools/perf/util/evsel.c                  |    1 +
>  tools/perf/util/session.c                |    4 +-
>  4 files changed, 82 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index 1e744c2..c6068cb 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -115,8 +115,8 @@ OPTIONS
>  -f::
>  --fields::
>          Comma separated list of fields to print. Options are:
> -        comm, tid, pid, time, cpu, event, trace, ip, sym, dso. Field
> -        list can be prepended with the type, trace, sw or hw,
> +        comm, tid, pid, time, cpu, event, trace, ip, sym, dso, addr.
> +        Field list can be prepended with the type, trace, sw or hw,
>          to indicate to which event type the field list applies.
>          e.g., -f sw:comm,tid,time,ip,sym  and -f trace:time,cpu,trace
>  
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index a8bd00f..3056b45 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -33,6 +33,7 @@ enum perf_output_field {
>  	PERF_OUTPUT_IP              = 1U << 7,
>  	PERF_OUTPUT_SYM             = 1U << 8,
>  	PERF_OUTPUT_DSO             = 1U << 9,
> +	PERF_OUTPUT_ADDR            = 1U << 10,
>  };
>  
>  struct output_option {
> @@ -49,6 +50,7 @@ struct output_option {
>  	{.str = "ip",    .field = PERF_OUTPUT_IP},
>  	{.str = "sym",   .field = PERF_OUTPUT_SYM},
>  	{.str = "dso",   .field = PERF_OUTPUT_DSO},
> +	{.str = "addr",  .field = PERF_OUTPUT_ADDR},
>  };
>  
>  /* default set to maintain compatibility with current format */
> @@ -173,14 +175,22 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
>  		    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
>  			symbol_conf.use_callchain = false;
>  	}
> -	if (PRINT_FIELD(SYM) && !PRINT_FIELD(IP)) {
> -		pr_err("Display of symbols requested but IP is not selected.\n"
> -		       "No addresses to convert to symbols.\n");
> +
> +	if (PRINT_FIELD(ADDR) &&
> +		perf_event_attr__check_stype(attr, PERF_SAMPLE_ADDR, "ADDR",
> +				       PERF_OUTPUT_ADDR))
> +		return -EINVAL;
> +
> +	if (PRINT_FIELD(SYM) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
> +		pr_err("Display of symbols requested but neither sample IP nor "
> +			   "sample address\nis selected. Hence, no addresses to convert "
> +		       "to symbols.\n");
>  		return -EINVAL;
>  	}
> -	if (PRINT_FIELD(DSO) && !PRINT_FIELD(IP)) {
> -		pr_err("Display of DSO requested but IP is not selected.\n"
> -		       "No addresses to convert to dso.\n");
> +	if (PRINT_FIELD(DSO) && !PRINT_FIELD(IP) && !PRINT_FIELD(ADDR)) {
> +		pr_err("Display of DSO requested but neither sample IP nor "
> +			   "sample address\nis selected. Hence, no addresses to convert "
> +		       "to DSO.\n");
>  		return -EINVAL;
>  	}
>  
> @@ -288,6 +298,63 @@ static void print_sample_start(struct perf_sample *sample,
>  	}
>  }
>  
> +static bool sample_addr_correlates_sym(struct perf_event_attr *attr)
> +{
> +	if ((attr->type == PERF_TYPE_SOFTWARE) &&
> +	    ((attr->config == PERF_COUNT_SW_PAGE_FAULTS) ||
> +	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MIN) ||
> +	     (attr->config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)))
> +		return true;
> +
> +	return false;
> +}
> +
> +static void print_sample_addr(union perf_event *event,
> +			  struct perf_sample *sample,
> +			  struct perf_session *session,
> +			  struct thread *thread,
> +			  struct perf_event_attr *attr)
> +{
> +	struct addr_location al;
> +	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
> +	const char *symname, *dsoname;
> +
> +	printf("%16" PRIx64, sample->addr);
> +
> +	if (!sample_addr_correlates_sym(attr))
> +		return;
> +
> +	thread__find_addr_map(thread, session, cpumode, MAP__FUNCTION,
> +			      event->ip.pid, sample->addr, &al);
> +	if (!al.map)
> +		thread__find_addr_map(thread, session, cpumode, MAP__VARIABLE,
> +				      event->ip.pid, sample->addr, &al);
> +
> +	al.cpu = sample->cpu;
> +	al.sym = NULL;
> +
> +	if (al.map)
> +		al.sym = map__find_symbol(al.map, al.addr, NULL);
> +
> +	if (PRINT_FIELD(SYM)) {
> +		if (al.sym && al.sym->name)
> +			symname = al.sym->name;
> +		else
> +			symname = "";
> +
> +		printf(" %16s", symname);
> +	}
> +
> +	if (PRINT_FIELD(DSO)) {
> +		if (al.map && al.map->dso && al.map->dso->name)
> +			dsoname = al.map->dso->name;
> +		else
> +			dsoname = "";
> +
> +		printf(" (%s)", dsoname);
> +	}
> +}
> +
>  static void process_event(union perf_event *event __unused,
>  			  struct perf_sample *sample,
>  			  struct perf_evsel *evsel,
> @@ -305,6 +372,9 @@ static void process_event(union perf_event *event __unused,
>  		print_trace_event(sample->cpu, sample->raw_data,
>  				  sample->raw_size);
>  
> +	if (PRINT_FIELD(ADDR))
> +		print_sample_addr(event, sample, session, thread, attr);
> +
>  	if (PRINT_FIELD(IP)) {
>  		if (!symbol_conf.use_callchain)
>  			printf(" ");
> @@ -1003,7 +1073,7 @@ static const struct option options[] = {
>  	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
>  		    "Look for files with symbols relative to this directory"),
>  	OPT_CALLBACK('f', "fields", NULL, "str",
> -		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso",
> +		     "comma separated output fields prepend with 'type:'. Valid types: hw,sw,trace,raw. Fields: comm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr",
>  		     parse_output_fields),
>  
>  	OPT_END()
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index cca29ed..669e18a 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -361,6 +361,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>  		array++;
>  	}
>  
> +	data->addr = 0;
>  	if (type & PERF_SAMPLE_ADDR) {
>  		data->addr = *array;
>  		array++;
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 360d8c4..21e6c91 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -698,9 +698,9 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
>  	if (!dump_trace)
>  		return;
>  
> -	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 "\n",
> +	printf("(IP, %d): %d/%d: %#" PRIx64 " period: %" PRIu64 " addr: %#" PRIx64 "\n",
>  	       event->header.misc, sample->pid, sample->tid, sample->ip,
> -	       sample->period);
> +	       sample->period, sample->addr);
>  
>  	if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
>  		callchain__printf(sample);
