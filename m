Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab0DGTJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 15:09:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53945 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0DGTJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 15:09:21 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: start_kernel(): bug: interrupts were enabled early
References: <20100325194100.GA2364@debian>
	<20100331134048.da4e35a7.akpm@linux-foundation.org>
	<4BB3B4DB.7040904@kernel.org>
	<20100331135220.c6695a51.akpm@linux-foundation.org>
	<4BB3BAD6.50308@zytor.com>
	<alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 07 Apr 2010 12:09:17 -0700
In-Reply-To: <alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org> (Linus Torvalds's message of "Thu\, 1 Apr 2010 09\:13\:31 -0700 \(PDT\)")
Message-ID: <878w8zcc6a.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
>> 
>> The obvious way to fix this would be to use
>> spin_lock_irqsave..spin_lock_irqrestore in __down_read as well as in the
>> other locations; I don't have a good feel for what the cost of doing so
>> would be, though.  On x86 it's fairly expensive simply because the only
>> way to save the state is to push it on the stack, which the compiler
>> doesn't deal well with, but this code isn't used on x86.
>

[...]

> So making the slow-path do the spin_[un]lock_irq{save,restore}() versions 
> sounds like the right thing. It won't be a performance issue: it _is_ the 
> slow-path, and we're already doing the expensive part (the spinlock itself 
> and the irq thing).
>
> So ACK on the idea. Who wants to write the trivial patch and test it? 

OK, I'll bite since I was seeing boot-time hangs on ARM (TI OMAP3) due
to this.  Patch below.

Kevin


>From 7baff4008353bbfd2a2e2a4da22b87bc4efa4194 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Wed, 7 Apr 2010 11:52:46 -0700
Subject: [PATCH] rwsem generic spinlock: use IRQ save/restore spinlocks

rwsems can be used with IRQs disabled, particularily in early boot
before IRQs are enabled.  Currently the spin_unlock_irq() usage in the
slow-patch will unconditionally enable interrupts and cause problems
since interrupts are not yet initialized or enabled.

This patch uses save/restore versions of IRQ spinlocks in the slowpath
to ensure interrupts are not unintentionally disabled.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 lib/rwsem-spinlock.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ccf95bf..ffc9fc7 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -143,13 +143,14 @@ void __sched __down_read(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
+	unsigned long flags;
 
-	spin_lock_irq(&sem->wait_lock);
+	spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity++;
-		spin_unlock_irq(&sem->wait_lock);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -164,7 +165,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irq(&sem->wait_lock);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
@@ -209,13 +210,14 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
+	unsigned long flags;
 
-	spin_lock_irq(&sem->wait_lock);
+	spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity = -1;
-		spin_unlock_irq(&sem->wait_lock);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -230,7 +232,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irq(&sem->wait_lock);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
-- 
1.7.0.2

