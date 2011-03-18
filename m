Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883Ab1CRPZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:25:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1CRPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:25:13 -0400
Date: Fri, 18 Mar 2011 15:25:02 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv4 3/3] ARM: mx51: Add support for low power suspend on
	MX51
Message-ID: <20110318152502.GO29758@n2100.arm.linux.org.uk>
References: <1300461684-21775-1-git-send-email-Dinh.Nguyen@freescale.com> <1300461684-21775-2-git-send-email-Dinh.Nguyen@freescale.com> <1300461684-21775-3-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300461684-21775-3-git-send-email-Dinh.Nguyen@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 10:21:24AM -0500, Dinh.Nguyen@freescale.com wrote:
> +#include <linux/suspend.h>
> +#include <linux/clk.h>
> +#include <asm/mach/map.h>
> +#include <asm/cacheflush.h>
> +#include <asm/tlb.h>
> +#include <mach/system.h>
> +#include "crm_regs.h"

Why does the code below require asm/mach/map.h ?
Why does it require asm/tlb.h ?

> +
> +static struct clk *gpc_dvfs_clk;
> +
> +static int mx5_suspend_enter(suspend_state_t state)
> +{
> +	if (gpc_dvfs_clk == NULL)
> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs");
> +
> +	if (gpc_dvfs_clk) {
> +		clk_enable(gpc_dvfs_clk);
> +		switch (state) {
> +		case PM_SUSPEND_MEM:
> +			mx5_cpu_lp_set(STOP_POWER_OFF);
> +			break;
> +		case PM_SUSPEND_STANDBY:
> +			mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> +			break;
> +		default:
> +			return -EINVAL;
> +		}
> +
> +		if (state == PM_SUSPEND_MEM) {
> +			local_flush_tlb_all();
> +			flush_cache_all();
> +
> +			/*clear the EMPGC0/1 bits */
> +			__raw_writel(0, MXC_SRPG_EMPGC0_SRPGCR);
> +			__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
> +		}
> +		cpu_do_idle();
> +		clk_disable(gpc_dvfs_clk);
> +	}else {
> +		printk(KERN_ERR "Cannot enter SRPG suspend -no gpc_dvfs clock!\n");
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mx5_pm_valid(suspend_state_t state)
> +{
> +	return (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX);
> +}
> +
> +static const struct platform_suspend_ops mx5_suspend_ops = {
> +	.valid = mx5_pm_valid,
> +	.enter = mx5_suspend_enter,
> +};
> +
> +static int __init mx5_pm_init(void)
> +{
> +	if (cpu_is_mx51())
> +		suspend_set_ops(&mx5_suspend_ops);
> +
> +	return 0;
> +}
> +device_initcall(mx5_pm_init);
> -- 
> 1.6.0.4
> 
> 
