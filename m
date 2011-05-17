Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1EQMnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:43:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39958 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab1EQMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SS4n3Mi39KFYFFreUmDH3ZYdB5n229yP0aHiKi3whZ4/Clwh9xnIGaVHeWtvTvS90A
         qEmdzrRiYZGZI1jWVgz4STeK0iC9KQPvCIhgzT1OKDWEZyIQEd2kzFNhhzP2XQHb3XGD
         jeGS0M1Lkr06NCwCGdtFVHjWrCLIjalgz94Tg=
Date: Tue, 17 May 2011 14:43:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110517124341.GA1776@nowhere>
References: <20110513141431.GV2258@linux.vnet.ibm.com>
 <20110513150744.GE32688@elte.hu>
 <20110513162646.GW2258@linux.vnet.ibm.com>
 <20110516070808.GC24836@elte.hu>
 <20110516074822.GE2573@linux.vnet.ibm.com>
 <20110516115148.GA2421@elte.hu>
 <20110516122329.GA29356@elte.hu>
 <20110516212449.GJ2573@linux.vnet.ibm.com>
 <20110517024000.GA5026@nowhere>
 <20110517075349.GQ2573@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110517075349.GQ2573@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 12:53:49AM -0700, Paul E. McKenney wrote:
> On Tue, May 17, 2011 at 04:40:03AM +0200, Frederic Weisbecker wrote:
> > On Mon, May 16, 2011 at 02:24:49PM -0700, Paul E. McKenney wrote:
> > > On Mon, May 16, 2011 at 02:23:29PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > > In the meantime, would you be willing to try out the patch at 
> > > > > > https://lkml.org/lkml/2011/5/14/89?  This patch helped out Yinghai in 
> > > > > > several configurations.
> > > > > 
> > > > > Wasn't this the one i tested - or is it a new iteration?
> > > > > 
> > > > > I'll try it in any case.
> > > > 
> > > > oh, this was a new iteration, mea culpa!
> > > > 
> > > > And yes, it solves all problems for me as well. Mind pushing it as a fix? :-)
> > > 
> > > ;-)
> > > 
> > > Unfortunately, the only reason I can see that it works is (1) there
> > > is some obscure bug in my code or (2) someone somewhere is failing to
> > > call irq_exit() on some interrupt-exit path.  Much as I might be tempted
> > > to paper this one over, I believe that we do need to find whatever the
> > > underlying bug is.
> > > 
> > > Oh, yes, there is option (3) as well: maybe if an interrupt deschedules
> > > a process, the final irq_exit() is omitted in favor of rcu_enter_nohz()?
> > > But I couldn't see any evidence of this in my admittedly cursory scan
> > > of the x86 interrupt-handling code.
> > > 
> > > So until I learn differently, I am assuming that each and every
> > > irq_enter() has a matching call to irq_exit(), and that rcu_enter_nohz()
> > > is called after the final irq_exit() of a given burst of interrupts.
> > > 
> > > If my assumptions are mistaken, please do let me know!
> > 
> > So it would be nice to have a trace of the calls to rcu_irq_*() / rcu_*_nohz()
> > before the unpairing happened.
> > 
> > I have tried to reproduce it but couldn't trigger anything.
> > 
> > So it would be nice if Yinghai can test the patch below, since he was able
> > to trigger the warning.
> > 
> > This is essentially Paul's patch but with stacktrace of the calls recorded.
> > Then the whole trace is dumped on the console when one of the WARN_ON_ONCE
> > sanity check is positive. Beware as the trace will be dumped everytime
> > WARN_ON_ONCE() is positive. So the first dump is enough, you can ignore the
> > rest.
> > 
> > This requires CONFIG_TRACING. May be a good thing to boot with
> > "ftrace=nop" parameter, so that ftrace will set up a long enough buffer
> > to have an interesting trace.
> 
> Very cool, thank you!!!  I was going to do something like this next,
> but given my lack of familiarity with tracing, your patch looks much
> nicer than mine would have been.
> 
> It applies fine on top of tip/core/rcu and builds OK.  I cannot reproduce
> the problem, either, so I am hoping that either Yinghai or Ingo can
> run this, and hopefully doing so will provide some enlightenment.
> 
> I have pushed this as:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git diag.2011.05.16b
> 
> I also #ifdefed out the bodies of rcu_nmi_enter() and rcu_nmi_exit()
> to match the earlier patches.
> 
> > PS: the first check in rcu_nmi_enter() doesn't seem to make sense.
> 
> Here is what it is doing:
> 
> o	rdtp->dynticks_nmi_nesting == 0:
> 
> 	Is this is the first-level NMI?  In theory this should always
> 	be true, but I don't trust NMIs to mask each other.  I have seen
> 	many systems where NMIs could interrupt other NMIs.
> 
> 	The idea is that if we already recorded one level of NMI, we
> 	had better record them all so we can figure out when we exit
> 	the last level of NMI handler.
> 
> o	atomic_read(&rdtp->dynticks) & 0x1):
> 
> 	Did the NMI interrupt a non-dyntick code segment?  If we did,
> 	then there is no need to tell RCU anything -- RCU is already
> 	paying attention to this CPU anyway due to the fact that the
> 	interrupted code segment was not in dyntick mode.

In fact I was rather referring to your last added check:

	if (rdtp->dynticks_nmi_nesting == 0 &&
-	    (atomic_read(&rdtp->dynticks) & 0x1))
+	    (atomic_read(&rdtp->dynticks) & 0x1)) {
+		WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
 		return;
+	}

> Again, thank you for adding the tracing!

No problem, I hope it will work as I couldn't test it myself.
