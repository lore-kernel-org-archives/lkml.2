Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab1EPXwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:52:47 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65422 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1EPXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sRZUfeuMUGwqdjgi0j97jcWMpVJWQ8RO8QNgxk49MDmFgIaZ+X4WtYAIk36p5VFi0v
         2YGSbGUzoeVU0uzVBtPo+vW+y84kC4ACJ/YAVNxEwwQcJGyRjE2Ou+nFQF9szwYY+vce
         TcoUdZolZunJNN8doMVxmUb0nyiIt42V5/rDc=
Date: Tue, 17 May 2011 01:52:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110516235239.GD1738@nowhere>
References: <20110513130414.GA6863@elte.hu>
 <20110513131218.GA7669@elte.hu>
 <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
 <20110516212449.GJ2573@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516212449.GJ2573@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 02:24:49PM -0700, Paul E. McKenney wrote:
> On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > In the meantime, would you be willing to try out the patch at 
> > > > https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
> > > > several configurations.
> > > 
> > > Wasn't this the one i tested - or is it a new iteration?
> > > 
> > > I'll try it in any case.
> > 
> > oh, this was a new iteration, mea culpa!
> > 
> > And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)
> 
> ;-)
> 
> Unfortunately, the only reason I can see that it works is (1) there
> is some obscure bug in my code or (2) someone somewhere is failing to
> call irq_exit() on some interrupt-exit path.  Much as I might be tempted
> to paper this one over, I believe that we do need to find whatever the
> underlying bug is.
> 
> Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
> a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
> But I couldn't see any evidence of this in my admittedly cursory scan
> of the x86 interrupt-handling code.
> 
> So until I learn differently, I am assuming that each and every
> irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
> is called after the final irq_exit() of a given burst of interrupts.
> 
> If my assumptions are mistaken, please do let me know!

About 2), I believe that such an unpairing would have been detected before
your whole patchset was merged.
For example if an interrupt failed to call rcu_irq_exit(), we would have
found cases where we have:

rcu_enter_nohz()
<irq>
	rcu_irq_enter()
</irq>
rcu_exit_nohz()

And then that last call would trigger "WARN_ON_ONCE(!(rdtp->dynticks & 0x1))".

But may be there was a patch in your set that touched one of these rcu_irq_...
callsites.

About 3), it shouldn't happen because preempt_schedule_irq() is called in the
exit path of the low level interrupt handler. rcu_exit_irq() is called from
the higher level, before resuming to the low level.

That said there might be something nasty that the old checks in the QS APIs
were missing.

I think it would be nice to add some checks in rcu-lockdep inside
rcu_read_lock()/rcu_dereference() to ensure rdp->dynticks is not even, ie
that we are not in an extended qs. That's something I planned to add for
my next nohz tasks patchset version, because I bring more dance with the
extended quiescent state, but given the problems we are facing today, it
may be better sooner.
