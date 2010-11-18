Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0KRLPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:15:34 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33653 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0KRLPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:15:33 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6170"; a="63181451"
Date: Thu, 18 Nov 2010 16:45:27 +0530
From: Pavan Kondeti <pkondeti@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] msm: gpio: Add irq support to v2 gpiolib.
Message-ID: <20101118111527.GD11700@codeaurora.org>
References: <1289943516-11367-1-git-send-email-gbean@codeaurora.org> <1289943516-11367-2-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289943516-11367-2-git-send-email-gbean@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Nov 16, 2010 at 01:38:36PM -0800, Gregory Bean wrote:
> Complete the MSM v2 gpio subsystem by adding irq_chip.
> 
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---
>  arch/arm/mach-msm/gpio-v2.c |  344 ++++++++++++++++++++++++++++++++++++++++---
>  1 files changed, 326 insertions(+), 18 deletions(-)
> 
>  
> +#ifdef CONFIG_PM
> +static int msm_gpio_suspend_noirq(struct device *dev)
> +{
> +	unsigned long irq_flags;
> +	unsigned long i;
> +
> +	spin_lock_irqsave(&tlmm_lock, irq_flags);
> +	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
> +		if (!test_bit(i, msm_gpio.wake_irqs))
> +			writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(i));
> +	}
If none of the enabled irqs is configured as a wakeup source, should not we
disable the summary IRQ?
> +	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +	return 0;
> +}
> +
> +static int msm_gpio_resume_noirq(struct device *dev)
> +{
> +	unsigned long irq_flags;
> +	unsigned long i;
> +
> +	spin_lock_irqsave(&tlmm_lock, irq_flags);
> +	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS)
> +		writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(i));
> +	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
> +	return 0;
> +}
> +#else
> +#define msm_gpio_suspend_noirq NULL
> +#define msm_gpio_resume_noirq NULL
> +#endif
> +
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

