Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1DDRLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:11:25 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:18690
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab1DDRLY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:11:24 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz9371P542N1432N98dK12b6izz1202hzzz2dh95h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
Date: Mon, 4 Apr 2011 11:11:10 -0600
In-Reply-To: <20110404165011.GE22480@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
Thread-Index: Acvy6GWxkC0muZmBRPmepDtDMOEcbgAADG7w
References: <1301864418-12425-1-git-send-email-john.linn@xilinx.com> <1301864418-12425-2-git-send-email-john.linn@xilinx.com> <5ad00b91-47d8-4f02-aa72-5a413957cdb5@VA3EHSMHS005.ehs.local> <20110404165011.GE22480@n2100.arm.linux.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <catalin.marinas@arm.com>, <glikely@secretlab.ca>,
        <jamie@jamieiles.com>, <arnd@arndb.de>
X-OriginalArrivalTime: 04 Apr 2011 17:11:18.0127 (UTC) FILETIME=[4FDC5FF0:01CBF2EB]
X-RCIS-Action: ALLOW
Message-ID: <636cc632-4dae-477a-9092-24c0d8431cb8@VA3EHSMHS032.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Monday, April 04, 2011 10:50 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org;
> catalin.marinas@arm.com; glikely@secretlab.ca; jamie@jamieiles.com;
> arnd@arndb.de
> Subject: Re: [PATCH 2/3] ARM: Xilinx: add SMP specific support files
> 
> On Sun, Apr 03, 2011 at 03:00:17PM -0600, John Linn wrote:
> > +#include <linux/jiffies.h>
> > +#include <linux/init.h>
> > +#include <linux/io.h>
> > +#include <asm/cacheflush.h>
> > +#include <asm/smp_scu.h>
> > +#include <mach/xilinx_soc.h>
> > +#include <mach/smp.h>
> > +#include "common.h"
> > +
> > +static void __iomem *scu_base = SCU_PERIPH_BASE;
> 
> You don't need this if its known at build time.

Ok.

> 
> > +
> > +static DEFINE_SPINLOCK(boot_lock);
> > +
> > +/* Secondary CPU kernel startup is a 2 phase process.
> > + * 1st phase is transition from a boot loader to the kernel, but
> > + * then wait not starting the kernel yet. 2nd phase starts the
> > + * the kernel. In both phases, the secondary CPU waits for an
> > + * event before it continues.
> > + */
> > +
> > +void __cpuinit platform_secondary_init(unsigned int cpu)
> > +{
> > +	/*
> > +	 * if any interrupts are already enabled for the primary
> > +	 * core (e.g. timer irq), then they will not have been enabled
> > +	 * for us: do so
> > +	 */
> > +	gic_secondary_init(0);
> > +
> > +	/*
> > +	 * Synchronise with the boot thread.
> > +	 */
> > +	spin_lock(&boot_lock);
> > +	spin_unlock(&boot_lock);
> > +}
> > +
> > +int __cpuinit boot_secondary(unsigned int cpu, struct task_struct
> *idle)
> > +{
> > +	unsigned long timeout;
> > +
> > +	/*
> > +	 * set synchronisation state between this boot processor
> > +	 * and the secondary one
> > +	 */
> > +	spin_lock(&boot_lock);
> > +
> > +	printk(KERN_INFO "Xilinx SMP: booting CPU1 now\n");
> 
> Aren't the messages which are already printed enough?

This was helpful, but can be deleted too, not a big deal.

> 
> > +
> > +	/*
> > +	 * Update boot lock register with the boot key to allow the
> > +	 * secondary processor to start the kernel after an SEV.
> > +	 */
> > +	__raw_writel(BOOT_LOCK_KEY, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> > +
> > +	/* Flush the kernel cache to ensure that the page tables are
> > +	 * available for the secondary CPU to use and make sure that
> > +	 * the write buffer is drained before doing an SEV.
> > +	 */
> > +	flush_cache_all();
> > +	smp_wmb();
> 
> The page tables and everything else required should already be visible
> to the secondary CPU - if not that points to a bug in the generic
code.
> All that you should need to do here is to make sure your write above
> is visible to the secondary CPU (and the address for it to boot from).

I didn't have the flush in early during debug and found it was needed.
I haven't tried it for quite some time without, I'll give it a try as
maybe some generic code was updated to fix a problem since then.

I noticed it in other platforms was the reason I thought it was really
needed.

> 
> > +
> > +	/*
> > +	 * Send an event to wake the secondary core from WFE state.
> > +	 */
> > +	sev();
> > +
> > +	timeout = jiffies + (1 * HZ);
> > +	while (time_before(jiffies, timeout))
> > +		;
> 
> Have you no way to determine that the secondary CPU has started?

Not right now. I can look at the ability to handshake back so that 
it's not based on time.  I'll to see what some other platforms do with
that.

I can see that it would help boot time not to do it this way.

It was based it off of some platforms doing it like this and it may 
not have been the best pattern to use.

> 
> > +void __init smp_init_cpus(void)
> > +{
> > +	unsigned int i, ncores;
> > +
> > +	ncores = scu_base ? scu_get_core_count(scu_base) : 1;
> 
> 	unsigned int i, ncores = scu_get_core_count(SCU_PERIPH_BASE);
> 
> > +
> > +	/* sanity check */
> > +	if (ncores > NR_CPUS) {
> > +		printk(KERN_WARNING
> > +		       "Realview: no. of cores (%d) greater than
configured
> "
> > +		       "maximum of %d - clipping\n",
> > +		       ncores, NR_CPUS);
> > +		ncores = NR_CPUS;
> > +	}
> 
> Firstly, you're not Realview.  Secondly, I think this kind of check
> should
> be inside scu_get_core_count() if it has to exist.
> 

I should have caught that. Ok it can be moved inside.  

The NR_CPUS thing is not real clear to me so I'll have to investigate
more as we 
only have 2 CPUs, yet the default in the kernel configs is generally 4. 

I know there has been a big deal about defconfigs so I was trying not to
add more
problems by adding one for Xilinx platform, but maybe I have
misunderstood that issue.

> > +
> > +	for (i = 0; i < ncores; i++)
> > +		set_cpu_possible(i, true);
> > +}
> > +
> > +void __init platform_smp_prepare_cpus(unsigned int max_cpus)
> > +{
> > +	int i;
> > +
> > +	/*
> > +	 * Initialise the present map, which describes the set of CPUs
> > +	 * actually populated at the present time.
> > +	 */
> > +	for (i = 0; i < max_cpus; i++)
> > +		set_cpu_present(i, true);
> > +
> > +	scu_enable(scu_base);
> > +
> > +	/* Initialize the boot lock register to prevent CPU1 from
> > +	   starting the kernel before CPU0 is ready for that.
> > +	*/
> > +	__raw_writel(0, OCM_HIGH_BASE + BOOT_LOCK_OFFSET);
> > +
> > +	/*
> > +	 * Write the address of secondary startup routine into the
> > +	 * boot address. The secondary CPU will use this value
> > +	 * to get into the kernel after it's awake from WFE state.
> > +	 *
> > +	 * Note the physical address is needed as the secondary CPU
> > +	 * will not have the MMU on yet. A barrier is added to ensure
> > +	 * that write buffer is drained.
> > +	 */
> > +	__raw_writel(virt_to_phys(xilinx_secondary_startup),
> > +					OCM_HIGH_BASE +
BOOT_ADDR_OFFSET);
> > +	smp_wmb();
> > +
> > +	/*
> > +	 * Send an event to wake the secondary core from WFE state.
> > +	 */
> > +	sev();
> 
> This looks like it shouldn't be necessary - you send an event in the
> boot_secondary() path which should be enough to get the CPU going.

It's a 2 stage process, the 1st SEV gets the 2nd CPU out of the boot rom
and into the kernel, the 2nd SEV lets it start running the kernel.

At some point this was based on a similar pattern that I saw in other
platforms.

Thanks for your time and input,
John

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


