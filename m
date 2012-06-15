Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab2FOMSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:18:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:40676 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2FOMSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:18:02 -0400
Date: Fri, 15 Jun 2012 14:18:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ning Jiang <ning.n.jiang@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] genirq: Resend nested irq's ancestor irq
In-Reply-To: <CAH3Oq6R_z1jQ9GPwHJ8yfZUK0mZyK8vwpKsWDBXDTpfOpe4o1w@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1206151159340.3086@ionos>
References: <1339662697-4600-1-git-send-email-ning.n.jiang@gmail.com> <1339662697-4600-2-git-send-email-ning.n.jiang@gmail.com> <alpine.LFD.2.02.1206141221360.3086@ionos> <CAH3Oq6R_z1jQ9GPwHJ8yfZUK0mZyK8vwpKsWDBXDTpfOpe4o1w@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012, Ning Jiang wrote:
> 2012/6/14 Thomas Gleixner <tglx@linutronix.de>:
> > The correct solution for this is to replace the tasklet with a kernel
> > thread and check whether the interrupt is marked nested or not and
> > then invoke the correct function.
> >
> 
> Do you want something like this?

Definitely not.

> This just gives a rough idea. Please help to review.

It's a very bad idea.

>  #ifdef CONFIG_HARDIRQS_SW_RESEND
> -			/* Set it pending and activate the softirq: */
> -			set_bit(irq, irqs_resend);
> -			tasklet_schedule(&resend_tasklet);
> +			struct task_struct *t;
> +			if (irq_settings_is_nested_thread(desc)) {
> +				raw_spin_unlock(&desc->lock);
> +				t = kthread_create(irq_thread, desc->action,
> +					"irq/%d-%s", irq, desc->action->name);

Did you even try to run that code?

You CANNOT call kthread_create() with interrupts disabled and you
CANNOT expect that the state of the irq desc is unchanged when you
drop the lock.

And even if this would work it would be fricking insane to create a
kernel thread every time we resend an interrupt. Not to talk about the
exit madness you decided to stick into the existing thread function.

Either we have a kthread set up explicitely for that and just have to
wake it up or if we can deal with the possible latency just hand it
off to workqueue context.

Thanks,

	tglx
