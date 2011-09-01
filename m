Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab1IATUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:20:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:35910 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757575Ab1IATUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:20:06 -0400
Date: Thu, 1 Sep 2011 21:20:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Liming Wang <liming.wang@windriver.com>
cc: rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mips/rt: convert cascade interrupt non threaded
In-Reply-To: <1314370804-21266-1-git-send-email-liming.wang@windriver.com>
Message-ID: <alpine.LFD.2.02.1109012115000.2723@ionos>
References: <1314370804-21266-1-git-send-email-liming.wang@windriver.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Liming Wang wrote:

> The preempt_rt kernel forces all irq interrupts to be threaded,
> but special interrupts can be excluded from this conversion.
> The cascade interrupt should be part of these exceptions.
> 
> In this case, irq2 is initialized before "kthreadd" task, which
> converts irq interrupt to threaded.
> 
> If this irq is threaded, the kernel calls "try_to_wake_up" function
> to wake up "kthreadd" task, but at that moment, "kthreadd" task
> has not been initialized and try_to_wake_up wakes up a NULL task.

That's not a reason to mark an interrupt NO_THREAD. The interrupt
handler could be non hardirq safe on RT. You'd run into other
problems.

In the case at hand it's the no_action handler which is hardirq safe
on RT and being no_action which means it simply returns IRQ_NONE.
I'll queue it for the next rt release and fixup the changelog myself.
 
Thanks,

	tglx


> Signed-off-by: Liming Wang <liming.wang@windriver.com>
> Signed-off-by: Bruce Ashfield <bruce.ashfield@windriver.com>
> ---
>  arch/mips/kernel/i8259.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/mips/kernel/i8259.c b/arch/mips/kernel/i8259.c
> index 5c74eb7..fb338db 100644
> --- a/arch/mips/kernel/i8259.c
> +++ b/arch/mips/kernel/i8259.c
> @@ -295,6 +295,7 @@ static void init_8259A(int auto_eoi)
>  static struct irqaction irq2 = {
>  	.handler = no_action,
>  	.name = "cascade",
> +	.flags = IRQF_NO_THREAD,
>  };
>  
>  static struct resource pic1_io_resource = {
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
