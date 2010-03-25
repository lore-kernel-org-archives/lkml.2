Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0CYTCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 15:02:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38035 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab0CYTCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 15:02:16 -0400
Date: Thu, 25 Mar 2010 20:01:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com, Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH] Prevent nested interrupts when the IRQ stack is near
 overflowing v2
Message-ID: <20100325190126.GA19536@elte.hu>
References: <alpine.LFD.2.00.1003250001500.3147@localhost.localdomain>
 <20100325003652.GG20695@one.firstfloor.org>
 <alpine.LFD.2.00.1003250201370.3147@localhost.localdomain>
 <20100325093744.GH20695@one.firstfloor.org>
 <alpine.LFD.2.00.1003251133010.3147@localhost.localdomain>
 <alpine.LFD.2.00.1003250842240.3721@i5.linux-foundation.org>
 <1269539254.12097.100.camel@laptop>
 <alpine.LFD.2.00.1003251054030.3721@i5.linux-foundation.org>
 <1269541282.12097.106.camel@laptop>
 <1269541438.12097.107.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269541438.12097.107.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-03-25 at 19:21 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-03-25 at 11:01 -0700, Linus Torvalds wrote:
> > > Are there any cases around 
> > > that still have busy-loop delays based on real-time in their irq handlers? 
> > > I simply don't know. 
> > 
> > I recently found a few in drivers/net/ there's all kinds of funny stuff
> > in there.. not sure how common the matching hardware is though.
> > 
> > One thing we could do is instrument jiffies to yell when its used from
> > hardirq context and fix up these things.
> 
> Also, Arjan mentioned he wanted to sweep the kernel for jiffies users and 
> convert them to timer interfaces..

Dynticks found most of the loop-for-jiffies-in-handlers cruft: an IRQ handler 
hitting the idle loop and then spinning for jiffies, with dynticks enabled, 
would spin forver because there's no timer irq.

That is because in dynticks mode we dont reactivate the tick when we go into 
an irq handler (that has hit the idle task). So any looping on jiffies will 
loop forever. We only reactivate the tick when we go out of idle.

We had a few bugs of that kind in the early days of dynticks - they were not 
particularly numerous and all were fixed.

Thanks,

	Ingo
