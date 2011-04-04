Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1DDQub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:50:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57416 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1DDQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:50:30 -0400
Date: Mon, 4 Apr 2011 17:50:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, glikely@secretlab.ca, jamie@jamieiles.com,
        arnd@arndb.de
Subject: Re: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
Message-ID: <20110404165011.GE22480@n2100.arm.linux.org.uk>
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com> <1301864418-12425-2-git-send-email-john.linn@xilinx.com> <5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 03, 2011 at 03:00:17PM -0600, John Linn wrote:
> +#include <linux/jiffies.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <asm/cacheflush.h>
> +#include <asm/smp_scu.h>
> +#include <mach/xilinx_soc.h>
> +#include <mach/smp.h>
> +#include "common.h"
> +
> +static void __iomem *scu_base = SCU_PERIPH_BASE;

You don't need this if its known at build time.

> +
> +static DEFINE_SPINLOCK(boot_lock);
> +
> +/* Secondary CPU kernel startup is a 2 phase process.
> + * 1st phase is transition from a boot loader to the kernel, but
> + * then wait not starting the kernel yet. 2nd phase starts the
> + * the kernel. In both phases, the secondary CPU waits for an
> + * event before it continues.
> + */
> +
> +void __cpuinit platform_secondary_init(unsigned int cpu)
> +{
> +	/*
> +	 * if any interrupts are already enabled for the primary
> +	 * core (e.g. timer irq), then they will not have been enabled
> +	 * for us: do so
> +	 */
> +	gic_secondary_init(0);
> +
> +	/*
> +	 * Synchronise with the boot thread.
> +	 */
> +	spin_lock(&boot_lock);
> +	spin_unlock(&boot_lock);
> +}
> +
> +int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +	unsigned long timeout;
> +
> +	/*
> +	 * set synchronisation state between this boot processor
> +	 * and the secondary one
> +	 */
> +	spin_lock(&boot_lock);
> +
> +	printk(KERN_INFO "Xilinx SMP: booting CPU1 now\n");

Aren't the messages which are already printed enough?

> +
> +	/*
> +	 * Update boot lock register with the boot key to allow the
> +	 * secondary processor to start the kernel after an SEV.
> +	 */
> +	__raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> +
> +	/* Flush the kernel cache to ensure that the page tables are
> +	 * available for the secondary CPU to use and make sure that
> +	 * the write buffer is drained before doing an SEV.
> +	 */
> +	flush_cache_all();
> +	smp_wmb();

The page tables and everything else required should already be visible
to the secondary CPU - if not that points to a bug in the generic code.
All that you should need to do here is to make sure your write above
is visible to the secondary CPU (and the address for it to boot from).

> +
> +	/*
> +	 * Send an event to wake the secondary core from WFE state.
> +	 */
> +	sev();
> +
> +	timeout = jiffies + (1 * HZ);
> +	while (time_before(jiffies, timeout))
> +		;

Have you no way to determine that the secondary CPU has started?

> +void __init smp_init_cpus(void)
> +{
> +	unsigned int i, ncores;
> +
> +	ncores = scu_base ? scu_get_core_count(scu_base) : 1;

	unsigned int i, ncores = scu_get_core_count(SCU_PERIPH_BASE);

> +
> +	/* sanity check */
> +	if (ncores > NR_CPUS) {
> +		printk(KERN_WARNING
> +		       "Realview: no. of cores (%d) greater than configured "
> +		       "maximum of %d - clipping\n",
> +		       ncores, NR_CPUS);
> +		ncores = NR_CPUS;
> +	}

Firstly, you're not Realview.  Secondly, I think this kind of check should
be inside scu_get_core_count() if it has to exist.

> +
> +	for (i = 0; i < ncores; i++)
> +		set_cpu_possible(i, true);
> +}
> +
> +void __init platform_smp_prepare_cpus(unsigned int max_cpus)
> +{
> +	int i;
> +
> +	/*
> +	 * Initialise the present map, which describes the set of CPUs
> +	 * actually populated at the present time.
> +	 */
> +	for (i = 0; i < max_cpus; i++)
> +		set_cpu_present(i, true);
> +
> +	scu_enable(scu_base);
> +
> +	/* Initialize the boot lock register to prevent CPU1 from
> +	   starting the kernel before CPU0 is ready for that.
> +	*/
> +	__raw_writel(0, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> +
> +	/*
> +	 * Write the address of secondary startup routine into the
> +	 * boot address. The secondary CPU will use this value
> +	 * to get into the kernel after it's awake from WFE state.
> +	 *
> +	 * Note the physical address is needed as the secondary CPU
> +	 * will not have the MMU on yet. A barrier is added to ensure
> +	 * that write buffer is drained.
> +	 */
> +	__raw_writel(virt_to_phys(xilinx_secondary_startup),
> +					OCM_HIGH_BASE + BOOT_ADDR_OFFSET);
> +	smp_wmb();
> +
> +	/*
> +	 * Send an event to wake the secondary core from WFE state.
> +	 */
> +	sev();

This looks like it shouldn't be necessary - you send an event in the
boot_secondary() path which should be enough to get the CPU going.
