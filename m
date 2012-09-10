Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab2IJNnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:43:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:59799 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2IJNnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:43:35 -0400
Message-ID: <504DEE1D.3040704@windriver.com>
Date: Mon, 10 Sep 2012 09:41:49 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: <raghu.prabhu13@gmail.com>
CC: <jeremy@goop.org>, <mingo@redhat.com>, <x86@kernel.org>,
        Raghavendra D Prabhu <rprabhu@wnohang.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] IRQ: Add a check for uninitialized irqs.
References: <9250ef1afde6ddd2bab613bd847ad54adc014bac.1347218449.git.rprabhu@wnohang.net>
In-Reply-To: <9250ef1afde6ddd2bab613bd847ad54adc014bac.1347218449.git.rprabhu@wnohang.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-09-09 03:25 PM, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> Errors like "do_IRQ: 0.84 No Irq handler for vector (irq -1)" have been reported
> earlier filling up the console/logs. So this adds a condition to check for

Reported by who, and where, and on what hardware, and under what
circumstances?

You are adding another if statement to the hot path of do_IRQ just
to mask some random unknown symptom. instead of trying to understand
(and then solve) what the real breakage is.  Which is not the right
approach.

Paul.
--

> uninitialized irqs so that it exits early and doesn't proceed further. Also, irq
> is made a signed integer, since if it is not mapped to a vector, it will be
> assigned -1 which will be UINT_MAX otherwise.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  arch/x86/kernel/irq.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index d44f782..ddba63a 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -184,21 +184,24 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
>  
>  	/* high bit used in ret_from_ code  */
>  	unsigned vector = ~regs->orig_ax;
> -	unsigned irq;
> +	int irq;
>  
>  	irq_enter();
>  	exit_idle();
>  
> -	irq = __this_cpu_read(vector_irq[vector]);
> +	if (unlikely((irq = __this_cpu_read(vector_irq[vector])) == -1)) {
> +		pr_emerg_ratelimited("IRQ handler not setup for vector %u", vector);
> +		goto err_exit;
> +	}
>  
>  	if (!handle_irq(irq, regs)) {
>  		ack_APIC_irq();
>  
> -		if (printk_ratelimit())
> -			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
> -				__func__, smp_processor_id(), vector, irq);
> +		pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %u)\n",
> +			__func__, smp_processor_id(), vector, irq);
>  	}
>  
> +err_exit:
>  	irq_exit();
>  
>  	set_irq_regs(old_regs);
> 
