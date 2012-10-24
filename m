Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2JXIRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 04:17:12 -0400
Received: from galiil.marvell.com ([199.203.130.254]:2692 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2JXIRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 04:17:05 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 04:17:04 EDT
From: Yehuda Yitschak <yehuday@marvell.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 10:11:34 +0200
Subject: RE: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
Thread-Topic: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
Thread-Index: Ac2xvjfLLS+DDbieT1OoVnu+bUOBCgAAJZ2A
Message-ID: <2E2747FC8980BB40958FB06A958ED3550144C25FAD4F@IL-MB01.marvell.com>
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com>
 <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1351065841-18654-3-git-send-email-gregory.clement@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Gregory CLEMENT [mailto:gregory.clement@free-electrons.com]
> Sent: Wednesday, October 24, 2012 10:04 AM
> To: Jason Cooper; Andrew Lunn; Gregory Clement
> Cc: linux-arm-kernel@lists.infradead.org; Arnd Bergmann; Olof Johansson;
> Russell King; Rob Herring; Ben Dooks; Ian Molton; Nicolas Pitre; Lior
> Amsalem; Maen Suleiman; Tawfik Bayouk; Shadi Ammouri; Eran Ben-Avi;
> Yehuda Yitschak; Nadav Haklai; Ike Pan; Jani Monoses; Chris Van Hoof; Dan
> Frazier; Thomas Petazzoni; Leif Lindholm; Jon Masters; David Marlin;
> Sebastian Hesselbarth; linux-kernel@vger.kernel.org
> Subject: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
> 
> Armada 370 and XP come with an unit called coherency fabric. This unit
> allows to use the Armada XP as a nearly coherent architecture. The
> coherency mechanism uses snoop filters to ensure the coherency between
> caches, DRAM and devices. This mechanism needs a synchronization barrier
> which guarantees that all memory write initiated by the devices has
> reached their target and do not reside in intermediate write buffers. That's
> why the architecture is not totally coherent and we need to provide our
> own functions for some DMA operations.
> 
> Beside the use of the coherency fabric, the device units will have to set the
> attribute flag to select the accurate coherency process for the memory
> transaction. This is done each device driver programs the DRAM address
> windows. The value of the attribute set by the driver is retrieved through
> the orion_addr_map_cfg struct filled during the early initialization of the
> platform.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Reviewed-by: Yehuda Yitschak <yehuday@marvell.com>
> ---
>  arch/arm/boot/dts/armada-370-xp.dtsi |    3 +-
>  arch/arm/mach-mvebu/addr-map.c       |    3 ++
>  arch/arm/mach-mvebu/armada-370-xp.c  |    1 +
>  arch/arm/mach-mvebu/coherency.c      |   87
> ++++++++++++++++++++++++++++++++++
>  arch/arm/mach-mvebu/common.h         |    2 +
>  5 files changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi
> b/arch/arm/boot/dts/armada-370-xp.dtsi
> index 18ba60b..af22e53 100644
> --- a/arch/arm/boot/dts/armada-370-xp.dtsi
> +++ b/arch/arm/boot/dts/armada-370-xp.dtsi
> @@ -38,7 +38,8 @@
> 
>  	coherency-fabric@d0020200 {
>  		compatible = "marvell,coherency-fabric";
> -		reg = <0xd0020200 0xb0>;
> +		reg = <0xd0020200 0xb0>,
> +		      <0xd0021010 0x1c>;
>  	};
> 
>  	soc {
> diff --git a/arch/arm/mach-mvebu/addr-map.c b/arch/arm/mach-
> mvebu/addr-map.c index fe454a4..595f6b7 100644
> --- a/arch/arm/mach-mvebu/addr-map.c
> +++ b/arch/arm/mach-mvebu/addr-map.c
> @@ -108,6 +108,9 @@ static int __init armada_setup_cpu_mbus(void)
> 
>  	addr_map_cfg.bridge_virt_base = mbus_unit_addr_decoding_base;
> 
> +	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-
> fabric"))
> +		addr_map_cfg.hw_io_coherency = 1;
> +
>  	/*
>  	 * Disable, clear and configure windows.
>  	 */
> diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-
> mvebu/armada-370-xp.c
> index 41431a1..3517f7d 100644
> --- a/arch/arm/mach-mvebu/armada-370-xp.c
> +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> @@ -49,6 +49,7 @@ struct sys_timer armada_370_xp_timer = {
> 
>  static void __init armada_370_xp_dt_init(void)  {
> +	armada_370_xp_coherency_iocache_init();
>  	of_platform_populate(NULL, of_default_bus_match_table, NULL,
> NULL);  }
> 
> diff --git a/arch/arm/mach-mvebu/coherency.c b/arch/arm/mach-
> mvebu/coherency.c index 71e27ba..a596ca9 100644
> --- a/arch/arm/mach-mvebu/coherency.c
> +++ b/arch/arm/mach-mvebu/coherency.c
> @@ -22,6 +22,10 @@
>  #include <linux/of_address.h>
>  #include <linux/io.h>
>  #include <linux/smp.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <asm/smp_plat.h>
> +
>  #include "armada-370-xp.h"
> 
>  /* Some functions in this file are called very early during SMP @@ -31,16
> +35,53 @@
>   * value matching its virtual mapping
>   */
>  static void __iomem *coherency_base = ARMADA_370_XP_REGS_VIRT_BASE
> + 0x20200;
> +static void __iomem *coherency_cpu_base;
> +
> +struct dma_map_ops armada_xp_dma_ops;
> 
>  /* Coherency fabric registers */
>  #define COHERENCY_FABRIC_CTL_OFFSET		   0x0
>  #define COHERENCY_FABRIC_CFG_OFFSET		   0x4
> 
> +#define IO_SYNC_BARRIER_CTL_OFFSET		   0x0
> +
>  static struct of_device_id of_coherency_table[] = {
>  	{.compatible = "marvell,coherency-fabric"},
>  	{ /* end of list */ },
>  };
> 
> +static inline void armada_xp_sync_io_barrier(void) {
> +	writel(0x1, coherency_cpu_base + IO_SYNC_BARRIER_CTL_OFFSET);
> +	while (readl(coherency_cpu_base + IO_SYNC_BARRIER_CTL_OFFSET)
> & 0x1);
> +}
> +
> +dma_addr_t armada_xp_dma_map_page(struct device *dev, struct page
> *page,
> +				  unsigned long offset, size_t size,
> +				  enum dma_data_direction dir,
> +				  struct dma_attrs *attrs)
> +{
> +	if (dir != DMA_TO_DEVICE)
> +		armada_xp_sync_io_barrier();
> +	return pfn_to_dma(dev, page_to_pfn(page)) + offset; }
> +
> +
> +void armada_xp_dma_unmap_page(struct device *dev, dma_addr_t
> dma_handle,
> +			      size_t size, enum dma_data_direction dir,
> +			      struct dma_attrs *attrs)
> +{
> +	if (dir != DMA_TO_DEVICE)
> +		armada_xp_sync_io_barrier();
> +}
> +
> +void armada_xp_dma_sync(struct device *dev, dma_addr_t dma_handle,
> +			size_t size, enum dma_data_direction dir) {
> +	if (dir != DMA_TO_DEVICE)
> +		armada_xp_sync_io_barrier();
> +}
> +

Shouldn't all the 4 functions above start with armada_370_xp and not armada_xp ? 


>  int armada_xp_get_cpu_count(void)

This function can be limited to CONFIG_SP

>  {
>  	int reg, cnt;
> @@ -74,6 +115,42 @@ int armada_370_xp_set_cpu_coherent(unsigned int
> hw_cpu_id, int smp_group_id)
>  	return 0;
>  }
> 
> +static int armada_xp_platform_notifier(struct notifier_block *nb,
> +				       unsigned long event, void *__dev) {
> +	struct device *dev = __dev;
> +
> +	if (event != BUS_NOTIFY_ADD_DEVICE)
> +		return NOTIFY_DONE;
> +	set_dma_ops(dev, &armada_xp_dma_ops);
> +
> +	return NOTIFY_OK;
> +}
> +
> +static struct notifier_block armada_xp_platform_nb = {
> +	.notifier_call = armada_xp_platform_notifier, };
> +
> +void __init armada_370_xp_coherency_iocache_init(void)
> +{
> +	/* When the coherency fabric is available, the Armada XP and
> +	 * Aramada 370 are close to a coherent architecture, so we based
> +	 * our dma ops on the coherent one, and just changes the
> +	 * operations which need a arch io sync */
> +	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-
> fabric")) {
> +		struct dma_map_ops *dma_ops = &armada_xp_dma_ops;
> +		memcpy(dma_ops, &arm_coherent_dma_ops,
> sizeof(*dma_ops));
> +		dma_ops->map_page = armada_xp_dma_map_page;
> +		dma_ops->unmap_page = armada_xp_dma_unmap_page;
> +		dma_ops->unmap_sg = arm_dma_ops.unmap_sg;
> +		dma_ops->sync_single_for_cpu = armada_xp_dma_sync;
> +		dma_ops->sync_single_for_device = armada_xp_dma_sync;
> +		dma_ops->sync_sg_for_cpu =
> arm_dma_ops.sync_sg_for_cpu;
> +		dma_ops->sync_sg_for_device =
> arm_dma_ops.sync_sg_for_device;
> +	}
> +	bus_register_notifier(&platform_bus_type,
> &armada_xp_platform_nb); }
> +
>  int __init armada_370_xp_coherency_init(void)
>  {
>  	struct device_node *np;
> @@ -82,7 +159,17 @@ int __init armada_370_xp_coherency_init(void)
>  	if (np) {
>  		pr_info("Initializing Coherency fabric\n");
>  		coherency_base = of_iomap(np, 0);
> +		coherency_cpu_base = of_iomap(np, 1);
> +	}
> +#ifndef CONFIG_SMP
> +	if (coherency_base) {
> +		/* In UP case, cpu coherency is enabled here, in SMP case
> cpu
> +		 * coherency is enabled for each CPU by
> +		 * armada_xp_smp_prepare_cpus() in platsmp.c */
> +		int hw_cpuid = cpu_logical_map(smp_processor_id());
> +		armada_370_xp_set_cpu_coherent(hw_cpuid, 0);
>  	}
> +#endif
> 
>  	return 0;
>  }
> diff --git a/arch/arm/mach-mvebu/common.h b/arch/arm/mach-
> mvebu/common.h index 86484bb..fff952e 100644
> --- a/arch/arm/mach-mvebu/common.h
> +++ b/arch/arm/mach-mvebu/common.h
> @@ -23,6 +23,8 @@ void armada_370_xp_handle_irq(struct pt_regs *regs);
> 
>  void armada_xp_cpu_die(unsigned int cpu);
> 
> +void armada_370_xp_coherency_iocache_init(void);
> +
>  int armada_370_xp_coherency_init(void);
>  int armada_370_xp_pmsu_init(void);
>  void armada_xp_secondary_startup(void);
> --
> 1.7.9.5

