Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab1GMIY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 04:24:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:46905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964995Ab1GMIY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 04:24:57 -0400
Subject: Re: lockdep circular locking error (rcu_node_level_0 vs rq->lock)
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20110712225443.GS2326@linux.vnet.ibm.com>
References: <20110711231932.GB20367@redhat.com>
	 <1310502014.2309.7.camel@laptop> <20110712205126.GM2326@linux.vnet.ibm.com>
	 <1310507047.2309.10.camel@laptop>
	 <20110712225443.GS2326@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 13 Jul 2011 10:24:08 +0200
Message-ID: <1310545448.14978.40.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 15:54 -0700, Paul E. McKenney wrote:
> > @@ -892,6 +892,7 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
> >        * prev into current:
> >        */
> >       spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
> > +     rcu_read_acquire();
> 
> Oooh...  This is a tricky one.  Hmmm...

<snip>

> Does any of this make sense?

No?

> > @@ -3141,6 +3170,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
> >        */
> >  #ifndef __ARCH_WANT_UNLOCKED_CTXSW
> >       spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
> > +     rcu_read_release();
> 
> My guess is that we don't need the rcu_read_release() -- the arch shouldn't
> care that we have a non-atomic field in task_struct incremented, right?
> 
> Or am I confused about what this is doing?

Either that or I used the wrong primitives for what I was meaning to do.

So from looking at rcupdate.h rcu_read_{acquire,release} are the lockdep
annotations of the rcu_read_lock. The thing we're doing above is context
switching and not making lockdep upset.

The problem is that held lock state is tracked per task, and we're well
switching tasks, so we need to transfer the held lock state from the old
to the new task, since the new task will be unlocking the thing, if at
that time lockdep finds we're not actually holding it it screams bloody
murder.

So what we do is we release the lock (annotation only, the actual lock
says locked) on prev before switching and acquire the lock on next right
after switching.


