Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0GKNdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 09:33:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0GKNda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 09:33:30 -0400
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
From: Mike Galbraith <mgalbraith@suse.de>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1278790882.7352.101.camel@marge.simson.net>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
	 <1278790882.7352.101.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 11 Jul 2010 15:33:28 +0200
Message-Id: <1278855208.15197.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-10 at 21:41 +0200, Mike Galbraith wrote:
> On Fri, 2010-07-09 at 15:33 -0700, Darren Hart wrote:

> > If we can't move the unlock above before set_owner, then we may need a:
> > 
> > retry:
> > cur->lock()
> > top_waiter = get_top_waiter()
> > cur->unlock()
> > 
> > double_lock(cur, topwaiter)
> > if top_waiter != get_top_waiter()
> > 	double_unlock(cur, topwaiter)
> > 	goto retry
> > 
> > Not ideal, but I think I prefer that to making all the hb locks raw.

Another option: only scratch the itchy spot.

futex: non-blocking synchronization point for futex_wait_requeue_pi() and futex_requeue().

Problem analysis by Darren Hart;
The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
a scenario where a task can wake-up, not knowing it has been enqueued on an
rtmutex. In order to detect this, the task would have to be able to take either
task->pi_blocked_on->lock->wait_lock and/or the hb->lock.  Unfortunately,
without already holding one of these, the pi_blocked_on variable can change
from NULL to valid or from valid to NULL. Therefor, the task cannot be allowed
to take a sleeping lock after wakeup or it could end up trying to block on two
locks, the second overwriting a valid pi_blocked_on value. This obviously
breaks the pi mechanism.

Rather than convert the bh-lock to a raw spinlock, do so only in the spot where
blocking cannot be allowed, ie before we know that lock handoff has completed.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/futex.c b/kernel/futex.c
index a6cec32..ef489f3 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -2255,7 +2255,14 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
 	futex_wait_queue_me(hb, &q, to);
 
-	spin_lock(&hb->lock);
+	/*
+	 * Non-blocking synchronization point with futex_requeue().
+	 *
+	 * We dare not block here because this will alter PI state, possibly
+	 * before our waker finishes modifying same in wakeup_next_waiter().
+	 */
+	while(!spin_trylock(&hb->lock))
+		cpu_relax();
 	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
 	spin_unlock(&hb->lock);
 	if (ret)


