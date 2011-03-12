Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1CLANT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 19:13:19 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62848 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1CLANS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 19:13:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6282"; a="79519720"
Message-ID: <4D7ABA9D.8070705@codeaurora.org>
Date: Fri, 11 Mar 2011 16:13:17 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6> <4D770E47.6050402@codeaurora.org> <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6> <4D79A85D.8000301@codeaurora.org> <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6> <4D7A71B9.9000306@codeaurora.org> <alpine.LFD.2.00.1103112020370.2787@localhost6.localdomain6> <4D7A80DD.7000909@codeaurora.org> <alpine.LFD.2.00.1103112112310.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103112112310.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> So I deduce, that your HW has no way to mark the wakeup
> interrupts. Whack your HW designer on my behalf, please! :)
> 
> Patch below against:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/core
> 
> It's 8 lines, but that's still at least an order of magnitude less
> than solving this with an workaround. :)
> 
> Thanks,
> 
> 	tglx
> 
> ---------->
> Subject: genirq-force-mask-on-suspend.patch
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Fri, 11 Mar 2011 21:22:14 +0100
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/irq.h |    2 ++
>  kernel/irq/pm.c     |   14 ++++++++++----
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6-tip/include/linux/irq.h
> ===================================================================
> --- linux-2.6-tip.orig/include/linux/irq.h
> +++ linux-2.6-tip/include/linux/irq.h
> @@ -330,10 +330,12 @@ struct irq_chip {
>   *
>   * IRQCHIP_SET_TYPE_MASKED:	Mask before calling chip.irq_set_type()
>   * IRQCHIP_EOI_IF_HANDLED:	Only issue irq_eoi() when irq was handled
> + * IRQCHIP_MASK_ON_SUSPEND:	Mask non wake irqs in the suspend path
>   */
>  enum {
>  	IRQCHIP_SET_TYPE_MASKED		= (1 <<  0),
>  	IRQCHIP_EOI_IF_HANDLED		= (1 <<  1),
> +	IRQCHIP_MASK_ON_SUSPEND		= (2 <<  1),
>  };
>  
>  /* This include will go away once we isolated irq_desc usage to core code */
> Index: linux-2.6-tip/kernel/irq/pm.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/irq/pm.c
> +++ linux-2.6-tip/kernel/irq/pm.c
> @@ -68,10 +68,16 @@ int check_wakeup_irqs(void)
>  	struct irq_desc *desc;
>  	int irq;
>  
> -	for_each_irq_desc(irq, desc)
> -		if (irqd_is_wakeup_set(&desc->irq_data) &&
> -		    (desc->istate & IRQS_PENDING))
> -			return -EBUSY;
> +	for_each_irq_desc(irq, desc) {
> +		if (irqd_is_wakeup_set(&desc->irq_data)) {
> +			if (desc->istate & IRQS_PENDING)
> +				return -EBUSY;
> +			continue;
> +		}
> +		if (desc->istate & IRQS_SUSPENDED &&
> +		    irq_desc_get_chip(desc)->flags & IRQCHIP_MASK_ON_SUSPEND)
> +			mask_irq(desc);
> +	}
>  
>  	return 0;
>  }

Awesome. This addresses the suspend/resume concerns. Thanks so much.
Reviewed-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

To avoid compile time issues, I will add
.flags = IRQCHIP_MASK_ON_SUSPEND
in my driver at a later time (after this change is pulled in).

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.
