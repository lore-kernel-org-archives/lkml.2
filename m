Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0GJTl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 15:41:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:34005 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751229Ab0GJTl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 15:41:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196OOBSXrh6zIW+aER4ZdzinIoJL/sWjkmm/IOLTz
	jTrz9H1V2pXp09
Subject: Re: [PATCH 4/4] futex: convert hash_bucket locks to raw_spinlock_t
From: Mike Galbraith <efault@gmx.de>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
	 <1278714780-788-5-git-send-email-dvhltc@us.ibm.com>
Content-Type: text/plain
Date: Sat, 10 Jul 2010 21:41:22 +0200
Message-Id: <1278790882.7352.101.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:33 -0700, Darren Hart wrote:
> The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
> a scenario where a task can wake-up, not knowing it has been enqueued on an
> rtmutex. In order to detect this, the task would have to be able to take either
> task->pi_blocked_on->lock->wait_lock and/or the hb->lock.  Unfortunately,
> without already holding one of these, the pi_blocked_on variable can change
> from NULL to valid or from valid to NULL. Therefor, the task cannot be allowed
> to take a sleeping lock after wakeup or it could end up trying to block on two
> locks, the second overwriting a valid pi_blocked_on value. This obviously
> breaks the pi mechanism.

copy/paste offline query/reply at Darren's request..

On Sat, 2010-07-10 at 10:26 -0700, Darren Hart wrote:
On 07/09/2010 09:32 PM, Mike Galbraith wrote:
> > On Fri, 2010-07-09 at 13:05 -0700, Darren Hart wrote:
> >
> >> The core of the problem is that the proxy_lock blocks a task on a lock
> >> the task knows nothing about. So when it wakes up inside of
> >> futex_wait_requeue_pi, it immediately tries to block on hb->lock to
> >> check why it woke up. This has the potential to block the task on two
> >> locks (thus overwriting the pi_blocked_on). Any attempt preventing this
> >> involves a lock, and ultimiately the hb->lock. The only solution I see
> >> is to make the hb->locks raw locks (thanks to Steven Rostedt for
> >> original idea and batting this around with me in IRC).
> >
> > Hm, so wakee _was_ munging his own state after all.
> >
> > Out of curiosity, what's wrong with holding his pi_lock across the
> > wakeup?  He can _try_ to block, but can't until pi state is stable.
> >
> > I presume there's a big fat gotcha that's just not obvious to futex
> > locking newbie :)
> 
> It'll take me more time that I have right now to positive, but:
> 
> 
> 	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
> 
> 	raw_spin_unlock(&current->pi_lock);
> 
> Your patch moved the unlock before the set_owner. I _believe_ this can 
> break the pi boosting logic - current is the owner until it calls 
> set_owner to be pendowner. I haven't traced this entire path yet, but 
> that's my gut feel.

I _think_ it should be fine to do that.  Setting an owner seems to only
require holding the wait_lock.  I could easily be missing subtleties
though.  Looking around, I didn't see any reason not to unlock the
owner's pi_lock after twiddling pi_waiters (and still don't, but...).
 
> However, you're idea has merit as we have to take our ->pi_lock before 
> we can block on the hb->lock (inside task_blocks_on_rt_mutex()).
> 
> If we can't move the unlock above before set_owner, then we may need a:
> 
> retry:
> cur->lock()
> top_waiter = get_top_waiter()
> cur->unlock()
> 
> double_lock(cur, topwaiter)
> if top_waiter != get_top_waiter()
> 	double_unlock(cur, topwaiter)
> 	goto retry
> 
> Not ideal, but I think I prefer that to making all the hb locks raw.
> 
> You dropped the CC list for some reason, probably a good idea to send 
> this back out in response to my raw lock patch (4/4) - your question and 
> my reply. This is crazy stuff, no harm in putting the question out there.
> 
> I'll take a closer look at this when I can, if not tonight, Monday morning.

	-Mike

