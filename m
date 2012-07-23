Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2GWJrD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 05:47:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33582 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751473Ab2GWJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 05:47:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/NIdM7ZIvN0e9FEg4/IeFBjGXB0W/zI1nwbhgEHe
	QRvrXI+w2yfoBu
Message-ID: <1343036808.7336.80.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com, Steven Rostedt <rostedt@goodmis.org>
Date: Mon, 23 Jul 2012 11:46:48 +0200
In-Reply-To: <1342982589.7210.25.camel@marge.simpson.net>
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
	 <1342586692.7321.45.camel@marge.simpson.net>
	 <1342589411.7321.59.camel@marge.simpson.net>
	 <1342856835.7739.19.camel@marge.simpson.net>
	 <1342982589.7210.25.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-22 at 20:43 +0200, Mike Galbraith wrote: 
> On Sat, 2012-07-21 at 09:47 +0200, Mike Galbraith wrote: 
> > On Wed, 2012-07-18 at 07:30 +0200, Mike Galbraith wrote: 
> > > On Wed, 2012-07-18 at 06:44 +0200, Mike Galbraith wrote:
> > > 
> > > > The patch in question for missing Cc.  Maybe should be only mutex, but I
> > > > see no reason why IO dependency can only possibly exist for mutexes...
> > > 
> > > Well that was easy, box quickly said "nope, mutex only does NOT cut it".
> > 
> > And I also learned (ouch) that both doesn't cut it either.  Ksoftirqd
> > (or sirq-blk) being nailed by q->lock in blk_done_softirq() is.. not
> > particularly wonderful.  As long as that doesn't happen, IO deadlock
> > doesn't happen, troublesome filesystems just work.  If it does happen
> > though, you've instantly got a problem.
> 
> That problem being slab_lock in practice btw, though I suppose it could
> do the same with any number of others.  In encountered case, ksoftirqd
> (or sirq-blk) blocks on slab_lock while holding q->queue_lock, while a
> userspace task (dbench) blocks on q->queue_lock while holding slab_lock
> on the same cpu.  Game over.

Hello vacationing rt wizards' mail boxen (and others so bored they're
actually reading about obscure -rt IO troubles;).

ext4 is still alive, which is a positive sign, and box hasn't yet
deadlocked either, another sign.  Now all I have to do is (sigh) grind
filesystems to fine powder for a few days.. again.

---
 kernel/rtmutex.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -649,7 +649,14 @@ static inline void rt_spin_lock_fastlock
 	if (likely(rt_mutex_cmpxchg(lock, NULL, current)))
 		rt_mutex_deadlock_account_lock(lock, current);
 	else {
-		if (blk_needs_flush_plug(current))
+		/*
+		 * We can't pull the plug if we're already holding a lock
+		 * else we can deadlock.  eg, if we're holding slab_lock,
+		 * ksoftirqd can block while processing BLOCK_SOFTIRQ after
+		 * having acquired q->queue_lock.  If _we_ then block on
+		 * that q->queue_lock while flushing our plug, deadlock.
+		 */
+		if (__migrate_disabled(current) < 2 && blk_needs_flush_plug(current))
 			blk_schedule_flush_plug(current);
 		slowfn(lock);
 	}


