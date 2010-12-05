Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0LEF2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 00:28:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42032 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0LEF2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 00:28:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FQdKI7MR9HwJH5gbYLFO11dQ1k2kY9/7TjNk29FDGW8Q21PKV2G4NPy9y17jzzleKE
         MKE/JG5PHjnHDMfO43rSpVd7uQEOrVqsXFcSfAYTI5qUpdTRTAaWB6lHNGh4GF4z0Xq1
         nzQT33vCw1TE/nQnWNTukXTQ/Y7E+U36HoEII=
Date: Sun, 5 Dec 2010 13:28:19 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: Scheduler bug related to rq->skip_clock_update?
Message-ID: <20101205052819.GA2878@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
 <1290359641.4816.69.camel@maggy.simson.net>
 <alpine.LNX.2.00.1011212327250.8927@jupiter-cs.cs.unc.edu>
 <1290442781.16393.22.camel@maggy.simson.net>
 <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1011221310430.8927@jupiter-cs.cs.unc.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 01:14:47PM -0500, Bjoern B. Brandenburg wrote:
> On Mon, 22 Nov 2010, Mike Galbraith wrote:
> 
> > On Sun, 2010-11-21 at 23:29 -0500, Bjoern B. Brandenburg wrote:
> > > On Sun, 21 Nov 2010, Mike Galbraith wrote:
> > >
> > > > On Sat, 2010-11-20 at 23:22 -0500, Bjoern B. Brandenburg wrote:
> > > >
> > > > > I was under the impression that, as an invariant, tasks should not have
> > > > > TIF_NEED_RESCHED set after they've blocked. In this case, the idle load
> > > > > balancer should not mark the task that's on its way out with
> > > > > set_tsk_need_resched().
> > > >
> > > > Nice find.
> > > >
> > > > > In any case, check_preempt_curr() seems to assume that a resuming task cannot
> > > > > have TIF_NEED_RESCHED already set. Setting skip_clock_update on a remote CPU
> > > > > that hasn't even been notified via IPI seems wrong.
> > > >
> > > > Yes. Does the below fix it up for you?
> > >
> > > The patch definitely changes the behavior, but it doesn't seem to solve (all
> > > of) the root cause(s). The failsafe kicks in and clears the flag the next
> > > time that update_rq_clock() is called, but there can still be a significant
> > > delay between setting and clearing the flag. Right after boot, I'm now seeing
> > > values that go up to ~21ms.
> >
> > A pull isn't the only vulnerability.  Since idle_balance() drops
> > rq->lock, so another cpu can wake to this rq.
> >
> > > Please let me know if there is something else that I should test.
> >
> > Sched: clear_tsk_need_resched() after NEWIDLE balancing
> >
> > idle_balance() drops/retakes rq->lock, leaving the previous task
> > vulnerable to set_tsk_need_resched() from another CPU.  Clear it
> > after NEWIDLE balancing to maintain the invariant that descheduled
> > tasks are NOT marked for resched.
> >
> > This also confuses the skip_clock_update logic, which assumes that
> > the next call to update_rq_clock() will come nearly ĩmmediately after
> > being set.  Make the optimization more robust by clearing before we
> > balance and in update_rq_clock().
> 
> Unfortunately that doesn't seem to do it yet.
> 
> After running five 'find /' instances to completion on the ARM platform,
> I'm still seeing delays close to 10ms.
> 
>     bbb@district10:~$ egrep 'cpu#|skip' /proc/sched_debug
>     cpu#0
>       .skip_clock_count              : 89606
>       .skip_clock_recent_max         : 9817250
>       .skip_clock_max                : 21992375
>     cpu#1
>       .skip_clock_count              : 81978
>       .skip_clock_recent_max         : 9582500
>       .skip_clock_max                : 17201750
>     cpu#2
>       .skip_clock_count              : 74565
>       .skip_clock_recent_max         : 9678000
>       .skip_clock_max                : 9879250
>     cpu#3
>       .skip_clock_count              : 81685
>       .skip_clock_recent_max         : 9300125
>       .skip_clock_max                : 14115750
> 
> On the x86_64 host, I've changed to HZ=100 and am now also seeing delays
> close to 10ms after 'make clean && make -j8 bzImage'.
> 
>     bbb@koruna:~$ egrep 'cpu#|skip' /proc/sched_debug
>     cpu#0, 2493.476 MHz
>       .skip_clock_count              : 29703
>       .skip_clock_recent_max         : 9999858
>       .skip_clock_max                : 40645942
>     cpu#1, 2493.476 MHz
>       .skip_clock_count              : 32696
>       .skip_clock_recent_max         : 9959118
>       .skip_clock_max                : 35074771
>     cpu#2, 2493.476 MHz
>       .skip_clock_count              : 31742
>       .skip_clock_recent_max         : 9788654
>       .skip_clock_max                : 24821765
>     cpu#3, 2493.476 MHz
>       .skip_clock_count              : 31123
>       .skip_clock_recent_max         : 9858546
>       .skip_clock_max                : 44276033
>     cpu#4, 2493.476 MHz
>       .skip_clock_count              : 28346
>       .skip_clock_recent_max         : 10000775
>       .skip_clock_max                : 18681753
>     cpu#5, 2493.476 MHz
>       .skip_clock_count              : 29421
>       .skip_clock_recent_max         : 9997656
>       .skip_clock_max                : 138473407
>     cpu#6, 2493.476 MHz
>       .skip_clock_count              : 27721
>       .skip_clock_recent_max         : 9992074
>       .skip_clock_max                : 53436918
>     cpu#7, 2493.476 MHz
>       .skip_clock_count              : 29637
>       .skip_clock_recent_max         : 9994516
>       .skip_clock_max                : 566793528
> 
> These numbers were recorded with the below patch.
> 
> Please let me know if I can help by testing or tracing something else.

Please just ignore my previous email and sorry for those noise.

I think I find the root cause after all-night sleep. :)

when we init idle task, we doesn't mark it on_rq.
My test show the concern is smoothed by below patch.

Thanks,
Yong

---
diff --git a/kernel/sched.c b/kernel/sched.c
index dc91a4d..21c76d9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5486,6 +5486,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	__sched_fork(idle);
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
+	idle->se.on_rq = 1;
 
 	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
 	/*
