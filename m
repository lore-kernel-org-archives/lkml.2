Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0FQIty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 04:49:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0FQItw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 04:49:52 -0400
Subject: Re: [GIT PULL rcu/urgent] yet more lockdep-RCU splat fixes
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, daniel.blueman@gmail.com,
       lizf@cn.fujitsu.com, miles.lane@gmail.com, manfred@colorfullife.com
In-Reply-To: <20100616224110.GI2457@linux.vnet.ibm.com>
References: <20100616042224.GA3892@linux.vnet.ibm.com>
	 <20100616055358.GB17936@elte.hu> <1276669431.1745.595.camel@laptop>
	 <20100616224110.GI2457@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Jun 2010 10:49:14 +0200
Message-ID: <1276764554.27822.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 15:41 -0700, Paul E. McKenney wrote:

> Hello, Peter!
> 
> Here is the story as I understand it:
> 
> o	wake_affine() calls task_group() and uses the resulting
> 	pointer, for example, passing it to effective_load().
> 
> 	This pointer is to a struct task_group, which contains
> 	a struct rcu_head, which is passed to call_rcu in
> 	sched_destroy_group().  So some protection really is
> 	needed -- or is it enough that wake_affine seems to be
> 	invoked on the current task?  If the latter, we would
> 	need to add a "task == current" check to task_subsys_state().
> 
> o	task_group() calls task_subsys_state(), returning a pointer to
> 	the enclosing task_group structure.
> 
> o	task_subsys_state() returns an rcu_dereference_check()ed
> 	pointer.  The caller must either be in an RCU read-side
> 	critical section, hold the ->alloc_lock, or hold the
> 	cgroup lock.
> 
> Now wake_affine() appears to be doing load calculations, so it does not
> seem reasonable to acquire the lock.  Hence the use of RCU.
> 
> So, what should we be doing instead?  ;-)

Well, start by writing a sane changlog ;-)

I realise you didn't actually wrote these patches, but you should push
back to the people feeding you these things (esp when you get gems like:

  tg = task_group();
  rcu_read_unlock();

which is obvious utter garbage).

There's _two_ task_group() users in wake_affine(), at least one should
be covered by the rq->lock we're holding. It should then explain why the
other isn't covered (and which the other is).

It should also explain why using RCU read lock is the right solution,
and doesn't result in funny races. That is, the current changelog reads
like: "It whines, this makes it quiet." -- which I totally distrust
because we already found at least two actual bugs in this area
(sched-cgroup rcu usage).

That said, the two patches together might not be wrong, but its very
hard to verify without more information.
