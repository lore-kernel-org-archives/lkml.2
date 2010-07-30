Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0G3Ka6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:30:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:59283 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725Ab0G3Ka0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:30:26 -0400
Subject: Re: [PATCH 3/4] powerpc: Use IRQF_NO_SUSPEND not IRQF_TIMER for
 non-timer interrupts
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1280398595-29708-3-git-send-email-ian.campbell@citrix.com>
References: <1280398573.24292.1684.camel@zakaz.uk.xensource.com>
	 <1280398595-29708-3-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Jul 2010 20:30:04 +1000
Message-ID: <1280485804.1902.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-29 at 11:16 +0100, Ian Campbell wrote:
> kw_i2c_irq and via_pmu_interrupt are not timer interrupts and
> therefore should not use IRQF_TIMER. Use the recently introduced
> IRQF_NO_SUSPEND instead since that is the actual desired behaviour.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linuxppc-dev@ozlabs.org
> Cc: devicetree-discuss@lists.ozlabs.org
> ---
>  arch/powerpc/platforms/powermac/low_i2c.c |    5 +++--
>  drivers/macintosh/via-pmu.c               |    9 +++++----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powermac/low_i2c.c b/arch/powerpc/platforms/powermac/low_i2c.c
> index 06a137c..480567e 100644
> --- a/arch/powerpc/platforms/powermac/low_i2c.c
> +++ b/arch/powerpc/platforms/powermac/low_i2c.c
> @@ -542,11 +542,12 @@ static struct pmac_i2c_host_kw *__init kw_i2c_host_init(struct device_node *np)
>  	/* Make sure IRQ is disabled */
>  	kw_write_reg(reg_ier, 0);
>  
> -	/* Request chip interrupt. We set IRQF_TIMER because we don't
> +	/* Request chip interrupt. We set IRQF_NO_SUSPEND because we don't
>  	 * want that interrupt disabled between the 2 passes of driver
>  	 * suspend or we'll have issues running the pfuncs
>  	 */
> -	if (request_irq(host->irq, kw_i2c_irq, IRQF_TIMER, "keywest i2c", host))
> +	if (request_irq(host->irq, kw_i2c_irq, IRQF_NO_SUSPEND,
> +			"keywest i2c", host))
>  		host->irq = NO_IRQ;
>  
>  	printk(KERN_INFO "KeyWest i2c @0x%08x irq %d %s\n",
> diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
> index 3d4fc0f..35bc273 100644
> --- a/drivers/macintosh/via-pmu.c
> +++ b/drivers/macintosh/via-pmu.c
> @@ -400,11 +400,12 @@ static int __init via_pmu_start(void)
>  		printk(KERN_ERR "via-pmu: can't map interrupt\n");
>  		return -ENODEV;
>  	}
> -	/* We set IRQF_TIMER because we don't want the interrupt to be disabled
> -	 * between the 2 passes of driver suspend, we control our own disabling
> -	 * for that one
> +	/* We set IRQF_NO_SUSPEND because we don't want the interrupt
> +	 * to be disabled between the 2 passes of driver suspend, we
> +	 * control our own disabling for that one
>  	 */
> -	if (request_irq(irq, via_pmu_interrupt, IRQF_TIMER, "VIA-PMU", (void *)0)) {
> +	if (request_irq(irq, via_pmu_interrupt, IRQF_NO_SUSPEND,
> +			"VIA-PMU", (void *)0)) {
>  		printk(KERN_ERR "via-pmu: can't request irq %d\n", irq);
>  		return -ENODEV;
>  	}


