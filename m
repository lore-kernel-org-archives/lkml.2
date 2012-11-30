Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab2K3Vn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 16:43:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2K3Vnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:43:55 -0500
Date: Fri, 30 Nov 2012 13:43:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, axboe@kernel.dk,
        jmoyer@redhat.com, Neil Brown <neilb@suse.de>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] wait: add wait_event_lock_irq() interface
Message-Id: <20121130134353.eb4ba17e.akpm@linux-foundation.org>
In-Reply-To: <1354272161-9173-1-git-send-email-lczerner@redhat.com>
References: <1354272161-9173-1-git-send-email-lczerner@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 11:42:40 +0100
Lukas Czerner <lczerner@redhat.com> wrote:

> New wait_event{_interruptible}_lock_irq{_cmd} macros added. This commit
> moves the private wait_event_lock_irq() macro from MD to regular wait
> includes, introduces new macro wait_event_lock_irq_cmd() instead of using
> the old method with omitting cmd parameter which is ugly and makes a use
> of new macros in the MD. It also introduces the _interruptible_ variant.
> 
> The use of new interface is when one have a special lock to protect data
> structures used in the condition, or one also needs to invoke "cmd"
> before putting it to sleep.
> 
> All new macros are expected to be called with the lock taken. The lock
> is released before sleep and is reacquired afterwards. We will leave the
> macro with the lock held.
> 
> Note to DM: IMO this should also fix theoretical race on waitqueue while
> using simultaneously wait_event_lock_irq() and wait_event() because of
> lack of locking around current state setting and wait queue removal.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: Neil Brown <neilb@suse.de>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> v2: add interruptible variant, swap cmd and schedule, use prepare_to_wait
> v3: swap cmd and schedule so we call cmd before schedule

Your v3 patch reverts
http://ozlabs.org/~akpm/mmots/broken-out/wait-add-wait_event_lock_irq-interface-fix.patch.

Here's what I've queued in -mm:

--- a/include/linux/wait.h~wait-add-wait_event_lock_irq-interface-v3
+++ a/include/linux/wait.h
@@ -555,14 +555,13 @@ do {									\
 do {									\
 	DEFINE_WAIT(__wait);						\
 									\
-	cmd;								\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
 		if (condition)						\
 			break;						\
 		spin_unlock_irq(&lock);					\
-		schedule();						\
 		cmd;							\
+		schedule();						\
 		spin_lock_irq(&lock);					\
 	}								\
 	finish_wait(&wq, &__wait);					\
@@ -575,8 +574,8 @@ do {									\
  *			     taken.
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * @lock: a locked spinlock_t, which will be released before schedule()
- *	  and cmd reacquired afterwards.
+ * @lock: a locked spinlock_t, which will be released before cmd
+ *	  and schedule() and reacquired afterwards.
  * @cmd: a command which is invoked outside the critical section before
  *	 sleep
  *
@@ -588,7 +587,7 @@ do {									\
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
- * dropped before going to sleep and invoking the cmd and is reacquired
+ * dropped before invoking the cmd and going to sleep and is reacquired
  * afterwards.
  */
 #define wait_event_lock_irq_cmd(wq, condition, lock, cmd)		\
@@ -631,7 +630,6 @@ do {									\
 do {									\
 	DEFINE_WAIT(__wait);						\
 									\
-	cmd;								\
 	for (;;) {							\
 		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
 		if (condition)						\
@@ -641,8 +639,8 @@ do {									\
 			break;						\
 		}							\
 		spin_unlock_irq(&lock);					\
-		schedule();						\
 		cmd;							\
+		schedule();						\
 		spin_lock_irq(&lock);					\
 	}								\
 	finish_wait(&wq, &__wait);					\
@@ -654,8 +652,8 @@ do {									\
  *		be called with the lock taken.
  * @wq: the waitqueue to wait on
  * @condition: a C expression for the event to wait for
- * @lock: a locked spinlock_t, which will be released before schedule()
- *	  and cmd reacquired afterwards.
+ * @lock: a locked spinlock_t, which will be released before cmd and
+ *	  schedule() and reacquired afterwards.
  * @cmd: a command which is invoked outside the critical section before
  *	 sleep
  *
@@ -667,7 +665,7 @@ do {									\
  * change the result of the wait condition.
  *
  * This is supposed to be called while holding the lock. The lock is
- * dropped before going to sleep and invoking the cmd and is reacquired
+ * dropped before invoking the cmd and going to sleep and is reacquired
  * afterwards.
  *
  * The macro will return -ERESTARTSYS if it was interrupted by a signal
_

