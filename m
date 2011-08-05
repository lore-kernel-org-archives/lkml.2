Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1HEJut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:50:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52096 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1HEJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:50:48 -0400
Date: Fri, 5 Aug 2011 11:49:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [perf] enable raw OFFCORE_EVENTS for non-perf userspace
Message-ID: <20110805094942.GB2420@elte.hu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
 <1312473330.16729.42.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312473330.16729.42.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2011-08-03 at 12:05 -0400, Vince Weaver wrote:
> > Hello
> > 
> > I propose we just enable raw OFFCORE_EVENT support and get it over with.
> > 
> > There is a lot of demand for this from PAPI users, and so we encourage 
> > them to apply the below patch.  PAPI supports this out of the box.
> > 
> > The current "block" against using this feature *DOES NOT WORK*.
> > It silently fails if you try to use the config1 field to set it.
> > 
> > Even worse, if some previous user has set the OFFCORE_RSP_0 msr
> > (say by running "perf stat -e LLC-load-misses") then
> > the msr *stays set* and if you try to set the config1 field on your own
> > it looks like it worked, but instead it is using whatever value the
> > kernel last used.
> > 
> > So there's a lot of userspace confusion about this, and you can't even 
> > reliably tell if the feature is turned off or not because it fails 
> > silently in unpredictable ways.
> 
> 
> > diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> > index 4ee3abf..28f9ca9 100644
> > --- a/arch/x86/kernel/cpu/perf_event.c
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -604,12 +604,8 @@ static int x86_setup_perfctr(struct perf_event *event)
> >  			return -EOPNOTSUPP;
> >  	}
> >  
> > -	/*
> > -	 * Do not allow config1 (extended registers) to propagate,
> > -	 * there's no sane user-space generalization yet:
> > -	 */
> >  	if (attr->type == PERF_TYPE_RAW)
> > -		return 0;
> > +		return x86_pmu_extra_regs(event->attr.config, event);
> >  
> >  	if (attr->type == PERF_TYPE_HW_CACHE)
> >  		return set_ext_hw_attr(hwc, event);
> 
> 
> I'm inclined to merge this, aside from snb, the offcore stuff is 
> actually quite usable now. Ingo can we somehow persuade you?

Sure, i think we are almost there, the only missing bit i see is to 
add the now generalized NUMA node bits to tools/perf/ so that it can 
be tested easily and then we can enable the raw bits as well.

It was supposed to be added alongside of:

  89d6c0b: perf, arch: Add generic NODE cache events

what happened to that? If someone wants to accelerate the raw events 
enabling then that should be an easy thing to fix.

Thanks,

	Ingo
