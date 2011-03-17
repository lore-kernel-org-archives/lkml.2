Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1CQIVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:21:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60821 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1CQIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:21:07 -0400
Date: Thu, 17 Mar 2011 09:21:06 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dinh.Nguyen@freescale.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, u.kleine-koenig@pengutronix.de,
        arnaud.patard@rtp-net.org, ra5478@freescale.com,
        xiao-lizhang@freescale.com, festevam@gmail.com
Subject: Re: [PATCHv3 3/3] ARM: mx51: Add support for low power suspend on
 MX51
Message-ID: <20110317082106.GT29521@pengutronix.de>
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1300305787-7970-3-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300305787-7970-3-git-send-email-Dinh.Nguyen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:19:43 up 28 days, 20:17, 27 users,  load average: 0.63, 0.39,
 0.20
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 03:03:07PM -0500, Dinh.Nguyen@freescale.com wrote:
> +
> +struct clk *gpc_dvfs_clk;
> +
> +static int mx5_suspend_enter(suspend_state_t state)
> +{
> +	if (gpc_dvfs_clk == NULL)
> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs_clk");

clk_get can fail and NULL can be a valid clock.

Sascha

> +
> +	clk_enable(gpc_dvfs_clk);
> +	switch (state) {
> +	case PM_SUSPEND_MEM:
> +		mx5_cpu_lp_set(STOP_POWER_OFF);
> +		break;
> +	case PM_SUSPEND_STANDBY:
> +		mx5_cpu_lp_set(WAIT_UNCLOCKED_POWER_OFF);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (state == PM_SUSPEND_MEM) {
> +		local_flush_tlb_all();
> +		flush_cache_all();
> +
> +		/*clear the EMPGC0/1 bits */
> +		__raw_writel(0, MXC_SRPG_EMPGC0_SRPGCR);
> +		__raw_writel(0, MXC_SRPG_EMPGC1_SRPGCR);
> +	}
> +	cpu_do_idle();
> +	clk_disable(gpc_dvfs_clk);
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
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
