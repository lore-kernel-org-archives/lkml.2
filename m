Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0I3Tpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:45:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0I3Tpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:45:40 -0400
Date: Thu, 30 Sep 2010 15:44:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100930194451.GI26290@redhat.com>
References: <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
 <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
 <20100929154528.GD9440@lenovo>
 <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
 <20100929170924.GR13563@erda.amd.com>
 <20100929181207.GW26290@redhat.com>
 <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
 <20100930091246.GV13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100930091246.GV13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:12:46AM +0200, Robert Richter wrote:
> On 29.09.10 15:42:26, Stephane Eranian wrote:
> > On Wed, Sep 29, 2010 at 8:12 PM, Don Zickus <dzickus@redhat.com> wrote:
> > > I think you missed Stephane's point.  Say for example, kgdb is being used
> > > while we are doing stuff with the perf counter (and say kgdb's handler is
> > > a lower priority than perf; which isn't true I know, but let's say):
> > >
> > Yes, exactly my point. The reality is you cannot afford to have false positive
> > because you may starve another subsystem from an important notification.
> 
> As soon as you stop executing the chain, there are chances to miss an
> nmi for other parts of the system. Where is no way to avoid this. So
> your argument above is valid also for regular perf nmis and not only
> for catched-spurious or back-to-back nmis.

I don't agree with that.  Most nmi handlers can do a check to see if their
subsystem triggered an nmi or not.  Now we may not catch it in the right
order because one handler is higher in the chain than the other, but
ultimately the other handler will get its chance to execute because it
fired its own nmi (which hasn't been lost).

Whereas the problem Stephane is describing is that the heurestics of the
perf counters 'eats' an NMI, thus possibly starving another handler.  With
back-to-back nmis we are at least polite, letting everyone have a chance to
process the nmi before we indulge ourselves and 'eat' it (if it still
around to be eaten).

However in the case of the 'catched-spurious', we selfishly 'eat' the NMI
without really knowing if it was our to be eaten.  That was the
difference and the concern.

> 
> > > Now I sent a patch last week that can prevent that extra NMI from being
> > > generated at the cost of another rdmsrl in the non-pmu_stop cases (which I
> > > will attach below again, obviously P4 would need something similar too).
> 
> A rdmsrl() does not help, it only causes overhead. There is no bit to
> detect if a counter overflowed and triggered the interrupt, you only
> know the counter value is greater zero or not.

Well, the counters are programmed to trigger an NMI when it crosses zero.
So if we delay reprogramming the counters until after we know if we are
going to issue a pmu_stop, then it should be impossible to trigger an
overflow (because the counters are going to keeping counting above zero,
unless it wraps which would be a different problem all together).

> 
> We should take care the discussion becomes not academical and do not
> start to overengineer something. I always can imagine some really rare
> corner cases in which we may loss an nmi. This is because hardware is
> not built for it. But in 99% or so of the cases we get all nmis,
> instead of before where all nmis were eaten by the profiler.

I don't think this is over engineering.  Basically we haven't seen the
problem yet because the only really active nmi handler is the perf one and
it is designed to be last on the list.  If we start fiddling with
priorities and re-arranging the list, the problem might be exposed quicker
than you think.

Trying to prevent a 'spurious' NMI in the back-to-back case might be a
case for over-engineering, I'll agree to that (I think I tried and
realized how foolish that was).

Cheers,
Don
