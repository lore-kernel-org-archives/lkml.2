Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab0LOOxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:53:25 -0500
Received: from www.tglx.de ([62.245.132.106]:33276 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0LOOxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:53:24 -0500
Date: Wed, 15 Dec 2010 15:52:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lai Jiangshan <eag0628@gmail.com>
cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
In-Reply-To: <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1012151550190.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com> <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6> <4D083900.1050801@cn.fujitsu.com> <1292386606.5015.1862.camel@gandalf.stny.rr.com> <4D0877D2.10000@cn.fujitsu.com> <alpine.LFD.2.00.1012151029090.12146@localhost6.localdomain6>
 <AANLkTi=x-_ffBnFL4TMtjGBBpbu9aBvSHKiQ7BgNy7J0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-567598182-1292424729=:12146"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-567598182-1292424729=:12146
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 15 Dec 2010, Lai Jiangshan wrote:
> On Wed, Dec 15, 2010 at 8:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 15 Dec 2010, Lai Jiangshan wrote:
> >> +     if (waiter || rt_mutex_has_waiters(lock)) {
> >> +             unsigned long flags;
> >> +             struct rt_mutex_waiter *top;
> >> +
> >> +             raw_spin_lock_irqsave(&task->pi_lock, flags);
> >> +
> >> +             /* remove the queued waiter. */
> >> +             if (waiter) {
> >> +                     plist_del(&waiter->list_entry, &lock->wait_list);
> >> +                     task->pi_blocked_on = NULL;
> >> +             }
> >> +
> >> +             /*
> >> +              * We have to enqueue the top waiter(if have) into
> >> +              * task->pi_waiters list and would get boost from it.
> >
> > No, we don't get boosted from it. We just have to enqueue it into
> > pi_waiters list. There is no boosting happening at this point. Please
> > be very careful with the comments in this code.
> >
> > Otherwise this looks really interesting. Still this wants to be ported
> > to -rt and stress tested there.
> >
> 
> Hi, Thomas,
> 
> Where can I find the code of stress testcases?

RT itself will stress test the rtmutex code as much as it goes as we
convert almost every lock into a rtmutex there.

Steven, could you have a look at that ?

Thanks,

	tglx
---1463795968-567598182-1292424729=:12146--
