Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab0DKWKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 18:10:21 -0400
Received: from www.tglx.de ([62.245.132.106]:44572 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092Ab0DKWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 18:10:20 -0400
Date: Mon, 12 Apr 2010 00:09:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Frantisek Rysanek <Frantisek.Rysanek@post.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: setitimer vs. threads: SIGALRM returned to which thread? (process
 master or individual child)
In-Reply-To: <87d3y5btdk.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.1004120000330.18009@localhost.localdomain>
References: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz> <87d3y5btdk.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Apr 2010, Andi Kleen wrote:

> "Frantisek Rysanek" <Frantisek.Rysanek@post.cz> writes:
> 
> > Yes, it used to be quite a relief to have Linux do the management of 
> > timers for me. Now I have two options to choose from:
> > 1) write my own "timer queueing" (timekeeping) code to order the 
> > timers for me in the master thread
> > 2) find another function, similar to setitimer(), that would function 
> > the way setitimer() used to work in the old days...
> 
> POSIX timers (timer_create et.al.) allow specifying the signal.
> 
> So if you use custom RT signals for each threads and block them in the
> threads you don't want them it should work. This would limit the
> maximum number of threads though because there's only a limited
> range of RT signals.
> 
> There are probably other ways to do this too, e.g. with some clever
> use of timerfd_create in recent kernels.
> 
> Or you could overwrite the clone in the thread library to not 
> set signal sharing semantics. This might have other bad side effects
> though.

Nonsense. Just use the right flags when creating the posix
timer. posix timers support per thread delivery of a signal, i.e. you
can use the same signal for all threads.

   sigev.sigev_notify = SIGEV_THREAD_ID | SIGEV_SIGNAL;
   sigev.sigev_signo = YOUR_SIGNAL;
   sigev.sigev_notify_thread_id = gettid();
   timer_create(CLOCK_MONOTONIC, &sigev, &timer);

That signal for that timer will not be delivered to any other thread
than the one specified in sigev.sigev_notify_thread_id as long as that
thread has not exited w/o canceling the timer.

Thanks,

	tglx
