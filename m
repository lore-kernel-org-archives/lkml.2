Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab1EBV1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:27:16 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:42941 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab1EBV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:27:15 -0400
Date: Mon, 2 May 2011 21:27:04 +0000 (UTC)
From: johnlinn@comcast.net
To: arnd@arndb.de
Cc: john.linn@xilinx.com, grant.likely@secretlab.ca, nicolas.pitre@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Message-ID: <538266033.2230575.1304371624720.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <1518608384.2203937.1304349657551.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [149.199.62.254]
X-Mailer: Zimbra 6.0.5_GA_2431.RHEL5_64 (ZimbraWebClient - IE8 (Win)/6.0.5_GA_2427.RHEL4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de] 
> Sent: Monday, May 02, 2011 2:40 AM
> To: linux-arm-kernel@lists.infradead.org
> Cc: grant.likely@secretlab.ca; Nicolas Pitre; Russell King;
> devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> John
> Linn
> Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
> 
> On Monday 02 May 2011 07:08:00 Grant Likely wrote:
> > The 1st board support is minimal to get a system up and running
> > on the Xilinx platform.
> > 
> > This platform reuses the clock implementation from plat-versatile,
> and
> > it depends entirely on CONFIG_OF support.  There is only one board
> > support file which obtains all device information from a device
> tree
> > dtb file which is passed to the kernel at boot time.
> 
> Very cool stuff!
> 
> > +
> > +	amba {
> > +		compatible = "simple-bus";
> > +		#address-cells = <1>;
> > +		#size-cells = <1>;
> > +		ranges;
> 
> Shouldn't we have a way to identify amba buses by the compatible
> property
> as well, rather than only declaring it simple-bus?
> 
> We might be able to do some more automatic probing in the amba
> code in cases where the architected registers are actually filled
> with meaningful data there.
> 
> Is the empty ranges property technically correct? Excuse my poor
> knowledge of amba, but I would have assumed that only a range
> of addresses is actually put on the bus, while others (e.g. RAM)
> are not visible on AMBA.
> 

Grant can comment on the ranges technical correctness, I see it other
places but that's doesn't mean it's right.

AFAIK, everything is visible from this bus including RAM.

> > +static struct of_device_id zynq_of_bus_ids[] __initdata = {
> > +	{ .compatible = "simple-bus", },
> > +	{}
> > +};
> > +
> > +static struct of_device_id gic_match[] = {
> > +	{ .compatible = "arm,gic", },
> > +	{}
> > +};
> > +
> > +/**
> > + * xilinx_init_machine() - System specific initialization,
> intended
> to be
> > + *			   called from board specific initialization.
> > + */
> > +void __init xilinx_init_machine(void)
> > +{
> > +	struct device_node *node = of_find_matching_node(NULL,
> gic_match);
> > +
> > +	if (node)
> > +		of_irq_domain_add_simple(node, 0, NR_IRQS);
> > +
> > +#ifdef CONFIG_CACHE_L2X0
> > +	/*
> > +	 * 64KB way size, 8-way associativity, parity disabled
> > +	 */
> > +	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
> > +#endif
> > +
> > +/**
> > + * xilinx_irq_init() - Interrupt controller initialization for the
> GIC.
> > + */
> > +void __init xilinx_irq_init(void)
> > +{
> > +	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
> > +}
> 
> I think we can do better than this, there is still more hardcoded
> stuff
> in here than I think should be. I understand that you tried to
> minimize
> the size of the patch set for obvious reasons, but none of this
> seems too board specific to put into common code in one way or
> another.
> 
> Of course we can not fix all of this at once, but maybe we can have
> an explanation for each hardcoded setting on why it is still needed
> and what would have to be done to make it go away.
> 

Yes we could explain hard coded numbers.  Ideally GIC driver would support
device tree it seems like to me.

> > +/* The minimum devices needed to be mapped before the VM system is
> up
> and
> > + * running include the GIC, UART and Timer Counter.
> > + */
> > +
> > +static struct map_desc io_desc[] __initdata = {
> > +	{
> > +		.virtual	= TTC0_VIRT,
> > +		.pfn		= __phys_to_pfn(TTC0_PHYS),
> > +		.length		= SZ_4K,
> > +		.type		= MT_DEVICE,
> > +	}, {
> > +		.virtual	= SCU_PERIPH_VIRT,
> > +		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
> > +		.length		= SZ_8K,
> > +		.type		= MT_DEVICE,
> > +	}, {
> > +		.virtual	= PL310_L2CC_VIRT,
> > +		.pfn		= __phys_to_pfn(PL310_L2CC_PHYS),
> > +		.length		= SZ_4K,
> > +		.type		= MT_DEVICE,
> > +	},
> 
> I especially dislike the idea of having to set up iotables, these
> seem completely counterintuitive when we probe the devices from the
> device tree.
> 
> AFAICT, all of init_irq, time_init and init_machine are called way
> after
> mm_init, so you should have ioremap available by the time you need to
> access these virtual memory ranges.
> 

Seems like the GIC driver could remap it's own memory but maybe that won't
work across all platforms and then the platform would need to do it.

Yes the timer driver could remap it's own memory.

> I can understand why you'd want to special-case PCI I/O space windows
> and early serial port access, but I think we should handle them
> differently
> and give them fixed machine independent virtual addresses.
> 
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/io.h
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/irqs.h
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/memory.h
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/system.h
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/timex.h
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/vmalloc.h
> 
> These are all either completely generic versions that could be reused
> on a number of other machines, or they could be turned into such
> files.
> 
> For the global inlude/asm-generic files, we have just added a
> mechanism
> to share that kind of file across multiple architectures using some
> Makefile magic. Should we perhaps do something similar here to avoid
> having to create more of the same files?
> 
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/uart.h
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/include/mach/uncompress.h
> 
> For these, it obviously won't work.
> 
> > diff --git a/arch/arm/mach-zynq/timer.c
> b/arch/arm/mach-zynq/timer.c
> > new file mode 100644
> > index 0000000..c2c96cc
> > --- /dev/null
> > +++ b/arch/arm/mach-zynq/timer.c
> 
> In the light of the recent discussions of drivers moving out of
> platforms into common Linux code, do we expect this to also
> happen to timers any time soon?

I'm not sure on the rest. Thanks Arnd, appreciate the help.

-- John

> 
> 	Arnd
> 
> 
> This email and any attachments are intended for the sole use of the
> named recipient(s) and contain(s) confidential information that may be
> proprietary, privileged or copyrighted under applicable law. If you
> are not the intended recipient, do not read, copy, or forward this
> email message or any attachments. Delete this email message and any
> attachments immediately.
