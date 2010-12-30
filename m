Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0L3P4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 10:56:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:55917 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab0L3P4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 10:56:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
Date: Thu, 30 Dec 2010 16:56:03 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        Mike Christie <michaelc@cs.wisc.edu>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com> <201012292016.41880.arnd@arndb.de> <AANLkTikGCLPSuvi4UkRL8RThdP32QoNhubXmXsqANK7e@mail.gmail.com>
In-Reply-To: <AANLkTikGCLPSuvi4UkRL8RThdP32QoNhubXmXsqANK7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012301656.03788.arnd@arndb.de>
X-Provags-ID: V02:K0:M4cUlIpw2VaxLT8yd7sUE2AVlcHgQuRobhZF0SrTDYY
 r7uC++oBxfJQ1T+m2rlXqifjIEQERDMwXsINwgsRm430rlosv4
 me+aRG2mtrxtbVYbBzezjZO84pk2jAMLRbFmrisCO+oObyJrB8
 oja6DMCRzH5cMGtVtqCV83jZTSy6npv8eXXEL3FaqtQBKZth3k
 mPHvgwpK+o24AcQ/Hppvw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 December 2010, Hillf Danton wrote:
> >>  /*
> >>   * In the DEBUG case we are using the "NULL fastpath" for mutexes,
> >> @@ -248,7 +249,11 @@ __mutex_lock_common(struct mutex *lock,
> >>               /* didnt get the lock, go to sleep: */
> >>               spin_unlock_mutex(&lock->wait_lock, flags);
> >>               preempt_enable_no_resched();
> >> -             schedule();
> >> +             do {
> >> +                     /* sleep 10,000 nanoseconds per loop */
> >> +                     ktime_t kt = ktime_set(0, 10000);
> >> +                     schedule_hrtimeout(&kt, HRTIMER_MODE_REL);
> >> +             } while (0);
> >>               preempt_disable();
> >>               spin_lock_mutex(&lock->wait_lock, flags);
> >>       }
> >>
> >
> > Doing this would be extremely inefficient, because now the mutex wait
> > function would wake up very frequently instead of just once when the
> 
> Is it waked up less than jeffy?
> If not, checking more frequently in the endless loop could help receive
> signal, other than that is extremely meaningless, as the holder of
> mutex is not ready to release.

It should normally only wake up once, at exactly the time that the other
thread releases the mutex. What exactly happens depends on the relative
priorities of the two lock holders and whether all CPUs are busy already.

If there is nothing else to do and the blocking thread is made runnable
by giving up the mutex, it will run immediately. Even if we keep the
current thread running, the jiffie timer is rather meaningless and
does not directly impact when the new one wakes up.

> As to timeout, it is another story, in which waiter is able to determine
> how many jiffies or nanoseconds are acceptable if waiting is necessary.

Actually, the timeout is the time after which the waiter gives up and
does something else because it no longer expects to get the lock. This
is very rarely needed.

	Arnd
