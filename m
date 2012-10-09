Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab2JIUZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 16:25:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:40483 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2JIUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 16:25:41 -0400
Date: Tue, 9 Oct 2012 22:25:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Sankara Muthukrishnan <sankara.m@gmail.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] irq: Set CPU affinity as soon as the irq thread is
 created
In-Reply-To: <1346890155.27919.80.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1210092224480.10988@ionos>
References: <CAFQPvXckDMhH6MCkXC44wF0t13Ov=yQwER8GZgRRA4aq5=_w9w@mail.gmail.com> <1346890155.27919.80.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Sep 2012, Steven Rostedt wrote:

> On Wed, 2012-09-05 at 18:07 -0500, Sankara Muthukrishnan wrote:
> > Hi there,
> 
> This also affects mainline. Please Cc LKML (as I did).
> 
> > 
> > As irq_thread_check_affinity is called inside the while loop in the
> > IRQ thread, the core affinity is set only when an interrupt happens.
> > It does not seem to be a bad idea to set the core affinity soon after
> > the thread is created also (as shown in the patch).
> > irq_thread_check_affinity calls kmalloc_node that can sleep.
> 
> Note, it only calls kmalloc if you enable CONFIG_CPUMASK_OFFSTACK, which
> you probably don't on an embedded device. But you might. Your embedded
> device may have more than 32 or 64 CPUs.
> 
> I'd be more worried about calling set_cpus_allowed_ptr() than kmalloc().
> 
> >  In an
> > embedded target where IRQ affinities are pre-configured during
> > boot-time (and not modified through /proc/irq/../smp_affinity) during
> > run-time, the extra latency due to irq_thread_check_affinity can be
> > avoided during processing of the first interrupt with this patch.
> > Thoughts?

Yes, this needs a proper Signed-off-by and an update against current
mainline.

Thanks,

	tglx

> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index 87dc053..bf2cdc2 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -791,6 +791,7 @@ static int irq_thread(void *data)
> > 
> >         sched_setscheduler(current, SCHED_FIFO, &param);
> >         current->irqaction = action;
> > +       irq_thread_check_affinity(desc, action);
> > 
> >         while (!irq_wait_for_interrupt(action)) {
> 
> I see no problem with this patch.
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
