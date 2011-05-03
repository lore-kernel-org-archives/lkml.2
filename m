Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1ECCJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 22:09:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:33003 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab1ECCJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 22:09:42 -0400
Subject: Re: [PATCH 3/6] powerpc: Make struct irq_host semi-private by
 moving into irqhost.h
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        hpa@zytor.com, Dirk Brandewie <dirk.brandewie@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20110428200158.8979.39548.stgit@ponder>
References: <20110428192227.8979.49181.stgit@ponder>
	 <20110428200158.8979.39548.stgit@ponder>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 11:48:40 +1000
Message-ID: <1304387320.2513.299.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 14:01 -0600, Grant Likely wrote:
> Very few files actually need direct access to struct irq_host members.
> This patch moves the irq_host definition into another file so that it
> isn't brought in by default, and to prepare for the addition of
> struct of_irq_domain, which will factor some of the irq_host behaviour
> out into common code.  This needs to be done because of_irq_domain
> will be embedded inside struct irq_host, and to do that it needs to be
> guaranteed that struct of_irq_domain gets fully defined first.

Why do you want to separate the irq "host" as used by powerpc with the
generic irq domain ? They should be one single thing...

Cheers,
Ben.

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/powerpc/include/asm/irq.h                   |   20 +--------------
>  arch/powerpc/include/asm/irqhost.h               |   29 ++++++++++++++++++++++
>  arch/powerpc/kernel/irq.c                        |    1 +
>  arch/powerpc/platforms/512x/mpc5121_ads_cpld.c   |    1 +
>  arch/powerpc/platforms/52xx/media5200.c          |    1 +
>  arch/powerpc/platforms/52xx/mpc52xx_gpt.c        |    1 +
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |    1 +
>  arch/powerpc/platforms/82xx/pq2ads-pci-pic.c     |    1 +
>  arch/powerpc/platforms/cell/axon_msi.c           |    1 +
>  arch/powerpc/platforms/cell/spider-pic.c         |    1 +
>  arch/powerpc/platforms/embedded6xx/flipper-pic.c |    1 +
>  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |    1 +
>  arch/powerpc/platforms/embedded6xx/wii.c         |    6 +++--
>  arch/powerpc/sysdev/fsl_msi.c                    |    1 +
>  arch/powerpc/sysdev/i8259.c                      |    1 +
>  arch/powerpc/sysdev/ipic.c                       |    1 +
>  arch/powerpc/sysdev/mpc8xxx_gpio.c               |    1 +
>  arch/powerpc/sysdev/mpic.c                       |    1 +
>  arch/powerpc/sysdev/mpic_msi.c                   |    1 +
>  arch/powerpc/sysdev/mpic_pasemi_msi.c            |    1 +
>  arch/powerpc/sysdev/qe_lib/qe_ic.c               |    1 +
>  arch/powerpc/sysdev/uic.c                        |    1 +
>  arch/powerpc/sysdev/xilinx_intc.c                |    1 +
>  23 files changed, 54 insertions(+), 21 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/irqhost.h
> 
> diff --git a/arch/powerpc/include/asm/irq.h b/arch/powerpc/include/asm/irq.h
> index 4d2cc6f..a44be93 100644
> --- a/arch/powerpc/include/asm/irq.h
> +++ b/arch/powerpc/include/asm/irq.h
> @@ -104,29 +104,11 @@ struct irq_host_ops {
>  		     irq_hw_number_t *out_hwirq, unsigned int *out_type);
>  };
>  
> -struct irq_host {
> -	struct list_head	link;
> -
> -	/* type of reverse mapping technique */
> -	unsigned int		revmap_type;
> +/* Reverse map types; pass into irq_alloc_host revmap_type argument */
>  #define IRQ_HOST_MAP_LEGACY     0 /* legacy 8259, gets irqs 1..15 */
>  #define IRQ_HOST_MAP_NOMAP	1 /* no fast reverse mapping */
>  #define IRQ_HOST_MAP_LINEAR	2 /* linear map of interrupts */
>  #define IRQ_HOST_MAP_TREE	3 /* radix tree */
> -	union {
> -		struct {
> -			unsigned int size;
> -			unsigned int *revmap;
> -		} linear;
> -		struct radix_tree_root tree;
> -	} revmap_data;
> -	struct irq_host_ops	*ops;
> -	void			*host_data;
> -	irq_hw_number_t		inval_irq;
> -
> -	/* Optional device node pointer */
> -	struct device_node	*of_node;
> -};
>  
>  struct irq_data;
>  extern irq_hw_number_t irqd_to_hwirq(struct irq_data *d);
> diff --git a/arch/powerpc/include/asm/irqhost.h b/arch/powerpc/include/asm/irqhost.h
> new file mode 100644
> index 0000000..958e6c1
> --- /dev/null
> +++ b/arch/powerpc/include/asm/irqhost.h
> @@ -0,0 +1,29 @@
> +#ifndef _ASM_POWERPC_IRQHOST_H
> +#define _ASM_POWERPC_IRQHOST_H
> +
> +#include <linux/list.h>
> +#include <linux/radix-tree.h>
> +#include <linux/irq.h>
> +#include <linux/of.h>
> +
> +struct irq_host {
> +	struct list_head	link;
> +
> +	/* type of reverse mapping technique */
> +	unsigned int		revmap_type;
> +	union {
> +		struct {
> +			unsigned int size;
> +			unsigned int *revmap;
> +		} linear;
> +		struct radix_tree_root tree;
> +	} revmap_data;
> +	struct irq_host_ops	*ops;
> +	void			*host_data;
> +	irq_hw_number_t		inval_irq;
> +
> +	/* Optional device node pointer */
> +	struct device_node	*of_node;
> +};
> +
> +#endif /* _ASM_POWERPC_IRQHOST_H */
> diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
> index 5ccf38f..b961b19 100644
> --- a/arch/powerpc/kernel/irq.c
> +++ b/arch/powerpc/kernel/irq.c
> @@ -56,6 +56,7 @@
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
>  
> +#include <asm/irqhost.h>
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  #include <asm/io.h>
> diff --git a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
> index a8bc0d4..162bbb7 100644
> --- a/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
> +++ b/arch/powerpc/platforms/512x/mpc5121_ads_cpld.c
> @@ -18,6 +18,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/io.h>
> +#include <asm/irqhost.h>
>  #include <asm/prom.h>
>  
>  static struct device_node *cpld_pic_node;
> diff --git a/arch/powerpc/platforms/52xx/media5200.c b/arch/powerpc/platforms/52xx/media5200.c
> index 96f85e5..e03f2cb 100644
> --- a/arch/powerpc/platforms/52xx/media5200.c
> +++ b/arch/powerpc/platforms/52xx/media5200.c
> @@ -25,6 +25,7 @@
>  #include <linux/irq.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <asm/irqhost.h>
>  #include <asm/time.h>
>  #include <asm/prom.h>
>  #include <asm/machdep.h>
> diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> index 6c39b9c..55b2d26 100644
> --- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> +++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
> @@ -67,6 +67,7 @@
>  #include <linux/watchdog.h>
>  #include <linux/miscdevice.h>
>  #include <linux/uaccess.h>
> +#include <asm/irqhost.h>
>  #include <asm/div64.h>
>  #include <asm/mpc52xx.h>
>  
> diff --git a/arch/powerpc/platforms/52xx/mpc52xx_pic.c b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> index bb61181..65bbfd1 100644
> --- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> +++ b/arch/powerpc/platforms/52xx/mpc52xx_pic.c
> @@ -101,6 +101,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/of.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/mpc52xx.h>
> diff --git a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> index 5d6c34c..0ca79e0 100644
> --- a/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> +++ b/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> @@ -19,6 +19,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/slab.h>
>  
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/cpm2.h>
> diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
> index 1e3329e..e1469ae 100644
> --- a/arch/powerpc/platforms/cell/axon_msi.c
> +++ b/arch/powerpc/platforms/cell/axon_msi.c
> @@ -17,6 +17,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/slab.h>
>  
> +#include <asm/irqhost.h>
>  #include <asm/dcr.h>
>  #include <asm/machdep.h>
>  #include <asm/prom.h>
> diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
> index 34d2b99..73a5494 100644
> --- a/arch/powerpc/platforms/cell/spider-pic.c
> +++ b/arch/powerpc/platforms/cell/spider-pic.c
> @@ -24,6 +24,7 @@
>  #include <linux/irq.h>
>  #include <linux/ioport.h>
>  
> +#include <asm/irqhost.h>
>  #include <asm/pgtable.h>
>  #include <asm/prom.h>
>  #include <asm/io.h>
> diff --git a/arch/powerpc/platforms/embedded6xx/flipper-pic.c b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
> index 77cbe4c..1b60a34 100644
> --- a/arch/powerpc/platforms/embedded6xx/flipper-pic.c
> +++ b/arch/powerpc/platforms/embedded6xx/flipper-pic.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/irq.h>
>  #include <linux/of.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  
>  #include "flipper-pic.h"
> diff --git a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
> index 44b398b..4f87661 100644
> --- a/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
> +++ b/arch/powerpc/platforms/embedded6xx/hlwd-pic.c
> @@ -18,6 +18,7 @@
>  #include <linux/init.h>
>  #include <linux/irq.h>
>  #include <linux/of.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  
>  #include "hlwd-pic.h"
> diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
> index 1b5dc1a..c9176a9 100644
> --- a/arch/powerpc/platforms/embedded6xx/wii.c
> +++ b/arch/powerpc/platforms/embedded6xx/wii.c
> @@ -85,9 +85,11 @@ void __init wii_memory_fixups(void)
>  	wii_hole_start = p[0].base + p[0].size;
>  	wii_hole_size = p[1].base - wii_hole_start;
>  
> -	pr_info("MEM1: <%08llx %08llx>\n", p[0].base, p[0].size);
> +	pr_info("MEM1: <%08llx %08llx>\n",
> +		(unsigned long long)p[0].base, (unsigned long long)p[0].size);
>  	pr_info("HOLE: <%08lx %08lx>\n", wii_hole_start, wii_hole_size);
> -	pr_info("MEM2: <%08llx %08llx>\n", p[1].base, p[1].size);
> +	pr_info("MEM2: <%08llx %08llx>\n",
> +		(unsigned long long)p[1].base, (unsigned long long)p[1].size);
>  
>  	p[0].size += wii_hole_size + p[1].size;
>  
> diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
> index d5679dc..2c11b3e 100644
> --- a/arch/powerpc/sysdev/fsl_msi.c
> +++ b/arch/powerpc/sysdev/fsl_msi.c
> @@ -19,6 +19,7 @@
>  #include <linux/slab.h>
>  #include <linux/of_platform.h>
>  #include <sysdev/fsl_soc.h>
> +#include <asm/irqhost.h>
>  #include <asm/prom.h>
>  #include <asm/hw_irq.h>
>  #include <asm/ppc-pci.h>
> diff --git a/arch/powerpc/sysdev/i8259.c b/arch/powerpc/sysdev/i8259.c
> index 142770c..30869f0 100644
> --- a/arch/powerpc/sysdev/i8259.c
> +++ b/arch/powerpc/sysdev/i8259.c
> @@ -13,6 +13,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/delay.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  #include <asm/i8259.h>
>  #include <asm/prom.h>
> diff --git a/arch/powerpc/sysdev/ipic.c b/arch/powerpc/sysdev/ipic.c
> index f0ece79..fc3751f 100644
> --- a/arch/powerpc/sysdev/ipic.c
> +++ b/arch/powerpc/sysdev/ipic.c
> @@ -24,6 +24,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/fsl_devices.h>
>  #include <asm/irq.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/ipic.h>
> diff --git a/arch/powerpc/sysdev/mpc8xxx_gpio.c b/arch/powerpc/sysdev/mpc8xxx_gpio.c
> index fb4963a..f6839a7 100644
> --- a/arch/powerpc/sysdev/mpc8xxx_gpio.c
> +++ b/arch/powerpc/sysdev/mpc8xxx_gpio.c
> @@ -17,6 +17,7 @@
>  #include <linux/gpio.h>
>  #include <linux/slab.h>
>  #include <linux/irq.h>
> +#include <asm/irqhost.h>
>  
>  #define MPC8XXX_GPIO_PINS	32
>  
> diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
> index 824a94f..6e9e594 100644
> --- a/arch/powerpc/sysdev/mpic.c
> +++ b/arch/powerpc/sysdev/mpic.c
> @@ -28,6 +28,7 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  
> +#include <asm/irqhost.h>
>  #include <asm/ptrace.h>
>  #include <asm/signal.h>
>  #include <asm/io.h>
> diff --git a/arch/powerpc/sysdev/mpic_msi.c b/arch/powerpc/sysdev/mpic_msi.c
> index 0f67cd7..50176ed 100644
> --- a/arch/powerpc/sysdev/mpic_msi.c
> +++ b/arch/powerpc/sysdev/mpic_msi.c
> @@ -11,6 +11,7 @@
>  #include <linux/irq.h>
>  #include <linux/bitmap.h>
>  #include <linux/msi.h>
> +#include <asm/irqhost.h>
>  #include <asm/mpic.h>
>  #include <asm/prom.h>
>  #include <asm/hw_irq.h>
> diff --git a/arch/powerpc/sysdev/mpic_pasemi_msi.c b/arch/powerpc/sysdev/mpic_pasemi_msi.c
> index 38e6238..6b11a89 100644
> --- a/arch/powerpc/sysdev/mpic_pasemi_msi.c
> +++ b/arch/powerpc/sysdev/mpic_pasemi_msi.c
> @@ -18,6 +18,7 @@
>  #include <linux/irq.h>
>  #include <linux/bootmem.h>
>  #include <linux/msi.h>
> +#include <asm/irqhost.h>
>  #include <asm/mpic.h>
>  #include <asm/prom.h>
>  #include <asm/hw_irq.h>
> diff --git a/arch/powerpc/sysdev/qe_lib/qe_ic.c b/arch/powerpc/sysdev/qe_lib/qe_ic.c
> index b2acda0..9dd7746 100644
> --- a/arch/powerpc/sysdev/qe_lib/qe_ic.c
> +++ b/arch/powerpc/sysdev/qe_lib/qe_ic.c
> @@ -26,6 +26,7 @@
>  #include <linux/device.h>
>  #include <linux/bootmem.h>
>  #include <linux/spinlock.h>
> +#include <asm/irqhost.h>
>  #include <asm/irq.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
> diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
> index 984cd20..a097f4c 100644
> --- a/arch/powerpc/sysdev/uic.c
> +++ b/arch/powerpc/sysdev/uic.c
> @@ -26,6 +26,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel_stat.h>
>  #include <asm/irq.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  #include <asm/prom.h>
>  #include <asm/dcr.h>
> diff --git a/arch/powerpc/sysdev/xilinx_intc.c b/arch/powerpc/sysdev/xilinx_intc.c
> index 6183799..28d4ded 100644
> --- a/arch/powerpc/sysdev/xilinx_intc.c
> +++ b/arch/powerpc/sysdev/xilinx_intc.c
> @@ -23,6 +23,7 @@
>  #include <linux/kernel.h>
>  #include <linux/irq.h>
>  #include <linux/of.h>
> +#include <asm/irqhost.h>
>  #include <asm/io.h>
>  #include <asm/processor.h>
>  #include <asm/i8259.h>


