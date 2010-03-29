Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0C2WX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:23:26 -0400
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:35218 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751312Ab0C2WXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:23:24 -0400
Date: Tue, 30 Mar 2010 09:23:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>,
       Kent Overstreet <kent.overstreet@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: KVM bug, git bisected
Message-ID: <20100329222315.GQ3335@dastard>
References: <4BADFD74.8060904@gmail.com>
 <4BB0D11A.607@redhat.com>
 <1269880140.12097.356.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269880140.12097.356.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 06:29:00PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 12:11 -0400, Rik van Riel wrote:
> > On 03/27/2010 08:43 AM, Kent Overstreet wrote:
> > > commit 5beb49305251e5669852ed541e8e2f2f7696c53e
> > > Author: Rik van Riel <riel@redhat.com>
> > > Date: Fri Mar 5 13:42:07 2010 -0800
> > >
> > > mm: change anon_vma linking to fix multi-process server scalability issue
> > >
> > > I get this when starting kvm. The warning hasn't caused me problems, but
> > > I've also been getting a scheduling while atomic panic when I start kvm
> > > that I can only reproduce when I don't want to. It's definitely config
> > > dependent, I'd guess preempt might have something to do with it.
> > 
> >  From your trace, it looks like mm_take_all_locks is taking close
> > to 256 locks, which is where the preempt_count could overflow into
> > the softirq count.
> > 
> > Since kvm-qemu is exec'd, I am guessing you have a very large
> > number of VMAs in your qemu process.  Is that correct?
> > 
> > Peter, would it be safe to increase PREEMPT_BITS to eg. 10?
> 
> Possibly, but who's to say the thing won't bloat to 65k at which it'll
> hit the vma limit, but even that can be grown beyond that.

This issue came up a few years ago w.r.t. the per-cpu
superblock counters in XFS which used one spinlock per CPU to be held at
synchronisation/rebalance time. A 256p machine would fall over doing
this, and there was great resistance to increasing the preempt count
field size.

Instead, I changed the spinlocks to use a bit in a flag word in the
per-cpu structure and used a test_and_set_bit() loop to emulate a
spinlock. Then by adding an external preempt_disable()/enable() for
the fast and slow paths, they ultimately behave like spinlocks but
without causing preempt count windup.

I'm not suggesting that this is the solution to the current problem
case, just indicating that we've been here before and that there are
ways of avoiding preempt count windup in the cases where lots of
critical areas need to be locked out simultaneously....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
