Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab0HDPuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 11:50:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab0HDPuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 11:50:19 -0400
Date: Wed, 4 Aug 2010 11:50:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804155002.GS3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
 <20100804100116.GH26154@erda.amd.com>
 <20100804140021.GN3353@redhat.com>
 <1280931093.1923.1194.camel@laptop>
 <20100804145203.GP3353@redhat.com>
 <1280934161.1923.1294.camel@laptop>
 <20100804151858.GB5130@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804151858.GB5130@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 07:18:58PM +0400, Cyrill Gorcunov wrote:
> On Wed, Aug 04, 2010 at 05:02:41PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-08-04 at 10:52 -0400, Don Zickus wrote:
> > > > Right so I looked up your thing and while that limits the damage in that
> > > > at some point it will let NMIs pass, it will still consume too many.
> > > > Meaning that Yinghai will have to potentially press his NMI button
> > > > several times before it registers.
> > > 
> > > Ok.  Thanks for reviewing.  How does it consume to many?  I probably don't
> > > understand how perf is being used in the non-simple scenarios.
> > 
> > Suppose you have 4 counters (AMD, intel-nhm+), when more than 2 overflow
> > the first will raise the PMI, if the other 2+ overflow before we disable
> > the PMU it will try to raise 2+ more PMIs, but because hardware only has
> > a single interrupt pending bit it will at most cause a single extra
> > interrupt after we finish servicing the first one.
> > 
> > So then the first interrupt will see 3+ overflows, return 3+, and will
> > thus eat 2+ NMIs, only one of which will be the pending interrupt,
> > leaving 1+ NMIs from other sources to consume unhandled.
> > 
> > In which case Yinghai will have to press his NMI button 2+ times before
> > it registers.
> > 
> > That said, that might be a better situation than always consuming
> > unknown NMIs.. 
> > 
> 
> Well, first I guess having Yinghai CC'ed is a bonus ;)
> The second thing is that I don't get why perf handler can't be _last_
> call in default_do_nmi, if there were any nmi with reason (serr or parity)
> I think they should be calling first which of course don't eliminate
> the former issue but somewhat make it weaken.

Because the reason registers are never set.  If they were, then the code
wouldn't have to walk the notify_chain. :-)

Unknown nmis are unknown nmis, nobody is claiming them.  Even worse, there
are customers that want to register their nmi handler below the perf
handler to claim all the unknown nmis, so they can be logged on the system
before being rebooted.

Cheers,
Don
