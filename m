Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab0L2TQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 14:16:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab0L2TQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 14:16:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
Date: Wed, 29 Dec 2010 20:16:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com> <201012291247.27663.arnd@arndb.de> <AANLkTikGe3D-ujM9jqcOtk1cGmtLtUiV3kMkam1N8fyM@mail.gmail.com>
In-Reply-To: <AANLkTikGe3D-ujM9jqcOtk1cGmtLtUiV3kMkam1N8fyM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012292016.41880.arnd@arndb.de>
X-Provags-ID: V02:K0:bcABXOaQFRxGgjZxDZNj24Plsqj2F3y1iBlJtS+lkMc
 KDUAhPUQ6iiWASiwmqE0X5ZNR0KEYXLtQFQq+/wwJQH0d+MrJk
 cJtQAcr5g26sB7rVsOGI9mad4MiSjQ5rdJh9UZyrcc/duAHx6X
 69qs/YPUakioSy7JZ33+CoPyWb+atKtBk4Gv8WPRJk/4C2l1ug
 IcLT0VordYjEvtC0YHCTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 December 2010 15:42:36 Hillf Danton wrote:
> On Wed, Dec 29, 2010 at 7:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 28 December 2010 16:51:30 Daniel Walker wrote:
> >> We for sure don't want new semaphores, or new semaphore usage in the
> >> kernel ..
> 
> Would you please, Daniel, explain why there are so my file systems under
> the fs directory? Would you think the ext file system is better than others?

Most of the file systems are for compatibility with other operating systems.
The ones that duplicate Linux-only functionality are there in order to provide
backwards-compatibility with existing users. We can't remove them in the
same way that we would remove code that is only used in the kernel itself.

> And why there are in kernel spin lock, read/write lock, mutex, rw_mutex,
> rtmutx, and semaphore

There are more of these, and they partly exist because it has been hard
to change all the old users. We did remove some others though.

> timer and hrtimer?
> 
> Could timer be removed tonight?

These two are subtly different, timers are optimized for not expiring, while
hrtimer is optimized for actually expiring.

> > Yes. I once even tried unifying the semaphore and rwsem implementation,
> > but gave up on that for a number of reasons.
> 
> It looks hard to change rwsem, almost impossible, since it is based upon
> asm, at least under the x86 dir.

That could be changed using the C implementation everywhere,
but there are other problems.

> >> It should also be noted that the rtmutex (kernel/rtmutex.c) already has
> >> this capability. Although I don't think you can use an rtmutex from
> >> inside the kernel.
> >
> > I wasn't aware we had already grown another one ;-)
> >
> > AFAICT, you can only use it inside of the kernel, but it's very
> > specific and I wouldn't recommend using it unless a regular mutex
> > cannot be used for some reason. The only user besides the futex
> > code seems to be the i2c layer at this moment.
> >
> >> If you really want this you should look into the rtmutex, and the
> >> regular mutex API's .
> 
> But greping "struct semaphore" include/linux and fs dirs may tell us
> more about semaphore.

There are three classes of semaphore users today:

1. Those that initialize the semaphore to >1, guarding access to a
   resource that has multiple users: acpi/osl, mthca, mlx4, megaraid,
   comedi/vmk80xx, udlfb, usblc, usb-skeleton, blizzard, hwa742, and 9p.
2. Those that use the semaphore as some sort of completion, or a combination
   of completion and mutex.
3. Those that can and should be converted to mutex: most of the staging
   drivers, plus some more.

IMHO it would be nice to separate the first two classes in some way, so we
can make the counting semaphores stricter and apply the same rules as
mutexes and make the completion-like semaphores non-counting.

> > If Hillf relies on counting semaphores, that won't work, but very
> > few such users exist in code outside of textbooks.
> >
> 
> Though capable in rtmutex, why mutex should no longer stay in Kernel?
> 
> However mutex could be changed based on hrtimer if needed for some reason.

There is currently no mutex_lock_timeout(), so that would be meaningless.

> --- a/kernel/mutex.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/kernel/mutex.c	2010-12-29 22:35:40.000000000 +0800
> @@ -23,6 +23,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/interrupt.h>
>  #include <linux/debug_locks.h>
> +#include <linux/hrtimer.h>
> 
>  /*
>   * In the DEBUG case we are using the "NULL fastpath" for mutexes,
> @@ -248,7 +249,11 @@ __mutex_lock_common(struct mutex *lock,
>  		/* didnt get the lock, go to sleep: */
>  		spin_unlock_mutex(&lock->wait_lock, flags);
>  		preempt_enable_no_resched();
> -		schedule();
> +		do {
> +			/* sleep 10,000 nanoseconds per loop */
> +			ktime_t kt = ktime_set(0, 10000);
> +			schedule_hrtimeout(&kt, HRTIMER_MODE_REL);
> +		} while (0);
>  		preempt_disable();
>  		spin_lock_mutex(&lock->wait_lock, flags);
>  	}
> 

Doing this would be extremely inefficient, because now the mutex wait
function would wake up very frequently instead of just once when the
mutex has been released by another thread.

	Arnd
