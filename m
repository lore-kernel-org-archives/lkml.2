Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1FCFH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:07:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60623 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1FCFH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:07:28 -0400
Date: Thu, 2 Jun 2011 22:07:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110603050724.GB2304@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306401337.27271.3.camel@t41.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306401337.27271.3.camel@t41.thuisdomein>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:15:21AM +0200, Paul Bolle wrote:
> On Mon, 2011-05-23 at 08:38 -0700, Paul E. McKenney wrote:
> > Please see attached for a script to poll at 15-second intervals.
> 
> 0) The output from collectdebugfs.sh is pasted below. In this case the "CFQ
> crash" occurred at "May 26 10:47:07".

Thank you for the info!

And please accept my apologies for being so slow to get to it.

> 1) Big friendly warning: the "CFQ crash" that occurred while running
> your script didn't happen in a clean session. Not at all! It actually
> happened after (summarized a bit):
> - two "CFQ crashes" with the patch for Jens' first idea;
> - switching to deadline
> - removing cfq_iosched
> - recompiling cfq-iosched.ko (to revert Jens' patch)
> - installing cfq_iosched.ko
> - inserting cfq_iosched
> - switching back to cfq again
> 
> So if this makes you doubt the validity of the data I collected, which I
> guess it could, I'd be happy to try again in a clean session (ie, after
> a reboot).

Well, given that I cannot make it happen myself, your data is all I
have to go on.

> 2) Output:
> Thu May 26 10:43:29 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=554580  gpnum=554581
> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=554582 g=554583 s=2 jfq=2 j=2580 nfqs=246266/nfqsng=0(246266) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    

OK, so this system is running a kernel built with CONFIG_SMP=y, but
with only one CPU online.  You are also running with CONFIG_TREE_RCU=y,
rather than with CONFIG_TREE_PREEMPT=y.  Because you were using plain
RCU (rather than RCU-bh, RCU-sched, or SRCU), the "rcu_sched" entries
are the ones that are pertinent.

In this situation, synchronize_rcu() is by definition a grace period
all by itself -- just the fact that you invoked it suffices.

If you are instead using call_rcu(), things are still pretty simple:
the first context switch is both a quiescent state for the single
CPU, and, by definition a grace period for the whole system.

Jumping ahead to 10:47:

[ . . . ]

> Thu May 26 10:46:49 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=665689  gpnum=665690

Here we are waiting for a grace period to complete.  No surprise.

> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=665692 g=665693 s=2 jfq=3 j=32a6 nfqs=299855/nfqsng=0(299855) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    

We have advanced a couple of grace periods in the time it took to print
out the intervening messages, still no surprise.  We are waiting on
CPU 0 to pass through a quiescent state, which is no surprise because
there is no other online CPU.

RCU has gotten to the point of checking for dyntick-idle, and will
set_need_resched() in 3 jiffies if the grace period doesn't end by then.
The jiffies counter is advancing (don't laugh, I have seen cases where it
wasn't advancing).  RCU has felt the need to kick the grace-period process
not quite 300K times since boot, and has succeeded every time it tried.
The former is not too surprising, as it can take more than one kick to
get a grace period going, and this system has passed through more than
600K grace periods since boot.  The latter is not surprising either,
given that there is no other CPU to contend for the lock or to finish
the grace period asynchronously.

> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7069459 j=32a6 nfqs=50/nfqsng=0(50)
> fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=665700 g=665701 pq=0 pqc=665699 qp=1 dt=7911759/1 dn=0 df=42 of=0 ri=15459 ql=5 b=10 ci=1601915 co=0 ca=0

Eight more grace periods have elapsed.  This CPU has not passed a
quiescent state for this grace period (otherwise RCU would be idle),
and the last time we did pass a quiescent state, it was for the
previous grace period.  RCU is waiting for this CPU to pass through
a quiescent state, and the CPU is not in dyntick-idle mode -- and
has transitioned to and from dyntick-idle mode a -lot-.  It is not
current in an NMI handler, and the grace period has ended due to the
CPU being in dyntick-idle mode 42 times.  (No, the CPU cannot possibly
have been in dyntick-idle mode when RCU was trying to force a quiescent
state, but it could well have visited dyntick-idle mode between two
successive attempts to force a quiescent state for the same grace
period.)

RCU has never intuited a quiescent state due to the CPU being offline
(running with zero CPUs being problematic), and has sent itself
a resched IPI (really just set_need_resched() in the single-CPU case)
about 15K times.  There are five callbacks queued, and there have
been more than 1.6M RCU callbacks invoked since boot, or an average
of 2.4 RCU callbacks per grace period.

> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7911759/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=1950196 qsp=209090 rpq=465319 cbr=814 cng=101986 gpc=98794 gps=0 nf=16887 nn=1266396

RCU has checked to see if there is work to be done not quite 2M times,
and 1.2M of those times, nothing was needed.  The numbers in between are
the reasons there was something to do: RCU was waiting for a quiescent
state from the CPU, the CPU had passed through a quiescent state and
needed to report this to the RCU core, there were callbacks ready to
invoke, the CPU needed a new grace period to be started, the CPU needed
to be informed of a newly completed grace period, a grace period had
been started by some other CPU (yep, that is why it is zero), and RCU
needed to force a quiescent state.

> rcu_bh:
>   0 np=1266396 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1249400

The stuff below isn't compiled in, so you have CONFIG_RCU_TORTURE_TEST=n.

> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture

Also, because you don't have CONFIG_TREE_PREEMPT_RCU=y, you can't have
CONFIG_RCU_BOOST=y, so the below stuff isn't compiled in either.

> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> Thu May 26 10:47:04 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=674282  gpnum=674283

15 more seconds, lots more grace periods.

> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=674286 g=674287 s=2 jfq=1 j=6ef9 nfqs=303532/nfqsng=0(303532) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    

Four more grace periods, again waiting on CPU 0 (no one else to be waiting
on), only one jiffy from forcing a quiescent state, and several more
attempts to force have been recorded.

> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7084902 j=6ef9 nfqs=50/nfqsng=0(50)
> fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=674300 g=674301 pq=0 pqc=674299 qp=1 dt=7916737/1 dn=0 df=42 of=0 ri=15670 ql=5 b=10 ci=1622776 co=0 ca=0

Another four grace periods down.  Again waiting on CPU 0, a few thousand
more dyntick-idle transitions, still not in an NMI handler, and a few
hundred more set_need_resched() calls.

> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7916737/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=1961236 qsp=212684 rpq=471110 cbr=822 cng=102605 gpc=99130 gps=0 nf=17168 nn=1270401

Still no grace periods started by nonexistent other CPUs, but a bit more
work in every other category over the past 15 seconds.  (Other than responding
to grace periods started by nonexistent other CPUs.)

> rcu_bh:
>   0 np=1270401 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1253405
> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture
> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> Thu May 26 10:47:20 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=682249  gpnum=682250

15 more seconds, a few thousand more grace periods.  About 500 grace
periods per second, which is quite reasonable on a single-CPU system.

> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=682257 g=682258 s=2 jfq=3 j=aad8 nfqs=307404/nfqsng=0(307404) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    

Eight more grace periods, force quiescent state in three jiffies, and
about 4K attempts to force quiescent states over the past 15 seconds.
This is consistent with HZ=1000.  As always, waiting on CPU 0.

> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7100229 j=aad8 nfqs=50/nfqsng=0(50)
> fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=682260 g=682261 pq=0 pqc=682259 qp=1 dt=7921175/1 dn=0 df=42 of=0 ri=16003 ql=4 b=10 ci=1642246 co=0 ca=0

Three more grace periods, several thousand more dyntick-idle transitions
over the past 15 seconds.  A few hundred more set_need_resched() calls.
About 1300 RCU callbacks invoked per second over the past 15 seconds.

> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7921175/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=1971567 qsp=216816 rpq=476234 cbr=830 cng=103139 gpc=99383 gps=0 nf=17588 nn=1274393

Seven more grace periods.  A bit more work in every other category other
than gps.

Looks healthy to me...

							Thanx, Paul

> rcu_bh:
>   0 np=1274393 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1257397
> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture
> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> Thu May 26 10:47:35 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=689950  gpnum=689951
> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=689955 g=689956 s=2 jfq=2 j=e69e nfqs=311206/nfqsng=0(311206) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7115531 j=e69e nfqs=50/nfqsng=0(50)
> fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=689964 g=689965 pq=0 pqc=689963 qp=1 dt=7925441/1 dn=0 df=42 of=0 ri=16397 ql=5 b=10 ci=1661655 co=0 ca=0
> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7925441/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=1982355 qsp=221269 rpq=481281 cbr=835 cng=103658 gpc=99618 gps=0 nf=18095 nn=1278868
> rcu_bh:
>   0 np=1278868 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1261872
> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture
> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> Thu May 26 10:47:50 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=698992  gpnum=698993
> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=698998 g=698999 s=2 jfq=3 j=2298 nfqs=313944/nfqsng=0(313944) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7130885 j=2298 nfqs=50/nfqsng=0(50)
> fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=699006 g=699007 pq=0 pqc=699005 qp=1 dt=7928625/1 dn=0 df=42 of=0 ri=16821 ql=4 b=10 ci=1693458 co=0 ca=0
> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7928625/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=1994830 qsp=225627 rpq=488590 cbr=837 cng=103889 gpc=99736 gps=0 nf=18667 nn=1283111
> rcu_bh:
>   0 np=1283111 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1266115
> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture
> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> Thu May 26 10:48:06 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=711432  gpnum=711433
> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=711441 g=711441 s=0 jfq=1 j=5eaf nfqs=314929/nfqsng=0(314929) fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7146268 j=5eaf nfqs=50/nfqsng=0(50)
> fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=711443 g=711444 pq=0 pqc=711442 qp=1 dt=7930563/1 dn=0 df=42 of=0 ri=16851 ql=9 b=10 ci=1748424 co=0 ca=0
> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7930563/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=2008491 qsp=226909 rpq=500253 cbr=837 cng=104041 gpc=99813 gps=0 nf=18710 nn=1284837
> rcu_bh:
>   0 np=1284837 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1267841
> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture
> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> Thu May 26 10:48:21 CEST 2011
> /sys/kernel/debug/rcu/rcugp:
> rcu_sched: completed=719902  gpnum=719903
> rcu_bh: completed=-114  gpnum=4294967182
> /sys/kernel/debug/rcu/rcuhier:
> rcu_sched:
> c=719907 g=719908 s=2 jfq=2 j=9aa3 nfqs=315817/nfqsng=0(315817) fqlh=0
> 1/1 ..>.. 0:63 ^0    
> 1/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> rcu_bh:
> c=4294967182 g=4294967182 s=0 jfq=-7161616 j=9aa3 nfqs=50/nfqsng=0(50) fqlh=0
> 0/1 ..>.. 0:63 ^0    
> 0/1 ..>.. 0:15 ^0    0/0 ..>.. 16:31 ^1    0/0 ..>.. 32:47 ^2 0/0 ..>.. 48:63 ^3    
> /sys/kernel/debug/rcu/rcudata:
> rcu_sched:
>   0 c=719915 g=719916 pq=0 pqc=719914 qp=1 dt=7934501/1 dn=0 df=42 of=0 ri=16854 ql=4 b=10 ci=1780327 co=0 ca=0
> rcu_bh:
>   0 c=4294967182 g=4294967182 pq=1 pqc=4294967181 qp=0 dt=7934501/1 dn=0 df=1 of=0 ri=0 ql=0 b=10 ci=1925 co=0 ca=0
> /sys/kernel/debug/rcu/rcu_pending:
> rcu_sched:
>   0 np=2020635 qsp=227848 rpq=507995 cbr=838 cng=104418 gpc=100105 gps=0 nf=18720 nn=1288559
> rcu_bh:
>   0 np=1288559 qsp=0 rpq=16939 cbr=0 cng=33 gpc=24 gps=0 nf=0 nn=1271563
> /sys/kernel/debug/rcu/rcutorture:
> no /sys/kernel/debug/rcu/rcutorture
> /sys/kernel/debug/rcu/rcuboost:
> no /sys/kernel/debug/rcu/rcuboost
> 
> 
> Paul Bolle
> 
