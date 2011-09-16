Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1IPMSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 08:18:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:56282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab1IPMSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 08:18:35 -0400
Subject: Re: [RFC][PATCH 3/3] ipc/sem: Rework wakeup scheme
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Mike Galbraith <efault@gmx.de>
Date: Fri, 16 Sep 2011 14:18:17 +0200
In-Reply-To: <4E7235F6.1030303@colorfullife.com>
References: <20110914133034.687048806@chello.nl>
	 <20110914133750.916911903@chello.nl> <4E7235F6.1030303@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316175497.10174.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 19:29 +0200, Manfred Spraul wrote:
> What is broken?

So basically sembench was broken and the futex patch is causing spurious
wakeups.

I've got the below patch to fix up the sem code.

One more question, do the sem wakeups need to be issued in FIFO order?
There's a comment in there:

 * User space visible behavior:
 * - FIFO ordering for semop() operations (just FIFO, not starvation
 *   protection)

that seems to suggest the sem ops processing is in FIFO order, but does
the user visible effect propagate to the wakeup order?

Currently the wake-list is a FILO, although making it FIFO isn't really
hard (in fact, I've got the patch).


---
Subject: ipc/sem: Deal with spurious wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri Sep 16 13:58:44 CEST 2011

The current code doesn't deal well with spurious wakeups and returns
a -EINTR to user space even though there were no signals anywhere near
the task.

Deal with this to check for pending signals before actually dropping
out of the kernel and try again, avoids user<->kernel round-trip
overhead.

Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-1uiuenzz5hwf04opwqmni7cn@git.kernel.org
---
 ipc/sem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)
Index: linux-2.6/ipc/sem.c
===================================================================
--- linux-2.6.orig/ipc/sem.c
+++ linux-2.6/ipc/sem.c
@@ -1366,6 +1366,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+retry:
 	current->state = TASK_INTERRUPTIBLE;
 	sem_unlock(sma);
 
@@ -1399,21 +1400,23 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 		goto out_free;
 	}
 
-
 	/*
 	 * If queue.status != -EINTR we are woken up by another process.
 	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
 
-	if (error != -EINTR) {
+	if (error != -EINTR)
 		goto out_unlock_free;
-	}
 
 	/*
 	 * If an interrupt occurred we have to clean up the queue
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
+
+	if (error == -EINTR && !signal_pending(current))
+		goto retry;
+
 	unlink_queue(sma, &queue);
 
 out_unlock_free:

