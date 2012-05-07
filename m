Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2EGR5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:57:49 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:43871 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2EGR5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:57:47 -0400
Date: Mon, 7 May 2012 10:57:43 -0700
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next oops in __lock_acquire for process_one_work
Message-ID: <20120507175743.GC19417@google.com>
References: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1205070951170.1544@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Peter and Ingo and quoting whole body)

On Mon, May 07, 2012 at 10:19:09AM -0700, Hugh Dickins wrote:
> Running MM load on recent linux-nexts (e.g. 3.4.0-rc5-next-20120504),
> with CONFIG_PROVE_LOCKING=y, I've been hitting an oops in __lock_acquire
> called from lock_acquire called from process_one_work: serving mm/swap.c's
> lru_add_drain_all - schedule_on_each_cpu(lru_add_drain_per_cpu).
> 
> In each case the oopsing address has been ffffffff00000198, and the
> oopsing instruction is the "atomic_inc((atomic_t *)&class->ops)" in
> __lock_acquire: so class is ffffffff00000000.
> 
> I notice Stephen's commit 0976dfc1d0cd80a4e9dfaf87bd8744612bde475a
> workqueue: Catch more locking problems with flush_work()
> in linux-next but not 3.4-rc, adding
> 	lock_map_acquire(&work->lockdep_map);
> 	lock_map_release(&work->lockdep_map);
> to flush_work.
> 
> I believe that occasionally races with your
> 	struct lockdep_map lockdep_map = work->lockdep_map;
> in process_one_work, putting an entry into the class_cache
> just as you're copying it, so you end up with half a pointer.
> yes, the structure copy is using "rep movsl" not "rep movsq".
> 
> I've reverted Stephen's commit from my testing, and indeed it's
> now run that MM load much longer than I've seen since this bug
> first appeared.  Though I suspect that strictly it's your
> unlocked copying of the lockdep_map that's to blame.  Probably
> easily fixed by someone who understands lockdep - not me!

The offending commit is 0976dfc1d0cd80a4e9dfaf87bd8744612bde475a
"workqueue: Catch more locking problems with flush_work()".  It sounds
fancy but all it does is adding the following to flush_work().

	lock_map_acquire(&work->lockdep_map);
	lock_map_release(&work->lockdep_map);

Which seems correct to me and more importantly not different from what
wait_on_work() does, so if this is broken, flush_work_sync() and
cancel_work_sync() are broken too - probably masked by lower usage
frequency.

It seems the problem stems from how process_one_work() "caches"
lockdep_map.  This part predates cmwq changes but it seems necessary
because the work item may be freed during execution but lockdep_map
should be released after execution is complete.  Peter, do you
remember how this lockdep_map copying is added?  Is (or was) this
correct?  If it's broken, how do we fix it?  Add a lockdep_map copy
API which does some magic lockdep locking dancing?

Thanks.

-- 
tejun
