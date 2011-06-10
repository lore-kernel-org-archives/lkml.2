Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab1FJUmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:42:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43248 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab1FJUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=dNGK8Puqk7cyVF+zUOjOGQxfFS8+pQENeudY+jpB83cD0HLgg2cmBic3PHH7Qe5yoU
         AScFUKQABYVE8ZJkhWcKturQYl9evZKSBHM0z4qdU1eYrl7GfJeENfdRpjrK1WHuDczV
         pMBb/dhcBkKqIpyxp3DKpGNxSnVpywtTTeIt4=
Date: Fri, 10 Jun 2011 17:42:08 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sam Liao <phyomh@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [perf] Add inverted call graph report support.
Message-ID: <20110610204208.GC13694@ghostprotocols.net>
References: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=svHgWzyKiEHjMc-j5Hq4y5R8Mow@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jun 09, 2011 at 02:44:19PM +0800, Sam Liao escreveu:
> Add "caller/callee" option to support inverted butterfly report,
> in the inverted report (with caller option), the call graph start
> from the callee's ancestor. Users can use such view to catch system's
> performance bottleneck from a sysprof like view. Using this option
> with specified sort order like pid gives us high level view of call
> graph statistics.

Looks OK, haven't had time to test tho.

Frédéric, can you process this one? Tomorrow I'll be off the grid,
vacations!

Thanks a lot,

- Arnaldo

> ---
>  tools/perf/builtin-report.c |   28 ++++++++++++++++++++++------
>  tools/perf/util/callchain.h |    6 ++++++
>  tools/perf/util/hist.c      |    3 ++-
>  tools/perf/util/session.c   |    7 ++++++-
>  4 files changed, 36 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 287a173..2ceac45 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -45,7 +45,7 @@ static struct perf_read_values	show_threads_values;
>  static const char	default_pretty_printing_style[] = "normal";
>  static const char	*pretty_printing_style = default_pretty_printing_style;
> 
> -static char		callchain_default_opt[] = "fractal,0.5";
> +static char		callchain_default_opt[] = "fractal,0.5,callee";
>  static symbol_filter_t	annotate_init;
> 
>  static int perf_session__add_hist_entry(struct perf_session *session,
> @@ -386,13 +386,29 @@ parse_callchain_opt(const struct option *opt
> __used, const char *arg,
>  	if (!tok)
>  		goto setup;
> 
> -	tok2 = strtok(NULL, ",");
>  	callchain_param.min_percent = strtod(tok, &endptr);
>  	if (tok == endptr)
>  		return -1;
> 
> -	if (tok2)
> +	/* get the print limit */
> +	tok2 = strtok(NULL, ",");
> +	if (!tok2)
> +		goto setup;
> +
> +	if (tok2[0] != 'c') {
>  		callchain_param.print_limit = strtod(tok2, &endptr);
> +		tok2 = strtok(NULL, ",");
> +		if (!tok2)
> +			goto setup;
> +	}
> +
> +	/* get the call chain order */
> +	if (!strcmp(tok2, "caller"))
> +		callchain_param.order = ORDER_CALLER;
> +	else if (!strcmp(tok2, "callee"))
> +		callchain_param.order = ORDER_CALLEE;
> +	else
> +		return -1;
>  setup:
>  	if (callchain_register_param(&callchain_param) < 0) {
>  		fprintf(stderr, "Can't register callchain params\n");
> @@ -436,9 +452,9 @@ static const struct option options[] = {
>  		   "regex filter to identify parent, see: '--sort parent'"),
>  	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
>  		    "Only display entries with parent-match"),
> -	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
> -		     "Display callchains using output_type (graph, flat, fractal,
> or none) and min percent threshold. "
> -		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
> +	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL,
> "output_type,min_percent, call_order",
> +		     "Display callchains using output_type (graph, flat, fractal,
> or none) , min percent threshold and callchain order. "
> +		     "Default: fractal,0.5,callee", &parse_callchain_opt,
> callchain_default_opt),
>  	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
>  		   "only consider symbols in these dsos"),
>  	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
> diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
> index 1a79df9..9b4ff16 100644
> --- a/tools/perf/util/callchain.h
> +++ b/tools/perf/util/callchain.h
> @@ -14,6 +14,11 @@ enum chain_mode {
>  	CHAIN_GRAPH_REL
>  };
> 
> +enum chain_order {
> +	ORDER_CALLER,
> +	ORDER_CALLEE
> +};
> +
>  struct callchain_node {
>  	struct callchain_node	*parent;
>  	struct list_head	siblings;
> @@ -41,6 +46,7 @@ struct callchain_param {
>  	u32			print_limit;
>  	double			min_percent;
>  	sort_chain_func_t	sort;
> +	enum chain_order	order;
>  };
> 
>  struct callchain_list {
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 627a02e..dae4202 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -14,7 +14,8 @@ enum hist_filter {
> 
>  struct callchain_param	callchain_param = {
>  	.mode	= CHAIN_GRAPH_REL,
> -	.min_percent = 0.5
> +	.min_percent = 0.5,
> +	.order  = ORDER_CALLEE
>  };
> 
>  u16 hists__col_len(struct hists *self, enum hist_column col)
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index f5a8fbd..e545a4d 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -247,9 +247,14 @@ int perf_session__resolve_callchain(struct
> perf_session *self,
>  	callchain_cursor_reset(&self->callchain_cursor);
> 
>  	for (i = 0; i < chain->nr; i++) {
> -		u64 ip = chain->ips[i];
> +		u64 ip;
>  		struct addr_location al;
> 
> +		if (callchain_param.order == ORDER_CALLEE)
> +			ip = chain->ips[i];
> +		else
> +			ip = chain->ips[chain->nr - i - 1];
> +
>  		if (ip >= PERF_CONTEXT_MAX) {
>  			switch (ip) {
>  			case PERF_CONTEXT_HV:
> -- 
> 1.7.4.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
