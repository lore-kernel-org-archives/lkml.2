Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0FVQ0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:26:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61952 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab0FVQ0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:26:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C2EaZTs9/ZwqYdeaqt/L04C39MmVspBWE5VMqvu9vERKtpg9mbkZwwi+Rh7L5mSv85
         Gt/Nk2GSsK6BvEu4pvpCHqaiDkOt0EP9QDwUQAsRi+JCf/LTkhzQWhHmiwyIouaYWOO4
         MxFwrTTeZKyW7bkT0Qyvj4pvWHkn1wXh50Pe8=
Date: Tue, 22 Jun 2010 18:26:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 8/8] perf: Rework the PMU methods
Message-ID: <20100622162652.GB5458@nowhere>
References: <20100616160027.590430763@chello.nl> <20100616160238.721536975@chello.nl> <20100618042143.GE5345@nowhere> <1276845338.27822.1450.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276845338.27822.1450.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 09:15:38AM +0200, Peter Zijlstra wrote:
> On Fri, 2010-06-18 at 06:21 +0200, Frederic Weisbecker wrote:
> > On Wed, Jun 16, 2010 at 06:00:35PM +0200, Peter Zijlstra wrote:
> > > -static void x86_pmu_stop(struct perf_event *event)
> > > +static void x86_pmu_stop(struct perf_event *event, int flags)
> > >  {
> > > -	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > > -	struct hw_perf_event *hwc = &event->hw;
> > > -	int idx = hwc->idx;
> > > -
> > >  	if (!__test_and_clear_bit(idx, cpuc->active_mask))
> > > -		return;
> > 
> > 
> > 
> > Do you still need active_mask now that you have HES_STOPPED?
> 
> there still were some users, but yeah, we cuold probably clean that up,
> bit since the patch is large enough as is, I didn't attempt that.


Yeah, that can be done later.


 
> > > +static void perf_swevent_start(struct perf_event *event, int flags)
> > > +{
> > > +	event->hw.state = 0;
> > > +}
> > > +
> > > +static void perf_swevent_stop(struct perf_event *event, int flags)
> > >  {
> > > +	event->hw.state = 1;
> > >  }
> > 
> > 
> > So, instead of doing this and add yet another check in the fast path,
> > what about just playing with the hlist insertion and deletion?
> 
> I wanted to avoid too much trickery, first make a simple one work, then
> try something fancy.



Ok, as far it's not considered a long term thing. I can
improve that from my exclusion patchset, rebased on top of yours.




> > It would be nice to have a PERF_EF_STOP as well in ->del, so that
> > each pmu don't need to maintain an internal state.
> 
> You have to track it since we can stop the thing outselves without the
> caller knowing.


>From the pmu internals yeah, that's what the x86 pmu does. But otherwise, other
pmu don't do such things.

