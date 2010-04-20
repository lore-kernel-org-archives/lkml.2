Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0DTDE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:04:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:42915 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0DTDEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:04:55 -0400
Date: Mon, 19 Apr 2010 20:04:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@parisplace.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without
 protection!
Message-ID: <20100420030452.GB2905@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
 <20100311032843.GE6767@linux.vnet.ibm.com>
 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
 <1271098032.4807.137.camel@twins>
 <1271242058.32749.19.camel@laptop>
 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
 <20100419230136.GA16856@linux.vnet.ibm.com>
 <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271726729.2972.13.camel@dhcp231-113.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 09:25:29PM -0400, Eric Paris wrote:
> On Mon, 2010-04-19 at 16:01 -0700, Paul E. McKenney wrote:
> 
> > Yep, different code path to the same location.  Does the following
> > patch help?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit 2836f18139267ea918ed2cf39023fb0eb38c4361
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Mon Apr 19 15:59:50 2010 -0700
> > 
> >     rcu: fix RCU lockdep splat on freezer_fork path
> >     
> >     Add an RCU read-side critical section to suppress this false positive.
> >     
> >     Located-by: Eric Paris <eparis@parisplace.org>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> That one is also fixed so feel free to add a tested or something from
> me.  But we've got another, weeeee!  If there some way I could get all
> of these at once?

Sure!  I -think- that if you remove the first "if" statement in
lockdep_rcu_dereference() in kernel/lockdep.c, you will get lots of them
all at once.  Maybe more than your console log is able to hold...

So another approach would be to print only the first 100 or some such.

It -looks- to me that you could make __debug_locks_off() atomically
decrement a counter rather than just setting it to zero, see
include/linux/debug_locks.h.  I suspect that atomic_dec_not_zero()
would work very well for you here.

Peter probably knows a better approach, but those would work.

						Thanx, Paul

> [    0.045164] ===================================================
> [    0.047002] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.048002] ---------------------------------------------------
> [    0.049012] include/linux/cgroup.h:533 invoked rcu_dereference_check() without protection!
> [    0.051087] 
> [    0.051088] other info that might help us debug this:
> [    0.051088] 
> [    0.057011] 
> [    0.057011] rcu_scheduler_active = 1, debug_locks = 0
> [    0.059046] no locks held by watchdog/0/5.
> [    0.060002] 
> [    0.060003] stack backtrace:
> [    0.061003] Pid: 5, comm: watchdog/0 Not tainted 2.6.34-rc4-next-20100415+ #104
> [    0.063011] Call Trace:
> [    0.063654]  [<ffffffff8108652f>] lockdep_rcu_dereference+0xaf/0xc0
> [    0.065009]  [<ffffffff810b53f0>] ? watchdog+0x0/0xa0
> [    0.066006]  [<ffffffff8104d01b>] __sched_setscheduler+0x3ab/0x430
> [    0.067005]  [<ffffffff810b53f0>] ? watchdog+0x0/0xa0
> [    0.068004]  [<ffffffff8104d0be>] sched_setscheduler+0xe/0x10
> [    0.070009]  [<ffffffff810b541a>] watchdog+0x2a/0xa0
> [    0.071004]  [<ffffffff810b53f0>] ? watchdog+0x0/0xa0
> [    0.072007]  [<ffffffff810714ec>] kthread+0xac/0xc0
> [    0.073005]  [<ffffffff81087ff0>] ? trace_hardirqs_on_caller+0xc0/0x240
> [    0.074006]  [<ffffffff8100bc24>] kernel_thread_helper+0x4/0x10
> [    0.075005]  [<ffffffff814fee54>] ? restore_args+0x0/0x30
> [    0.076004]  [<ffffffff81071440>] ? kthread+0x0/0xc0
> [    0.077004]  [<ffffffff8100bc20>] ? kernel_thread_helper+0x0/0x10
> 
> 
> 
