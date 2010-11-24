Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0KXC3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:29:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0KXC3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:29:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fo4O23HLqIdM8h1ZxvBfaPeuVevgkue31vZtdfcYUjv76hC+dJRmmyQ24iLx2JZMue
         T5/+Yy6WvAaEkxMYX6PUJlVwTakbKDgZ+IWADoUbblMaF3CgWkYavCm5LRQCL2d3qxXm
         g+B2SeRidudZsRINXAjsgnw/5uBs2S5ZdDJV4=
MIME-Version: 1.0
In-Reply-To: <20101124005820.GH8056@linux.vnet.ibm.com>
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
	<1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
	<20101124005820.GH8056@linux.vnet.ibm.com>
Date: Wed, 24 Nov 2010 03:29:43 +0100
Message-ID: <AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states after
 extended grace periods
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 04:58:20PM -0800, Paul E. McKenney wrote:
> On Wed, Nov 24, 2010 at 01:31:12AM +0100, Frederic Weisbecker wrote:
> > When a cpu is in an extended quiescent state, which includes idle
> > nohz or CPU offline, others CPUs will take care of the grace periods
> > on its behalf.
> >
> > When this CPU exits its extended quiescent state, it will catch up
> > with the last started grace period and start chasing its own
> > quiescent states to end the current grace period.
> >
> > However in this case we always start to track quiescent states if the
> > grace period number has changed since we started our extended
> > quiescent state. And we do this because we always assume that the last
> > grace period is not finished and needs us to complete it, which is
> > sometimes wrong.
> >
> > This patch verifies if the last grace period has been completed and
> > if so, start hunting local quiescent states like we always did.
> > Otherwise don't do anything, this economizes us some work and
> > an unnecessary softirq.
>
> Interesting approach!  I can see how this helps in the case where the
> CPU just came online, but I don't see it in the nohz case, because the
> nohz case does not update the rdp->completed variable.  In contrast,
> the online path calls rcu_init_percpu_data() which sets up this variable.
>
> So, what am I missing here?
>
> 							Thanx, Paul
>
> PS.  It might well be worthwhile for the online case alone, but
>      the commit message does need to be accurate.


So, let's take this scenario (inspired from a freshly dumped trace to
clarify my ideas):

CPU 1 was idle, it has missed several grace periods, but CPU 0 took care
of that.

Hence, CPU 0's rdp->gpnum = rdp->completed = 4294967000

But the last grace period was 4294967002 and it's completed
(rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).

Now CPU 0 gets a tick for a random reason, it calls rcu_check_callbacks()
and then rcu_pending() which raises the softirq because of this:

	/* Has another RCU grace period completed?  */
	if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
		rdp->n_rp_gp_completed++;
		return 1;
	}

The softirq fires, we call rcu_process_gp_end() which will
update rdp->completed into the global state:
(rsp->completed = rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).

But rsp->pgnum is still 2 offsets backwards.

Now we call rcu_check_quiescent_state() -> check_for_new_grace_period()
-> note_new_gpnum() and then we end up a requested quiescent state while
every grace periods are completed.

So, now that I describe all that, I wonder if actually the solution would
be better with changing the above condition to not fire the softirq to begin
with, because:

	rnp->completed != rdp->completed

doesn't seem to mean we need the current cpu. It just mean that the node
was smart enough to make its way without us when we were in an extended
quiescent state :)
