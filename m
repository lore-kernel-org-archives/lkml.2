Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1IGQct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:32:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:42928 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1IGQcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:32:47 -0400
Date: Wed, 7 Sep 2011 18:32:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Frank Rowand <frank.rowand@am.sony.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
In-Reply-To: <20110907140130.GT6619@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.02.1109071818350.2723@ionos>
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com> <alpine.LFD.2.02.1109071115410.2723@ionos> <20110907104633.GR6619@n2100.arm.linux.org.uk>
 <20110907104747.GA29282@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1109071254010.2723@ionos> <20110907140130.GT6619@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Sep 2011, Russell King - ARM Linux wrote:

> On Wed, Sep 07, 2011 at 12:57:44PM +0200, Thomas Gleixner wrote:
> > The problem is that if you enable interrupts on the CPU _BEFORE_ it is
> > set online AND active, then you can end up waking up kernel threads
> > which are bound to that CPU and the scheduler will happily schedule
> > them on an online CPU. That makes them lose the cpu affinity to the
> > CPU as well and hell breaks lose.
> 
> How can that happen?
> 
> 1. The only interrupts we're likely to receive are the local timer
>    interrupts - we have not routed any other interrupts to this CPU.

Fair enough, on x86 this can happen when we enable interrupts.
 
> 2. We will not schedule on this CPU except at explicit scheduling
>    points (such as contended mutexes or explicit calls to schedule)
>    as we have a call to preempt_disable().

Right, you don't schedule. But a wakeup of a thread which has its
affinity set to the new online CPU runs (as Frank pointed out)
through:

   wake_up_process()
      try_to_wake_up()
         select_task_rq()
            if (... || !cpu_online(cpu))
               select_fallback_rq(task_cpu(p), p)
                  ...
                  /* No more Mr. Nice Guy. */
                  dest_cpu = cpuset_cpus_allowed_fallback(p)
                     do_set_cpus_allowed(p, cpu_possible_mask)
                        #  Thus ksoftirqd can now run on any cpu...

So the problem is not scheduling, it's the wakeup code. Sorry for
being imprecise.

We can't do anything about it in the scheduler code, so we have to
make sure that the cpu startup code enables interrupts after the
online AND active bits have been set.
 
> > Frank has observed this with softirq threads, but the same thing is
> > true for any other CPU bound thread like the worker stuff.
> 
> So who is scheduling a workqueue from the local timer?

The problem are timer callbacks which might be executed in the softirq
code on return from interrupt. We had one case observed on x86 where
an expired timer was queued on the about to go online cpu and the
callback scheduled work on that CPU which then caused the cpu affine
worker thread to move away :(

> > So moving the online, active thing BEFORE enabling interrupt is the
> > only sensible solution.
> 
> Yes, that'll be why even x86 enables interrupts before setting the CPU
> online for the delay calibration.

Correct.

Thanks,

	tglx
