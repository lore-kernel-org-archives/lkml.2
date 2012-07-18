Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2GREpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:45:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34927 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751488Ab2GREo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:44:59 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18PNBA6x8UPuO9YKWs3RUDrE42p+bZh41TrqNYUaD
	39/yNx9jge2bxZ
Message-ID: <1342586692.7321.45.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com, Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 18 Jul 2012 06:44:52 +0200
In-Reply-To: <1342530621.7353.116.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
	 <1342432094.7659.39.camel@marge.simpson.net>
	 <1342433303.7659.42.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161216200.32033@ionos>
	 <1342530621.7353.116.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adds rather important missing Cc)

On Tue, 2012-07-17 at 15:10 +0200, Mike Galbraith wrote: 
> On Mon, 2012-07-16 at 12:19 +0200, Thomas Gleixner wrote:
> 
> > > @@ -647,8 +648,11 @@ static inline void rt_spin_lock_fastlock
> > >  
> > >  	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
> > >  		rt_mutex_deadlock_account_lock(lock, current);
> > > -	else
> > > +	else {
> > > +		if (blk_needs_flush_plug(current))
> > > +			blk_schedule_flush_plug(current);
> > >  		slowfn(lock);
> > > +	}
> > 
> > That should do the trick.
> 
> Box has been grinding away long enough now to agree that it did.
> 
> rt: pull your plug before blocking

Hm.  x3550 seems to have lost interest in nearly instant gratification
ext4 deadlock testcase: taskset -c 3 dbench -t 30 -s 8 in enterprise.
Previously, it _might_ have survived one 30 second test, but never for
minutes, much less several minutes of very many threads, so it appears
to have been another flavor of IO dependency deadlock. 

I just tried virgin 3.4.4-rt13, and it too happily churned away.. until
I tried dbench -t 300 -s 500 that is.  That (seemingly 100% repeatably)
makes rcu stall that doesn't get to serial console, nor will my virgin
source/config setup crash dump.  Damn.  Enterprise kernel will dump, but
won't stall, so I guess I'd better check out the other virgin 3.x-rt
trees to at least narrow down where stall started.

Whatever, RCU stall is a different problem.  Revert unplug patchlet, and
ext4 deadlock is back in virgin 3.4-rt, so methinks it's sufficiently
verified that either we need some form of unplug before blocking, or we
need a pull your plug point is at least two filesystems, maybe more.

-Mike

The patch in question for missing Cc.  Maybe should be only mutex, but I
see no reason why IO dependency can only possibly exist for mutexes...

rt: pull your plug before blocking

Queued IO can lead to IO deadlock should a task require wakeup from as task
which is blocked on that queued IO.

ext3: dbench1 queues a buffer, blocks on journal mutex, it's plug is not
pulled.  dbench2 mutex owner is waiting for kjournald, who is waiting for
the buffer queued by dbench1.  Game over.

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 3bff726..3f6ae32 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -20,6 +20,7 @@
 #include <linux/export.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
+#include <linux/blkdev.h>
 
 #include "rtmutex_common.h"
 
@@ -647,8 +648,11 @@ static inline void rt_spin_lock_fastlock(struct rt_mutex *lock,
 
 	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
 		rt_mutex_deadlock_account_lock(lock, current);
-	else
+	else {
+		if (blk_needs_flush_plug(current))
+			blk_schedule_flush_plug(current);
 		slowfn(lock);
+	}
 }
 
 static inline void rt_spin_lock_fastunlock(struct rt_mutex *lock,
@@ -1104,8 +1108,11 @@ rt_mutex_fastlock(struct rt_mutex *lock, int state,
 	if (!detect_deadlock && likely(rt_mutex_cmpxchg(lock, NULL, current))) {
 		rt_mutex_deadlock_account_lock(lock, current);
 		return 0;
-	} else
+	} else {
+		if (blk_needs_flush_plug(current))
+			blk_schedule_flush_plug(current);
 		return slowfn(lock, state, NULL, detect_deadlock);
+	}
 }
 
 static inline int



