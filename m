Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480Ab0EGV3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 17:29:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64098 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0EGV3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 17:29:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xUb6Eh9oei0e6CkRLafXcSroKcUeZW58HbFH44KpCaSiu02wBPFmD1PS9P/JHr1jG5
         NPEQw8eR7IgO57Tn/vNYrJKhKlvLyl03QbDvDVWh1N15vWoLicSwdipTAzKyQI7Fw26d
         R0xW2jPVLyqweGy9ezdaCk5ux0ZR/KFjVxawE=
Date: Fri, 7 May 2010 23:29:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tony Breeds <tonyb@au1.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH/RFC] mutex: Fix optimistic spinning vs. BKL
Message-ID: <20100507212909.GD5401@nowhere>
References: <1272429513.24542.83.camel@pasglop> <201004281406.04080.arnd@arndb.de> <1272494121.24542.113.camel@pasglop> <20100507042010.GR12389@ozlabs.org> <20100507053023.GF8069@nowhere> <1273212116.4861.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273212116.4861.61.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 04:01:56PM +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-05-07 at 07:30 +0200, Frederic Weisbecker wrote:
> > 
> > 
> > I like the safeguard against the bkl, it looks indeed like something
> > we should have in .34
> > 
> > But I really don't like the timeout.
> 
> And I hate not having it :-)
> 
> > This is going to make the things even worse if we have another cause
> > of deadlock by hiding the worst part of the consequences without
> > actually solving the problem.
> 
> Yes and no. There's two reasons why the timeout is good. One is the
> safeguard part and it's arguable whether it helps hiding bugs or not,
> but there are very real cases where I believe we should get out and go
> to sleep as well that aren't bugs.
> 
> IE. If the mutex owner is running for a long time and nobody is
> contending on your CPU, you're simply not going to hit the
> need_resched() test. That means you will spin, which means you will suck
> a lot more power as well, not counting the potentially bad effect on
> rebalance, load average etc...
> 
> There's also the fact that 2 CPUs or more trying to obtain it at once
> may all go into spinning, which can lead to interesting results in term
> of power consumption (and cpu_relax doesn't help that much).
> 
> I really don't think it's a good idea to turns mutex into potential
> multi-jiffies spinning things like that.



Yeah, I was considering only the deadlock issue.

Ok it's an problem on power consumption. That said I wonder if we have
so much places where a task can hold a mutex for two jiffies without
sleeping in-between, since when the owner goes to sleep, spinning is
stopped.

If that's an issue for power saving, it means we have places to fix.
Also I wonder if we should disable adaptive spinning for people who want
agressive power saving. At least it would be worth the test to check the
result.

Also, to solve this problem when several cpus may spin on the owner,
I wonder adaptive spinning is doing the right thing here. We should
have only one spinner I think, and the rest should go to sleep as the
time to spin on several subsequent owners would be much better gained
to do something else (schedule something else or power saving).
In fact, that too could deserve some tests.

 
> > And since the induced latency or deadlock won't be easily visible
> > anymore, we'll miss there is a problem. So we are going to spin for
> > two jiffies and only someone doing specific latency measurements will
> > notice, if he's lucky enough to meet the bug.
> 
> Well, the thing is that it may not be a bug.
> 
> The thing is that the actual livelock with the BKL should really only
> happen with the BKL since that's the only thing we have that allows for
> AB->BA semantics. Anything else should hopefully be caught by lockdep.
> 
> So I don't think there's that much to fear about hidden bugs.
> 
> But I -also- don't see the point of spinning potentially for a very long
> time instead of going to sleep and saving power. The adaptive spinning
> goal is to have an opportunistic optimization based on the idea that the
> mutex is likely to be held for a very short period of time by its owner
> and nobody's waiting for it yet. Ending up doing multi-jiffies spins
> just doesn't fit in that picture. In fact, I was tempted to make the
> timeout a lot shorter but decided against calling into clock sources
> etc... and instead kept it simple with jiffies.


Ok. But even under this power saving angle, I think this heuristic based on
timeout is still only hidding the problem. Or it lowers it more than it
solves it, which is quite better than keeping the things as is of course.
But if the real source is in places that hold mutexes without sleeping for
too much time, I think we should rather identify these places and solve
the ugly locking there.

Plus may be allowing only one spinner at the time.

But yeah until we reach a good solution for that, may be this timeout
would be worth.



> > Moreover that adds some unnessary (small) overhead in this path.
> 
> Uh ? So ? This is the contended path where we are .. spinning :-) The
> overhead of reading jiffies and comparing here is simply never going to
> show on any measurement I bet you :-)



Yeah, probably in fact :)



> > May be can we have it as a debugging option, something that would
> > be part of lockdep, which would require CONFIG_DEBUG_MUTEX to
> > support mutex adaptive spinning.
> 
> No, what I would potentially add as part of lockdep however is a way to
> instrument how often we get out of the spin via the timeout. That might
> be a useful information to figure out some of those runaway code path,
> but they may well happen for very legit reasons and aren't a bug per-se.



We could make a trace event for that.

Thanks.

