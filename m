Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab0LJT0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:26:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:33923 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0LJT0R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:26:17 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <peterz@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Venkatesh Pallipadi <venki@google.com>, Mikael Pettersson <mikpe@it.uu.se>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <1292004654.13513.38.camel@laptop>
References: <1291917330.6803.7.camel@twins>
	 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>
	 <1291920939.6803.38.camel@twins>
	 <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>
	 <1291936593.13513.3.camel@laptop>
	 <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
	 <1291975704.6803.59.camel@twins> <1291987065.6803.151.camel@twins>
	 <1291987635.6803.161.camel@twins> <1291988866.6803.171.camel@twins>
	 <20101210175645.GB28263@n2100.arm.linux.org.uk>
	 <1292004654.13513.38.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 10 Dec 2010 20:25:56 +0100
Message-ID: <1292009156.13513.47.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-10 at 19:10 +0100, Peter Zijlstra wrote:
> > > +   delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> > > +   rq->clock += delta;
> > 
> > Hmm.  Can you tell me how this is different to:
> > 
> >       new_clock = sched_clock_cpu(cpu_of(rq));
> >       delta = new_clock - rq->clock;
> >       rq->clock = new_clock;
> > 
> > which I think may be simpler in terms of 64-bit math for 32-bit compilers
> > to deal with?
> 
> Its not, I could write it like that, the only reason I didn't is because
> it uses an extra variable. If gcc on 32bit targets really generates
> hideous code for it I'll happily change it. 

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1863,6 +1863,7 @@ void account_system_vtime(struct task_st
 {
        unsigned long flags;
        s64 delta;
+       u64 now;
        int cpu;
 
        if (!sched_clock_irqtime)
@@ -1870,8 +1871,9 @@ void account_system_vtime(struct task_st
 
        local_irq_save(flags);
        cpu = smp_processor_id();
-       delta = sched_clock_cpu(cpu) - per_cpu(irq_start_time, cpu);
-       per_cpu(irq_start_time, cpu) += delta;
+       now = sched_clock_cpu(cpu);
+       delta = now - per_cpu(irq_start_time, cpu);
+       per_cpu(irq_start_time, cpu) = now;
 
        irq_time_write_begin(cpu);
 
On i386 (gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5):

Before: account_system_vtime: 160 bytes
After:  account_system_vtime: 214 bytes


