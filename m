Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab1EBN3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:29:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47091 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab1EBN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=t5Fok/7ZXKsU6lRmNMQgd0pQt/D3/tcNO9F72z/6u8f4vN0f0q7DYgfvN9Rg7gDDIm
         P0mEWtUs4jDxDZM4eYCw9o/zlZCMzj5I/KBo19Md/0ZKWw2I0gQn/PNaoroZUuNplwxU
         UqXYRjoLwFn41sW96zk5q/f/nGI9hrWWCWuxg=
Message-ID: <4DBEB1A8.3040202@gmail.com>
Date: Mon, 02 May 2011 08:29:12 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>
CC: linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
References: <20110502045207.24800.91172.stgit@ponder>	<20110502050800.24800.13738.stgit@ponder> <201105021039.32374.arnd@arndb.de>
In-Reply-To: <201105021039.32374.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2011 03:39 AM, Arnd Bergmann wrote:
> On Monday 02 May 2011 07:08:00 Grant Likely wrote:
>> The 1st board support is minimal to get a system up and running
>> on the Xilinx platform.
>>
>> This platform reuses the clock implementation from plat-versatile, and
>> it depends entirely on CONFIG_OF support.  There is only one board
>> support file which obtains all device information from a device tree
>> dtb file which is passed to the kernel at boot time.
>
> Very cool stuff!
>
>> +
>> +	amba {
>> +		compatible = "simple-bus";
>> +		#address-cells =<1>;
>> +		#size-cells =<1>;
>> +		ranges;
>
> Shouldn't we have a way to identify amba buses by the compatible property
> as well, rather than only declaring it simple-bus?
>
> We might be able to do some more automatic probing in the amba
> code in cases where the architected registers are actually filled
> with meaningful data there.
>

Typically, I don't think anything but ARM's Primecell peripherals have 
registers for probing. The GIC and PL310 don't have them.

However, this is what was used for an early version of the versatile dts:

compatible = "arm,amba-bus";

> Is the empty ranges property technically correct? Excuse my poor
> knowledge of amba, but I would have assumed that only a range
> of addresses is actually put on the bus, while others (e.g. RAM)
> are not visible on AMBA.
>
>> +static struct of_device_id zynq_of_bus_ids[] __initdata = {
>> +	{ .compatible = "simple-bus", },
>> +	{}
>> +};
>> +
>> +static struct of_device_id gic_match[] = {
>> +	{ .compatible = "arm,gic", },
>> +	{}
>> +};
>> +
>> +/**
>> + * xilinx_init_machine() - System specific initialization, intended to be
>> + *			   called from board specific initialization.
>> + */
>> +void __init xilinx_init_machine(void)
>> +{
>> +	struct device_node *node = of_find_matching_node(NULL, gic_match);
>> +
>> +	if (node)
>> +		of_irq_domain_add_simple(node, 0, NR_IRQS);
>> +
>> +#ifdef CONFIG_CACHE_L2X0
>> +	/*
>> +	 * 64KB way size, 8-way associativity, parity disabled
>> +	 */
>> +	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
>> +#endif
>> +
>> +/**
>> + * xilinx_irq_init() - Interrupt controller initialization for the GIC.
>> + */
>> +void __init xilinx_irq_init(void)
>> +{
>> +	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
>> +}
>
> I think we can do better than this, there is still more hardcoded stuff
> in here than I think should be. I understand that you tried to minimize
> the size of the patch set for obvious reasons, but none of this
> seems too board specific to put into common code in one way or another.
>
> Of course we can not fix all of this at once, but maybe we can have
> an explanation for each hardcoded setting on why it is still needed
> and what would have to be done to make it go away.

The SCU base address is probe-able:

	/* Get SCU base */
	asm("mrc p15, 4, %0, c15, c0, 0" : "=r" (base));

However, this is specific to the A9 and not an SCU feature.

>
>> +/* The minimum devices needed to be mapped before the VM system is up and
>> + * running include the GIC, UART and Timer Counter.
>> + */
>> +
>> +static struct map_desc io_desc[] __initdata = {
>> +	{
>> +		.virtual	= TTC0_VIRT,
>> +		.pfn		= __phys_to_pfn(TTC0_PHYS),
>> +		.length		= SZ_4K,
>> +		.type		= MT_DEVICE,
>> +	}, {
>> +		.virtual	= SCU_PERIPH_VIRT,
>> +		.pfn		= __phys_to_pfn(SCU_PERIPH_PHYS),
>> +		.length		= SZ_8K,
>> +		.type		= MT_DEVICE,
>> +	}, {
>> +		.virtual	= PL310_L2CC_VIRT,
>> +		.pfn		= __phys_to_pfn(PL310_L2CC_PHYS),
>> +		.length		= SZ_4K,
>> +		.type		= MT_DEVICE,
>> +	},
>
> I especially dislike the idea of having to set up iotables, these
> seem completely counterintuitive when we probe the devices from the
> device tree.
>
> AFAICT, all of init_irq, time_init and init_machine are called way after
> mm_init, so you should have ioremap available by the time you need to
> access these virtual memory ranges.
>

The SCU is accessed before ioremap is up. The only reason it is accessed 
early is to determine the number of cores present.

The L2 can certainly be ioremapped and probed via DT. How about 
something like this:

	l2cc {
		compatible = "arm,pl310-l2";
		reg = <0xfff12000 0x1000>;
		aux-value = <0>;
		aux-mask = <0xffffffff>;
	};

Rob
