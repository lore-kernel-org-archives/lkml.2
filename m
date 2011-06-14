Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1FNMul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:50:41 -0400
Received: from blu0-omc1-s15.blu0.hotmail.com ([65.55.116.26]:48839 "EHLO
	blu0-omc1-s15.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab1FNMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:50:39 -0400
X-Originating-IP: [184.145.208.36]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP67AEF22F46362646A365A596680@phx.gbl>
Date: Tue, 14 Jun 2011 08:50:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, josh@joshtriplett.org,
        Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu,doc: lock-free update site
References: <4DF7231B.1080708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4DF7231B.1080708@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:28:48 up 432 days, 22:18,  4 users,  load average: 0.27, 0.32,
	0.22
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 14 Jun 2011 12:50:38.0699 (UTC) FILETIME=[A95D4BB0:01CC2A91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Add a document which describes a pattern of using RCU to implement lock-free(lockless)
> update site.
> 
[...]
> @@ -0,0 +1,143 @@
> +Lock-free(lockless) update site
> +
> +This article describes a pattern of using RCU to implement lock-free(lockless)
> +update site. RCU update site is considered call-rare and it is protected
> +by a update-site lock generally. But blocking algorithms are undesirable
> +in some cases for some reasons, thus, this pattern may help.

Hi Lai,

Yes, using this kind of rcu read-side lock to protect against the
cmpxchg ABA problem is well-known (to me at least) ;) I used this
technique in the userspace RCU library "lock-free queue" and "lock-free
stack" in 2010*. Please feel free to dig through my RCU data containers code
to bring in more data structure examples:

http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/static/rculfqueue.h;h=b627e450cfdd581692b474d89437e3fd47f18463;hb=HEAD

http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/static/rculfqueue.h;h=b627e450cfdd581692b474d89437e3fd47f18463;hb=HEAD

Thanks!

Mathieu

* AFAIK I introduced this technique using RCU read-side C.S. to deal
  with cmpxchg ABA at that point, but someone might have thought about
  it before me without my knowledge. My litterature survey so far
  indicates that using a double-word CAS on a pointer/counter was one of
  the usual technique used to protect against cmpxchg ABA so far. Other
  techniques imply allocating elements in a limited-size array (so a
  simple cmpxchg can update the array index and counter atomically),
  Hasard Pointers, or having a full-blown GC which provides similar
  guarantees to the RCU grace period with a read-side lock held.
  Ref.:

  [1998] Maged Michael, Michael Scott "Simple, fast, and practical non-blocking and blocking concurrent queue algorithms"
  [2002] Maged M.Michael "Safe memory reclamation for dynamic lock-free objects using atomic reads and writes"
  [2003] Maged M.Michael "Hazard Pointers: Safe memory reclamation for lock-free objects"

> +
> +This pattern can only protect a single pointer which is the only reference
> +of the object.
> +
> +object pointer:
> +
> +struct my_struct *gptr;
> +
> +wait-free read site:
> +{
> +	rcu_read_lock();
> +	ptr = rcu_dereference(gptr);
> +	my_struct_read(ptr);
> +	rcu_read_unlock();
> +}
> +
> +lock-free update site(update as new):
> +{
> +	new_ptr = my_struct_alloc();
> +	for (;;) {
> +		rcu_read_lock();
> +
> +		old_ptr = rcu_dereference(gptr);
> +
> +		/* copy data from old_ptr to new_ptr and update it */
> +		my_struct_update(new_ptr, old_ptr);
> +
> +		/* atomically publish the new_ptr and de-publish the old_ptr */
> +		if (cmpxchg(&gptr, old_ptr, new_ptr) == old_ptr) {
> +			rcu_read_unlock();
> +
> +			/*
> +			 * free it after a grace-period, read sites and other
> +			 * update sites may be reading it in parallel.
> +			 */
> +			kfree_rcu(old_ptr);
> +
> +			/* success, exit the loop */
> +			break;
> +		} else {
> +			rcu_read_unlock();
> +
> +			/*
> +			 * Other update site successfully update it, we need
> +			 * to read the latest data and try the update again.
> +			 *
> +			 * If the other update site did the same thing we need,
> +			 * we can free the new_ptr and exit this loop too,
> +			 * and it may becomes a wait-free algorithm.
> +			 */
> +		}



> +	}
> +}
> +
> +1) In update site, rcu_read_lock() is needed for my_struct_update().
> +
> +   In this kind of lock-free update site, many update sides
> +   may run parallel, other update side may had successfully
> +   de-published old_ptr and tried to free it. rcu_read_lock()
> +   prevents old_ptr from freeing and ensures it valid for
> +   my_struct_update().
> +
> +2) In update site, rcu_read_lock() is needed until cmpxchg() finished.
> +
> +   Although the content of old_ptr is not accessed when cmpxchg(),
> +   but old_ptr should not be freed until cmpxchg() finished.
> +   Otherwise we may miss other successful update and publish a
> +   new_ptr without information from the latest object.
> +
> +   Example:(wrong update site code, rcu_read_unlock() is moved up before cmpxchg())
> +   (cause ABA-problem: http://en.wikipedia.org/wiki/ABA_problem)
> +
> +   CPU0						CPU1
> +   rcu_read_lock()
> +   old_ptr = rcu_dereference(gptr);
> +   my_struct_update(new_ptr, old_ptr);
> +   rcu_read_unlock();
> +   .						successfully update, now gptr=other_ptr
> +   .						old_ptr is freed
> +   .
> +   .						other update, my_struct_alloc() returns old_ptr
> +   .						successfully publish and de-publish
> +   .						now gptr=old_ptr again
> +   .
> +   cmpxchg(&gptr, old_ptr, new_ptr)
> +     cmpxchg() success, but the 2 updates
> +     of CPU1 are completely missed.
> +
> +   This exmaple shows rcu_read_lock() is needed to prevent old_ptr from reusing
> +   before cmpxchg() finished and to prevent ABA-problem.
> +
> +3) Beware NULL pointer.
> +
> +   Some use cases may set gptr to NULL when needed. (the previous gptr != NULL)
> +
> +lock-free update site(dispose, wait-free):
> +{
> +	old_ptr = xchg(&gptr, NULL);
> +	if (old_ptr != NULL)
> +		kfree_rcu(old_ptr);
> +}
> +
> +   This code cause NULL reusing and may cause ABA-problem like above example:
> +
> +   CPU0						CPU1
> +   rcu_read_lock()
> +   old_ptr = rcu_dereference(gptr);
> +   /* old_ptr = NULL */
> +   my_struct_update(new_ptr, NULL);
> +   .						successfully update, now gptr=other_ptr
> +   .
> +   .						successfully dispose
> +   .						now gptr=NULL again
> +   .
> +   cmpxchg(&gptr, NULL, new_ptr)
> +     cmpxchg() success, but the update
> +     and the dispose of CPU1 are missed
> +     consideration by CPU0.
> +   rcu_read_unlock();
> +
> +   In many use cases, these behaviors are OK. In these use cases,
> +   my_struct_update(new_ptr, NULL) give us the same result even we retry.
> +
> +   But in some raw use cases(I can't find any use-case now, I believe it exist),
> +   the missed considerations of the updates are not acceptable, in this case,
> +   we should use different null-value for NULL pointer for every disposing.
> +
> +lock-free update site(dispose, wait-free, paranoid version):
> +{
> +	null_ptr = alloc_null_ptr();
> +	old_ptr = xchg(&gptr, null_ptr);
> +	if (is_null_ptr(old_ptr))
> +		free_null_ptr_by_rcu_for_preventing_it_from_reusing(old_ptr);
> +	else
> +		kfree_rcu(old_ptr);
> +}
> +

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
