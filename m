Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935030Ab2JXOjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:39:35 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:49726 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934903Ab2JXOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:39:33 -0400
Message-ID: <5087FD91.1050803@free-electrons.com>
Date: Wed, 24 Oct 2012 16:39:13 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Jon Masters <jcm@redhat.com>, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com> <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com> <20121024142722.46c0f456@skate>
In-Reply-To: <20121024142722.46c0f456@skate>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 02:27 PM, Thomas Petazzoni wrote:
[...]
I will fixed the spelling and complete the comments as suggested

[...]

>> +struct dma_map_ops armada_xp_dma_ops;
> 
> static

OK

> 
>> +static inline void armada_xp_sync_io_barrier(void)
>> +{
>> +	writel(0x1, coherency_cpu_base + IO_SYNC_BARRIER_CTL_OFFSET);
>> +	while (readl(coherency_cpu_base + IO_SYNC_BARRIER_CTL_OFFSET) & 0x1);
>> +}
>> +
>> +dma_addr_t armada_xp_dma_map_page(struct device *dev, struct page *page,
>> +				  unsigned long offset, size_t size,
>> +				  enum dma_data_direction dir,
>> +				  struct dma_attrs *attrs)
>> +{
>> +	if (dir != DMA_TO_DEVICE)
>> +		armada_xp_sync_io_barrier();
>> +	return pfn_to_dma(dev, page_to_pfn(page)) + offset;
>> +}
>> +
>> +
>> +void armada_xp_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
>> +			      size_t size, enum dma_data_direction dir,
>> +			      struct dma_attrs *attrs)
>> +{
>> +	if (dir != DMA_TO_DEVICE)
>> +		armada_xp_sync_io_barrier();
>> +}
>> +
>> +void armada_xp_dma_sync(struct device *dev, dma_addr_t dma_handle,
>> +			size_t size, enum dma_data_direction dir)
>> +{
>> +	if (dir != DMA_TO_DEVICE)
>> +		armada_xp_sync_io_barrier();
>> +}
> 
> As others said, the prefix is wrong. Since the file is named coherency,
> maybe just "coherency_" as the prefix? Not sure, though. Shouldn't the
> file be named coherency-armada-370-xp.c, as we have done for the irq
> controller file? In that case, the armada_370_xp prefix would make
> sense

I would prefer to just use coherency_ everywhere and keep the name of
the file as is. It made sense to suffix the irq file with
armada-370-xp because the other mvebu SoCs have their own irq
controller. Whereas, as far as I know the coherency unit is only
present in the Armada 370/XP.

> 
>>  int armada_xp_get_cpu_count(void)
>>  {
>>  	int reg, cnt;
> 
> static?

Which function?
armada_xp_get_cpu_count and armada_370_xp_set_cpu_coherent are exported
and moreover are not part of this patch set but the SMP one.

> 
>> @@ -74,6 +115,42 @@ int armada_370_xp_set_cpu_coherent(unsigned int hw_cpu_id, int smp_group_id)
>>  	return 0;
>>  }
>>  
>> +static int armada_xp_platform_notifier(struct notifier_block *nb,
>> +				       unsigned long event, void *__dev)
>> +{
>> +	struct device *dev = __dev;
>> +
>> +	if (event != BUS_NOTIFY_ADD_DEVICE)
>> +		return NOTIFY_DONE;
>> +	set_dma_ops(dev, &armada_xp_dma_ops);
>> +
>> +	return NOTIFY_OK;
>> +}
>> +
>> +static struct notifier_block armada_xp_platform_nb = {
>> +	.notifier_call = armada_xp_platform_notifier,
>> +};
>> +
>> +void __init armada_370_xp_coherency_iocache_init(void)
>> +{
>> +	/* When the coherency fabric is available, the Armada XP and
>> +	 * Aramada 370 are close to a coherent architecture, so we based
>> +	 * our dma ops on the coherent one, and just changes the
>> +	 * operations which need a arch io sync */
>> +	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric")) {
>> +		struct dma_map_ops *dma_ops = &armada_xp_dma_ops;
>> +		memcpy(dma_ops, &arm_coherent_dma_ops, sizeof(*dma_ops));
>> +		dma_ops->map_page = armada_xp_dma_map_page;
>> +		dma_ops->unmap_page = armada_xp_dma_unmap_page;
>> +		dma_ops->unmap_sg = arm_dma_ops.unmap_sg;
>> +		dma_ops->sync_single_for_cpu = armada_xp_dma_sync;
>> +		dma_ops->sync_single_for_device = armada_xp_dma_sync;
>> +		dma_ops->sync_sg_for_cpu = arm_dma_ops.sync_sg_for_cpu;
>> +		dma_ops->sync_sg_for_device = arm_dma_ops.sync_sg_for_device;
>> +	}
>> +	bus_register_notifier(&platform_bus_type, &armada_xp_platform_nb);
> 
> As Arnd said, I would prefer a lot to have the armada_xp_dma_ops
> structure be initialized statically, even though it means that if the
> arm_coherent_dma_ops structure is changed, we'll have to update here as
> well. But I think it's cleaner.
> 
> Also, the bus notifier should be registered only if we have the
> coherency fabric, otherwise it is anyway going to be called, setting
> invalid DMA operations for all the platform devices.
> 
> So:
> 
> static dma_map_ops armada_370_xp_dma_ops = {
> 	...
> };
> 
> void __init armada_370_xp_coherency_iocache_init(void)
> {
> 	if (! of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric"))
> 		return;
> 
> 	bus_register_notifier(&platform_bus_type, &armada_370_xp_platform_nb);
> }

OK I agree

> 
>>  int __init armada_370_xp_coherency_init(void)
>>  {
>>  	struct device_node *np;
>> @@ -82,7 +159,17 @@ int __init armada_370_xp_coherency_init(void)
>>  	if (np) {
>>  		pr_info("Initializing Coherency fabric\n");
>>  		coherency_base = of_iomap(np, 0);
>> +		coherency_cpu_base = of_iomap(np, 1);
>> +	}
>> +#ifndef CONFIG_SMP
>> +	if (coherency_base) {
>> +		/* In UP case, cpu coherency is enabled here, in SMP case cpu
>> +		 * coherency is enabled for each CPU by
>> +		 * armada_xp_smp_prepare_cpus() in platsmp.c */
>> +		int hw_cpuid = cpu_logical_map(smp_processor_id());
>> +		armada_370_xp_set_cpu_coherent(hw_cpuid, 0);
>>  	}
>> +#endif
> 
> I really don't like this part of the code. First, the test is done on
> "coherency_base", while armada_370_xp_coherency_iocache_init() is
> checking the existence of the DT node to find if we have a coherency
> fabric or not. It should be consistent.

OK

> 
> Then, I don't see why the code patch for SMP and UP should be
> different. The code in platsmp.c:armada_xp_smp_prepare_cpus() only
> enables the coherency unit for the boot CPU. The other CPUs are
> enabling the mechanism in the assembly code in headsmp.S. In other
> words, I think you can remove the call to
> armada_370_xp_set_cpu_coherent() in armada_xp_smp_prepare_cpus(), and
> make the call unconditionally here in coherency.c for the boot CPU.
> 
> It seems like there is a better way to do this.

Yes indeed code in headsmp.S and armada_xp_smp_prepare_cpus() are
redundant we can simplify it. I will change it in the SMP series and
for this series also.

> 
>> diff --git a/arch/arm/mach-mvebu/common.h b/arch/arm/mach-mvebu/common.h
>> index 86484bb..fff952e 100644
>> --- a/arch/arm/mach-mvebu/common.h
>> +++ b/arch/arm/mach-mvebu/common.h
>> @@ -23,6 +23,8 @@ void armada_370_xp_handle_irq(struct pt_regs *regs);
>>  
>>  void armada_xp_cpu_die(unsigned int cpu);
>>  
>> +void armada_370_xp_coherency_iocache_init(void);
>> +
>>  int armada_370_xp_coherency_init(void);
>>  int armada_370_xp_pmsu_init(void);
>>  void armada_xp_secondary_startup(void);
> 
> Do we have a good reason for having
> armada_370_xp_coherency_iocache_init() separate from
> armada_370_xp_coherency_iocache_init() ? I.e, what prevents us from

No good reason because they are the same! ;)

But more seriously, armada_370_xp_coherency_init() is called as an
early_init call whereas armada_370_xp_coherency_iocache_init() is called
later by armada_370_xp_dt_init(). I have to check if we can use
bus_register_notifier() from an early_init call or if we still need to
call armada_370_xp_coherency_init() as an early_init call.

> registering the bus notifier directly in armada_370_xp_coherency_init()
> if the coherency unit is available?

Thanks,

Gregory
