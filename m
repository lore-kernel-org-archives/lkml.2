Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab0DPLpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:45:46 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:47899 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757929Ab0DPLpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:45:44 -0400
Date: Fri, 16 Apr 2010 07:45:02 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: zach.brown@oracle.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100416114502.GH10828@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	Nick Piggin <npiggin@suse.de>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC84957.9080608@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC84957.9080608@colorfullife.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BC84DE0.00EA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:26:15PM +0200, Manfred Spraul wrote:
> On 04/12/2010 08:49 PM, Chris Mason wrote:
> >I have a microbenchmark to test how quickly we can post and wait in
> >bulk.  With this change, semtimedop is able do to more than twice
> >as much work in the same run.  On a large numa machine, it brings
> >the IPC lock system time (reported by perf) down from 85% to 15%.
> >
> Looking at the current code:
> - update_queue() can be O(N^2) if only some of the waiting tasks are
> woken up.
> Actually: all non-woken up tasks are rescanned after a task that can
> be woken up is found.
> 
> - Your test app tests the best case for the current code:
> You wake up the tasks in the same order as the called semop().
> If you invert the order (i.e.: worklist_add() adds to head instead
> of tail), I would expect an even worse performance of the current
> code.
> 
> The O(N^2) is simple to fix, I've attached a patch.

Good point.

> For your micro-benchmark, the patch does not change much: you
> wake-up in-order, thus the current code does not misbehave.
> 
> Do you know how Oracle wakes up the tasks?
> FIFO, LIFO, un-ordered?

Ordering in terms of the sem array?  I had them try many variations ;) I
don't think it will be ordered as well as sembench most of the time.

> 
> >	while(unlikely(error == IN_WAKEUP)) {
> >  		cpu_relax();
> >  		error = queue.status;
> >  	}
> >
> >-	if (error != -EINTR) {
> >+	/*
> >+	 * we are lock free right here, and we could have timed out or
> >+	 * gotten a signal, so we need to be really careful with how we
> >+	 * play with queue.status.  It has three possible states:
> >+	 *
> >+	 * -EINTR, which means nobody has changed it since we slept.  This
> >+	 * means we woke up on our own.
> >+	 *
> >+	 * IN_WAKEUP, someone is currently waking us up.  We need to loop
> >+	 * here until they change it to the operation error value.  If
> >+	 * we don't loop, our process could exit before they are done waking us
> >+	 *
> >+	 * operation error value: we've been properly woken up and can exit
> >+	 * at any time.
> >+	 *
> >+	 * If queue.status is currently -EINTR, we are still being processed
> >+	 * by the semtimedop core.  Someone either has us on a list head
> >+	 * or is currently poking our queue struct.  We need to find that
> >+	 * reference and remove it, which is what remove_queue_from_lists
> >+	 * does.
> >+	 *
> >+	 * We always check for both -EINTR and IN_WAKEUP because we have no
> >+	 * locks held.  Someone could change us from -EINTR to IN_WAKEUP at
> >+	 * any time.
> >+	 */
> >+	if (error != -EINTR&&  error != IN_WAKEUP) {
> >  		/* fast path: update_queue already obtained all requested
> >  		 * resources */
> No: The code accesses a local variable. The loop above the comment
> guarantees that the error can't be IN_WAKEUP.

Whoops, thanks.

> 
> >+
> >+out_putref:
> >+	sem_putref(sma);
> >+	goto out_free;
> Is it possible to move the sem_putref into wakeup_sem_queue()?
> Right now, the exit path of semtimedop doesn't touch the spinlock.
> You remove that optimization.

I'll look at this, we need to be able to go through the sma to remove
the process from the lists if it woke up on its own, but I don't see why
we can't putref in wakeup.

My current revision of the patch uses an atomic instead of the lock, so it
restores the lockless wakeup either way.  Still it is better to putref in
wakeup.

-chris
