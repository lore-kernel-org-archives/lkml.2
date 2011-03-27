Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1C0FHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 01:07:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:55579 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab1C0FHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 01:07:33 -0400
Date: Sat, 26 Mar 2011 22:07:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: sedat.dilek@gmail.com
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: linux-next: Tree for March 25 (Call trace:
 RCU|workqueues|block|VFS|ext4 related?)
Message-ID: <20110327050720.GA31424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=N6Z0bDg1YXVFkUbv7phM8XvQ5U3=vS6Ej8Af5@mail.gmail.com>
 <20110325174855.GR2322@linux.vnet.ibm.com>
 <AANLkTin9HxOTwavbtbsMd0quYsEvhDNmuO5kOpquqoF=@mail.gmail.com>
 <20110326034210.GX2322@linux.vnet.ibm.com>
 <AANLkTi=zJZ26i14D-kyWQ1uqUPifrv+DN4So4+fC5V=d@mail.gmail.com>
 <20110326160229.GZ2322@linux.vnet.ibm.com>
 <AANLkTikzLm+ArYkG20F41JOgfNygfdhxC0+A4tV4ez-R@mail.gmail.com>
 <20110327000900.GB2322@linux.vnet.ibm.com>
 <AANLkTikpq2CiSTk9Br7DdkVt=E1p8OFGa+Ls2BzkkhcO@mail.gmail.com>
 <20110327032529.GC2322@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110327032529.GC2322@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 08:25:29PM -0700, Paul E. McKenney wrote:
> On Sun, Mar 27, 2011 at 03:30:34AM +0200, Sedat Dilek wrote:
> > On Sun, Mar 27, 2011 at 1:09 AM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Sat, Mar 26, 2011 at 11:15:22PM +0100, Sedat Dilek wrote:

[ . . . ]

> > >> But then came RCU :-(.
> > >
> > > Well, if it turns out to be a problem in RCU I will certainly apologize.
> > >
> > 
> > No, that's not so dramatic.
> > Dealing with this RCU issue has nice side-effects: I remembered (and
> > finally did) to use a reduced kernel-config set.
> > The base for it I created with 'make localmodconfig' and did some
> > manual fine-tuning afterwards (throw out media, rc, dvd, unneeded FSs,
> > etc.).
> > Also, I can use fresh gcc-4.6 (4.6.0-1) from the official Debian repos.
> > 
> > So, I started building with
> > "revert-rcu-patches/0001-Revert-rcu-introduce-kfree_rcu.patch".
> > I will let you know.
> 
> And please also check for tasks consuming all available CPU.

And I still cannot reproduce with the full RCU stack (but based off of
2.6.38 rather than -next).  Nevertheless, if you would like to try a
speculative patch, here you go.

							Thanx, Paul

------------------------------------------------------------------------

rcu: further lower priority in rcu_yield()

Although rcu_yield() dropped from real-time to normal priority, there
is always the possibility that the competing tasks have been niced.
So nice to 19 in rcu_yield() to help ensure that other tasks have a
better chance of running.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 759f54b..5477764 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1492,6 +1492,7 @@ static void rcu_yield(void (*f)(unsigned long), unsigned long arg)
 	mod_timer(&yield_timer, jiffies + 2);
 	sp.sched_priority = 0;
 	sched_setscheduler_nocheck(current, SCHED_NORMAL, &sp);
+	set_user_nice(current, 19);
 	schedule();
 	sp.sched_priority = RCU_KTHREAD_PRIO;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
