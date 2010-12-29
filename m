Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0L2Ooa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:44:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63532 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab0L2Oo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ofZsSJM3WvBwoHCRM31FYtCXP7fcAvuPLa1zdBY7i7w+PiP6Jr80Ao1DHjylJ+5+h5
         U+JvxZNFUyZHtn3wS17zfA9vPmEOumuTbreDLiyTviLKnQVdxjgeEr7YDZqIFsQSxnID
         KhiOkmbYRKjhFbYwKgWZss41UiOYraZBwYsDQ=
MIME-Version: 1.0
In-Reply-To: <201012291247.27663.arnd@arndb.de>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<201012272215.52642.arnd@arndb.de>
	<1293551490.24601.10.camel@m0nster>
	<201012291247.27663.arnd@arndb.de>
Date: Wed, 29 Dec 2010 22:42:36 +0800
Message-ID: <AANLkTikGe3D-ujM9jqcOtk1cGmtLtUiV3kMkam1N8fyM@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 29, 2010 at 7:47 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 28 December 2010 16:51:30 Daniel Walker wrote:
>> We for sure don't want new semaphores, or new semaphore usage in the
>> kernel ..

Would you please, Daniel, explain why there are so my file systems under
the fs directory? Would you think the ext file system is better than others?

And why there are in kernel spin lock, read/write lock, mutex, rw_mutex,
rtmutx, and semaphore, timer and hrtimer?

Could timer be removed tonight?

>
> Yes. I once even tried unifying the semaphore and rwsem implementation,
> but gave up on that for a number of reasons.

It looks hard to change rwsem, almost impossible, since it is based upon
asm, at least under the x86 dir.

>
>> It should also be noted that the rtmutex (kernel/rtmutex.c) already has
>> this capability. Although I don't think you can use an rtmutex from
>> inside the kernel.
>
> I wasn't aware we had already grown another one ;-)
>
> AFAICT, you can only use it inside of the kernel, but it's very
> specific and I wouldn't recommend using it unless a regular mutex
> cannot be used for some reason. The only user besides the futex
> code seems to be the i2c layer at this moment.
>
>> If you really want this you should look into the rtmutex, and the
>> regular mutex API's .
>

But greping "struct semaphore" include/linux and fs dirs may tell us
more about semaphore.

> If Hillf relies on counting semaphores, that won't work, but very
> few such users exist in code outside of textbooks.
>

Though capable in rtmutex, why mutex should no longer stay in Kernel?

However mutex could be changed based on hrtimer if needed for some reason.

Thanks
Hillf
---

--- a/kernel/mutex.c	2010-11-01 19:54:12.000000000 +0800
+++ b/kernel/mutex.c	2010-12-29 22:35:40.000000000 +0800
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/debug_locks.h>
+#include <linux/hrtimer.h>

 /*
  * In the DEBUG case we are using the "NULL fastpath" for mutexes,
@@ -248,7 +249,11 @@ __mutex_lock_common(struct mutex *lock,
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
 		preempt_enable_no_resched();
-		schedule();
+		do {
+			/* sleep 10,000 nanoseconds per loop */
+			ktime_t kt = ktime_set(0, 10000);
+			schedule_hrtimeout(&kt, HRTIMER_MODE_REL);
+		} while (0);
 		preempt_disable();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
