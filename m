Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab0FRMqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 08:46:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35807 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932178Ab0FRMqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 08:46:08 -0400
Date: Fri, 18 Jun 2010 14:45:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100618124551.GC7612@elte.hu>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
 <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
 <20100618094838.GD23977@elte.hu>
 <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* huang ying <huang.ying.caritas@gmail.com> wrote:

> Hi, Ingo,
> 
> On Fri, Jun 18, 2010 at 5:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
> >
> >> (2010/06/12 19:25), Ingo Molnar wrote:
> >> >
> >> > * Huang Ying <ying.huang@intel.com> wrote:
> >> >
> >> >> NMI can be triggered even when IRQ is masked. So it is not safe for NMI
> >> >> handler to call some functions. One solution is to delay the call via self
> >> >> interrupt, so that the delayed call can be done once the interrupt is
> >> >> enabled again. This has been implemented in MCE and perf event. This patch
> >> >> provides a unified version and make it easier for other NMI semantic handler
> >> >> to take use of the delayed call.
> >> >
> >> > Instead of introducing this extra intermediate facility please use the same
> >> > approach the unified NMI watchdog is using (see latest -tip): a perf event
> >> > callback gives all the extra functionality needed.
> >> >
> >> > The MCE code needs to be updated to use that - and then it will be integrated
> >> > into the events framework.
> >>
> >> Hi Ingo,
> >>
> >> I think this "NMI delayed call mechanism" could be a part of "the events
> >> framework" that we are planning to get in kernel soon. [...]
> >
> > My request was to make it part of perf events - which is a generic event 
> > logging framework. We dont really need/want a second 'events framework' as 
> > we have one already ;-)
> 
> This patchset is simple and straightforward, [...]

We wouldnt want to add another workqueue or memory allocation mechanism 
either, even if it was 'simple and straightforward'. We try to make things 
more generally useful.

> [...] it is just a delayed execution mechanism, not another 'events 
> framework'. There are several other NMI users other than perf, should we 
> integrate all NMI users into perf framework?

We already did so with the NMI watchdog. What other significant NMI event 
users do you have in mind?

> >> [...] ??At least APEI will use NMI to report some hardware events (likely 
> >> error) to kernel. ??So I suppose we will go to have a delayed call as an 
> >> event handler for APEI.
> >
> > Yep, that makes sense. I wasnt arguing against the functionality itself, i 
> > was arguing against the illogical layering that limits its utility. By 
> > making it part of perf events it becomes a generic part of that framework 
> > and can be used by anything that deals with events and uses that 
> > framework.
> 
> I think the the 'layering' in the patchset helps instead of 'limits' its 
> utility. It is designed to be as general as possible, so that it can be used 
> by both perf and other NMI users. Do you think so?

What other NMI users do you mean? EDAC/MCE is going to go utilize events as 
well (away from the horrible /dev/mcelog interface), the NMI watchdog already 
did it and the perf tool obviously does as well. There's a few leftovers like 
kcrash which isnt really event centric and i dont think it needs to be 
converted.

Thanks,

	Ingo
