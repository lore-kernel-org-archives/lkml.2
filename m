Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0KZOGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:06:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44149 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0KZOGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:06:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KOJ1Fsf9c2GgE0moI/HvvitpKtmrhAPJC8qwsHxkTYp0eBCMw/o6IsxSB0gB5DJDjC
         wdwFhbdEQe/XJJ6zN1vawU5eDJzaf2n9nAPfhl33eia5m7IclqTk7DAXkNpd93FB8IFO
         wnQ1sXAOfxubKbR97Hgktgtl+GNymB1sWZG8o=
Date: Fri, 26 Nov 2010 15:06:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states
 after extended grace periods
Message-ID: <20101126140639.GA1675@nowhere>
References: <AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
 <20101124062212.GA2165@linux.vnet.ibm.com>
 <AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
 <20101124144240.GC2165@linux.vnet.ibm.com>
 <AANLkTi=EA09DACMNLUpTU8qH5wFPdXvOMQzJeejXX170@mail.gmail.com>
 <20101124161513.GA2207@linux.vnet.ibm.com>
 <AANLkTikbZUO6MbSC=uWYp4JRCdHPHrr5Z2_=to1YsC1X@mail.gmail.com>
 <20101124182051.GF2207@linux.vnet.ibm.com>
 <20101124234257.36870244@nowhere>
 <20101125145632.GC2162@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101125145632.GC2162@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 06:56:32AM -0800, Paul E. McKenney wrote:
> On Wed, Nov 24, 2010 at 11:42:57PM +0100, Frederic Weisbecker wrote:
> > Le Wed, 24 Nov 2010 10:20:51 -0800,
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> a écrit :
> > 
> > > On Wed, Nov 24, 2010 at 06:38:45PM +0100, Frederic Weisbecker wrote:
> > > > Yeah. I mean, I need to read how the code manages the different
> > > > queues. But __rcu_process_gp_end() seems to sum it up quite well.
> > > 
> > > For advancing callbacks, that is the one!  For invocation of
> > > callbacks, see rcu_do_batch().
> > 
> > Ok.
> > 
> > > > It's more like couldn't ever stop the tick. But that doesn't
> > > > concern mainline. This is because I have a hook that prevents the
> > > > tick from beeing stopped until rcu_pending() == 0.
> > > 
> > > That would certainly change behavior!!!  Why did you need to do that?
> > > 
> > > Ah, because force_quiescent_state() has not yet been taught about
> > > dyntick-HPC, got it...
> > 
> > Oh actually I have taught it about that. For such isolated CPU that
> > doesn't respond, it sends a specific IPI that will restart the tick if
> > we are not in nohz.
> > 
> > The point in restarting the tick is to find some quiescent states and
> > also to keep the tick for a little while for potential further grace
> > periods to complete while we are in the kernel.
> > 
> > This is why I use rcu_pending() from the tick: to check if we still
> > need the tick for rcu.
> 
> So if you have received the IPI, then you turn on the tick.  As soon as
> rcu_pending() returns false, you can turn off the tick.  Once the tick
> is off, you can go back to using rcu_needs_cpu(), right?  (At least
> until that CPU receives another RCU IPI.)

Yep. Although there is already a test for rcu_needs_cpu() in
tick_nohz_stop_sched_tick() that cancels the switch to nohz mode.

 
> Either that or you need to check for both rcu_needs_cpu() -and-
> rcu_pending().  Actually, you do need to check both during the time that
> you have the tick on after receiving an RCU IPI.

Yeah.
 
> > But it's not enough to track quiescent states. And we have no more timer
> > interrupts to track them. So we need to restart the tick at least until
> > we find a quiescent state for the grace period waiting for us.
> > 
> > But I may be missing something either :)
> 
> Well, I don't know whether or not you are missing it, but I do need to
> get my act together and get RCU priority boosting ported from tiny
> RCU to tree RCU.  Otherwise, force_quiescent_state() cannot do much
> for preemptible RCU.

And if I understood it correctly, RCU priority boosting involves a new
kthread that handles the callbacks instead of a softirq? So that you
can give dynamic priority to this thread and so?

How will that help in the preemptibe RCU case to force the quiescent
state? Scheduling the kthread doesn't mean that every tasks that were
preempted have been rescheduled and exited their rcu_read_unlock(), so
I guess you plan another trickery :)


> > > > Ah, I see what you mean. So you would suggest to even ignore those
> > > > explicit QS report when in dynticj-hpc mode for CPUs that don't
> > > > have callbacks?
> > > > 
> > > > Why not keeping them?
> > > 
> > > My belief is that people needing dyntick-HPC are OK with RCU grace
> > > periods taking a few jiffies longer than they might otherwise.
> > > Besides, when you are running dyntick-HPC, you aren't context
> > > switching much, so keeping the tick doesn't buy you as much reduction
> > > in grace-period latency.
> > 
> > But don't we still need the tick on such cases, (if we aren't in
> > userspace) when a grace period starts, to note our grace periods?
> > The rcu IPI itself doesn't seem to be sufficient for that.
> > 
> > I'm not sure I undrstand what you mean.
> 
> If there is a grace period, there must be an RCU callback.  The CPU that
> has the RCU callback queued will keep its own tick going, because
> rcu_needs_cpu() will return true.
> 
> The reason for ignoring the explicit QS reports in at least some of the
> cases is that paying attention to them requires that the tick be enabled.
> Which is fine for most workloads, but not so good for workloads that care
> about OS jitter.

Is there another solution than restarting the tick a local CPU when we need
a quiescent state from it? The simple IPI is not enough to ensure we find a
decent grace period, in that case we need to restart the tick anyway if we
are in the kernel, no?

Enjoy your turkey(s) ;-)
