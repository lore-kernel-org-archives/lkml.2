Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab1BQRoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:44:16 -0500
Received: from juliet.he.net ([184.105.210.2]:34842 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754105Ab1BQRoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:44:13 -0500
Date: Thu, 17 Feb 2011 09:44:06 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Pratyush Anand <pratyush.anand@st.com>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <gregkh@suse.de>, <jbarnes@virtuousgeek.org>, <viresh.kumar@st.com>,
        <shiraz.hashim@st.com>
Subject: Re: [PATCH V4] ST SPEAr: PCIE gadget suppport
Message-Id: <20110217094406.7e01fe24.rdunlap@xenotime.net>
In-Reply-To: <1297939844-6433-1-git-send-email-pratyush.anand@st.com>
References: <1297939844-6433-1-git-send-email-pratyush.anand@st.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 16:20:44 +0530 Pratyush Anand wrote:

> This is a configurable gadget. can be configured by configfs interface. Any
> IP available at PCIE bus can be programmed to be used by host
> controller.It supoorts both INTX and MSI.
> By default, gadget is configured for INTX and SYSRAM1 is mapped to BAR0
> with size 0x1000
> 
> Changes since V3:
> - support for multiple instances of such device
> - changes to minizie portability issue on 64 bit machine
> - unnecessary typecast removed
> - sysfs_streq used in place of complex code
> 
> Changes since V2:
> - driver has been moved from sysfs to configfs
> - Documentation/ABI directory has also been updated
> - typo error in documenation has been corrected
> - clk value is checked after encapsulating by IS_ERR
> 
> Changes since V1:
> - __iomem added for register addresses
> - kerneldoc comment removed whereever not required.
> - help node moved from sysfs to documentation/misc-devices
> - strict_strtoul used instead of sscanf
> 
> Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
> ---
>  .../ABI/testing/configfs-spear-pcie-gadget         |   30 +
>  Documentation/misc-devices/spear-pcie-gadget.txt   |  129 +++
>  drivers/misc/Kconfig                               |   10 +
>  drivers/misc/Makefile                              |    1 +
>  drivers/misc/spear13xx_pcie_gadget.c               |  904 ++++++++++++++++++++
>  5 files changed, 1074 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/configfs-spear-pcie-gadget
>  create mode 100644 Documentation/misc-devices/spear-pcie-gadget.txt
>  create mode 100644 drivers/misc/spear13xx_pcie_gadget.c
> 
> diff --git a/Documentation/ABI/testing/configfs-spear-pcie-gadget b/Documentation/ABI/testing/configfs-spear-pcie-gadget
> new file mode 100644
> index 0000000..3a1e653
> --- /dev/null
> +++ b/Documentation/ABI/testing/configfs-spear-pcie-gadget
> @@ -0,0 +1,30 @@
> +What:		/config/pcie-gadget
> +Date:		Feb 2011
> +KernelVersion:	2.6.37
> +Contact:	Pratyush Anand <pratyush.anand@st.com>
> +Description:
> +
> +	Interface is used to configure selected dual mode pcie controller

	                                                  PCIe

> +	as device and then program its various registers to configure it
> +	as a particular device type.
> +	This interfaces can be used to show spear's pcie device capability.

	                                            PCIe

> +
> +	Nodes are only visible when configfs is mounted. To mount configfs
> +	in /config directory use:
> +	# mount -t configfs none /config/
> +
> +	/config/pcie-gadget/
> +		link ... used to enable ltssm and read its status.
> +		int_type ...used to configure and read type of supported
> +			interrupt
> +		no_of_msi ... used to configure number of MSI vector needed and
> +			to read no of MSI granted.
> +		inta ... write 1 to assert INTA and 0 to de-assert.
> +		send_msi ... write MSI vector to be sent.
> +		vendor_id ... used to write and read vendor id (hex)
> +		device_id ... used to write and read device id (hex)
> +		bar0_size ... used to write and read bar0_size
> +		bar0_address ... used to write and read bar0 mapped area in hex.
> +		bar0_rw_offset ... used to write and read offset of bar0 where
> +			bar0_data will be written or read.
> +		bar0_data ... used to write and read data at bar0_rw_offset.
> diff --git a/Documentation/misc-devices/spear-pcie-gadget.txt b/Documentation/misc-devices/spear-pcie-gadget.txt
> new file mode 100644
> index 0000000..7361793
> --- /dev/null
> +++ b/Documentation/misc-devices/spear-pcie-gadget.txt
> @@ -0,0 +1,129 @@
> +Spear PCIE Gadget Driver:

         PCIe

> +
> +Author
> +=============
> +Pratyush Anand (pratyush.anand@st.com)
> +
> +Location
> +============
> +driver/misc/spear13xx_pcie_gadget.c
> +
> +Supported Chip:
> +===================
> +SPEAr1300
> +SPEAr1310
> +
> +Menuconfig option:
> +==========================
> +Device Drivers
> +	Misc devices
> +		PCIE gadget support for SPEAr13XX platform

ditto

> +purpose
> +===========
> +This driver has several nodes which can read/written by configfs interface.

                                 which can be read/written

> +Its main purpose is to configure selected dual mode pcie controller as device

                                                       PCIe

> +and then program its various registers to configure it as a particular device
> +type. This driver can be used to show spear's pcie device capability.

ditto

> +
> +Description of different nodes:
> +=================================
> +
> +read behavior of nodes:
> +------------------------------
> +link 		:gives ltssm status.
> +int_type 	:type of supported interrupt
> +no_of_msi 	:zero if MSI is not enabled by host. A positive value is the
> +		number of MSI vector granted.
> +vendor_id	:returns programmed vendor id (hex)
> +device_id	:returns programmed device id(hex)
> +bar0_size:	:returns size of bar0 in hex.
> +bar0_address	:returns address of bar0 mapped area in hex.
> +bar0_rw_offset	:returns offset of bar0 for which bar0_data will return value.
> +bar0_data	:returns data at bar0_rw_offset.
> +
> +write behavior of nodes:
> +------------------------------
> +link 		:write UP to enable ltsmm DOWN to disable
> +int_type	:write interrupt type to be configured and (int_type could be
> +		INTA, MSI or NO_INT).select MSI only when you have programmed

		             NO_INT). Select MSI
	
> +		no_of_msi node.
> +no_of_msi	:number of MSI vector needed.
> +inta		:write 1 to assert INTA and 0 to de-assert.
> +send_msi	:write MSI vector to be sent.
> +vendor_id	:write vendor id(hex) to be programmed.
> +device_id	:write device id(hex) to be programmed.
> +bar0_size	:write size of bar0 in hex. default bar0 size is 1000 (hex)
> +		bytes.
> +bar0_address	:write	address of bar0 mapped area in hex. (default mapping of
> +		bar0 is SYSRAM1(E0800000).Always program bar size before bar

		               (E0800000). Always

> +		address. kernel might modify bar size and address to align. So

		         Kernel                                   for alignment, so

> +		read back bar size and address after writing to cross check.
> +bar0_rw_offset	:write offset of bar0 for which	bar0_data will write value.
> +bar0_data	:write data to be written at bar0_rw_offset.
> +
> +Node programming example
> +===========================
> +Program all PCIE registers in such a way that when this device is connected

               PCIe

> +to the pcie host, then host sees this device as 1MB RAM.

ditto

> +#mount -t configfs none /Config
> +# cd /config/pcie_gadget/
> +Now you have all the nodes in this directory.
> +program vendor id as 0x104a
> +# echo 104A >> vendor_id
> +
> +program device id as 0xCD80
> +# echo CD80 >> device_id
> +
> +program BAR0 size as 1MB
> +# echo 100000 >> bar0_size
> +
> +check for programmed bar0 size
> +# cat bar0_size
> +
> +Program BAR0 Address as DDR (0x2100000).this is the physical address of

                               (0x2100000). This

> +memory, which is to be made visible to pcie host. Similarly any other peripheral

                                          PCIe

> +can also be made visible to pcie host. e.g if you program base address of UART

                               PCIe host. E.g., if

> +as BAR0 address then when this device will be connected to a host, it will be
> +visible as UART.
> +# echo 2100000 >> bar0_address
> +
> +program interrupt type : INTA
> +# echo INTA >> int_type
> +
> +go for link up now.
> +# echo UP >> link
> +
> +It will have to be insured that, once link up is done on gadget, then only host
> +is initialized and start to search pcie devices on its port.

                                      PCIe

> +
> +/*wait till link is up*/
> +# cat link
> +wait till it returns UP.
> +
> +To assert INTA
> +# echo 1 >> inta
> +
> +To de-assert INTA
> +# echo 0 >> inta
> +
> +if MSI is to be used as interrupt, program no of msi vector needed (say4)
> +# echo 4 >> no_of_msi
> +
> +select MSI as interrupt type
> +# echo MSI >> int_type
> +
> +go for link up now
> +# echo UP >> link
> +
> +wait till link is up
> +# cat link
> +An application can repetitively read this node till link is found UP. It can
> +sleep between two read.
> +
> +wait till msi is enabled
> +# cat no_of_msi
> +Should return 4 (number of requested MSI vector)
> +
> +to send msi vector 2
> +# echo 2 >> send_msi
> +#cd -
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4d073f1..c364a9b 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -394,6 +394,16 @@ config DS1682
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ds1682.
>  
> +config SPEAR13XX_PCIE_GADGET
> +	bool "PCIE gadget support for SPEAr13XX platform"
> +	depends on ARCH_SPEAR13XX
> +	default n
> +	help
> +	 This option enables gadget support for PCIE controller. If

	                                        PCIe

> +	 board file defines any controller as PCIE endpoint then a sysfs

ditto

> +	 entry will be created for that controller. User can use these
> +	 sysfs node to configure PCIE EP as per his requirements.

ditto

> +
>  config TI_DAC7512
>  	tristate "Texas Instruments DAC7512"
>  	depends on SPI && SYSFS
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 98009cc..c489536 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
>  obj-$(CONFIG_HMC6352)		+= hmc6352.o
>  obj-y				+= eeprom/
>  obj-y				+= cb710/
> +obj-$(CONFIG_SPEAR13XX_PCIE_GADGET)	+= spear13xx_pcie_gadget.o
>  obj-$(CONFIG_VMWARE_BALLOON)	+= vmw_balloon.o
>  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
>  obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
> diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
> new file mode 100644
> index 0000000..86f821b
> --- /dev/null
> +++ b/drivers/misc/spear13xx_pcie_gadget.c
> @@ -0,0 +1,904 @@
> +/*
> + * drivers/misc/spear13xx_pcie_gadget.c
> + *
> + * Copyright (C) 2010 ST Microelectronics
> + * Pratyush Anand<pratyush.anand@st.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */

...

> +static ssize_t pcie_gadget_store_send_msi(
> +		struct spear_pcie_gadget_config *config,
> +		const char *buf, size_t count)
> +{
> +	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
> +	ulong vector;
> +	u32 ven_msi;
> +
> +	if (strict_strtoul(buf, 0, &vector))
> +		return -EINVAL;
> +
> +	if (!config->configured_msi)
> +		return -EINVAL;
> +
> +	if (vector >= config->configured_msi)
> +		return -EINVAL;
> +
> +	ven_msi = readl(&app_reg->ven_msi_1);
> +	ven_msi &= ~VEN_MSI_FUN_NUM_MASK;
> +	ven_msi |= 0 << VEN_MSI_FUN_NUM_ID;
> +	ven_msi &= ~VEN_MSI_TC_MASK;
> +	ven_msi |= 0 << VEN_MSI_TC_ID;
> +	ven_msi &= ~VEN_MSI_VECTOR_MASK;
> +	ven_msi |= vector << VEN_MSI_VECTOR_ID;
> +
> +	/*generating interrupt for msi vector*/

	/* generating interrupt for MSI vector */

> +	ven_msi |= VEN_MSI_REQ_EN;
> +	writel(ven_msi, &app_reg->ven_msi_1);
> +	/*need to wait till this bit is cleared, it is not cleared
> +	 * autometically[Bug RTL] TBD*/

	   automatically
Please use the normal kernel multi-line comment style:
	/*
	 * need to wait till this bit is cleared, it is not cleared
	 * automatically [Bug RTL] TBD
	 */

> +	udelay(1);
> +	ven_msi &= ~VEN_MSI_REQ_EN;
> +	writel(ven_msi, &app_reg->ven_msi_1);
> +
> +	return count;
> +}

...

> +static ssize_t pcie_gadget_store_bar0_size(
> +		struct spear_pcie_gadget_config *config,
> +		const char *buf, size_t count)
> +{
> +	ulong size;
> +	u32 pos, pos1;
> +	u32 no_of_bit = 0;
> +
> +	if (strict_strtoul(buf, 0, &size))
> +		return -EINVAL;
> +	/* as per PCIE specs, min bar size supported is 128 bytes. But
> +	 * our controller supports min as 256*/

Use kernel multi-line comment style.
"PCIe"

> +	if (size <= 0x100)
> +		size = 0x100;
> +	/* max bar size is 1MB*/
> +	else if (size >= 0x100000)
> +		size = 0x100000;
> +	else {
> +		pos = 0;
> +		pos1 = 0;
> +		while (pos < 21) {
> +			pos = find_next_bit((ulong *)&size, 21, pos);
> +			if (pos != 21)
> +				pos1 = pos + 1;
> +			pos++;
> +			no_of_bit++;
> +		}
> +		if (no_of_bit == 2)
> +			pos1--;
> +
> +		size = 1 << pos1;
> +	}
> +	config->bar0_size = size;
> +	spear_dbi_write_reg(config, PCIE_BAR0_MASK_REG, 4, size - 1);
> +
> +	return count;
> +}

...

> +static int __devinit spear_pcie_gadget_probe(struct platform_device *pdev)
> +{
> +	struct resource *res0, *res1;
> +	unsigned int status = 0;
> +	int irq;
> +	struct clk *clk;
> +	static struct pcie_gadget_target *target;
> +	struct spear_pcie_gadget_config *config;
> +	struct config_item		*cg_item;
> +	struct configfs_subsystem *subsys;
> +
> +	/* get resource for application registers*/
> +
> +	res0 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res0) {
> +		dev_err(&pdev->dev, "no resource defined\n");
> +		return -EBUSY;
> +	}
> +	if (!request_mem_region(res0->start, resource_size(res0),
> +				pdev->name)) {
> +		dev_err(&pdev->dev, "pcie gadget region already	claimed\n");
> +		return -EBUSY;
> +	}
> +	/* get resource for dbi registers*/
> +
> +	res1 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	if (!res1) {
> +		dev_err(&pdev->dev, "no resource defined\n");
> +		goto err_rel_res0;
> +	}
> +	if (!request_mem_region(res1->start, resource_size(res1),
> +				pdev->name)) {
> +		dev_err(&pdev->dev, "pcie gadget region already	claimed\n");
> +		goto err_rel_res0;
> +	}
> +
> +	target = kzalloc(sizeof(*target), GFP_KERNEL);
> +	if (!target) {
> +		dev_err(&pdev->dev, "out of memory\n");
> +		status = -ENOMEM;
> +		goto err_rel_res;
> +	}
> +
> +	cg_item = &target->subsys.su_group.cg_item;
> +	sprintf(cg_item->ci_namebuf, "pcie_gadget.%d", pdev->id);
> +	cg_item->ci_type	= &pcie_gadget_target_type;
> +	config = &target->config;
> +	config->va_app_base = (void __iomem *)ioremap(res0->start,
> +			resource_size(res0));
> +	if (!config->va_app_base) {
> +		dev_err(&pdev->dev, "ioremap fail\n");
> +		status = -ENOMEM;
> +		goto err_kzalloc;
> +	}
> +
> +	config->base = (void __iomem *)res1->start;
> +
> +	config->va_dbi_base = (void __iomem *)ioremap(res1->start,
> +			resource_size(res1));
> +	if (!config->va_dbi_base) {
> +		dev_err(&pdev->dev, "ioremap fail\n");
> +		status = -ENOMEM;
> +		goto err_iounmap_app;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, target);
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "no update irq?\n");
> +		status = irq;
> +		goto err_iounmap;
> +	}
> +
> +	status = request_irq(irq, spear_pcie_gadget_irq, 0, pdev->name, NULL);
> +	if (status) {
> +		dev_err(&pdev->dev, "pcie gadget interrupt IRQ%d already \
> +				claimed\n", irq);
> +		goto err_iounmap;
> +	}
> +
> +	/* Register configfs hooks */
> +	subsys = &target->subsys;
> +	config_group_init(&subsys->su_group);
> +	mutex_init(&subsys->su_mutex);
> +	status = configfs_register_subsystem(subsys);
> +	if (status)
> +		goto err_irq;
> +
> +	/* init basic pcie application registers*/
> +	/* do not enable clock if it is PCIE0.Ideally , all controller should
> +	 * have been independent from others with respect to clock. But PCIE1
> +	 * and 2 depends on PCIE0.So PCIE0 clk is provided during board init.*/

Use kernel multi-line comment style.

> +	if (pdev->id == 1) {
> +		/* Ideally CFG Clock should have been also enabled here. But
> +		 * it is done currently during board init routne*/

ditto
s/routne/routine/

> +		clk = clk_get_sys("pcie1", NULL);
> +		if (IS_ERR(clk)) {
> +			pr_err("%s:couldn't get clk for pcie1\n", __func__);
> +			goto err_irq;
> +		}
> +		if (clk_enable(clk)) {
> +			pr_err("%s:couldn't enable clk for pcie1\n", __func__);
> +			goto err_irq;
> +		}
> +	} else if (pdev->id == 2) {
> +		/* Ideally CFG Clock should have been also enabled here. But
> +		 * it is done currently during board init routne*/

same comments as above

> +		clk = clk_get_sys("pcie2", NULL);
> +		if (IS_ERR(clk)) {
> +			pr_err("%s:couldn't get clk for pcie2\n", __func__);
> +			goto err_irq;
> +		}
> +		if (clk_enable(clk)) {
> +			pr_err("%s:couldn't enable clk for pcie2\n", __func__);
> +			goto err_irq;
> +		}
> +	}
> +	spear13xx_pcie_device_init(config);
> +
> +	return 0;
> +err_irq:
> +	free_irq(irq, NULL);
> +err_iounmap:
> +	iounmap(config->va_dbi_base);
> +err_iounmap_app:
> +	iounmap(config->va_app_base);
> +err_kzalloc:
> +	kfree(config);
> +err_rel_res:
> +	release_mem_region(res1->start, resource_size(res1));
> +err_rel_res0:
> +	release_mem_region(res0->start, resource_size(res0));
> +	return status;
> +}

...

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
