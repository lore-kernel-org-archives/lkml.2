Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1GUHww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:52:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59016 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1GUHwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:52:50 -0400
Date: Thu, 21 Jul 2011 09:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Don Zickus <dzickus@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip/perf/core] perf, x86: P4 PMU - Introduce event alias
 feature
Message-ID: <20110721075201.GH9216@elte.hu>
References: <20110708201712.GS23657@sun>
 <20110721064610.GB26260@elte.hu>
 <20110721072052.GM7492@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721072052.GM7492@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > > +static u64 p4_get_alias_event(u64 config)
> > > +{
> > > +	u64 config_match;
> > > +	int i;
> > > +
> > > +	/*
> > > +	 * Probably we're lucky and don't have to do
> > > +	 * matching over all config bits.
> > > +	 */
> > > +	if (!(config & P4_CONFIG_ALIASABLE))
> > > +		return 0;
> > 
> > 'all' config bits? There's a single alias mapping in 
> > p4_event_aliases[] right now which makes the comment rather 
> > misleading ...
> 
> no, the cycle below does check for all bits in config, and test
> for single bit might help us to return early.

The loop below? AFAICS it does:

> > > +	 */
> > > +	for (i = 0; i < ARRAY_SIZE(p4_event_aliases); i++) {
> > > +		if (config_match == p4_event_aliases[i].orig) {
> > > +			config_match = p4_event_aliases[i].alter;
> > > +			break;
> > > +		} else if (config_match == p4_event_aliases[i].alter) {
> > > +			config_match = p4_event_aliases[i].orig;
> > > +			break;
> > > +		}
> > > +	}

and p4_event_aliases[] is a single-entry array, so ARRAY_SIZE() is 1 
and this loop iterates once.

> > Since this .c file is P4 specific and p4_event_aliases[] is a 
> > file-scope array, is the p4_ prefix even needed?
> 
> I prefer them to be distinguished this way, since the .c file in 
> real is included into another (perf_event.c) file.

That should probably be fixed btw. - but yeah, until the PMU drivers 
are separated out better the prefix is fine.

> > > +
> > > +	if (i >= ARRAY_SIZE(p4_event_aliases))
> > > +		return 0;
> > > +
> > > +	return (config_match |
> > > +		(config & P4_CONFIG_EVENT_ALIAS_IMMUTABLE_BITS));
> > 
> > 'return' is not a function. Also, please don't break the line 
> > pointlessly.
> 
> It is perfectly fine to return args in braces,
> but I will change it.

The parantheses are syntactically valid but not 'perfectly fine'. As 
per kernel coding style we don't use them, to signal that 'return' is 
not a function.

> 
> ...
> > > +			/*
> > > +			 * Probably an event alias is still available.
> > 
> > s/Probably/Possibly?
> 
> Hm? I don't get what is wrong with 'probably'.

Probably means "most likely, maybe" - and that's not the case here.

(It's misleading in this context because it declares the probability 
of this action as always higher than 50% - and that's not always the 
case here.)

'Possibly' leaves the probability more undefined.

You could also write 'Check whether an event alias is still 
available'.

Thanks,

	Ingo
