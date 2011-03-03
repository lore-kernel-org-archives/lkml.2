Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab1CCJew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 04:34:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab1CCJet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 04:34:49 -0500
Date: Thu, 3 Mar 2011 10:34:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tao Ma <tm@tao.ma>
Cc: Liu Yuan <namei.unix@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jaxboe@fusionio.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [RFC PATCH 4/5] mm: Add hit/miss accounting for Page Cache
Message-ID: <20110303093422.GC18252@elte.hu>
References: <no>
 <1299055090-23976-4-git-send-email-namei.unix@gmail.com>
 <20110302084542.GA20795@elte.hu>
 <4D6F077B.3060400@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6F077B.3060400@tao.ma>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Tao Ma <tm@tao.ma> wrote:

> On 03/02/2011 04:45 PM, Ingo Molnar wrote:
> >* Liu Yuan<namei.unix@gmail.com>  wrote:
> >
> >>+		if (likely(!retry_find)&&  page&&  PageUptodate(page))
> >>+			page_cache_acct_hit(inode->i_sb, READ);
> >>+		else
> >>+			page_cache_acct_missed(inode->i_sb, READ);
> >Sigh.
> >
> >This would make such a nice tracepoint or sw perf event. It could be collected in a
> >'count' form, equivalent to the stats you are aiming for here, or it could even be
> >traced, if someone is interested in such details.
> >
> >It could be mixed with other events, enriching multiple apps at once.
> >
> >But, instead of trying to improve those aspects of our existing instrumentation
> >frameworks, mm/* is gradually growing its own special instrumentation hacks, missing
> >the big picture and fragmenting the instrumentation space some more.

> Thanks for the quick response. Actually our team(including Liu) here are planing 
> to add some debug info to the mm parts for analyzing the application behavior and 
> hope to find some way to improve our application's performance. We have searched 
> the trace points in mm, but it seems to us that the trace points isn't quite 
> welcomed there. Only vmscan and writeback have some limited trace points added. 
> That's the reason we first tried to add some debug info like this patch. You does 
> shed some light on our direction. Thanks.

Yes, it's very much a 'critical mass' phenomenon: the moment there's enough 
tracepoints, above some magic limit, things happen quickly and everyone finds the 
stuff obviously useful.

Before that limit it's all pretty painful.

> btw, what part do you think is needed to add some trace point?  We
> volunteer to add more if you like.

Whatever part you find useful in your daily development work!

Tracepoints are pretty flexible. The bit that is missing and which is very important 
for the MM is the collapse into 'summaries' and the avoidance of tracing overhead 
when only a summary is wanted. Please see Wu Fengguang's reply in this thread about 
the 'dump state' facility he and Steve added to recover large statistics.

I suspect the hit/miss histogram you are building in this patch could be recovered 
via that facility initially?

The next step would generalize that approach - it is non-trivial but powerful :-)

The idea is to allow non-trivial histograms and summaries to be built out of simple 
events, via the filter engine.

It would require an extension of tracing to really allow a filter expression to be 
defined over existing events, which would allow the maintenance of a persistent 
'sum' variable - probably within the perf ring-buffer. We already have filter 
support, that would have to be extended with a notion of 'persistent variables'.

So right now, if you define a tracepoint in that spot, we already support such 
filter expressions:

     'bdev == sda1 && page_state == PageUptodate'

You can inject such filter expressions into /debug/tracing/events/*/*/filter today, 
and you can use filters in perf record --filter '...' as well.

To implement 'fast statistics', the filter engine would have to be extended to 
support (simple) statements like:

	if (bdev == sda1 && page_state == PageUptodate)'
		var0++;

And:

	if (bdev == sda1 && page_state != PageUptodate)'
		var1++;

Only a very minimal type of C syntax would be supported - not a full C parser.

That way the 'var0' portion of the perf ring-buffer (which would not be part of the 
regular, overwritten ring-buffer) would act as a 'hits' variable that you could 
recover. The 'var1' portion would be the 'misses' counter.

Individual trace events would only twiddle var0 and var1 - they would not inject a 
full-blown event into the ring-buffer, so statistics would be very fast.

This method is very extensible and could be used for far more things than just MM 
statistics. In theory all of /proc statistics collection could be replaced and made 
optional that way, just by adding the right events to the right spots in the kernel.  
That is obviously a very long-term project.

Thanks,

	Ingo
