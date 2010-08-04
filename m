Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925Ab0HDOwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464Ab0HDOwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:52:19 -0400
Date: Wed, 4 Aug 2010 10:52:03 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804145203.GP3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
 <20100804100116.GH26154@erda.amd.com>
 <20100804140021.GN3353@redhat.com>
 <1280931093.1923.1194.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280931093.1923.1194.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 04:11:33PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-08-04 at 10:00 -0400, Don Zickus wrote:
> > On Wed, Aug 04, 2010 at 12:01:16PM +0200, Robert Richter wrote:
> > > There is no general mechanism for recording the NMI source (except if
> > > it was external triggered, e.g. by the southbridge). Also, all nmis
> > > are mapped to NMI vector 2 and therefore there is no way to find out
> > > the reason by using apic mask registers.
> > 
> > This is no different than a shared interrupt, no?  All the nmi handlers
> > need to check their own sources to see if they triggered it.  You can't
> > expect the generic nmi handler to determine this.
> 
> Sure, but the problem is that the PMU can't reliably do that.

Right, but that is because there is no bit that says the PMU generated the
nmi.  But for the most part checking to see if the PMU is >0 is good
enough, no?

> 
> > > Now, if multiple perfctrs trigger an nmi, it may happen that a handler
> > > has nothing to do because the counter was already handled by the
> > > previous one. Thus, it is valid to have unhandled nmis caused by
> > > perfctrs.
> > > 
> > > So, with counters enabled we always have to return stop for *all* nmis
> > > as we cannot detect that it was an perfctr nmi. Otherwise we could
> > > trigger an unhandled nmi. To ensure that all other nmi handlers are
> > > called, the perfctr's nmi handler must have the lowest priority. Then,
> > > the handler will be the last in the chain.
> > 
> > But the cases this break are, external NMI buttons, broken firmware that
> > causes SERRs on the PCI bus, and any other general hardware failures.
> 
> It breaks broken firmware? :-) and you care?

Absolutely.  When a customer complains they upgraded their RHEL kernel and
the box suddenly hangs on boot trying to access the storage device, yes I
care.  Because a flood of NMIs would indiciate something is fishy with
the firmware (in this case it was a network card though it hung on storage
access).  Swallowing the NMIs would just cause everyone to waste weeks of
their time trying to figure it out (you don't want to know how many weeks
were wasted in RHEL-6 across multiple machines only to find out it was
broken firmware on a card that no one suspected as being the culprit).

As much as I hate broken firmware, it is becoming common place, and the
faster the kernel can point it out through unknown nmis, the faster we can
get the vendor involved to fix it.

> 
> > So what the perf handler does is really unacceptable.  The only reason we
> > are noticing this now is because I put the nmi_watchdog on top of the perf
> > subsystem, so it always has a user and will trigger NOTIFY_STOP.  Before,
> > it never had a registerd user so instead returned NOTIFY_DONE and
> > everything worked great.
> 
> Right so I looked up your thing and while that limits the damage in that
> at some point it will let NMIs pass, it will still consume too many.
> Meaning that Yinghai will have to potentially press his NMI button
> several times before it registers.

Ok.  Thanks for reviewing.  How does it consume to many?  I probably don't
understand how perf is being used in the non-simple scenarios.

Cheers,
Don

