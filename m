Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab0DHPwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 11:52:43 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:59501 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932763Ab0DHPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 11:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nvXtLEMEMJZIYBvXLthmhzQvr3g+ZH4HoYplin27Fi092cDuScH75hDUK//ncFcTMv
         IntwRbzBQrwIt3lo0uwLTWGHsogZcqbIUARZEfwlvcbGT2ZNxeeB7Y9yuk28jkwh0/7w
         4hYXECgx7i/OYWL5ONh/yNEq8U4s+IstpTV14=
Date: Thu, 8 Apr 2010 23:55:46 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100408155546.GB4213@hack>
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331135220.c6695a51.akpm@linux-foundation.org> <4BB3BAD6.50308@zytor.com> <alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org> <878w8zcc6a.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878w8zcc6a.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 12:09:17PM -0700, Kevin Hilman wrote:
>Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> On Wed, 31 Mar 2010, H. Peter Anvin wrote:
>>> 
>>> The obvious way to fix this would be to use
>>> spin_lock_irqsave..spin_lock_irqrestore in __down_read as well as in the
>>> other locations; I don't have a good feel for what the cost of doing so
>>> would be, though.  On x86 it's fairly expensive simply because the only
>>> way to save the state is to push it on the stack, which the compiler
>>> doesn't deal well with, but this code isn't used on x86.
>>
>
>[...]
>
>> So making the slow-path do the spin_[un]lock_irq{save,restore}() versions 
>> sounds like the right thing. It won't be a performance issue: it _is_ the 
>> slow-path, and we're already doing the expensive part (the spinlock itself 
>> and the irq thing).
>>
>> So ACK on the idea. Who wants to write the trivial patch and test it? 
>
>OK, I'll bite since I was seeing boot-time hangs on ARM (TI OMAP3) due
>to this.  Patch below.
>
>Kevin
>
>
>From 7baff4008353bbfd2a2e2a4da22b87bc4efa4194 Mon Sep 17 00:00:00 2001
>From: Kevin Hilman <khilman@deeprootsystems.com>
>Date: Wed, 7 Apr 2010 11:52:46 -0700
>Subject: [PATCH] rwsem generic spinlock: use IRQ save/restore spinlocks
>
>rwsems can be used with IRQs disabled, particularily in early boot
>before IRQs are enabled.  Currently the spin_unlock_irq() usage in the
>slow-patch will unconditionally enable interrupts and cause problems
>since interrupts are not yet initialized or enabled.
>
>This patch uses save/restore versions of IRQ spinlocks in the slowpath
>to ensure interrupts are not unintentionally disabled.
>
>Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

This looks reasonable and fine for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.


>---
> lib/rwsem-spinlock.c |   14 ++++++++------
> 1 files changed, 8 insertions(+), 6 deletions(-)
>
>diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
>index ccf95bf..ffc9fc7 100644
>--- a/lib/rwsem-spinlock.c
>+++ b/lib/rwsem-spinlock.c
>@@ -143,13 +143,14 @@ void __sched __down_read(struct rw_semaphore *sem)
> {
> 	struct rwsem_waiter waiter;
> 	struct task_struct *tsk;
>+	unsigned long flags;
> 
>-	spin_lock_irq(&sem->wait_lock);
>+	spin_lock_irqsave(&sem->wait_lock, flags);
> 
> 	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
> 		/* granted */
> 		sem->activity++;
>-		spin_unlock_irq(&sem->wait_lock);
>+		spin_unlock_irqrestore(&sem->wait_lock, flags);
> 		goto out;
> 	}
> 
>@@ -164,7 +165,7 @@ void __sched __down_read(struct rw_semaphore *sem)
> 	list_add_tail(&waiter.list, &sem->wait_list);
> 
> 	/* we don't need to touch the semaphore struct anymore */
>-	spin_unlock_irq(&sem->wait_lock);
>+	spin_unlock_irqrestore(&sem->wait_lock, flags);
> 
> 	/* wait to be given the lock */
> 	for (;;) {
>@@ -209,13 +210,14 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
> {
> 	struct rwsem_waiter waiter;
> 	struct task_struct *tsk;
>+	unsigned long flags;
> 
>-	spin_lock_irq(&sem->wait_lock);
>+	spin_lock_irqsave(&sem->wait_lock, flags);
> 
> 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
> 		/* granted */
> 		sem->activity = -1;
>-		spin_unlock_irq(&sem->wait_lock);
>+		spin_unlock_irqrestore(&sem->wait_lock, flags);
> 		goto out;
> 	}
> 
>@@ -230,7 +232,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
> 	list_add_tail(&waiter.list, &sem->wait_list);
> 
> 	/* we don't need to touch the semaphore struct anymore */
>-	spin_unlock_irq(&sem->wait_lock);
>+	spin_unlock_irqrestore(&sem->wait_lock, flags);
> 
> 	/* wait to be given the lock */
> 	for (;;) {
>-- 
>1.7.0.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
