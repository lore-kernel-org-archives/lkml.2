Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab1EWPiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:38:52 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44329 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab1EWPiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:38:51 -0400
Date: Mon, 23 May 2011 08:38:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Paul Bolle <pebolle@tiscali.nl>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110523153848.GC2310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20110523152141.GB4019@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 23, 2011 at 11:21:41AM -0400, Vivek Goyal wrote:
> On Sat, May 21, 2011 at 02:00:13PM -0700, Paul E. McKenney wrote:
> 
> [..]
> > > In summary once in a while people notice CFQ crash. Debugging shows that
> > > we have a rcu protected hlist of elements of type cfq_io_context. Head of
> > > the list is at ioc->cic_list. We crash while traversing ioc->cic_list
> > > under rcu.
> > > 
> > > Looks like an element which we are trying to fetch the next pointer from got
> > > freed to slab, and the object got poisoned with 0x6b6b6b6b.. and then we
> > > tried to fetch the next object pointer and ended up dereferencing a
> > > freed object and CFQ crashes.
> > > 
> > > The function in question here is call_for_each_cic() in block/cfq-iosched.c
> > > 
> > > We free the cfq_io_context object using call_rcu(). So on the surface
> > > it looks like that we decoupled a cfq_io_context object from the hash
> > > list and scheduled a call_rcu() so that it is freed after rcu grace
> > > period but somehow object got freed earlier and got released to slab
> > > and got poisoned.
> > > 
> > > Is it possible? We have looked at the code many a times and we think
> > > that rcu locking around it is fine. Is it possible that a call_rcu()
> > > can fire before rcu grace period is over.
> > 
> > If it does, that would be a bug in RCU.
> > 
> > > I had put a debug patch in CFQ (details are in bugzilla) and I can
> > > see that after decoupling the object from the hash list, it got
> > > freed while we were still under rcu_read_lock().
> > > 
> > > Is there any known issue or is there any quick tip on how can I 
> > > go about debugging it further from rcu point of view.
> > 
> 
> Thanks for the response paul.
> 
> > First for uses of RCU:
> > 
> > o	One thing to try would be CONFIG_PROVE_RCU, which could help
> > 	find missing rcu_read_lock()s and similar.  Some years back, it
> > 	used to be the case that spin_lock() implied rcu_read_lock(),
> > 	but it no longer does.	There might still be some cases where
> > 	spin_lock() needs to have an rcu_read_lock() added.
> > 
> 
> I believe that PaulB already had CONFIG_PROVE_RCU=y for his kernels. I
> also built a kernel CONFIG_PROVE_RCU=y and no warning popped up. In
> fact it looks like (comment 113 in bz 577968) that with 2.6.39 if PaulB
> takes fedora kernel release config andn enabled CONFIG_PROVE_RCU=y, he
> can reproduce the problem.
> 
> I am wondering if CONFIG_PROVE_RCU has some side affects.
> 
> > o	There are a few entries in the bugzilla mentioning that elements
> > 	are being removed more often than expected.  There is a config
> > 	option CONFIG_DEBUG_OBJECTS_RCU_HEAD that complains if the same
> > 	object is passed to call_rcu() before the grace period ends for
> > 	the first round.
> 
> I noticed that CONFIG_DEBUG_OBJECTS_RCU_HEAD gets enabled only if
> PREEMPT is enabled. In Paul's fedora config preemption is not enabled
> and I see following.
> 
> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> 
> So are you suggesting that we should explicitly enable preemption
> and set CONFIG_PREEMPT=y and CONFIG_DEBUG_OBJECTS_RCU_HEAD=y and try
> to reproduce the problem again?

Running under CONFIG_PREEMPT=y (along with CONFIG_TREE_PREEMPT_RCU=y)
could be very helpful in and of itself.  CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
can also be helpful.  In post-2.6.39 mainline, it should be possible
to set CONFIG_DEBUG_OBJECTS_RCU_HEAD=y without CONFIG_PREEMPT=y, but
again, CONFIG_PREEMPT=y can help find problems.

> > o	Try switching between CONFIG_TREE_RCU and CONFIG_TREE_PREEMPT_RCU.
> > 	These two settings are each sensitive to different forms of abuse.
> > 	For example, if you have CONFIG_PREEMPT=n and CONFIG_TREE_RCU=y,
> > 	illegally placing a synchronize_rcu() -- or anything else that
> > 	blocks -- in an RCU read-side critical section will silently
> > 	partition that RCU read-side critical section.  In contrast,
> > 	CONFIG_TREE_PREEMPT_RCU=y will complain about this.
> 
> Again CONFIG_TREE_PREEMPT_RCU is available only if PREEMPT=y. So should
> we enable preemtion and CONFIG_TREE_PREEMPT_RCU=y and try to reproduce
> the issue?

Please!

> > Second, for RCU itself, CONFIG_RCU_TRACE enables counter-based tracing
> > in RCU.  Sampling each of the files in the debugfs directory "rcu"
> > before and after the badness (if possible) could help me see if anything
> > untoward is happening.
> 
> This sounds doable. So you don't want periodic polling of these rcu
> files? I am assuming that this reading of rcu files is happening in
> user space. How do I do polling at specific events (before and after
> badness). Any suggestions ?
> 
> After badness we try to capture the crash dump. So hopefully appropriate
> files we should be able to read from crash dump. So the key quesiton 
> would be what's the easiest way to let a user space process poll these
> files before badness and display on console.

Polling is fine.  Please see attached for a script to poll at 15-second
intervals.  Please also feel free to adjust, just tell me what you
adjusted.

							Thanx, Paul

--BOKacYhQ+x31HxR3
Content-Type: application/x-sh
Content-Description: collectdebugfs.sh
Content-Disposition: attachment; filename="collectdebugfs.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A#=0A# Collect RCU-related debugfs data.  Set DEBUGFS_MP to the =
debugfs=0A# mount point, defaults to /sys/kernel/debug.=0A#=0A# This progra=
m is free software; you can redistribute it and/or modify=0A# it under the =
terms of the GNU General Public License as published by=0A# the Free Softwa=
re Foundation; either version 2 of the License, or=0A# (at your option) any=
 later version.=0A#=0A# This program is distributed in the hope that it wil=
l be useful,=0A# but WITHOUT ANY WARRANTY; without even the implied warrant=
y of=0A# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A# =
GNU General Public License for more details.=0A#=0A# You should have receiv=
ed a copy of the GNU General Public License=0A# along with this program; if=
 not, write to the Free Software=0A# Foundation, Inc., 59 Temple Place - Su=
ite 330, Boston, MA 02111-1307, USA.=0A#=0A# Copyright (C) IBM Corporation,=
 2010=0A#=0A# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>=0A=0AD=
EBUGFS_MP=3D/sys/kernel/debug=0ADRCU=3D$DEBUGFS_MP/rcu=0A=0Awhile :=0Ado=0A=
	date=0A	echo $DRCU/rcugp:=0A	cat $DRCU/rcugp || echo no $DRCU/rcugp=0A	ech=
o $DRCU/rcuhier:=0A	cat $DRCU/rcuhier || echo no $DRCU/rcuhier=0A	echo $DRC=
U/rcudata:=0A	cat $DRCU/rcudata || echo no $DRCU/rcudata=0A	echo $DRCU/rcu_=
pending:=0A	cat $DRCU/rcu_pending || echo no $DRCU/rcu_pending=0A	echo $DRC=
U/rcutorture:=0A	cat $DRCU/rcutorture || echo no $DRCU/rcutorture=0A	echo $=
DRCU/rcuboost:=0A	cat $DRCU/rcuboost || echo no $DRCU/rcuboost=0A	ps -eo pi=
d,class,sched,rtprio,stat,state,sgi_p,cputime,cmd | grep '\[rcuc[0-9]'=0A	p=
s -eo pid,class,sched,rtprio,stat,state,sgi_p,cputime,cmd | grep '\[rcun[0-=
9]'=0A	ps -eo pid,class,sched,rtprio,stat,state,sgi_p,cputime,cmd | grep '\=
[rcub[0-9]'=0A	echo=0A	sleep 15=0Adone=0A
--BOKacYhQ+x31HxR3--
