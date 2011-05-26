Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1EZFZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:25:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:38594 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab1EZFZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:25:02 -0400
Subject: Re: [PATCH v4]PPC4xx: Adding PCI(E) MSI support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
In-Reply-To: <201103300910.p2U9AO8t024353@amcc.com>
References: <201103300910.p2U9AO8t024353@amcc.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 15:24:44 +1000
Message-ID: <1306387484.7481.453.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 14:40 +0530, Rupjyoti Sarmah wrote:
> This patch adds MSI support for 440SPe, 460Ex, 460Sx and 405Ex.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
> Signed-off-by: Tirumala R Marri <tmarri@apm.com>

Ok so I sent the patch to Linus today. However I had to manually fix it
up for the generic changes to the irq subsystem. One change was trivial
set_irq_msi() -> irq_set_msi_desc(), but the other one was not: I just
removed the call to set_irq_data() as I couldn't figure out what it was
meant to do.

Please check the result and send any "fixup" patch that might be
necessary.

Cheers,
Ben.

> ---
> v4:
>  * Updated the coding style as per  recommendation by Philipp
>  * The goto style code removed as per suggestion
> v3:
>  * Rebased to Josh next tree
>  * Cleanup and remove some unwanted log msg.
>  * Remove list member and its references.
>  * Keep msi_data local reference.
> v2:
>   * Remove or add blank lines at appropriate places.
>   * Added BITMAP as it is easy to request and free the MSIs
>   * Removed UPPER_4BITS_OF36BIT & LOWER_32BITS_OF36BIT;
>   * Remove unused feature variable.
>   * Remove initialization of "virq".
>   * remove static int_no varaible and replace with bitmap.
>   * Eliminated reading count from DTS tree and added a macro.
>   * Remove printK.
>   * Remove else in setup_irqs.
>   * Free interrupts in teardown_msi_interrupts().
>   * Print contraints in check_device().
>   * Replace ioremap with of_iomap().
>   * Use msi_data in setup_pcieh_hw().
>   * Don't unmap in the setup_pcieh_hw().
>   * don't use WARN_ON.
>   * Remove ppc4xx_msi_ids[].
> ---
>  arch/powerpc/boot/dts/canyonlands.dts |   18 ++
>  arch/powerpc/boot/dts/katmai.dts      |   18 ++
>  arch/powerpc/boot/dts/kilauea.dts     |   28 ++++
>  arch/powerpc/boot/dts/redwood.dts     |   20 +++
>  arch/powerpc/platforms/40x/Kconfig    |    2 +
>  arch/powerpc/platforms/44x/Kconfig    |    6 +
>  arch/powerpc/sysdev/Kconfig           |    7 +
>  arch/powerpc/sysdev/Makefile          |    1 +
>  arch/powerpc/sysdev/ppc4xx_msi.c      |  277 +++++++++++++++++++++++++++++++++
>  9 files changed, 377 insertions(+), 0 deletions(-)
>  create mode 100644 arch/powerpc/sysdev/ppc4xx_msi.c
> 
> diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
> index 2779f08..22dd6ae 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -530,5 +530,23 @@
>  				0x0 0x0 0x0 0x3 &UIC3 0x12 0x4 /* swizzled int C */
>  				0x0 0x0 0x0 0x4 &UIC3 0x13 0x4 /* swizzled int D */>;
>  		};
> +
> +		MSI: ppc4xx-msi@C10000000 {
> +			compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
> +			reg = < 0xC 0x10000000 0x100>;
> +			sdr-base = <0x36C>;
> +			msi-data = <0x00000000>;
> +			msi-mask = <0x44440000>;
> +			interrupt-count = <3>;
> +			interrupts = <0 1 2 3>;
> +			interrupt-parent = <&UIC3>;
> +			#interrupt-cells = <1>;
> +			#address-cells = <0>;
> +			#size-cells = <0>;
> +			interrupt-map = <0 &UIC3 0x18 1
> +					1 &UIC3 0x19 1
> +					2 &UIC3 0x1A 1
> +					3 &UIC3 0x1B 1>;
> +		};
>  	};
>  };
> diff --git a/arch/powerpc/boot/dts/katmai.dts b/arch/powerpc/boot/dts/katmai.dts
> index 7c3be5e..f913dbe 100644
> --- a/arch/powerpc/boot/dts/katmai.dts
> +++ b/arch/powerpc/boot/dts/katmai.dts
> @@ -442,6 +442,24 @@
>  				0x0 0x0 0x0 0x4 &UIC3 0xb 0x4 /* swizzled int D */>;
>  		};
>  
> +		MSI: ppc4xx-msi@400300000 {
> +				compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
> +				reg = < 0x4 0x00300000 0x100>;
> +				sdr-base = <0x3B0>;
> +				msi-data = <0x00000000>;
> +				msi-mask = <0x44440000>;
> +				interrupt-count = <3>;
> +				interrupts =<0 1 2 3>;
> +				interrupt-parent = <&UIC0>;
> +				#interrupt-cells = <1>;
> +				#address-cells = <0>;
> +				#size-cells = <0>;
> +				interrupt-map = <0 &UIC0 0xC 1
> +					1 &UIC0 0x0D 1
> +					2 &UIC0 0x0E 1
> +					3 &UIC0 0x0F 1>;
> +		};
> +
>  		I2O: i2o@400100000 {
>  			compatible = "ibm,i2o-440spe";
>  			reg = <0x00000004 0x00100000 0x100>;
> diff --git a/arch/powerpc/boot/dts/kilauea.dts b/arch/powerpc/boot/dts/kilauea.dts
> index 89edb16..1613d6e 100644
> --- a/arch/powerpc/boot/dts/kilauea.dts
> +++ b/arch/powerpc/boot/dts/kilauea.dts
> @@ -403,5 +403,33 @@
>  				0x0 0x0 0x0 0x3 &UIC2 0xd 0x4 /* swizzled int C */
>  				0x0 0x0 0x0 0x4 &UIC2 0xe 0x4 /* swizzled int D */>;
>  		};
> +
> +		MSI: ppc4xx-msi@C10000000 {
> +			compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
> +			reg = < 0x0 0xEF620000 0x100>;
> +			sdr-base = <0x4B0>;
> +			msi-data = <0x00000000>;
> +			msi-mask = <0x44440000>;
> +			interrupt-count = <12>;
> +			interrupts = <0 1 2 3 4 5 6 7 8 9 0xA 0xB 0xC 0xD>;
> +			interrupt-parent = <&UIC2>;
> +			#interrupt-cells = <1>;
> +			#address-cells = <0>;
> +			#size-cells = <0>;
> +			interrupt-map = <0 &UIC2 0x10 1
> +					1 &UIC2 0x11 1
> +					2 &UIC2 0x12 1
> +					2 &UIC2 0x13 1
> +					2 &UIC2 0x14 1
> +					2 &UIC2 0x15 1
> +					2 &UIC2 0x16 1
> +					2 &UIC2 0x17 1
> +					2 &UIC2 0x18 1
> +					2 &UIC2 0x19 1
> +					2 &UIC2 0x1A 1
> +					2 &UIC2 0x1B 1
> +					2 &UIC2 0x1C 1
> +					3 &UIC2 0x1D 1>;
> +		};
>  	};
>  };
> diff --git a/arch/powerpc/boot/dts/redwood.dts b/arch/powerpc/boot/dts/redwood.dts
> index 81636c0..d86a3a4 100644
> --- a/arch/powerpc/boot/dts/redwood.dts
> +++ b/arch/powerpc/boot/dts/redwood.dts
> @@ -358,8 +358,28 @@
>  				0x0 0x0 0x0 0x4 &UIC3 0xb 0x4 /* swizzled int D */>;
>  		};
>  
> +		MSI: ppc4xx-msi@400300000 {
> +				compatible = "amcc,ppc4xx-msi", "ppc4xx-msi";
> +				reg = < 0x4 0x00300000 0x100
> +					0x4 0x00300000 0x100>;
> +				sdr-base = <0x3B0>;
> +				msi-data = <0x00000000>;
> +				msi-mask = <0x44440000>;
> +				interrupt-count = <3>;
> +				interrupts =<0 1 2 3>;
> +				interrupt-parent = <&UIC0>;
> +				#interrupt-cells = <1>;
> +				#address-cells = <0>;
> +				#size-cells = <0>;
> +				interrupt-map = <0 &UIC0 0xC 1
> +					1 &UIC0 0x0D 1
> +					2 &UIC0 0x0E 1
> +					3 &UIC0 0x0F 1>;
> +		};
> +
>  	};
>  
> +
>  	chosen {
>  		linux,stdout-path = "/plb/opb/serial@ef600200";
>  	};
> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index b721764..92aeee6 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -57,6 +57,8 @@ config KILAUEA
>  	select 405EX
>  	select PPC40x_SIMPLE
>  	select PPC4xx_PCI_EXPRESS
> +	select PCI_MSI
> +	select 4xx_MSI
>  	help
>  	  This option enables support for the AMCC PPC405EX evaluation board.
>  
> diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
> index f485fc5..f10cc7f 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -74,6 +74,8 @@ config KATMAI
>  	select 440SPe
>  	select PCI
>  	select PPC4xx_PCI_EXPRESS
> +	select PCI_MSI
> +	select 4xx_MSI
>  	help
>  	  This option enables support for the AMCC PPC440SPe evaluation board.
>  
> @@ -118,6 +120,8 @@ config CANYONLANDS
>  	select 460EX
>  	select PCI
>  	select PPC4xx_PCI_EXPRESS
> +	select PCI_MSI
> +	select 4xx_MSI
>  	select IBM_NEW_EMAC_RGMII
>  	select IBM_NEW_EMAC_ZMII
>  	help
> @@ -144,6 +148,8 @@ config REDWOOD
>  	select 460SX
>  	select PCI
>  	select PPC4xx_PCI_EXPRESS
> +	select PCI_MSI
> +	select 4xx_MSI
>  	help
>  	  This option enables support for the AMCC PPC460SX Redwood board.
>  
> diff --git a/arch/powerpc/sysdev/Kconfig b/arch/powerpc/sysdev/Kconfig
> index 3965828..32f5a40 100644
> --- a/arch/powerpc/sysdev/Kconfig
> +++ b/arch/powerpc/sysdev/Kconfig
> @@ -7,8 +7,15 @@ config PPC4xx_PCI_EXPRESS
>  	depends on PCI && 4xx
>  	default n
>  
> +config 4xx_MSI
> +	bool
> +	depends on PCI_MSI
> +	depends on PCI && 4xx
> +	default n
> +
>  config PPC_MSI_BITMAP
>  	bool
>  	depends on PCI_MSI
>  	default y if MPIC
>  	default y if FSL_PCI
> +	default y if 4xx_MSI
> diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
> index 1e0c933..5d92e29 100644
> --- a/arch/powerpc/sysdev/Makefile
> +++ b/arch/powerpc/sysdev/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_OF_RTC)		+= of_rtc.o
>  ifeq ($(CONFIG_PCI),y)
>  obj-$(CONFIG_4xx)		+= ppc4xx_pci.o
>  endif
> +obj-$(CONFIG_4xx_MSI)		+= ppc4xx_msi.o
>  obj-$(CONFIG_PPC4xx_CPM)	+= ppc4xx_cpm.o
>  obj-$(CONFIG_PPC4xx_GPIO)	+= ppc4xx_gpio.o
>  
> diff --git a/arch/powerpc/sysdev/ppc4xx_msi.c b/arch/powerpc/sysdev/ppc4xx_msi.c
> new file mode 100644
> index 0000000..ab69edb
> --- /dev/null
> +++ b/arch/powerpc/sysdev/ppc4xx_msi.c
> @@ -0,0 +1,277 @@
> +/*
> + * Adding PCI-E MSI support for PPC4XX SoCs.
> + *
> + * Copyright (c) 2010, Applied Micro Circuits Corporation
> + * Authors:	Tirumala R Marri <tmarri@apm.com>
> + *		Feng Kan <fkan@apm.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; either version 2 of
> + * the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> + * MA 02111-1307 USA
> + */
> +
> +#include <linux/irq.h>
> +#include <linux/bootmem.h>
> +#include <linux/pci.h>
> +#include <linux/msi.h>
> +#include <linux/of_platform.h>
> +#include <linux/interrupt.h>
> +#include <asm/prom.h>
> +#include <asm/hw_irq.h>
> +#include <asm/ppc-pci.h>
> +#include <boot/dcr.h>
> +#include <asm/dcr-regs.h>
> +#include <asm/msi_bitmap.h>
> +
> +#define PEIH_TERMADH	0x00
> +#define PEIH_TERMADL	0x08
> +#define PEIH_MSIED	0x10
> +#define PEIH_MSIMK	0x18
> +#define PEIH_MSIASS	0x20
> +#define PEIH_FLUSH0	0x30
> +#define PEIH_FLUSH1	0x38
> +#define PEIH_CNTRST	0x48
> +#define NR_MSI_IRQS	4
> +
> +struct ppc4xx_msi {
> +	u32 msi_addr_lo;
> +	u32 msi_addr_hi;
> +	void __iomem *msi_regs;
> +	int msi_virqs[NR_MSI_IRQS];
> +	struct msi_bitmap bitmap;
> +	struct device_node *msi_dev;
> +};
> +
> +static struct ppc4xx_msi ppc4xx_msi;
> +
> +static int ppc4xx_msi_init_allocator(struct platform_device *dev,
> +		struct ppc4xx_msi *msi_data)
> +{
> +	int err;
> +
> +	err = msi_bitmap_alloc(&msi_data->bitmap, NR_MSI_IRQS,
> +			      dev->dev.of_node);
> +	if (err)
> +		return err;
> +
> +	err = msi_bitmap_reserve_dt_hwirqs(&msi_data->bitmap);
> +	if (err < 0) {
> +		msi_bitmap_free(&msi_data->bitmap);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ppc4xx_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> +{
> +	int int_no = -ENOMEM;
> +	unsigned int virq;
> +	struct msi_msg msg;
> +	struct msi_desc *entry;
> +	struct ppc4xx_msi *msi_data = &ppc4xx_msi;
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		int_no = msi_bitmap_alloc_hwirqs(&msi_data->bitmap, 1);
> +		if (int_no >= 0)
> +			break;
> +		if (int_no < 0) {
> +			pr_debug("%s: fail allocating msi interrupt\n",
> +					__func__);
> +		}
> +		virq = irq_of_parse_and_map(msi_data->msi_dev, int_no);
> +		if (virq == NO_IRQ) {
> +			dev_err(&dev->dev, "%s: fail mapping irq\n", __func__);
> +			msi_bitmap_free_hwirqs(&msi_data->bitmap, int_no, 1);
> +			return -ENOSPC;
> +		}
> +		set_irq_data(virq, (void *)int_no);
> +		dev_dbg(&dev->dev, "%s: virq = %d\n", __func__, virq);
> +
> +		/* Setup msi address space */
> +		msg.address_hi = msi_data->msi_addr_hi;
> +		msg.address_lo = msi_data->msi_addr_lo;
> +
> +		set_irq_msi(virq, entry);
> +		msg.data = int_no;
> +		write_msi_msg(virq, &msg);
> +	}
> +	return 0;
> +}
> +
> +void ppc4xx_teardown_msi_irqs(struct pci_dev *dev)
> +{
> +	struct msi_desc *entry;
> +	struct ppc4xx_msi *msi_data = &ppc4xx_msi;
> +
> +	dev_dbg(&dev->dev, "PCIE-MSI: tearing down msi irqs\n");
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		if (entry->irq == NO_IRQ)
> +			continue;
> +		set_irq_msi(entry->irq, NULL);
> +		msi_bitmap_free_hwirqs(&msi_data->bitmap,
> +				virq_to_hw(entry->irq), 1);
> +		irq_dispose_mapping(entry->irq);
> +	}
> +}
> +
> +static int ppc4xx_msi_check_device(struct pci_dev *pdev, int nvec, int type)
> +{
> +	dev_dbg(&pdev->dev, "PCIE-MSI:%s called. vec %x type %d\n",
> +		__func__, nvec, type);
> +	if (type == PCI_CAP_ID_MSIX)
> +		pr_debug("ppc4xx msi: MSI-X untested, trying anyway.\n");
> +
> +	return 0;
> +}
> +
> +static int ppc4xx_setup_pcieh_hw(struct platform_device *dev,
> +				 struct resource res, struct ppc4xx_msi *msi)
> +{
> +	const u32 *msi_data;
> +	const u32 *msi_mask;
> +	const u32 *sdr_addr;
> +	dma_addr_t msi_phys;
> +	void *msi_virt;
> +
> +	sdr_addr = of_get_property(dev->dev.of_node, "sdr-base", NULL);
> +	if (!sdr_addr)
> +		return -1;
> +
> +	SDR0_WRITE(sdr_addr, (u64)res.start >> 32);	 /*HIGH addr */
> +	SDR0_WRITE(sdr_addr + 1, res.start & 0xFFFFFFFF); /* Low addr */
> +
> +
> +	msi->msi_dev = of_find_node_by_name(NULL, "ppc4xx-msi");
> +	if (msi->msi_dev)
> +		return -ENODEV;
> +
> +	msi->msi_regs = of_iomap(msi->msi_dev, 0);
> +	if (!msi->msi_regs) {
> +		dev_err(&dev->dev, "of_iomap problem failed\n");
> +		return -ENOMEM;
> +	}
> +	dev_dbg(&dev->dev, "PCIE-MSI: msi register mapped 0x%x 0x%x\n",
> +		(u32) (msi->msi_regs + PEIH_TERMADH), (u32) (msi->msi_regs));
> +
> +	msi_virt = dma_alloc_coherent(&dev->dev, 64, &msi_phys, GFP_KERNEL);
> +	msi->msi_addr_hi = 0x0;
> +	msi->msi_addr_lo = (u32) msi_phys;
> +	dev_dbg(&dev->dev, "PCIE-MSI: msi address 0x%x\n", msi->msi_addr_lo);
> +
> +	/* Progam the Interrupt handler Termination addr registers */
> +	out_be32(msi->msi_regs + PEIH_TERMADH, msi->msi_addr_hi);
> +	out_be32(msi->msi_regs + PEIH_TERMADL, msi->msi_addr_lo);
> +
> +	msi_data = of_get_property(dev->dev.of_node, "msi-data", NULL);
> +	if (!msi_data)
> +		return -1;
> +	msi_mask = of_get_property(dev->dev.of_node, "msi-mask", NULL);
> +	if (!msi_mask)
> +		return -1;
> +	/* Program MSI Expected data and Mask bits */
> +	out_be32(msi->msi_regs + PEIH_MSIED, *msi_data);
> +	out_be32(msi->msi_regs + PEIH_MSIMK, *msi_mask);
> +
> +	return 0;
> +}
> +
> +static int ppc4xx_of_msi_remove(struct platform_device *dev)
> +{
> +	struct ppc4xx_msi *msi = dev->dev.platform_data;
> +	int i;
> +	int virq;
> +
> +	for (i = 0; i < NR_MSI_IRQS; i++) {
> +		virq = msi->msi_virqs[i];
> +		if (virq != NO_IRQ)
> +			irq_dispose_mapping(virq);
> +	}
> +
> +	if (msi->bitmap.bitmap)
> +		msi_bitmap_free(&msi->bitmap);
> +	iounmap(msi->msi_regs);
> +	of_node_put(msi->msi_dev);
> +	kfree(msi);
> +
> +	return 0;
> +}
> +
> +static int __devinit ppc4xx_msi_probe(struct platform_device *dev)
> +{
> +	struct ppc4xx_msi *msi;
> +	struct resource res;
> +	int err = 0;
> +
> +	msi = &ppc4xx_msi;/*keep the msi data for further use*/
> +
> +	dev_dbg(&dev->dev, "PCIE-MSI: Setting up MSI support...\n");
> +
> +	msi = kzalloc(sizeof(struct ppc4xx_msi), GFP_KERNEL);
> +	if (!msi) {
> +		dev_err(&dev->dev, "No memory for MSI structure\n");
> +		return -ENOMEM;
> +	}
> +	dev->dev.platform_data = msi;
> +
> +	/* Get MSI ranges */
> +	err = of_address_to_resource(dev->dev.of_node, 0, &res);
> +	if (err) {
> +		dev_err(&dev->dev, "%s resource error!\n",
> +			dev->dev.of_node->full_name);
> +		goto error_out;
> +	}
> +
> +	if (ppc4xx_setup_pcieh_hw(dev, res, msi))
> +		goto error_out;
> +
> +	err = ppc4xx_msi_init_allocator(dev, msi);
> +	if (err) {
> +		dev_err(&dev->dev, "Error allocating MSI bitmap\n");
> +		goto error_out;
> +	}
> +
> +	ppc_md.setup_msi_irqs = ppc4xx_setup_msi_irqs;
> +	ppc_md.teardown_msi_irqs = ppc4xx_teardown_msi_irqs;
> +	ppc_md.msi_check_device = ppc4xx_msi_check_device;
> +	return err;
> +
> +error_out:
> +	ppc4xx_of_msi_remove(dev);
> +	return err;
> +}
> +static const struct of_device_id ppc4xx_msi_ids[] = {
> +	{
> +		.compatible = "amcc,ppc4xx-msi",
> +	},
> +	{}
> +};
> +static struct platform_driver ppc4xx_msi_driver = {
> +	.probe = ppc4xx_msi_probe,
> +	.remove = ppc4xx_of_msi_remove,
> +	.driver = {
> +		   .name = "ppc4xx-msi",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = ppc4xx_msi_ids,
> +		   },
> +
> +};
> +
> +static __init int ppc4xx_msi_init(void)
> +{
> +	return platform_driver_register(&ppc4xx_msi_driver);
> +}
> +
> +subsys_initcall(ppc4xx_msi_init);


