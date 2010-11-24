Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0KXNsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:48:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35003 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab0KXNss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:48:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ub+NDLvbZA+f9Z+sRcMauvZm2M0QMUGKTyIC0dVl9tLiBJ+9IsfAUTKl9xDq8srxtY
         udWgsRyLsTpPe4kDXlgh0LRp+yyTWe2JJHoivU4vefccR2ToUgZpbivpsVKH3RuFgw92
         vuBCqb4oapf36GgVim6dEovlmvTnjv/mYHTyU=
MIME-Version: 1.0
In-Reply-To: <20101124062212.GA2165@linux.vnet.ibm.com>
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
	<1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
	<20101124005820.GH8056@linux.vnet.ibm.com>
	<AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
	<AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
	<20101124062212.GA2165@linux.vnet.ibm.com>
Date: Wed, 24 Nov 2010 14:48:46 +0100
Message-ID: <AANLkTimjZnAfeuAXU7oXPRG5=qJ2d7aZVoozSm88kXMT@mail.gmail.com>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states after
 extended grace periods
From: Frederic Weisbecker <fweisbec@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/24 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Wed, Nov 24, 2010 at 03:33:21AM +0100, Frederic Weisbecker wrote:
>> 2010/11/24 Frederic Weisbecker <fweisbec@gmail.com>:
>> > On Tue, Nov 23, 2010 at 04:58:20PM -0800, Paul E. McKenney wrote:
>> >> On Wed, Nov 24, 2010 at 01:31:12AM +0100, Frederic Weisbecker wrote:
>> >> > When a cpu is in an extended quiescent state, which includes idle
>> >> > nohz or CPU offline, others CPUs will take care of the grace periods
>> >> > on its behalf.
>> >> >
>> >> > When this CPU exits its extended quiescent state, it will catch up
>> >> > with the last started grace period and start chasing its own
>> >> > quiescent states to end the current grace period.
>> >> >
>> >> > However in this case we always start to track quiescent states if the
>> >> > grace period number has changed since we started our extended
>> >> > quiescent state. And we do this because we always assume that the last
>> >> > grace period is not finished and needs us to complete it, which is
>> >> > sometimes wrong.
>> >> >
>> >> > This patch verifies if the last grace period has been completed and
>> >> > if so, start hunting local quiescent states like we always did.
>> >> > Otherwise don't do anything, this economizes us some work and
>> >> > an unnecessary softirq.
>> >>
>> >> Interesting approach!  I can see how this helps in the case where the
>> >> CPU just came online, but I don't see it in the nohz case, because the
>> >> nohz case does not update the rdp->completed variable.  In contrast,
>> >> the online path calls rcu_init_percpu_data() which sets up this variable.
>> >>
>> >> So, what am I missing here?
>> >>
>> >>                                                       Thanx, Paul
>> >>
>> >> PS.  It might well be worthwhile for the online case alone, but
>> >>      the commit message does need to be accurate.
>> >
>> >
>> > So, let's take this scenario (inspired from a freshly dumped trace to
>> > clarify my ideas):
>> >
>> > CPU 1 was idle, it has missed several grace periods, but CPU 0 took care
>> > of that.
>> >
>> > Hence, CPU 0's rdp->gpnum = rdp->completed = 4294967000


(Actually I was talking about CPU 1 here. CPU was idle and
has rdp->gpnum and rdp->completed at 4294967000.

While the global state and even the node are on 4294967002


> But CPU 1's rdp state is outdated, due to locking design.

Yeah.


>> > But the last grace period was 4294967002 and it's completed
>> > (rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).
>> >
>> > Now CPU 0 gets a tick for a random reason, it calls rcu_check_callbacks()
>> > and then rcu_pending() which raises the softirq because of this:
>> >
>> >        /* Has another RCU grace period completed?  */
>> >        if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
>> >                rdp->n_rp_gp_completed++;
>> >                return 1;
>> >        }
>
> Yes, because CPU 0 has not yet updated its rdp state.


So again I made a mistake. Here it's CPU 1 that takes this path, the outdated
CPU that was idle.

So yeah, here it has not yet updated its rdp state, it's still 2
offsets backwards.


>> > The softirq fires, we call rcu_process_gp_end() which will
>> > update rdp->completed into the global state:
>> > (rsp->completed = rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).
>> >
>> > But rsp->pgnum is still 2 offsets backwards.
>
> This one is hard for me to believe -- rsp->gpnum drives the rest of
> the ->gpnum fields, right?


Oops, I meant rdp->pgnum is still 2 offsets backward, for CPU 1.

Sorry.


>> > Now we call rcu_check_quiescent_state() -> check_for_new_grace_period()
>> > -> note_new_gpnum() and then we end up a requested quiescent state while
>> > every grace periods are completed.
>>
>> Sorry I should have described that in the changelogs but my ideas
>> weren't as clear as they
>> are now (at least I feel they are, doesn't mean they actually are ;)
>> Chasing these RCU bugs for too much hours has toasted my brain..
>
> Welcome to my world!!!  But keep in mind that an extra timer tick
> or two is much preferable to a potential hang!  And you only get
> the extra timer tick if there was some other reason that the
> CPU came out of nohz mode, correct?


Yeah, either because of a timer, hrtimer, or a reschedule.
But you still generate a spurious softirq in this scheme.

Two in fact: one because of the rnp->completed != rsp->completed condition
in rcu_pending(), another one because when we update the pgnum, we
always start chasing QS, regardless of the last GP beeing completed or not.


> Which is why checking the rnp fields makes more sense to me, actually.
> Acquiring rnp->lock is much less painful than pinning down the rsp state.

Right.

Another thing, we  already have the (rnp->gpnum) != rdp->gpnu check in
rcu_pending(),
why also checking (rnp->completed) != rdp->completed) ?

Thanks.
