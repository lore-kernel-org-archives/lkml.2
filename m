Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab0HDOLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:11:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:54855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab0HDOLq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:11:46 -0400
Subject: Re: A question of perf NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Robert Richter <robert.richter@amd.com>, Lin Ming <ming.m.lin@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <20100804140021.GN3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
	 <20100804100116.GH26154@erda.amd.com>  <20100804140021.GN3353@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 16:11:33 +0200
Message-ID: <1280931093.1923.1194.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 10:00 -0400, Don Zickus wrote:
> On Wed, Aug 04, 2010 at 12:01:16PM +0200, Robert Richter wrote:
> > There is no general mechanism for recording the NMI source (except if
> > it was external triggered, e.g. by the southbridge). Also, all nmis
> > are mapped to NMI vector 2 and therefore there is no way to find out
> > the reason by using apic mask registers.
> 
> This is no different than a shared interrupt, no?  All the nmi handlers
> need to check their own sources to see if they triggered it.  You can't
> expect the generic nmi handler to determine this.

Sure, but the problem is that the PMU can't reliably do that.

> > Now, if multiple perfctrs trigger an nmi, it may happen that a handler
> > has nothing to do because the counter was already handled by the
> > previous one. Thus, it is valid to have unhandled nmis caused by
> > perfctrs.
> > 
> > So, with counters enabled we always have to return stop for *all* nmis
> > as we cannot detect that it was an perfctr nmi. Otherwise we could
> > trigger an unhandled nmi. To ensure that all other nmi handlers are
> > called, the perfctr's nmi handler must have the lowest priority. Then,
> > the handler will be the last in the chain.
> 
> But the cases this break are, external NMI buttons, broken firmware that
> causes SERRs on the PCI bus, and any other general hardware failures.

It breaks broken firmware? :-) and you care?

> So what the perf handler does is really unacceptable.  The only reason we
> are noticing this now is because I put the nmi_watchdog on top of the perf
> subsystem, so it always has a user and will trigger NOTIFY_STOP.  Before,
> it never had a registerd user so instead returned NOTIFY_DONE and
> everything worked great.

Right so I looked up your thing and while that limits the damage in that
at some point it will let NMIs pass, it will still consume too many.
Meaning that Yinghai will have to potentially press his NMI button
several times before it registers.
