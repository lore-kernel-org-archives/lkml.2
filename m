Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1CGSG2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:06:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36710 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1CGSG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:06:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZLghrXBRHHmyFO3f6GFDwsXoNamM5urawdLlWQ7+1xzfnKYGgWN0SqZLzhLfog/C7a
         4/HOfspFnFwyhzXwJyqEQ5fz4Kp7r4Gylf2YpMkkpfnPPTJvmweFbcXlo4ujZMvaQQNm
         eK9DvD66+SuaEKeKd2+qSvV2LCiLuXUS2FWfE=
Date: Mon, 7 Mar 2011 19:06:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Sam Liao <phyomh@gmail.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Add inverted call graph report support to perf tool
Message-ID: <20110307180619.GG1873@nowhere>
References: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vxgHe=dqz+xEPcZ9oBexM1jBxFz3sXA2DJEZA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:43:27PM +0800, Sam Liao wrote:
> Add "-r" option to support inverted butterfly report, in the
> inverted report, the call graph start from the callee's ancestor,
> like main->func1->func2 style. users can use such view to catch
> system's performance bottleneck, find the software's design
> problem not just some function's poor performance.

Yeah, that can be interesting.

> 
> Current pref implementation is not easy to add such inversion, so this
> fix just invert the ip and callchain in an ugly style. But I do think
> this invert
> view help developer to find performance root cause for complex
> software.
> ---
>  tools/perf/builtin-report.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index c27e31f..ac2ec0e 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -33,6 +33,7 @@
>  static char		const *input_name = "perf.data";
> 
>  static bool		force, use_tui, use_stdio;
> +static bool		reverse_call;
>  static bool		hide_unresolved;
>  static bool		dont_use_callchains;
> 
> @@ -155,6 +156,41 @@ static int process_sample_event(event_t *event,
> struct sample_data *sample,
>  {
>  	struct addr_location al;
>  	struct perf_event_attr *attr;
> +
> +	/* reverse call chain data */
> +	if (reverse_call && symbol_conf.use_callchain && sample->callchain) {
> +		struct ip_callchain *chain;
> +		int i, j;
> +		u64 tmp_ip;
> +		event_t *reverse_event;
> +
> +		chain = malloc(sizeof(u64) * (sample->callchain->nr + 1));
> +		if (!chain) {
> +			pr_debug("malloc failed\n");
> +			return -1;
> +		}
> +		reverse_event = malloc(sizeof(event_t));
> +		if (!reverse_event) {
> +			pr_debug("malloc failed\n");
> +			return -1;
> +		}
> +		memcpy(reverse_event, event, sizeof(event_t));
> +
> +		chain->nr = sample->callchain->nr;
> +		j = sample->callchain->nr;
> +		tmp_ip = event->ip.ip;
> +		reverse_event->ip.ip = sample->callchain->ips[j-1];
> +		chain->ips[j-1] = tmp_ip;
> +		for (i = 0, j = sample->callchain->nr - 2; i < j; i++, j--) {
> +			chain->ips[i] = sample->callchain->ips[j];
> +			chain->ips[j] = sample->callchain->ips[i];
> +		}
> +
> +		sample->callchain = chain;
> +		call_chain_reversed = true;
> +		event = reverse_event;
> +	}

So, instead of having such temporary copy, could you rather feed the callchain
into the cursor in reverse from perf_session__resolve_callchain() ?

You can keep the common part inside the loop into a seperate helper
but have two different kinds of loops.

> 
>  	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
>  		fprintf(stderr, "problem processing %d event, skipping it.\n",
> @@ -177,6 +213,11 @@ static int process_sample_event(event_t *event,
> struct sample_data *sample,
>  		return -1;
>  	}
> 
> +	if (reverse_call && call_chain_reversed) {
> +		free(sample->callchain);
> +		free(event);
> +	}
> +
>  	return 0;
>  }
> 
> @@ -469,6 +510,8 @@ static const struct option options[] = {
>  	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
>  		     "Display callchains using output_type (graph, flat, fractal,
> or none) and min percent threshold. "
>  		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
> +	OPT_BOOLEAN('r', "reverse-call", &reverse_call,
> +			"reverse call chain report (butterfly view)"),

What about making it an argument to the exisiting -g option, something
that defines the base of the callchain like "caller" and "callee"

Like "-g graph,0.5,caller".

caller would be what we call here reverse and callee the current and future default.

Does that look sensible?
