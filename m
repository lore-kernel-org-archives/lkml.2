Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0KXCdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:33:25 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48336 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0KXCdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h/Wqeer/sJ/zp9l6lRA9sL1KbSsuPXuJ47CTGE/ToSRZsopTiGobxNGJbTf9yKtue9
         z0cpcOyDa1QGCJMK8+P52AigSh/I8hNhSawmXx+G2PankbJxHExzCkS3sfZaYcsPV/VF
         YObAlPJH1bcavgJDgCCxOVyMm7gP9NqGB5CPI=
MIME-Version: 1.0
In-Reply-To: <AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
	<1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
	<20101124005820.GH8056@linux.vnet.ibm.com>
	<AANLkTikhGErGQrFB-QNiYjWt2PqRGdF+m3kOkt2tmnER@mail.gmail.com>
Date: Wed, 24 Nov 2010 03:33:21 +0100
Message-ID: <AANLkTinFhEf1XVSRYuL+JL=JETLZ6cz3GYCR8CL3ex8X@mail.gmail.com>
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

2010/11/24 Frederic Weisbecker <fweisbec@gmail.com>:
> On Tue, Nov 23, 2010 at 04:58:20PM -0800, Paul E. McKenney wrote:
>> On Wed, Nov 24, 2010 at 01:31:12AM +0100, Frederic Weisbecker wrote:
>> > When a cpu is in an extended quiescent state, which includes idle
>> > nohz or CPU offline, others CPUs will take care of the grace periods
>> > on its behalf.
>> >
>> > When this CPU exits its extended quiescent state, it will catch up
>> > with the last started grace period and start chasing its own
>> > quiescent states to end the current grace period.
>> >
>> > However in this case we always start to track quiescent states if the
>> > grace period number has changed since we started our extended
>> > quiescent state. And we do this because we always assume that the last
>> > grace period is not finished and needs us to complete it, which is
>> > sometimes wrong.
>> >
>> > This patch verifies if the last grace period has been completed and
>> > if so, start hunting local quiescent states like we always did.
>> > Otherwise don't do anything, this economizes us some work and
>> > an unnecessary softirq.
>>
>> Interesting approach!  I can see how this helps in the case where the
>> CPU just came online, but I don't see it in the nohz case, because the
>> nohz case does not update the rdp->completed variable.  In contrast,
>> the online path calls rcu_init_percpu_data() which sets up this variable.
>>
>> So, what am I missing here?
>>
>>                                                       Thanx, Paul
>>
>> PS.  It might well be worthwhile for the online case alone, but
>>      the commit message does need to be accurate.
>
>
> So, let's take this scenario (inspired from a freshly dumped trace to
> clarify my ideas):
>
> CPU 1 was idle, it has missed several grace periods, but CPU 0 took care
> of that.
>
> Hence, CPU 0's rdp->gpnum = rdp->completed = 4294967000
>
> But the last grace period was 4294967002 and it's completed
> (rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).
>
> Now CPU 0 gets a tick for a random reason, it calls rcu_check_callbacks()
> and then rcu_pending() which raises the softirq because of this:
>
>        /* Has another RCU grace period completed?  */
>        if (ACCESS_ONCE(rnp->completed) != rdp->completed) { /* outside lock */
>                rdp->n_rp_gp_completed++;
>                return 1;
>        }
>
> The softirq fires, we call rcu_process_gp_end() which will
> update rdp->completed into the global state:
> (rsp->completed = rnp->pgnum = rnp->completed = rsp->pgnum = 4294967002).
>
> But rsp->pgnum is still 2 offsets backwards.
>
> Now we call rcu_check_quiescent_state() -> check_for_new_grace_period()
> -> note_new_gpnum() and then we end up a requested quiescent state while
> every grace periods are completed.


Sorry I should have described that in the changelogs but my ideas
weren't as clear as they
are now (at least I feel they are, doesn't mean they actually are ;)
Chasing these RCU bugs for too much hours has toasted my brain..
