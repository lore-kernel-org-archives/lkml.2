Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0FYKLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 06:11:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:44909 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0FYKLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 06:11:11 -0400
Date: Fri, 25 Jun 2010 20:11:08 +1000
From: Nick Piggin <npiggin@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 05/52] lglock: introduce special lglock and brlock spin
 locks
Message-ID: <20100625101108.GY10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030726.371426768@suse.de>
 <alpine.LFD.2.00.1006241904160.2911@localhost.localdomain>
 <20100625062250.GS10441@laptop>
 <alpine.LFD.2.00.1006251140090.2587@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006251140090.2587@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 11:50:02AM +0200, Thomas Gleixner wrote:
> On Fri, 25 Jun 2010, Nick Piggin wrote:
> > On Thu, Jun 24, 2010 at 08:15:54PM +0200, Thomas Gleixner wrote:
> > > On Thu, 24 Jun 2010, npiggin@suse.de wrote:
> > > 
> > > > +#define DEFINE_LGLOCK(name)						\
> > > > +									\
> > > > + DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
> > > 
> > > Uuurgh. You want to make that an arch_spinlock ? Just to avoid the
> > > preempt_count overflow when you lock all cpu locks nested ?
> > 
> > Yep, and the lockdep wreckage too :)
> > 
> > Actually it's nice to avoid the function call too (lglock/brlocks
> > are already out of line). Calls aren't totally free, especially
> > on small chips without RSBs. And even with RSBs it's helpful not
> > to overflow them, although Nehalem seems to have 12-16 entries.
> >  
> > 
> > > I'm really not happy about that, it's going to be a complete nightmare
> > > for RT. If you wanted to make this a present for RT giving the
> > > scalability stuff massive testing, then you failed miserably :)
> > 
> > Heh, it's a present for -rt because the locking is quite isolated
> > (I did the same thing with hashtable bitlocks, added a new structure
> > for them, in case you prefer spinlocks than bit spinlocks there).
> 
> Sure, bitlocks are equally horrible.
> 
> > -rt already changes locking primitives, so in the worst case you
> > might have to tweak this. My previous patches were open coding
> > these locks in fs/ so I can understand why that was a headache.
> 
> I agree that having the code isolated makes my life easier, but I'm a
> bit worried about the various new locking primitives which pop up in
> all corners of the kernel.

Be sure to shout at people for it :). Locking primitives really need
to be reviewed, and having them in common places lets other people
use them too.

 
> > I think I'll keep it as is for now, it's hard enough to keep single
> > threaded performance up. But it should be much easier to override
> > this in -rt and I'll be happy to try restructuring things to help rt
> > if and when it's possible.
> 
> Ok, lets see how bad it gets :)

Ok good.

