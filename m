Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045Ab2IFAJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:09:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19519 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab2IFAJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:09:17 -0400
X-Authority-Analysis: v=2.0 cv=VPlfbqzX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wje3kBUXQ1MA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ixUyXuldT7wA:10 a=vHThFQwaQLspwHubk_AA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1346890155.27919.80.camel@gandalf.local.home>
Subject: Re: [PATCH RFC] irq: Set CPU affinity as soon as the irq thread is
 created
From: Steven Rostedt <rostedt@goodmis.org>
To: Sankara Muthukrishnan <sankara.m@gmail.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 05 Sep 2012 20:09:15 -0400
In-Reply-To: <CAFQPvXckDMhH6MCkXC44wF0t13Ov=yQwER8GZgRRA4aq5=_w9w@mail.gmail.com>
References: <CAFQPvXckDMhH6MCkXC44wF0t13Ov=yQwER8GZgRRA4aq5=_w9w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 18:07 -0500, Sankara Muthukrishnan wrote:
> Hi there,

This also affects mainline. Please Cc LKML (as I did).

> 
> As irq_thread_check_affinity is called inside the while loop in the
> IRQ thread, the core affinity is set only when an interrupt happens.
> It does not seem to be a bad idea to set the core affinity soon after
> the thread is created also (as shown in the patch).
> irq_thread_check_affinity calls kmalloc_node that can sleep.

Note, it only calls kmalloc if you enable CONFIG_CPUMASK_OFFSTACK, which
you probably don't on an embedded device. But you might. Your embedded
device may have more than 32 or 64 CPUs.

I'd be more worried about calling set_cpus_allowed_ptr() than kmalloc().

>  In an
> embedded target where IRQ affinities are pre-configured during
> boot-time (and not modified through /proc/irq/../smp_affinity) during
> run-time, the extra latency due to irq_thread_check_affinity can be
> avoided during processing of the first interrupt with this patch.
> Thoughts?
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 87dc053..bf2cdc2 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -791,6 +791,7 @@ static int irq_thread(void *data)
> 
>         sched_setscheduler(current, SCHED_FIFO, &param);
>         current->irqaction = action;
> +       irq_thread_check_affinity(desc, action);
> 
>         while (!irq_wait_for_interrupt(action)) {

I see no problem with this patch.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


