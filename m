Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750808Ab2ANFCL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 00:02:11 -0500
Received: from mail4.comsite.net ([205.238.176.238]:43337 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2ANFCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 00:02:09 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: [PATCH] nohz: fix race allowing use of stale jiffies when waking
To: Eric Dumazet <eric.dumazet@gmail.com>
From: Milton Miller <miltonm@bga.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Message-ID: <nohz-jiffies-race-reply1@mdm.bga.com>
In-Reply-To: <1326361755.2950.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <nohz-jiffies-update64-race@mdm.bga.com>
 <1326361755.2950.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Date: Fri, 13 Jan 2012 23:02:06 -0600
X-Originating-IP: 71.22.127.106
X-HeloNotChecked: Helo response was not checked before commands sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 about 10:49:15 +0100 Eric Dumazet wrote:
> Le jeudi 12 janvier 2012 à 02:55 -0600, Milton Miller a écrit :
> > When waking up from nohz mode, all cpus call tick_do_update_jiffies64
> > regardless of tick_do_timer_cpu as it could be no cpu was assigned.
> > 
> > At the start of the function there is a quick lockless check to
> > determine if jiffies is current.  The check uses last_jiffies_update,
> > which is used to calculate when to perform the next increment.
> > Unfortunately it is updated when how many jiffies to advance the
> > clock is calculated, before the call to do_timer which actually
> > updates jiffies.  A second cpu waking up could use the (potentially
> > very) stale jiffies value during this window.
> > 
> > This patch changes the check to be against tick_next_period, which
> > is updated after the call to do_timer completes.  It compares the
> > result of subtraction to zero, but this is safe as ktime_sub returns
> > ktime_t which is s64, as signed type.
> > 
> > I found this race while trying to track down reports of network adapter
> > hangs on a large system.  I suspected premature false detection so
> > I added logging when the locked region determined a multiple jiffie
> > update would be required.  I noticed that it happened frequently when
> > tick_do_timer_cpu was NONE (-1), and realized the large update was
> > when all cpus were previously in nohz.  I then thought about what
> > would happen if multiple cpus woke up near close to each other in
> > time and decided the stale jiffies would be used.  (I later found at
> > least part of the hung adapter reports were due to faulty detection
> > logic that has since changed upstream.)
> > 
> > Signed-off-by: Milton Miller <miltonm@bga.com>
> > Cc: stable@vger.kernel.org
> > --- 
> > Patch was generated and tested against 2.6.36; I verified it applies
> > with offset -1 line to next-20120111.
> > 
> > Index: src/kernel/time/tick-sched.c
> > ===================================================================
> > --- src.orig/kernel/time/tick-sched.c	2011-10-13 17:42:16.000000000 -0500
> > +++ src/kernel/time/tick-sched.c	2011-10-13 17:45:31.000000000 -0500
> > @@ -52,8 +52,8 @@ static void tick_do_update_jiffies64(kti
> >  	/*
> >  	 * Do a quick check without holding xtime_lock:
> >  	 */
> > -	delta = ktime_sub(now, last_jiffies_update);
> > -	if (delta.tv64 < tick_period.tv64)
> > +	delta = ktime_sub(now, tick_next_period);
> > +	if (delta.tv64 < 0)
> >  		return;
> >  
> 
> Given ktime_t on 32bit arches is not an atomic type, I wonder how safe
> is this anyway...
> 

Ok I admit I hadn't thought about it, and initially I was going to
think of something involving comparing the two timestamps, and
waiting if next_period <= next_jiffies_update (with approprate
subtract and compare).

But then I thought some more and comparing the timestamp after the
update is safe:

case 1) We see neither half.   We compare now to old value, and
decide to take the lock and check again.

case 2) We see the new value.  We compare and decide we don't need
to take the lock.  Big win.

case 3) We see the the lower part is updated to a smaller
value but the upper part is still the old value.  The time
for update seems to be in the past and we wait take thee lock
and check again.

case 4) We see a partial update.  The upper half is a new larger
value but the lower half is the old, higher value.   In this case we
think the jiffy will be valid further into the future than we think
it should be and skip waiting for the lock.  This state is usually
quite transitory and we just got done updating jiffies, so its not
likely that jiffies should actually need an update.

I use weasel words here because there is a window where the update
has been half performed and the cpu doing the update stalls (eg
gets time sliced out by its hypervisor).  In this small window
we could continue to use the updated jiffies beyond its expiration
time instead of waiting for the updating cpu to finsih storing the
new expiration time and release the lock.

There are a couple additional points to consider in this scenerio.
One is that the cpu still has xtime lock so any attempt to read a
high precision time will stall.  The second is if the cpu updating
the jiffies is stalled by the hypervisor, then it is not unique to
when it is waking from nohz and is likely happing when it owns
timer duty, so time will be subject to bunching and jumping jiffies
on a regular baasis.  About the most we could do is detect it, either
by taking periodic helath checks of jiffie by other cpus or noticing
that our tick update is constantly behind.

So I think the updated racy check is fine, but will expand on the
racy check comment why it is safe if that is desired.

milton
