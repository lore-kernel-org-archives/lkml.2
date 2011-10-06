Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab1JFXC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:02:59 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40682 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1JFXC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:02:57 -0400
Date: Thu, 6 Oct 2011 20:02:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 07/15] perf top: Add callgraph support
Message-ID: <20111006230246.GA5944@ghostprotocols.net>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
 <1317921758-4154-8-git-send-email-acme@infradead.org>
 <4E8E21D6.9080201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8E21D6.9080201@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 06, 2011 at 03:47:02PM -0600, David Ahern escreveu:
> On 10/06/2011 11:22 AM, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > +-G [type,min,order]::
> > +--call-graph::
> > +        Display call chains using type, min percent threshold and order.
> > +	type can be either:
> > +	- flat: single column, linear exposure of call chains.
> > +	- graph: use a graph tree, displaying absolute overhead rates.
> > +	- fractal: like graph, but displays relative rates. Each branch of
> > +		 the tree is considered as a new profiled object.
> > +
> > +	order can be either:
> > +	- callee: callee based call graph.
> > +	- caller: inverted caller based call graph.
> > +
> > +	Default: fractal,0.5,callee.

> yuk. perf-report has -g for this. How about moving the current -g to -G
> and let -g be consistent across commands?

Yup, but top has -g for --group... This is something we need to improve
ASAP. 

I think changing top to use 0 for group, i.e. just --group and -g for
callchains is the way to go, right?

The "record" command has 'G' for --cgroup, -g for --call-graph... So
topuse 'G' for --cgroup too, I guess.
 
> > @@ -748,13 +756,29 @@ static void perf_event__process_sample(const union perf_event *event,
> >  		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
> >  		assert(evsel != NULL);
> >  
> > +		if ((sort__has_parent || symbol_conf.use_callchain) &&
> > +		    sample->callchain) {
> > +			err = perf_session__resolve_callchain(session, al.thread,
> > +							      sample->callchain, &parent);
> > +			if (err)
> > +				return;
> > +		}
> > +
> >  		he = perf_session__add_hist_entry(session, &al, sample, evsel);
> >  		if (he == NULL) {
> >  			pr_err("Problem incrementing symbol period, skipping event\n");
> >  			return;
> >  		}
> >  
> > -		record_precise_ip(he, evsel->idx, ip);
> > +		if (symbol_conf.use_callchain) {
> > +			err = callchain_append(he->callchain, &session->callchain_cursor,
> > +					       sample->period);
> > +			if (err)
> > +				return;
> > +		}
> > +
> > +		if (sort_has_symbols)
> > +			record_precise_ip(he, evsel->idx, ip);
> >  	}
> 
> A fair amount of code duplication with builtin-report now.

Yeah, eventually all this will be in the evlist class.
 
> > +	/* get the call chain order */
> > +	if (!strcmp(tok2, "caller"))
> > +		callchain_param.order = ORDER_CALLER;
> > +	else if (!strcmp(tok2, "callee"))
> > +		callchain_param.order = ORDER_CALLEE;
> > +	else
> > +		return -1;
> > +setup:
> > +	if (callchain_register_param(&callchain_param) < 0) {
> > +		fprintf(stderr, "Can't register callchain params\n");
> > +		return -1;
> > +	}
> 
> ditto for the parse_callchain_opt() -- seems to be a copy from report.

It is, I'll get that refactored. Just wanted to get this thing out now
as I found it to be an improvement to the current 'perf top' tool :)
 
> David
