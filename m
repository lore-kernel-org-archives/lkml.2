Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0EQWFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:05:35 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:33754 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab0EQWFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:05:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAF9X8UtGGOJc/2dsb2JhbACdd3K9DoUQBA
Date: Mon, 17 May 2010 18:00:25 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       Arnd Bergmann <arnd@relay.de.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC tip/core/rcu 23/23] vhost: add __rcu annotations
Message-ID: <20100517220025.GA1366@Krystal>
References: <20100512213317.GA15085@linux.vnet.ibm.com> <1273700022-16523-23-git-send-email-paulmck@linux.vnet.ibm.com> <20100512214847.GD22930@redhat.com> <20100512230057.GH2303@linux.vnet.ibm.com> <1273756043.5605.3542.camel@twins> <20100513152340.GA2879@linux.vnet.ibm.com> <20100517203349.GA14994@redhat.com> <20100517210606.GW2320@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100517210606.GW2320@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:39:30 up 40 days,  7:33,  4 users,  load average: 0.32, 0.19,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, May 17, 2010 at 11:33:49PM +0300, Michael S. Tsirkin wrote:
> > On Thu, May 13, 2010 at 08:23:40AM -0700, Paul E. McKenney wrote:
> > > On Thu, May 13, 2010 at 03:07:23PM +0200, Peter Zijlstra wrote:
> > > > On Wed, 2010-05-12 at 16:00 -0700, Paul E. McKenney wrote:
> > > > > Any thoughts?  One approach would be to create a separate lockdep class
> > > > > for vhost workqueue state, similar to the approach used in instrument
> > > > > rcu_read_lock() and friends. 
> > > > 
> > > > workqueue_struct::lockdep_map, its held while executing worklets.
> > > > 
> > > > lock_is_held(&vhost_workqueue->lockdep_map), should do as you want.
> > > 
> > > Thank you, Peter!!!
> > > 
> > > 							Thanx, Paul
> > 
> > vhost in fact does flush_work rather than
> > flush_workqueue, so while for now everything runs
> > from vhost_workqueue in theory nothing would break
> > if we use some other workqueue or even a combination
> > thereof.
> > 
> > I guess when/if this happens, we could start by converting
> > to _raw and then devise a solution.
> 
> If there are a small finite number of work queues involved, we can
> easily do something like:
> 
> 	#ifdef CONFIG_PROVE_RCU
> 	int in_vhost_workqueue(void)
> 	{
> 		return in_workqueue_context(vhost_workqueue) ||
> 		       in_workqueue_context(vhost_other_workqueue) ||
> 		       in_workqueue_context(yet_another_vhost_workqueue);
> 	}
> 	#endif /* #ifdef CONFIG_PROVE_RCU */
> 
> Seem reasonable?
> 
> > By the way what would be really nice is if we had a way
> > to trap when rcu protected pointer is freed without a flush
> > while some reader is running. Current annotation does not
> > allow this, does it?
> 
> Right now, it does not, but I wonder if something like Thomas's and
> Mathieu's debugobjects work could be brought to bear on this problem?
> This would need to be implemented in vhost, as synchronize_rcu() has
> no way to know what memory it is flushing, nor does flush_work().

We can think of my recent debugobjects addition as a small state machine
that is described by the code that owns the objects. At each state
transition, the code passes the expected state as well as the next
state.

The current implementation can only keep track of a single "state" per
object at once. This should be extended to be able to count the number
RCU read side C.S. in flight that are accessing to an object.

We could use a hook in rcu_dereference (which knows about the object)
and a hook in rcu_read_unlock (which determines the end of valid object
use).

We should hook into rcu_assign_pointer() to detect RCU structure
privatization. It should put these objects in a "privatized" hash table.

We should also hook into synchronize_rcu/sched() to remove the
privatized structures from the privatized hash.

A hook in "kfree" (maybe a new rcu_free(void (fctptr*)(void *)) wrapper ?)
would call a debugobject hook that would lookup the "privatized" hash.
If it contains the object to free, we check if there are RCU read-side
C.S. in flight using this object at the same time, and show an error if
both are true.

Thoughts ?

Mathieu


> 
> 						Thanx, Paul

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
