Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1GUHU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:20:58 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:41489 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1GUHU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:20:57 -0400
Date: Thu, 21 Jul 2011 11:20:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip/perf/core] perf, x86: P4 PMU - Introduce event alias
 feature
Message-ID: <20110721072052.GM7492@sun>
References: <20110708201712.GS23657@sun>
 <20110721064610.GB26260@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721064610.GB26260@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 08:46:10AM +0200, Ingo Molnar wrote:
...
> 
> > + */
> > +struct p4_event_alias {
> > +	u64 orig;
> > +	u64 alter;
> 
> what is an 'alter'? alias? alternate?

Shorthanded 'alternate', I can change it to alias.

> 
> > +} p4_event_aliases[] = {
> > +	{
> > +		/*
> > +		 * Non-halted cycles can be substituted with
> > +		 * non-sleeping cycles (see Intel SDM Vol3b for
> > +		 * details).
> > +		 */
> > +	.orig	=
> > +		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING)),
> > +	.alter	=
> > +		p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_EXECUTION_EVENT)		|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS0)|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS1)|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS2)|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, NBOGUS3)|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS0)	|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS1)	|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS2)	|
> > +				    P4_ESCR_EMASK_BIT(P4_EVENT_EXECUTION_EVENT, BOGUS3))|
> > +		p4_config_pack_cccr(P4_CCCR_THRESHOLD(15) | P4_CCCR_COMPLEMENT		|
> > +				    P4_CCCR_COMPARE),
> 
> That currently we only offer an alias for the generic cycles event is 
> an important property - yet it's only visible from the code and is 
> not mentioned in any of the voluminous comments. Good comments are to 
> the point and focused: what problem is being solved, how is it solved 
> and what are the limitations of the solution.

ok, will update the comment.

> 
> > + 	},
> > +};
> > +
> > +static u64 p4_get_alias_event(u64 config)
> > +{
> > +	u64 config_match;
> > +	int i;
> > +
> > +	/*
> > +	 * Probably we're lucky and don't have to do
> > +	 * matching over all config bits.
> > +	 */
> > +	if (!(config & P4_CONFIG_ALIASABLE))
> > +		return 0;
> 
> 'all' config bits? There's a single alias mapping in 
> p4_event_aliases[] right now which makes the comment rather 
> misleading ...

no, the cycle below does check for all bits in config, and test
for single bit might help us to return early.

> 
> > +
> > +	config_match = config & P4_CONFIG_EVENT_ALIAS_MASK;
> > +
> > +	/*
> > +	 * If an event was previously swapped to the alter config
> > +	 * we should swap it back otherwise contnention on registers
> > +	 * will return back.
> 
> 'alter config' is a new English word apparently. We can invent new 
> words but is it really warranted here? 'alternate config'? 'config 
> alias'?

i'll update to alternate config

> 
> > +	 */
> > +	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
> > +		if (config_match == p4_event_aliases[i].orig) {
> > +			config_match = p4_event_aliases[i].alter;
> > +			break;
> > +		} else if (config_match == p4_event_aliases[i].alter) {
> > +			config_match = p4_event_aliases[i].orig;
> > +			break;
> > +		}
> > +	}
> 
> Since this .c file is P4 specific and p4_event_aliases[] is a 
> file-scope array, is the p4_ prefix even needed?

I prefer them to be distinguished this way, since the .c file in
real is included into another (perf_event.c) file.

> 
> > +
> > +	if (i >= ARRAY_SIZE(p4_event_aliases))
> > +		return 0;
> > +
> > +	return (config_match |
> > +		(config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS));
> 
> 'return' is not a function. Also, please don't break the line 
> pointlessly.

It is perfectly fine to return args in braces,
but I will change it.

...
> > +			/*
> > +			 * Probably an event alias is still available.
> 
> s/Probably/Possibly?

Hm? I don't get what is wrong with 'probably'.
...
> >  
> >  	/* Try to register using hardware perf events */
> >  	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback, NULL);
> 
> This looks like the right approach otherwise. Peter?
> 
> Thanks,
> 
> 	Ingo

Thanks Ingo, I'll update the patch.

	Cyrill
