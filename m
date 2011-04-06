Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1DFOSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:18:31 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4886 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756165Ab1DFOS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:18:28 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "George Kashperko" <george@znau.edu.ua>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Russell King" <rmk@arm.linux.org.uk>, "Arnd Bergmann" <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
Date: Wed, 6 Apr 2011 16:18:09 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Organization: Broadcom
Message-ID: <op.vtisojsk3ri7v4@arend-laptop>
In-Reply-To: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
X-WSS-ID: 6182A96E3TK2984390-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 21:57:42 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> I believe this driver implements AI support in the proper way. This  
> introduces
> support for the *bus* and lets drivers register for specific cores. It  
> was
> tested with b43 and BCM4313, reading PHY info works fine.

Hi Rafał,


I like the general idea of your design (and George?). It has quite some  
similarities with the brcmaxi module I posted some time ago. I did receive  
some comments and will resubmit another patch for which I hope you can  
find some time to have a look at it and provide me with some feedback. I  
think you made an excellent move forward, but I want to comment on a  
couple of things that seem to restrict the use of this module.

1. Term Broadcom AI

You are referring to this as Broadcom AI. However, there is nothing  
Broadcom specific about this. Basically, this functionality (core  
enumeration and generic core functions) is provided by ARM with the AMBA  
AXI and named Device Management Plugin (abbrev. DMP).

2. Bus registration

The bus registration mandates the use of chipcommon driver if a chipcommon  
core is detected (same for pcie). In brcm80211 driver we access the  
d11core and chipcommon. Is this still possible or should we remove all  
register access to chipcommon from our driver if we were to use bcmai.  
Also as each core is registered as a linux device does that imply a  
one-on-one relation? So one core equals one driver?

3. Device identification

The cores are identified by manufacturer, core id and revision in your  
patch. I would not use the revision because 4 out of 5 times a revision  
change does indicate a hardware change but no change in programming  
interface. The enumeration data does contain a more selective field  
indicating the core class (4 bits following the core identifier). I  
suggest to replace the revision field by this class field.

4. PCI Host interface

When building the PCI host interface variant of the bcmai it compiles in  
the source file b43_pci_ai_bridge.c. This name suggests that this module  
can only be used with b43 driver. Is that a correct observation? I see  
this as a major restriction to using the new module or could another  
driver (like ours) use the bcmai_host_pci_register() function.

Now for the code comments, see inline remarks below.

> Current issues:
> 1) On second (un)load: kernel BUG at mm/slab.c:500!
>
> TODO:
> 1) DMA
> 2) IRQ
> ---
>  drivers/Kconfig                               |    2 +
>  drivers/Makefile                              |    1 +
>  drivers/bcmai/Kconfig                         |   30 ++
>  drivers/bcmai/Makefile                        |    5 +
>  drivers/bcmai/b43_pci_ai_bridge.c             |   33 ++
>  drivers/bcmai/bcmai_private.h                 |   41 ++
>  drivers/bcmai/core.c                          |   52 ++
>  drivers/bcmai/driver_chipcommon.c             |   87 ++++
>  drivers/bcmai/driver_chipcommon_pmu.c         |  134 +++++
>  drivers/bcmai/driver_pci.c                    |  191 ++++++++
>  drivers/bcmai/host_pci.c                      |  177 +++++++
>  drivers/bcmai/main.c                          |  249 ++++++++++
>  drivers/bcmai/scan.c                          |  383 +++++++++++++++
>  drivers/bcmai/scan.h                          |   53 ++
>  include/linux/bcmai/bcmai.h                   |  210 ++++++++
>  include/linux/bcmai/bcmai_driver_chipcommon.h |  644  
> +++++++++++++++++++++++++
>  include/linux/bcmai/bcmai_driver_pci.h        |   92 ++++
>  include/linux/bcmai/bcmai_regs.h              |   34 ++
>  include/linux/mod_devicetable.h               |   15 +
>  scripts/mod/file2alias.c                      |   20 +
>  20 files changed, 2453 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/bcmai/Kconfig
>  create mode 100644 drivers/bcmai/Makefile
>  create mode 100644 drivers/bcmai/b43_pci_ai_bridge.c
>  create mode 100644 drivers/bcmai/bcmai_private.h
>  create mode 100644 drivers/bcmai/core.c
>  create mode 100644 drivers/bcmai/driver_chipcommon.c
>  create mode 100644 drivers/bcmai/driver_chipcommon_pmu.c
>  create mode 100644 drivers/bcmai/driver_pci.c
>  create mode 100644 drivers/bcmai/host_pci.c
>  create mode 100644 drivers/bcmai/main.c
>  create mode 100644 drivers/bcmai/scan.c
>  create mode 100644 drivers/bcmai/scan.h
>  create mode 100644 include/linux/bcmai/bcmai.h
>  create mode 100644 include/linux/bcmai/bcmai_driver_chipcommon.h
>  create mode 100644 include/linux/bcmai/bcmai_driver_pci.h
>  create mode 100644 include/linux/bcmai/bcmai_regs.h
>
> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 177c7d1..a1d9198 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
>
>  source "drivers/ssb/Kconfig"
>
> +source "drivers/bcmai/Kconfig"
> +

Probably a different name would be better. bcm suggests this is broadcom  
specific, but it is hardware functionality provided by ARM. Suggestions:  
axi, axidmp,amba_axi.

>  source "drivers/mfd/Kconfig"
>
>  source "drivers/regulator/Kconfig"
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 3f135b6..dcd102c 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_HID)           += hid/
>  obj-$(CONFIG_PPC_PS3)          += ps3/
>  obj-$(CONFIG_OF)               += of/
>  obj-$(CONFIG_SSB)              += ssb/
> +obj-$(CONFIG_BCMAI)            += bcmai/
>  obj-$(CONFIG_VHOST_NET)                += vhost/
>  obj-$(CONFIG_VLYNQ)            += vlynq/
>  obj-$(CONFIG_STAGING)          += staging/
> diff --git a/drivers/bcmai/Kconfig b/drivers/bcmai/Kconfig
> new file mode 100644
> index 0000000..36b3995
> --- /dev/null
> +++ b/drivers/bcmai/Kconfig
> @@ -0,0 +1,30 @@
> +config BCMAI_POSSIBLE
> +       bool
> +       depends on HAS_IOMEM && HAS_DMA
> +       default y
> +
> +menu "Broadcom's AI"
> +       depends on BCMAI_POSSIBLE
> +
> +config BCMAI
> +       tristate "AI support"
> +       depends on BCMAI_POSSIBLE
> +
> +config BCMAI_HOST_PCI_POSSIBLE
> +       bool
> +       depends on BCMAI && PCI = y
> +       default y
> +
> +config BCMAI_HOST_PCI
> +       bool "Support for AI on PCI-host bus"
> +       depends on BCMAI_HOST_PCI_POSSIBLE
> +
> +config BCMAI_DEBUG
> +       bool "BCMAI debugging"
> +       depends on BCMAI
> +       help
> +         This turns on additional debugging messages.
> +
> +         If unsure, say N
> +
> +endmenu
> diff --git a/drivers/bcmai/Makefile b/drivers/bcmai/Makefile
> new file mode 100644
> index 0000000..02bed60
> --- /dev/null
> +++ b/drivers/bcmai/Makefile
> @@ -0,0 +1,5 @@
> +bcmai-y                                        += main.o scan.o core.o
> +bcmai-y                                        += driver_chipcommon.o  
> driver_chipcommon_pmu.o
> +bcmai-y                                        += driver_pci.o
> +bcmai-$(CONFIG_BCMAI_HOST_PCI)         += host_pci.o b43_pci_ai_bridge.o

Is the file b43_pci_ai_bridge.c specific for b43 driver or should it list  
all pci devices known to have chip with this AMBA AXI DMP plugin?

> +obj-$(CONFIG_BCMAI)                    += bcmai.o
> diff --git a/drivers/bcmai/b43_pci_ai_bridge.c  
> b/drivers/bcmai/b43_pci_ai_bridge.c
> new file mode 100644
> index 0000000..6fcfb96
> --- /dev/null
> +++ b/drivers/bcmai/b43_pci_ai_bridge.c
> @@ -0,0 +1,33 @@
> +/*
> + * Broadcom 43xx PCI-AI bridge module
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "bcmai_private.h"
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +#include <linux/pci.h>
> +
> +static const struct pci_device_id b43_pci_ai_bridge_tbl[] = {
> +       { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
> +       { PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
> +       { 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, b43_pci_ai_bridge_tbl);
> +
> +static struct pci_driver b43_pci_ai_bridge_driver = {
> +       .name = "b43-pci-ai-bridge",
> +       .id_table = b43_pci_ai_bridge_tbl,
> +};
> +
> +int __init b43_pci_ai_bridge_init(void)
> +{
> +       return bcmai_host_pci_register(&b43_pci_ai_bridge_driver);
> +}
> +
> +void __exit b43_pci_ai_bridge_exit(void)
> +{
> +       bcmai_host_pci_unregister(&b43_pci_ai_bridge_driver);
> +}
> diff --git a/drivers/bcmai/bcmai_private.h  
> b/drivers/bcmai/bcmai_private.h
> new file mode 100644
> index 0000000..5712c8b
> --- /dev/null
> +++ b/drivers/bcmai/bcmai_private.h
> @@ -0,0 +1,41 @@
> +#ifndef LINUX_AI_PRIVATE_H_
> +#define LINUX_AI_PRIVATE_H_
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#include <linux/pci.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/types.h>
> +
> +#define BCMAI_ADDR_BASE                0x18000000
> +#define BCMAI_WRAP_BASE                0x18100000
> +
> +#define BCMAI_CORE_SIZE                0x1000
> +
> +struct bcmai_bus;
> +
> +/* main.c */
> +extern int bcmai_bus_register(struct bcmai_bus *bus);
> +extern void bcmai_bus_unregister(struct bcmai_bus *bus);
> +
> +/* scan.c */
> +int bcmai_bus_scan(struct bcmai_bus *bus);
> +
> +#ifdef CONFIG_BCMAI_HOST_PCI
> +/* b43_pci_ai_bridge.c */
> +extern int __init b43_pci_ai_bridge_init(void);
> +extern void __exit b43_pci_ai_bridge_exit(void);
> +
> +/* host_pci.c */
> +extern int bcmai_host_pci_register(struct pci_driver *driver);
> +static inline void bcmai_host_pci_unregister(struct pci_driver *driver)
> +{
> +       pci_unregister_driver(driver);
> +}
> +#endif /* CONFIG_BCMAI_HOST_PCI */
> +
> +#endif
> diff --git a/drivers/bcmai/core.c b/drivers/bcmai/core.c
> new file mode 100644
> index 0000000..2f5d844
> --- /dev/null
> +++ b/drivers/bcmai/core.c
> @@ -0,0 +1,52 @@
> +/*
> + * Broadcom's AI
> + * Core ops
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "bcmai_private.h"
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +
> +bool bcmai_core_is_enabled(struct bcmai_device *core)
> +{
> +       if ((bcmai_aread32(core, BCMAI_IOCTL) & (BCMAI_IOCTL_CLK |  
> BCMAI_IOCTL_FGC)) != BCMAI_IOCTL_CLK)
> +               return false;
> +       if (bcmai_aread32(core, BCMAI_RESET_CTL) & BCMAI_RESET_CTL_RESET)
> +               return false;
> +       return true;
> +}
> +EXPORT_SYMBOL(bcmai_core_is_enabled);
> +
> +static void bcmai_core_disable(struct bcmai_device *core, u32 flags)
> +{
> +       if (bcmai_aread32(core, BCMAI_RESET_CTL) & BCMAI_RESET_CTL_RESET)
> +               return;
> +
> +       bcmai_awrite32(core, BCMAI_IOCTL, flags);
> +       bcmai_aread32(core, BCMAI_IOCTL);
> +       udelay(10);
> +
> +       bcmai_awrite32(core, BCMAI_RESET_CTL, BCMAI_RESET_CTL_RESET);
> +       udelay(1);
> +}
> +
> +int bcmai_core_enable(struct bcmai_device *core, u32 flags)
> +{
> +       bcmai_core_disable(core, flags);
> +
> +       bcmai_awrite32(core, BCMAI_IOCTL, (BCMAI_IOCTL_CLK |  
> BCMAI_IOCTL_FGC | flags));
> +       bcmai_aread32(core, BCMAI_IOCTL);
> +
> +       bcmai_awrite32(core, BCMAI_RESET_CTL, 0);
> +       udelay(1);
> +
> +       bcmai_awrite32(core, BCMAI_IOCTL, (BCMAI_IOCTL_CLK | flags));
> +       bcmai_aread32(core, BCMAI_IOCTL);
> +       udelay(1);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(bcmai_core_enable);
> diff --git a/drivers/bcmai/driver_chipcommon.c  
> b/drivers/bcmai/driver_chipcommon.c
> new file mode 100644
> index 0000000..6852cb2
> --- /dev/null
> +++ b/drivers/bcmai/driver_chipcommon.c
> @@ -0,0 +1,87 @@
> +/*
> + * Broadcom's AI
> + * Broadcom ChipCommon core driver
> + *
> + * Copyright 2005, Broadcom Corporation
> + * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +
> +static inline u32 bcmai_cc_write32_masked(struct bcmai_drv_cc *cc, u16  
> offset,
> +                                       u32 mask, u32 value)
> +{
> +       value &= mask;
> +       value |= bcmai_cc_read32(cc, offset) & ~mask;
> +       bcmai_cc_write32(cc, offset, value);
> +
> +       return value;
> +}
> +
> +void bcmai_core_chipcommon_init(struct bcmai_drv_cc *cc)
> +{
> +       if (cc->core->id.rev >= 11)
> +               cc->status = bcmai_cc_read32(cc, BCMAI_CC_CHIPSTAT);
> +       cc->capabilities = bcmai_cc_read32(cc, BCMAI_CC_CAP);
> +       if (cc->core->id.rev >= 35)
> +               cc->capabilities_ext = bcmai_cc_read32(cc,  
> BCMAI_CC_CAP_EXT);
> +
> +       bcmai_cc_write32(cc, 0x58, 0);
> +       bcmai_cc_write32(cc, 0x5C, 0);
> +
> +       if (cc->capabilities & BCMAI_CC_CAP_PMU)
> +               bcmai_pmu_init(cc);
> +       if (cc->capabilities & BCMAI_CC_CAP_PCTL)
> +               bcmai_err("Power control not implemented!\n");
> +}
> +
> +/* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
> +void bcmai_chipco_watchdog_timer_set(struct bcmai_drv_cc *cc, u32 ticks)
> +{
> +       /* instant NMI */
> +       bcmai_cc_write32(cc, BCMAI_CC_WATCHDOG, ticks);
> +}
> +
> +void bcmai_chipco_irq_mask(struct bcmai_drv_cc *cc, u32 mask, u32 value)
> +{
> +       bcmai_cc_write32_masked(cc, BCMAI_CC_IRQMASK, mask, value);
> +}
> +
> +u32 bcmai_chipco_irq_status(struct bcmai_drv_cc *cc, u32 mask)
> +{
> +       return bcmai_cc_read32(cc, BCMAI_CC_IRQSTAT) & mask;
> +}
> +
> +u32 bcmai_chipco_gpio_in(struct bcmai_drv_cc *cc, u32 mask)
> +{
> +       return bcmai_cc_read32(cc, BCMAI_CC_GPIOIN) & mask;
> +}
> +
> +u32 bcmai_chipco_gpio_out(struct bcmai_drv_cc *cc, u32 mask, u32 value)
> +{
> +       return bcmai_cc_write32_masked(cc, BCMAI_CC_GPIOOUT, mask,  
> value);
> +}
> +
> +u32 bcmai_chipco_gpio_outen(struct bcmai_drv_cc *cc, u32 mask, u32  
> value)
> +{
> +       return bcmai_cc_write32_masked(cc, BCMAI_CC_GPIOOUTEN, mask,  
> value);
> +}
> +
> +u32 xbcmai_chipco_gpio_control(struct bcmai_drv_cc *cc, u32 mask, u32  
> value)
> +{
> +       return bcmai_cc_write32_masked(cc, BCMAI_CC_GPIOCTL, mask,  
> value);
> +}
> +EXPORT_SYMBOL(xbcmai_chipco_gpio_control);
> +
> +u32 bcmai_chipco_gpio_intmask(struct bcmai_drv_cc *cc, u32 mask, u32  
> value)
> +{
> +       return bcmai_cc_write32_masked(cc, BCMAI_CC_GPIOIRQ, mask,  
> value);
> +}
> +
> +u32 bcmai_chipco_gpio_polarity(struct bcmai_drv_cc *cc, u32 mask, u32  
> value)
> +{
> +       return bcmai_cc_write32_masked(cc, BCMAI_CC_GPIOPOL, mask,  
> value);
> +}
> diff --git a/drivers/bcmai/driver_chipcommon_pmu.c  
> b/drivers/bcmai/driver_chipcommon_pmu.c
> new file mode 100644
> index 0000000..0050187
> --- /dev/null
> +++ b/drivers/bcmai/driver_chipcommon_pmu.c
> @@ -0,0 +1,134 @@
> +/*
> + * Broadcom's AI
> + * Broadcom ChipCommon Power Management Unit driver
> + *
> + * Copyright 2009, Michael Buesch <mb@bu3sch.de>
> + * Copyright 2007, Broadcom Corporation
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +
> +static void bcmai_chipco_chipctl_maskset(struct bcmai_drv_cc *cc,
> +                                        u32 offset, u32 mask, u32 set)
> +{
> +       u32 value;
> +
> +       bcmai_cc_read32(cc, BCMAI_CC_CHIPCTL_ADDR);
> +       bcmai_cc_write32(cc, BCMAI_CC_CHIPCTL_ADDR, offset);
> +       bcmai_cc_read32(cc, BCMAI_CC_CHIPCTL_ADDR);
> +       value = bcmai_cc_read32(cc, BCMAI_CC_CHIPCTL_DATA);
> +       value &= mask;
> +       value |= set;
> +       bcmai_cc_write32(cc, BCMAI_CC_CHIPCTL_DATA, value);
> +       bcmai_cc_read32(cc, BCMAI_CC_CHIPCTL_DATA);
> +}
> +
> +static void bcmai_pmu_pll_init(struct bcmai_drv_cc *cc)
> +{
> +       struct bcmai_bus *bus = cc->core->bus;
> +
> +       switch (bus->chipinfo.id) {
> +       case 0x4313:
> +       case 0x4331:
> +       case 43224:
> +       case 43225:
> +               break;
> +       default:
> +               bcmai_err("PLL init unknown for device 0x%04X\n",
> +                         bus->chipinfo.id);
> +       }
> +}
> +
> +static void bcmai_pmu_resources_init(struct bcmai_drv_cc *cc)
> +{
> +       struct bcmai_bus *bus = cc->core->bus;
> +       u32 min_msk = 0, max_msk = 0;
> +
> +       switch (bus->chipinfo.id) {
> +       case 0x4313:
> +               min_msk = 0x200D;
> +               max_msk = 0xFFFF;
> +               break;
> +       case 43224:
> +               break;
> +       default:
> +               bcmai_err("PMU resource config unknown for device  
> 0x%04X\n",
> +                         bus->chipinfo.id);
> +       }
> +
> +       /* Set the resource masks. */
> +       if (min_msk)
> +               bcmai_cc_write32(cc, BCMAI_CC_PMU_MINRES_MSK, min_msk);
> +       if (max_msk)
> +               bcmai_cc_write32(cc, BCMAI_CC_PMU_MAXRES_MSK, max_msk);
> +}
> +
> +void bcmai_pmu_swreg_init(struct bcmai_drv_cc *cc)
> +{
> +       struct bcmai_bus *bus = cc->core->bus;
> +
> +       switch (bus->chipinfo.id) {
> +       case 0x4313:
> +       case 0x4331:
> +       case 43224:
> +               break;
> +       default:
> +               bcmai_err("PMU switch/regulators init unknown for device  
> "
> +                         "0x%04X\n", bus->chipinfo.id);
> +       }
> +}
> +
> +void bcmai_pmu_workarounds(struct bcmai_drv_cc *cc)
> +{
> +       struct bcmai_bus *bus = cc->core->bus;
> +
> +       switch (bus->chipinfo.id) {
> +       case 0x4313:
> +               bcmai_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
> +               break;
> +       case 0x4331:
> +               bcmai_err("Enabling Ext PA lines not implemented\n");
> +               break;
> +       case 43224:
> +               if (bus->chipinfo.rev == 0) {
> +                       bcmai_err("Workarounds for 43224 rev 0 not fully  
> "
> +                                       "implemented\n");
> +                       bcmai_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
> +               } else {
> +                       bcmai_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
> +               }
> +               break;
> +       default:
> +               bcmai_err("Workarounds unknown for device 0x%04X\n",
> +                         bus->chipinfo.id);
> +       }
> +}
> +
> +void bcmai_pmu_init(struct bcmai_drv_cc *cc)
> +{
> +       u32 pmucap;
> +
> +       pmucap = bcmai_cc_read32(cc, BCMAI_CC_PMU_CAP);
> +       cc->pmu.rev = (pmucap & BCMAI_CC_PMU_CAP_REVISION);
> +
> +       bcmai_dbg("Found rev %u PMU (capabilities 0x%08X)\n",  
> cc->pmu.rev,
> +                 pmucap);
> +
> +       if (cc->pmu.rev == 1)
> +               bcmai_cc_mask32(cc, BCMAI_CC_PMU_CTL,
> +                             ~BCMAI_CC_PMU_CTL_NOILPONW);
> +       else
> +               bcmai_cc_set32(cc, BCMAI_CC_PMU_CTL,
> +                            BCMAI_CC_PMU_CTL_NOILPONW);
> +
> +       if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
> +               bcmai_err("Fix for 4329b0 bad LPOM state not  
> implemented!\n");
> +
> +       bcmai_pmu_pll_init(cc);
> +       bcmai_pmu_resources_init(cc);
> +       bcmai_pmu_swreg_init(cc);
> +       bcmai_pmu_workarounds(cc);
> +}
> diff --git a/drivers/bcmai/driver_pci.c b/drivers/bcmai/driver_pci.c
> new file mode 100644
> index 0000000..dca3eb1
> --- /dev/null
> +++ b/drivers/bcmai/driver_pci.c
> @@ -0,0 +1,191 @@
> +/*
> + * Broadcom's AI
> + * PCI Core
> + *
> + * Copyright 2005, Broadcom Corporation
> + * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include <linux/bcmai/bcmai_driver_pci.h>
> +#include "bcmai_private.h"
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +
> +/**************************************************
> + * R/W ops.
> + **************************************************/
> +
> +static inline
> +u32 pcicore_read32(struct bcmai_drv_pci *pc, u16 offset)
> +{
> +       return bcmai_read32(pc->core, offset);
> +}
> +
> +static inline
> +void pcicore_write32(struct bcmai_drv_pci *pc, u16 offset, u32 value)
> +{
> +       bcmai_write32(pc->core, offset, value);
> +}
> +
> +static inline
> +u16 pcicore_read16(struct bcmai_drv_pci *pc, u16 offset)
> +{
> +       return bcmai_read16(pc->core, offset);
> +}
> +
> +static inline
> +void pcicore_write16(struct bcmai_drv_pci *pc, u16 offset, u16 value)
> +{
> +       bcmai_write16(pc->core, offset, value);
> +}
> +
> +static u32 bcmai_pcie_read(struct bcmai_drv_pci *pc, u32 address)
> +{
> +       pcicore_write32(pc, 0x130, address);
> +       pcicore_read32(pc, 0x130);
> +       return pcicore_read32(pc, 0x134);
> +}
> +
> +#if 0
> +static void bcmai_pcie_write(struct bcmai_drv_pci *pc, u32 address, u32  
> data)
> +{
> +       pcicore_write32(pc, 0x130, address);
> +       pcicore_read32(pc, 0x130);
> +       pcicore_write32(pc, 0x134, data);
> +}
> +#endif
> +
> +static void bcmai_pcie_mdio_set_phy(struct bcmai_drv_pci *pc, u8 phy)
> +{
> +       const u16 mdio_control = 0x128;
> +       const u16 mdio_data = 0x12C;
> +       u32 v;
> +       int i;
> +
> +       v = (1 << 30); /* Start of Transaction */
> +       v |= (1 << 28); /* Write Transaction */
> +       v |= (1 << 17); /* Turnaround */
> +       v |= (0x1F << 18);
> +       v |= (phy << 4);
> +       pcicore_write32(pc, mdio_data, v);
> +
> +       udelay(10);
> +       for (i = 0; i < 200; i++) {
> +               v = pcicore_read32(pc, mdio_control);
> +               if (v & 0x100 /* Trans complete */)
> +                       break;
> +               msleep(1);
> +       }
> +}
> +
> +static u16 bcmai_pcie_mdio_read(struct bcmai_drv_pci *pc, u8 device, u8  
> address)
> +{
> +       const u16 mdio_control = 0x128;
> +       const u16 mdio_data = 0x12C;
> +       int max_retries = 10;
> +       u16 ret = 0;
> +       u32 v;
> +       int i;
> +
> +       v = 0x80; /* Enable Preamble Sequence */
> +       v |= 0x2; /* MDIO Clock Divisor */
> +       pcicore_write32(pc, mdio_control, v);
> +
> +       if (pc->core->id.rev >= 10) {
> +               max_retries = 200;
> +               bcmai_pcie_mdio_set_phy(pc, device);
> +       }
> +
> +       v = (1 << 30); /* Start of Transaction */
> +       v |= (1 << 29); /* Read Transaction */
> +       v |= (1 << 17); /* Turnaround */
> +       if (pc->core->id.rev < 10)
> +               v |= (u32)device << 22;
> +       v |= (u32)address << 18;
> +       pcicore_write32(pc, mdio_data, v);
> +       /* Wait for the device to complete the transaction */
> +       udelay(10);
> +       for (i = 0; i < 200; i++) {
> +               v = pcicore_read32(pc, mdio_control);
> +               if (v & 0x100 /* Trans complete */) {
> +                       udelay(10);
> +                       ret = pcicore_read32(pc, mdio_data);
> +                       break;
> +               }
> +               msleep(1);
> +       }
> +       pcicore_write32(pc, mdio_control, 0);
> +       return ret;
> +}
> +
> +static void bcmai_pcie_mdio_write(struct bcmai_drv_pci *pc, u8 device,
> +                               u8 address, u16 data)
> +{
> +       const u16 mdio_control = 0x128;
> +       const u16 mdio_data = 0x12C;
> +       int max_retries = 10;
> +       u32 v;
> +       int i;
> +
> +       v = 0x80; /* Enable Preamble Sequence */
> +       v |= 0x2; /* MDIO Clock Divisor */
> +       pcicore_write32(pc, mdio_control, v);
> +
> +       if (pc->core->id.rev >= 10) {
> +               max_retries = 200;
> +               bcmai_pcie_mdio_set_phy(pc, device);
> +       }
> +
> +       v = (1 << 30); /* Start of Transaction */
> +       v |= (1 << 28); /* Write Transaction */
> +       v |= (1 << 17); /* Turnaround */
> +       if (pc->core->id.rev < 10)
> +               v |= (u32)device << 22;
> +       v |= (u32)address << 18;
> +       v |= data;
> +       pcicore_write32(pc, mdio_data, v);
> +       /* Wait for the device to complete the transaction */
> +       udelay(10);
> +       for (i = 0; i < max_retries; i++) {
> +               v = pcicore_read32(pc, mdio_control);
> +               if (v & 0x100 /* Trans complete */)
> +                       break;
> +               msleep(1);
> +       }
> +       pcicore_write32(pc, mdio_control, 0);
> +}
> +
> +/**************************************************
> + * Workarounds.
> + **************************************************/
> +
> +static u8 bcmai_pcicore_polarity_workaround(struct bcmai_drv_pci *pc)
> +{
> +       return (bcmai_pcie_read(pc, 0x204) & 0x10) ? 0xC0 : 0x80;
> +}
> +
> +static void bcmai_pcicore_serdes_workaround(struct bcmai_drv_pci *pc)
> +{
> +       const u8 serdes_pll_device = 0x1D;
> +       const u8 serdes_rx_device = 0x1F;
> +       u16 tmp;
> +
> +       bcmai_pcie_mdio_write(pc, serdes_rx_device, 1 /* Control */,
> +                             bcmai_pcicore_polarity_workaround(pc));
> +       tmp = bcmai_pcie_mdio_read(pc, serdes_pll_device, 1 /* Control  
> */);
> +       if (tmp & 0x4000)
> +               bcmai_pcie_mdio_write(pc, serdes_pll_device, 1, tmp &  
> ~0x4000);
> +}
> +
> +/**************************************************
> + * Init.
> + **************************************************/
> +
> +void bcmai_core_pci_init(struct bcmai_drv_pci *pc)
> +{
> +       bcmai_pcicore_serdes_workaround(pc);
> +}
> diff --git a/drivers/bcmai/host_pci.c b/drivers/bcmai/host_pci.c
> new file mode 100644
> index 0000000..5659e95
> --- /dev/null
> +++ b/drivers/bcmai/host_pci.c
> @@ -0,0 +1,177 @@
> +/*
> + * Broadcom's AI
> + * PCI Host
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "bcmai_private.h"
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +
> +static void bcmai_host_pci_switch_core(struct bcmai_device *core)
> +{
> +       pci_write_config_dword(core->bus->host_pci, BCMAI_PCI_BAR0_WIN,
> +                              core->addr);
> +       pci_write_config_dword(core->bus->host_pci, BCMAI_PCI_BAR0_WIN2,
> +                              core->wrap);
> +       core->bus->mapped_core = core;
> +       bcmai_dbg("Switched to core: 0x%X\n", core->id.id);
> +}
> +
> +static u8 bcmai_host_pci_read8(struct bcmai_device *core, u16 offset)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       return ioread8(core->bus->mmio + offset);
> +}
> +
> +static u16 bcmai_host_pci_read16(struct bcmai_device *core, u16 offset)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       return ioread16(core->bus->mmio + offset);
> +}
> +
> +static u32 bcmai_host_pci_read32(struct bcmai_device *core, u16 offset)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       return ioread32(core->bus->mmio + offset);
> +}
> +
> +static void bcmai_host_pci_write8(struct bcmai_device *core, u16  
> offset, u8 value)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       iowrite8(value, core->bus->mmio + offset);
> +}
> +
> +static void bcmai_host_pci_write16(struct bcmai_device *core, u16  
> offset, u16 value)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       iowrite16(value, core->bus->mmio + offset);
> +}
> +
> +static void bcmai_host_pci_write32(struct bcmai_device *core, u16  
> offset, u32 value)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       iowrite32(value, core->bus->mmio + offset);
> +}
> +
> +static u32 bcmai_host_pci_aread32(struct bcmai_device *core, u16 offset)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       return ioread32(core->bus->mmio + 0x1000 + offset);
> +}

Maybe you can replace the 0x1000 with BCMAI_CORE_SIZE (if that was the  
correct define).

> +static void bcmai_host_pci_awrite32(struct bcmai_device *core, u16  
> offset, u32 value)
> +{
> +       if (unlikely(core->bus->mapped_core != core))
> +               bcmai_host_pci_switch_core(core);
> +       iowrite32(value, core->bus->mmio + 0x1000 + offset);
> +}
> +
> +const struct bcmai_host_ops bcmai_host_pci_ops = {
> +       .read8          = bcmai_host_pci_read8,
> +       .read16         = bcmai_host_pci_read16,
> +       .read32         = bcmai_host_pci_read32,
> +       .write8         = bcmai_host_pci_write8,
> +       .write16        = bcmai_host_pci_write16,
> +       .write32        = bcmai_host_pci_write32,
> +       .aread32        = bcmai_host_pci_aread32,
> +       .awrite32       = bcmai_host_pci_awrite32,
> +};
> +
> +static int bcmai_host_pci_probe(struct pci_dev *dev,
> +                            const struct pci_device_id *id)
> +{
> +       struct bcmai_bus *bus;
> +       int err = -ENOMEM;
> +       const char *name;
> +       u32 val;
> +
> +       /* Alloc */
> +       bus = kzalloc(sizeof(*bus), GFP_KERNEL);
> +       if (!bus)
> +               goto out;
> +
> +       /* Basic PCI configuration */
> +       err = pci_enable_device(dev);
> +       if (err)
> +               goto err_kfree_bus;
> +
> +       name = dev_name(&dev->dev);
> +       if (dev->driver && dev->driver->name)
> +               name = dev->driver->name;
> +       err = pci_request_regions(dev, name);
> +       if (err)
> +               goto err_pci_disable;
> +       pci_set_master(dev);
> +
> +       /* Disable the RETRY_TIMEOUT register (0x41) to keep
> +        * PCI Tx retries from interfering with C3 CPU state */
> +       pci_read_config_dword(dev, 0x40, &val);
> +       if ((val & 0x0000ff00) != 0)
> +               pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
> +
> +       /* SSB needed additional powering up, do we have any AI PCI  
> cards? */
> +       if (!pci_is_pcie(dev))
> +               bcmai_err("PCI card detected, report problems.\n");

Not that I know off with Broadcom chips. Can ask around here, but I don't  
know about other manufacturers. Not even sure if there are others using  
the AMBA AXI DMP functionality.

> +       /* Map MMIO */
> +       err = -ENOMEM;
> +       bus->mmio = pci_iomap(dev, 0, ~0UL);
> +       if (!bus->mmio)
> +               goto err_pci_release_regions;
> +
> +       /* Host specific */
> +       bus->host_pci = dev;
> +       bus->hosttype = BCMAI_HOSTTYPE_PCI;
> +       bus->ops = &bcmai_host_pci_ops;
> +
> +       /* Register */
> +       err = bcmai_bus_register(bus);
> +       if (err)
> +               goto err_pci_unmap_mmio;
> +
> +       pci_set_drvdata(dev, bus);
> +
> +out:
> +       return err;
> +
> +err_pci_unmap_mmio:
> +       pci_iounmap(dev, bus->mmio);
> +err_pci_release_regions:
> +       pci_release_regions(dev);
> +err_pci_disable:
> +       pci_disable_device(dev);
> +err_kfree_bus:
> +       kfree(bus);
> +       return err;
> +}
> +
> +static void bcmai_host_pci_remove(struct pci_dev *dev)
> +{
> +       struct bcmai_bus *bus = pci_get_drvdata(dev)
> +
> +       bcmai_bus_unregister(bus);
> +       pci_iounmap(dev, bus->mmio);
> +       pci_release_regions(dev);
> +       pci_disable_device(dev);
> +       kfree(bus);
> +       pci_set_drvdata(dev, NULL);
> +}
> +
> +int bcmai_host_pci_register(struct pci_driver *driver)
> +{
> +       driver->probe = bcmai_host_pci_probe;
> +       driver->remove = bcmai_host_pci_remove;
> +
> +       return pci_register_driver(driver);
> +}
> +EXPORT_SYMBOL(bcmai_host_pci_register);
> diff --git a/drivers/bcmai/main.c b/drivers/bcmai/main.c
> new file mode 100644
> index 0000000..f76ad32
> --- /dev/null
> +++ b/drivers/bcmai/main.c
> @@ -0,0 +1,249 @@
> +/*
> + * Broadcom's AI
> + * Bus subsystem
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "bcmai_private.h"
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +
> +MODULE_DESCRIPTION("AI driver");
> +MODULE_LICENSE("GPL");
> +
> +static int bcmai_bus_match(struct device *dev, struct device_driver  
> *drv);
> +static int bcmai_device_probe(struct device *dev);
> +static int bcmai_device_remove(struct device *dev);
> +
> +static ssize_t manuf_show(struct device *dev, struct device_attribute  
> *attr, char *buf)
> +{
> +       struct bcmai_device *core = container_of(dev, struct  
> bcmai_device, dev);
> +       return sprintf(buf, "0x%03X", core->id.manuf);
> +}
> +static ssize_t id_show(struct device *dev, struct device_attribute  
> *attr, char *buf)
> +{
> +       struct bcmai_device *core = container_of(dev, struct  
> bcmai_device, dev);
> +       return sprintf(buf, "0x%03X", core->id.id);
> +}
> +static ssize_t rev_show(struct device *dev, struct device_attribute  
> *attr, char *buf)
> +{
> +       struct bcmai_device *core = container_of(dev, struct  
> bcmai_device, dev);
> +       return sprintf(buf, "0x%02X", core->id.rev);
> +}
> +static struct device_attribute bcmai_device_attrs[] = {
> +       __ATTR_RO(manuf),
> +       __ATTR_RO(id),
> +       __ATTR_RO(rev),
> +       __ATTR_NULL,
> +};
> +
> +static struct bus_type bcmai_bus_type = {
> +       .name           = "bcmai",
> +       .match          = bcmai_bus_match,
> +       .probe          = bcmai_device_probe,
> +       .remove         = bcmai_device_remove,
> +       .dev_attrs      = bcmai_device_attrs,
> +};
> +
> +static struct bcmai_device *bcmai_find_core(struct bcmai_bus *bus, u16  
> coreid)
> +{
> +       u8 i;
> +       for (i = 0; i < bus->nr_cores; i++) {
> +               if (bus->cores[i].id.id == coreid)
> +                       return &bus->cores[i];
> +       }
> +       return NULL;
> +}
> +
> +static void bcmai_release_core_dev(struct device *dev)
> +{
> +       kfree(dev);
> +}
> +
> +static int bcmai_register_cores(struct bcmai_bus *bus)
> +{
> +       struct bcmai_device *core;
> +       int i, err, dev_id = 0;
> +
> +       for (i = 0; i < bus->nr_cores; i++) {
> +               core = &(bus->cores[i]);
> +
> +               /* We support that cores ourself */
> +               switch (core->id.id) {
> +               case BCMAI_CORE_CHIPCOMMON:
> +               case BCMAI_CORE_PCI:
> +               case BCMAI_CORE_PCIE:
> +                       continue;
> +               }
> +
> +               core->dev.release = bcmai_release_core_dev;
> +               core->dev.bus = &bcmai_bus_type;
> +               dev_set_name(&core->dev, "ssbX:%d", /*bus->busnumber,*/  
> dev_id);

The device name should probably start with something other than 'ssb' ;-)

> +               switch (bus->hosttype) {
> +               case BCMAI_HOSTTYPE_PCI:
> +                       core->dev.parent = &bus->host_pci->dev;
> +                       break;
> +               case BCMAI_HOSTTYPE_NONE:
> +               case BCMAI_HOSTTYPE_SDIO:
> +                       break;
> +               }
> +
> +               err = device_register(&core->dev);
> +               if (err) {
> +                       bcmai_err("Could not register dev for core  
> 0x%03X\n",
> +                                 core->id.id);
> +                       core->dev.release = NULL;
> +                       core->dev.bus = NULL;
> +                       core->dev.parent = NULL;
> +                       continue;
> +               }
> +               dev_id++;
> +       }
> +
> +       return 0;
> +}
> +
> +static void bcmai_unregister_cores(struct bcmai_bus *bus)
> +{
> +       struct bcmai_device *core;
> +       int i;
> +
> +       for (i = 0; i < bus->nr_cores; i++) {
> +               core = &(bus->cores[i]);
> +               if (core->dev.bus)
> +                       device_unregister(&core->dev);
> +       }
> +}
> +
> +int bcmai_bus_register(struct bcmai_bus *bus)
> +{
> +       int err;
> +       struct bcmai_device *core;
> +
> +       /* Scan for devices (cores) */
> +       err = bcmai_bus_scan(bus);
> +       if (err) {
> +               bcmai_err("Failed to scan: %d\n", err);
> +               return -1;
> +       }
> +
> +       /* Init CC core */
> +       core = bcmai_find_core(bus, BCMAI_CORE_CHIPCOMMON);
> +       if (core) {
> +               bus->drv_cc.core = core;
> +               bcmai_core_chipcommon_init(&bus->drv_cc);
> +       }
> +
> +       /* Init PCIE core */
> +       core = bcmai_find_core(bus, BCMAI_CORE_PCIE);
> +       if (core) {
> +               bus->drv_pci.core = core;
> +               bcmai_core_pci_init(&bus->drv_pci);
> +       }
> +
> +       /* Register found cores */
> +       bcmai_register_cores(bus);
> +
> +       bcmai_info("Broadcom's AI registered");
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(bcmai_bus_register);
> +
> +void bcmai_bus_unregister(struct bcmai_bus *bus)
> +{
> +       bcmai_unregister_cores(bus);
> +}
> +EXPORT_SYMBOL(bcmai_bus_unregister);
> +
> +int __bcmai_driver_register(struct bcmai_driver *drv, struct module  
> *owner)
> +{
> +       drv->drv.name = drv->name;
> +       drv->drv.bus = &bcmai_bus_type;
> +       drv->drv.owner = owner;
> +
> +       return driver_register(&drv->drv);
> +}
> +EXPORT_SYMBOL(__bcmai_driver_register);
> +
> +void bcmai_driver_unregister(struct bcmai_driver *drv)
> +{
> +       driver_unregister(&drv->drv);
> +}
> +EXPORT_SYMBOL(bcmai_driver_unregister);
> +
> +static int bcmai_bus_match(struct device *dev, struct device_driver  
> *drv)
> +{
> +       struct bcmai_device *core = container_of(dev, struct  
> bcmai_device, dev);
> +       struct bcmai_driver *bdrv = container_of(drv, struct  
> bcmai_driver, drv);
> +       const struct bcmai_device_id *id;
> +
> +       for (id = bdrv->id_table; id->manuf || id->id || id->rev; id++) {
> +               if (core->id.manuf == id->manuf &&
> +                   core->id.id == id->id &&
> +                   core->id.rev == id->rev)
> +                       return 1;
> +       }
> +       return 0;
> +}
> +
> +static int bcmai_device_probe(struct device *dev)
> +{
> +       struct bcmai_device *core = container_of(dev, struct  
> bcmai_device, dev);
> +       struct bcmai_driver *bdrv = container_of(dev->driver, struct  
> bcmai_driver, drv);
> +       int err = 0;
> +
> +       if (bdrv->probe)
> +               err = bdrv->probe(core);
> +
> +       return err;
> +}
> +
> +static int bcmai_device_remove(struct device *dev)
> +{
> +       struct bcmai_device *core = container_of(dev, struct  
> bcmai_device, dev);
> +       struct bcmai_driver *bdrv = container_of(dev->driver, struct  
> bcmai_driver, drv);
> +
> +       if (bdrv->remove)
> +               bdrv->remove(core);
> +
> +       return 0;
> +}
> +
> +static int __init bcmai_modinit(void)
> +{
> +       int err;
> +
> +       err = bus_register(&bcmai_bus_type);
> +       if (err)
> +               return err;
> +
> +#ifdef CONFIG_BCMAI_HOST_PCI
> +       err = b43_pci_ai_bridge_init();
> +       if (err) {
> +               bcmai_err("Broadcom 43xx PCI-AI-bridge initialization "
> +                         "failed\n");
> +               err = 0;
> +       }
> +#endif
> +
> +       return err;
> +}
> +fs_initcall(bcmai_modinit);
> +
> +static void __exit bcmai_modexit(void)
> +{
> +#ifdef CONFIG_BCMAI_HOST_PCI
> +       b43_pci_ai_bridge_exit();
> +#endif
> +       bus_unregister(&bcmai_bus_type);
> +}
> +module_exit(bcmai_modexit)
> diff --git a/drivers/bcmai/scan.c b/drivers/bcmai/scan.c
> new file mode 100644
> index 0000000..ca1692e
> --- /dev/null
> +++ b/drivers/bcmai/scan.c
> @@ -0,0 +1,383 @@
> +/*
> + * Broadcom's AI
> + * Bus scanning
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include "scan.h"
> +#include "bcmai_private.h"
> +#include <linux/bcmai/bcmai_driver_chipcommon.h>
> +
> +#include <linux/bcmai/bcmai.h>
> +#include <linux/bcmai/bcmai_regs.h>
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/slab.h>
> +
> +const char *bcmai_device_name(u16 coreid)
> +{
> +       switch (coreid) {
> +       case BCMAI_CORE_OOB_ROUTER:
> +               return "OOB Router";
> +       case BCMAI_CORE_INVALID:
> +               return "Invalid";
> +       case BCMAI_CORE_CHIPCOMMON:
> +               return "ChipCommon";
> +       case BCMAI_CORE_ILINE20:
> +               return "ILine 20";
> +       case BCMAI_CORE_SRAM:
> +               return "SRAM";
> +       case BCMAI_CORE_SDRAM:
> +               return "SDRAM";
> +       case BCMAI_CORE_PCI:
> +               return "PCI";
> +       case BCMAI_CORE_MIPS:
> +               return "MIPS";
> +       case BCMAI_CORE_ETHERNET:
> +               return "Fast Ethernet";
> +       case BCMAI_CORE_V90:
> +               return "V90";
> +       case BCMAI_CORE_USB11_HOSTDEV:
> +               return "USB 1.1 Hostdev";
> +       case BCMAI_CORE_ADSL:
> +               return "ADSL";
> +       case BCMAI_CORE_ILINE100:
> +               return "ILine 100";
> +       case BCMAI_CORE_IPSEC:
> +               return "IPSEC";
> +       case BCMAI_CORE_UTOPIA:
> +               return "UTOPIA";
> +       case BCMAI_CORE_PCMCIA:
> +               return "PCMCIA";
> +       case BCMAI_CORE_INTERNAL_MEM:
> +               return "Internal Memory";
> +       case BCMAI_CORE_MEMC_SDRAM:
> +               return "MEMC SDRAM";
> +       case BCMAI_CORE_OFDM:
> +               return "OFDM";
> +       case BCMAI_CORE_EXTIF:
> +               return "EXTIF";
> +       case BCMAI_CORE_80211:
> +               return "IEEE 802.11";
> +       case BCMAI_CORE_PHY_A:
> +               return "PHY A";
> +       case BCMAI_CORE_PHY_B:
> +               return "PHY B";
> +       case BCMAI_CORE_PHY_G:
> +               return "PHY G";
> +       case BCMAI_CORE_MIPS_3302:
> +               return "MIPS 3302";
> +       case BCMAI_CORE_USB11_HOST:
> +               return "USB 1.1 Host";
> +       case BCMAI_CORE_USB11_DEV:
> +               return "USB 1.1 Device";
> +       case BCMAI_CORE_USB20_HOST:
> +               return "USB 2.0 Host";
> +       case BCMAI_CORE_USB20_DEV:
> +               return "USB 2.0 Device";
> +       case BCMAI_CORE_SDIO_HOST:
> +               return "SDIO Host";
> +       case BCMAI_CORE_ROBOSWITCH:
> +               return "Roboswitch";
> +       case BCMAI_CORE_PARA_ATA:
> +               return "PATA";
> +       case BCMAI_CORE_SATA_XORDMA:
> +               return "SATA XOR-DMA";
> +       case BCMAI_CORE_ETHERNET_GBIT:
> +               return "GBit Ethernet";
> +       case BCMAI_CORE_PCIE:
> +               return "PCIe";
> +       case BCMAI_CORE_PHY_N:
> +               return "PHY N";
> +       case BCMAI_CORE_SRAM_CTL:
> +               return "SRAM Controller";
> +       case BCMAI_CORE_MINI_MACPHY:
> +               return "Mini MACPHY";
> +       case BCMAI_CORE_ARM_1176:
> +               return "ARM 1176";
> +       case BCMAI_CORE_ARM_7TDMI:
> +               return "ARM 7TDMI";
> +       case BCMAI_CORE_PHY_LP:
> +               return "PHY LP";
> +       case BCMAI_CORE_PMU:
> +               return "PMU";
> +       case BCMAI_CORE_PHY_SSN:
> +               return "PHY SSN";
> +       case BCMAI_CORE_SDIO_DEV:
> +               return "SDIO Device";
> +       case BCMAI_CORE_ARM_CM3:
> +               return "ARM CM3";
> +       case BCMAI_CORE_PHY_HT:
> +               return "PHY HT";
> +       case BCMAI_CORE_MIPS_74K:
> +               return "MIPS 74K";
> +       case BCMAI_CORE_MAC_GBIT:
> +               return "GBit MAC";
> +       case BCMAI_CORE_DDR12_MEM_CTL:
> +               return "DDR1/DDR2 Memory Controller";
> +       case BCMAI_CORE_PCIE_RC:
> +               return "PCIe Root Complex";
> +       case BCMAI_CORE_OCP_OCP_BRIDGE:
> +               return "OCP to OCP Bridge";
> +       case BCMAI_CORE_SHARED_COMMON:
> +               return "Common Shared";
> +       case BCMAI_CORE_OCP_AHB_BRIDGE:
> +               return "OCP to AHB Bridge";
> +       case BCMAI_CORE_SPI_HOST:
> +               return "SPI Host";
> +       case BCMAI_CORE_I2S:
> +               return "I2S";
> +       case BCMAI_CORE_SDR_DDR1_MEM_CTL:
> +               return "SDR/DDR1 Memory Controller";
> +       case BCMAI_CORE_SHIM:
> +               return "SHIM";
> +       case BCMAI_CORE_DEFAULT:
> +               return "Default";
> +       }
> +       return "UNKNOWN";
> +}
> +
> +static u32 bcmai_scan_read32(struct bcmai_bus *bus, u8 current_coreidx,
> +                      u16 offset)
> +{
> +       return readl(bus->mmio + offset);
> +}

I have seen both ioread32() and readl() in this patch. Are these doing the  
same thing?

> +static void bcmai_scan_switch_core(struct bcmai_bus *bus, u32 addr)
> +{
> +       if (bus->hosttype == BCMAI_HOSTTYPE_PCI)
> +               pci_write_config_dword(bus->host_pci, BCMAI_PCI_BAR0_WIN,
> +                                      addr);
> +}
> +
> +static u32 bcmai_erom_get_ent(struct bcmai_bus *bus, u32 **eromptr)
> +{
> +       u32 ent = readl(*eromptr);
> +       (*eromptr)++;
> +       return ent;
> +}
> +
> +static void bcmai_erom_push_ent(u32 **eromptr)
> +{
> +       (*eromptr)--;
> +}
> +
> +static s32 bcmai_erom_get_ci(struct bcmai_bus *bus, u32 **eromptr)
> +{
> +       u32 ent = bcmai_erom_get_ent(bus, eromptr);
> +       if (!(ent & SCAN_ER_VALID))
> +               return -1;
> +       if ((ent & SCAN_ER_TAG) != SCAN_ER_TAG_CI)
> +               return -2;
> +       return ent;
> +}
> +
> +static bool bcmai_erom_is_end(struct bcmai_bus *bus, u32 **eromptr)
> +{
> +       u32 ent = bcmai_erom_get_ent(bus, eromptr);
> +       bcmai_erom_push_ent(eromptr);
> +       return (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID));
> +}
> +
> +static bool bcmai_erom_is_bridge(struct bcmai_bus *bus, u32 **eromptr)
> +{
> +       u32 ent = bcmai_erom_get_ent(bus, eromptr);
> +       bcmai_erom_push_ent(eromptr);
> +       return (((ent & SCAN_ER_VALID)) &&
> +               ((ent & SCAN_ER_TAGX) == SCAN_ER_TAG_ADDR) &&
> +               ((ent & SCAN_ADDR_TYPE) == SCAN_ADDR_TYPE_BRIDGE));
> +}
> +
> +static void bcmai_erom_skip_component(struct bcmai_bus *bus, u32  
> **eromptr)
> +{
> +       u32 ent;
> +       while (1) {
> +               ent = bcmai_erom_get_ent(bus, eromptr);
> +               if ((ent & SCAN_ER_VALID) && ((ent & SCAN_ER_TAG) ==  
> SCAN_ER_TAG_CI))
> +                       break;
> +               if (ent == (SCAN_ER_TAG_END | SCAN_ER_VALID))
> +                       break;
> +       }
> +       bcmai_erom_push_ent(eromptr);
> +}
> +
> +static s32 bcmai_erom_get_mst_port(struct bcmai_bus *bus, u32 **eromptr)
> +{
> +       u32 ent = bcmai_erom_get_ent(bus, eromptr);
> +       if (!(ent & SCAN_ER_VALID))
> +               return -1;
> +       if ((ent & SCAN_ER_TAG) != SCAN_ER_TAG_MP)
> +               return -2;
> +       return ent;
> +}
> +
> +static s32 bcmai_erom_get_addr_desc(struct bcmai_bus *bus, u32  
> **eromptr, u32 type, u8 port)
> +{
> +       u32 addrl, addrh, sizel, sizeh = 0;
> +       u32 size;
> +
> +       u32 ent = bcmai_erom_get_ent(bus, eromptr);
> +       if ((!(ent & SCAN_ER_VALID)) ||
> +           ((ent & SCAN_ER_TAGX) != SCAN_ER_TAG_ADDR) ||
> +           ((ent & SCAN_ADDR_TYPE) != type) ||
> +           (((ent & SCAN_ADDR_PORT) >> SCAN_ADDR_PORT_SHIFT) != port)) {
> +               bcmai_erom_push_ent(eromptr);
> +               return -1;
> +       }
> +
> +       addrl = ent & SCAN_ADDR_ADDR;
> +       if (ent & SCAN_ADDR_AG32)
> +               addrh = bcmai_erom_get_ent(bus, eromptr);
> +       else
> +               addrh = 0;
> +
> +       if ((ent & SCAN_ADDR_SZ) == SCAN_ADDR_SZ_SZD) {
> +               size = bcmai_erom_get_ent(bus, eromptr);
> +               sizel = size & SCAN_SIZE_SZ;
> +               if (size & SCAN_SIZE_SG32)
> +                       sizeh = bcmai_erom_get_ent(bus, eromptr);
> +       } else
> +               sizel = SCAN_ADDR_SZ_BASE << ((ent & SCAN_ADDR_SZ) >>  
> SCAN_ADDR_SZ_SHIFT);
> +
> +       return addrl;
> +}
> +
> +int bcmai_bus_scan(struct bcmai_bus *bus)
> +{
> +       u32 erombase;
> +       u32 __iomem *eromptr, *eromend;
> +
> +       s32 cia, cib;
> +       u8 ports[2], wrappers[2];
> +
> +       s32 tmp;
> +       u8 i, j;
> +
> +       bus->nr_cores = 0;
> +
> +       bcmai_scan_switch_core(bus, BCMAI_ADDR_BASE);

Is BCMAI_ADDR_BASE used in other source file in this module? Otherwise, it  
could be defined in this source file only instead of in a header file.

> +       tmp = bcmai_scan_read32(bus, 0, BCMAI_CC_ID);
> +       bus->chipinfo.id = (tmp & BCMAI_CC_ID_ID) >>  
> BCMAI_CC_ID_ID_SHIFT;
> +       bus->chipinfo.rev = (tmp & BCMAI_CC_ID_REV) >>  
> BCMAI_CC_ID_REV_SHIFT;
> +       bus->chipinfo.pkg = (tmp & BCMAI_CC_ID_PKG) >>  
> BCMAI_CC_ID_PKG_SHIFT;
> +
> +       erombase = bcmai_scan_read32(bus, 0, BCMAI_CC_EROM);
> +       eromptr = bus->mmio;
> +       eromend = eromptr + BCMAI_CORE_SIZE / sizeof(u32);
> +
> +       bcmai_scan_switch_core(bus, erombase);
> +
> +       while (eromptr < eromend) {
> +               struct bcmai_device core;
> +               core.bus = bus;
> +
> +               /* get CIs */
> +               cia = bcmai_erom_get_ci(bus, &eromptr);
> +               if (cia < 0) {
> +                       bcmai_erom_push_ent(&eromptr);
> +                       if (bcmai_erom_is_end(bus, &eromptr))
> +                               break;
> +                       return -1;
> +               }
> +               cib = bcmai_erom_get_ci(bus, &eromptr);
> +               if (cib < 0)
> +                       return -2;
> +
> +               /* parse CIs */
> +               core.id.id = (cia & SCAN_CIA_ID) >> SCAN_CIA_ID_SHIFT;
> +               core.id.manuf = (cia & SCAN_CIA_MANUF) >>  
> SCAN_CIA_MANUF_SHIFT;

You can also get the component class here. Next 4 bits in cia.

> +               ports[0] = (cib & SCAN_CIB_NMP) >> SCAN_CIB_NMP_SHIFT;
> +               ports[1] = (cib & SCAN_CIB_NSP) >> SCAN_CIB_NSP_SHIFT;
> +               wrappers[0] = (cib & SCAN_CIB_NMW) >> SCAN_CIB_NMW_SHIFT;
> +               wrappers[1] = (cib & SCAN_CIB_NSW) >> SCAN_CIB_NSW_SHIFT;
> +               core.id.rev = (cib & SCAN_CIB_REV) >> SCAN_CIB_REV_SHIFT;
> +
> +               if (((core.id.manuf == BCMAI_MANUF_ARM) &&
> +                    (core.id.id == 0xFFF)) ||
> +                   (ports[1] == 0)) {
> +                       bcmai_erom_skip_component(bus, &eromptr);
> +                       continue;
> +               }
> +
> +               /* check if component is a core at all */
> +               if (wrappers[0] + wrappers[1] == 0) {
> +                       /* we could save addrl of the router
> +                       if (cid == BCMAI_CORE_OOB_ROUTER)
> +                        */
> +                       bcmai_erom_skip_component(bus, &eromptr);
> +                       continue;
> +               }
> +
> +               if (bcmai_erom_is_bridge(bus, &eromptr)) {
> +                       bcmai_erom_skip_component(bus, &eromptr);
> +                       continue;
> +               }
> +
> +               /* get & parse master ports */
> +               for (i = 0; i < ports[0]; i++) {
> +                       u32 mst_port_d = bcmai_erom_get_mst_port(bus,  
> &eromptr);
> +                       if (mst_port_d < 0)
> +                               return -3;
> +               }
> +
> +               /* get & parse slave ports */
> +               for (i = 0; i < ports[1]; i++) {
> +                       for (j = 0; ; j++) {
> +                               tmp = bcmai_erom_get_addr_desc(bus,  
> &eromptr, SCAN_ADDR_TYPE_SLAVE, i);
> +                               if (tmp < 0) {
> +                                       /* there are not more entries  
> for port _i_ */
> +                                       //bcmai_dbg("erom: slave port %d  
> has %d descriptors\n", i, j);
> +                                       break;
> +                               } else {
> +                                       if (i == 0 && j == 0)
> +                                               core.addr = tmp;
> +                               }
> +                       }
> +               }
> +
> +               /* get & parse master wrappers */
> +               for (i = 0; i < wrappers[0]; i++) {
> +                       for (j = 0; ; j++) {
> +                               tmp = bcmai_erom_get_addr_desc(bus,  
> &eromptr, SCAN_ADDR_TYPE_MWRAP, i);
> +                               if (tmp < 0) {
> +                                       /* there are not more entries  
> for port _i_ */
> +                                       //bcmai_dbg("erom: master  
> wrapper %d has %d descriptors\n", i, j);
> +                                       break;
> +                               } else {
> +                                       if (i == 0 && j == 0)
> +                                               core.wrap = tmp;
> +                               }
> +                       }
> +               }
> +
> +               /* get & parse slave wrappers */
> +               for (i = 0; i < wrappers[1]; i++) {
> +                       u8 hack = (ports[1] == 1) ? 0 : 1;
> +                       for (j = 0; ; j++) {
> +                               tmp = bcmai_erom_get_addr_desc(bus,  
> &eromptr, SCAN_ADDR_TYPE_SWRAP, i + hack);
> +                               if (tmp < 0) {
> +                                       /* there are not more entries  
> for port _i_ */
> +                                       //bcmai_dbg("erom: master  
> wrapper %d has %d descriptors\n", i, j);
> +                                       break;
> +                               } else {
> +                                       if (wrappers[0] == 0 && i == 0  
> && j == 0)
> +                                               core.wrap = tmp;
> +                               }
> +                       }
> +               }
> +
> +               bcmai_info("Core %d found: %s "
> +                          "(manuf 0x%03X, id 0x%03X, rev 0x%02X)\n",
> +                          bus->nr_cores, bcmai_device_name(core.id.id),
> +                          core.id.manuf, core.id.id, core.id.rev);
> +
> +               core.core_index = bus->nr_cores;
> +               bus->cores[bus->nr_cores++] = core;
> +       }
> +
> +       return 0;
> +}
> diff --git a/drivers/bcmai/scan.h b/drivers/bcmai/scan.h
> new file mode 100644
> index 0000000..d970184
> --- /dev/null
> +++ b/drivers/bcmai/scan.h
> @@ -0,0 +1,53 @@
> +#ifndef BCMAI_SCAN_H_
> +#define BCMAI_SCAN_H_
> +
> +#define SCAN_ER_VALID          0x00000001
> +#define SCAN_ER_TAGX           0x00000006 /* we have to ignore 0x8 bit  
> when checking tag for SCAN_ER_TAG_ADDR */
> +#define SCAN_ER_TAG            0x0000000E
> +#define  SCAN_ER_TAG_CI                0x00000000
> +#define  SCAN_ER_TAG_MP                0x00000002
> +#define  SCAN_ER_TAG_ADDR      0x00000004
> +#define  SCAN_ER_TAG_END       0x0000000E
> +#define SCAN_ER_BAD            0xFFFFFFFF
> +
> +#define SCAN_CIA_CCL           0x000000F0
> +#define SCAN_CIA_CCL_SHIFT     4
> +#define SCAN_CIA_ID            0x000FFF00
> +#define SCAN_CIA_ID_SHIFT      8
> +#define SCAN_CIA_MANUF         0xFFF00000
> +#define SCAN_CIA_MANUF_SHIFT   20
> +
> +#define SCAN_CIB_NMP           0x000001F0
> +#define SCAN_CIB_NMP_SHIFT     4
> +#define SCAN_CIB_NSP           0x00003E00
> +#define SCAN_CIB_NSP_SHIFT     9
> +#define SCAN_CIB_NMW           0x0007C000
> +#define SCAN_CIB_NMW_SHIFT     14
> +#define SCAN_CIB_NSW           0x00F80000
> +#define SCAN_CIB_NSW_SHIFT     17
> +#define SCAN_CIB_REV           0xFF000000
> +#define SCAN_CIB_REV_SHIFT     24
> +
> +#define SCAN_ADDR_AG32         0x00000008
> +#define SCAN_ADDR_SZ           0x00000030
> +#define SCAN_ADDR_SZ_SHIFT     4
> +#define  SCAN_ADDR_SZ_4K       0x00000000
> +#define  SCAN_ADDR_SZ_8K       0x00000010
> +#define  SCAN_ADDR_SZ_16K      0x00000020
> +#define  SCAN_ADDR_SZ_SZD      0x00000030
> +#define SCAN_ADDR_TYPE         0x000000C0
> +#define  SCAN_ADDR_TYPE_SLAVE  0x00000000
> +#define  SCAN_ADDR_TYPE_BRIDGE 0x00000040
> +#define  SCAN_ADDR_TYPE_SWRAP  0x00000080
> +#define  SCAN_ADDR_TYPE_MWRAP  0x000000C0
> +#define SCAN_ADDR_PORT         0x00000F00
> +#define SCAN_ADDR_PORT_SHIFT   8
> +#define SCAN_ADDR_ADDR         0xFFFFF000
> +
> +#define SCAN_ADDR_SZ_BASE      0x00001000      /* 4KB */
> +
> +#define SCAN_SIZE_SZ_ALIGN     0x00000FFF
> +#define SCAN_SIZE_SZ           0xFFFFF000
> +#define SCAN_SIZE_SG32         0x00000008
> +
> +#endif /* BCMAI_SCAN_H_ */
> diff --git a/include/linux/bcmai/bcmai.h b/include/linux/bcmai/bcmai.h
> new file mode 100644
> index 0000000..1d5d33c
> --- /dev/null
> +++ b/include/linux/bcmai/bcmai.h
> @@ -0,0 +1,210 @@
> +#ifndef LINUX_BCMAI_H_
> +#define LINUX_BCMAI_H_
> +
> +#include <linux/types.h>
> +#include <linux/bcmai/bcmai_driver_chipcommon.h>
> +#include <linux/bcmai/bcmai_driver_pci.h>
> +
> +#define bcmai_info(fmt, args...)       printk(KERN_INFO "bcmai: " fmt,  
> ##args)
> +#ifdef CONFIG_BCMAI_DEBUG
> +#define bcmai_dbg(fmt, args...)                printk(KERN_DEBUG "bcmai  
> debug: " fmt, ##args)
> +#else
> +#define bcmai_dbg(fmt, args...)                do { } while (0)
> +#endif
> +#define bcmai_err(fmt, args...)                printk(KERN_ERR "bcmai  
> error: " fmt, ##args)
> +

Would go for the pr_... functions. I used that in brcmaxi.

> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#include <linux/pci.h>
> +#include <linux/mod_devicetable.h>
> +#include <linux/dma-mapping.h>
> +
> +#include "bcmai_regs.h"
> +
> +struct bcmai_device;
> +struct bcmai_bus;
> +
> +enum bcmai_hosttype {
> +       BCMAI_HOSTTYPE_NONE,
> +       BCMAI_HOSTTYPE_PCI,
> +       BCMAI_HOSTTYPE_SDIO,
> +};
> +
> +struct bcmai_chipinfo {
> +       u16 id;
> +       u8 rev;
> +       u8 pkg;
> +};
> +
> +struct bcmai_host_ops {
> +       u8 (*read8)(struct bcmai_device *core, u16 offset);
> +       u16 (*read16)(struct bcmai_device *core, u16 offset);
> +       u32 (*read32)(struct bcmai_device *core, u16 offset);
> +       void (*write8)(struct bcmai_device *core, u16 offset, u8 value);
> +       void (*write16)(struct bcmai_device *core, u16 offset, u16  
> value);
> +       void (*write32)(struct bcmai_device *core, u16 offset, u32  
> value);
> +       /* Agent ops */
> +       u32 (*aread32)(struct bcmai_device *core, u16 offset);
> +       void (*awrite32)(struct bcmai_device *core, u16 offset, u32  
> value);
> +};
> +
> +#define BCMAI_MANUF_ARM                        0x43B
> +#define BCMAI_MANUF_MIPS               0x4A7
> +#define BCMAI_MANUF_BCM                        0x4BF
> +
> +/* Core-ID values. */
> +#define BCMAI_CORE_OOB_ROUTER          0x367   /* Out of band */
> +#define BCMAI_CORE_INVALID             0x700
> +#define BCMAI_CORE_CHIPCOMMON          0x800
> +#define BCMAI_CORE_ILINE20             0x801
> +#define BCMAI_CORE_SRAM                        0x802
> +#define BCMAI_CORE_SDRAM               0x803
> +#define BCMAI_CORE_PCI                 0x804
> +#define BCMAI_CORE_MIPS                        0x805
> +#define BCMAI_CORE_ETHERNET            0x806
> +#define BCMAI_CORE_V90                 0x807
> +#define BCMAI_CORE_USB11_HOSTDEV       0x808
> +#define BCMAI_CORE_ADSL                        0x809
> +#define BCMAI_CORE_ILINE100            0x80A
> +#define BCMAI_CORE_IPSEC               0x80B
> +#define BCMAI_CORE_UTOPIA              0x80C
> +#define BCMAI_CORE_PCMCIA              0x80D
> +#define BCMAI_CORE_INTERNAL_MEM                0x80E
> +#define BCMAI_CORE_MEMC_SDRAM          0x80F
> +#define BCMAI_CORE_OFDM                        0x810
> +#define BCMAI_CORE_EXTIF               0x811
> +#define BCMAI_CORE_80211               0x812
> +#define BCMAI_CORE_PHY_A               0x813
> +#define BCMAI_CORE_PHY_B               0x814
> +#define BCMAI_CORE_PHY_G               0x815
> +#define BCMAI_CORE_MIPS_3302           0x816
> +#define BCMAI_CORE_USB11_HOST          0x817
> +#define BCMAI_CORE_USB11_DEV           0x818
> +#define BCMAI_CORE_USB20_HOST          0x819
> +#define BCMAI_CORE_USB20_DEV           0x81A
> +#define BCMAI_CORE_SDIO_HOST           0x81B
> +#define BCMAI_CORE_ROBOSWITCH          0x81C
> +#define BCMAI_CORE_PARA_ATA            0x81D
> +#define BCMAI_CORE_SATA_XORDMA         0x81E
> +#define BCMAI_CORE_ETHERNET_GBIT       0x81F
> +#define BCMAI_CORE_PCIE                        0x820
> +#define BCMAI_CORE_PHY_N               0x821
> +#define BCMAI_CORE_SRAM_CTL            0x822
> +#define BCMAI_CORE_MINI_MACPHY         0x823
> +#define BCMAI_CORE_ARM_1176            0x824
> +#define BCMAI_CORE_ARM_7TDMI           0x825
> +#define BCMAI_CORE_PHY_LP              0x826
> +#define BCMAI_CORE_PMU                 0x827
> +#define BCMAI_CORE_PHY_SSN             0x828
> +#define BCMAI_CORE_SDIO_DEV            0x829
> +#define BCMAI_CORE_ARM_CM3             0x82A
> +#define BCMAI_CORE_PHY_HT              0x82B
> +#define BCMAI_CORE_MIPS_74K            0x82C
> +#define BCMAI_CORE_MAC_GBIT            0x82D
> +#define BCMAI_CORE_DDR12_MEM_CTL       0x82E
> +#define BCMAI_CORE_PCIE_RC             0x82F   /* PCIe Root Complex */
> +#define BCMAI_CORE_OCP_OCP_BRIDGE      0x830
> +#define BCMAI_CORE_SHARED_COMMON       0x831
> +#define BCMAI_CORE_OCP_AHB_BRIDGE      0x832
> +#define BCMAI_CORE_SPI_HOST            0x833
> +#define BCMAI_CORE_I2S                 0x834
> +#define BCMAI_CORE_SDR_DDR1_MEM_CTL    0x835   /* SDR/DDR1 memory  
> controller core */
> +#define BCMAI_CORE_SHIM                        0x837   /* SHIM  
> component in ubus/6362 */
> +#define BCMAI_CORE_DEFAULT             0xFFF

Probably this list includes some cores that were in old chips, but will  
never show up in bcmai chips.

> +#define BCMAI_MAX_NR_CORES             16
> +
> +struct bcmai_device {
> +       struct device dev;
> +
> +       struct bcmai_bus *bus;
> +       struct bcmai_device_id id;
> +
> +       u8 core_index;
> +
> +       u32 addr;
> +       u32 wrap;
> +};
> +
> +struct bcmai_driver {
> +       const char *name;
> +       const struct bcmai_device_id *id_table;
> +
> +       int (*probe)(struct bcmai_device *dev);
> +       void (*remove)(struct bcmai_device *dev);
> +       int (*suspend)(struct bcmai_device *dev, pm_message_t state);
> +       int (*resume)(struct bcmai_device *dev);
> +       void (*shutdown)(struct bcmai_device *dev);
> +
> +       struct device_driver drv;
> +};
> +extern int __bcmai_driver_register(struct bcmai_driver *drv, struct  
> module *owner);
> +static inline int bcmai_driver_register(struct bcmai_driver *drv)
> +{
> +       return __bcmai_driver_register(drv, THIS_MODULE);
> +}
> +extern void bcmai_driver_unregister(struct bcmai_driver *drv);
> +
> +struct bcmai_bus {
> +       /* The MMIO area. */
> +       void __iomem *mmio;
> +
> +       const struct bcmai_host_ops *ops;
> +
> +       enum bcmai_hosttype hosttype;
> +       union {
> +               /* Pointer to the PCI bus (only for BCMAI_HOSTTYPE_PCI)  
> */
> +               struct pci_dev *host_pci;
> +               /* Pointer to the SDIO device (only for  
> BCMAI_HOSTTYPE_SDIO) */
> +               struct sdio_func *host_sdio;
> +       };
> +
> +       struct bcmai_chipinfo chipinfo;
> +
> +       struct bcmai_device *mapped_core;
> +       struct bcmai_device cores[BCMAI_MAX_NR_CORES];
> +       u8 nr_cores;
> +
> +       struct bcmai_drv_cc drv_cc;
> +       struct bcmai_drv_pci drv_pci;
> +};
> +
> +extern inline u32 bcmai_read8(struct bcmai_device *core, u16 offset)
> +{
> +       return core->bus->ops->read8(core, offset);
> +}
> +extern inline u32 bcmai_read16(struct bcmai_device *core, u16 offset)
> +{
> +       return core->bus->ops->read16(core, offset);
> +}
> +extern inline u32 bcmai_read32(struct bcmai_device *core, u16 offset)
> +{
> +       return core->bus->ops->read32(core, offset);
> +}
> +extern inline void bcmai_write8(struct bcmai_device *core, u16 offset,  
> u32 value)
> +{
> +       core->bus->ops->write8(core, offset, value);
> +}
> +extern inline void bcmai_write16(struct bcmai_device *core, u16 offset,  
> u32 value)
> +{
> +       core->bus->ops->write16(core, offset, value);
> +}
> +extern inline void bcmai_write32(struct bcmai_device *core, u16 offset,  
> u32 value)
> +{
> +       core->bus->ops->write32(core, offset, value);
> +}
> +extern inline u32 bcmai_aread32(struct bcmai_device *core, u16 offset)
> +{
> +       return core->bus->ops->aread32(core, offset);
> +}
> +extern inline void bcmai_awrite32(struct bcmai_device *core, u16  
> offset, u32 value)
> +{
> +       core->bus->ops->awrite32(core, offset, value);
> +}
> +
> +extern bool bcmai_core_is_enabled(struct bcmai_device *core);
> +extern int bcmai_core_enable(struct bcmai_device *core, u32 flags);
> +
> +#endif /* LINUX_BCMAI_H_ */
> diff --git a/include/linux/bcmai/bcmai_driver_chipcommon.h  
> b/include/linux/bcmai/bcmai_driver_chipcommon.h
> new file mode 100644
> index 0000000..2704fa1
> --- /dev/null
> +++ b/include/linux/bcmai/bcmai_driver_chipcommon.h
> @@ -0,0 +1,644 @@
> +#ifndef LINUX_BCMAI_DRIVER_CC_H_
> +#define LINUX_BCMAI_DRIVER_CC_H_
> +
> +/* SonicsSiliconBackplane CHIPCOMMON core hardware definitions
> + *
> + * The chipcommon core provides chip identification, SB control,
> + * jtag, 0/1/2 uarts, clock frequency control, a watchdog interrupt  
> timer,
> + * gpio interface, extbus, and support for serial and parallel flashes.
> + *
> + * Copyright 2005, Broadcom Corporation
> + * Copyright 2006, Michael Buesch <mb@bu3sch.de>
> + *
> + * Licensed under the GPL version 2. See COPYING for details.
> + */
> +
> +/** ChipCommon core registers. **/
> +
> +#define BCMAI_CC_ID                    0x0000
> +#define  BCMAI_CC_ID_ID                        0x0000FFFF
> +#define  BCMAI_CC_ID_ID_SHIFT          0
> +#define  BCMAI_CC_ID_REV               0x000F0000
> +#define  BCMAI_CC_ID_REV_SHIFT         16
> +#define  BCMAI_CC_ID_PKG               0x00F00000
> +#define  BCMAI_CC_ID_PKG_SHIFT         20
> +#define  BCMAI_CC_ID_NRCORES           0x0F000000
> +#define  BCMAI_CC_ID_NRCORES_SHIFT     24
> +#define  BCMAI_CC_ID_TYPE              0xF0000000
> +#define  BCMAI_CC_ID_TYPE_SHIFT                28
> +#define BCMAI_CC_CAP                   0x0004          /* Capabilities  
> */
> +#define  BCMAI_CC_CAP_NRUART           0x00000003      /* # of UARTs */
> +#define  BCMAI_CC_CAP_MIPSEB           0x00000004      /* MIPS in  
> BigEndian Mode */
> +#define  BCMAI_CC_CAP_UARTCLK          0x00000018      /* UART clock  
> select */
> +#define   BCMAI_CC_CAP_UARTCLK_INT     0x00000008      /* UARTs are  
> driven by internal divided clock */
> +#define  BCMAI_CC_CAP_UARTGPIO         0x00000020      /* UARTs on GPIO  
> 15-12 */
> +#define  BCMAI_CC_CAP_EXTBUS           0x000000C0      /* External  
> buses present */
> +#define  BCMAI_CC_CAP_FLASHT           0x00000700      /* Flash Type */
> +#define   BCMAI_CC_FLASHT_NONE         0x00000000      /* No flash */
> +#define   BCMAI_CC_FLASHT_STSER                0x00000100      /* ST  
> serial flash */
> +#define   BCMAI_CC_FLASHT_ATSER                0x00000200      /* Atmel  
> serial flash */
> +#define          BCMAI_CC_FLASHT_PARA          0x00000700      /*  
> Parallel flash */
> +#define  BCMAI_CC_CAP_PLLT             0x00038000      /* PLL Type */
> +#define   SSB_PLLTYPE_NONE             0x00000000
> +#define   SSB_PLLTYPE_1                        0x00010000      /* 48Mhz  
> base, 3 dividers */
> +#define   SSB_PLLTYPE_2                        0x00020000      /*  
> 48Mhz, 4 dividers */
> +#define   SSB_PLLTYPE_3                        0x00030000      /*  
> 25Mhz, 2 dividers */
> +#define   SSB_PLLTYPE_4                        0x00008000      /*  
> 48Mhz, 4 dividers */
> +#define   SSB_PLLTYPE_5                        0x00018000      /*  
> 25Mhz, 4 dividers */
> +#define   SSB_PLLTYPE_6                        0x00028000      /*  
> 100/200 or 120/240 only */
> +#define   SSB_PLLTYPE_7                        0x00038000      /*  
> 25Mhz, 4 dividers */

Here and below there are quite some definitions still starting with SSB.

> +#define  BCMAI_CC_CAP_PCTL             0x00040000      /* Power Control  
> */
> +#define  BCMAI_CC_CAP_OTPS             0x00380000      /* OTP size */
> +#define  BCMAI_CC_CAP_OTPS_SHIFT       19
> +#define  BCMAI_CC_CAP_OTPS_BASE        5
> +#define  BCMAI_CC_CAP_JTAGM            0x00400000      /* JTAG master  
> present */
> +#define  BCMAI_CC_CAP_BROM             0x00800000      /* Internal boot  
> ROM active */
> +#define  BCMAI_CC_CAP_64BIT            0x08000000      /* 64-bit  
> Backplane */
> +#define  BCMAI_CC_CAP_PMU              0x10000000      /* PMU available  
> (rev >= 20) */
> +#define  BCMAI_CC_CAP_ECI              0x20000000      /* ECI available  
> (rev >= 20) */
> +#define  BCMAI_CC_CAP_SPROM            0x40000000      /* SPROM present  
> */
> +#define BCMAI_CC_CORECTL               0x0008
> +#define  BCMAI_CC_CORECTL_UARTCLK0     0x00000001      /* Drive UART  
> with internal clock */
> +#define         BCMAI_CC_CORECTL_SE            0x00000002      /* sync  
> clk out enable (corerev >= 3) */
> +#define  BCMAI_CC_CORECTL_UARTCLKEN    0x00000008      /* UART clock  
> enable (rev >= 21) */
> +#define BCMAI_CC_BIST                  0x000C
> +#define BCMAI_CC_OTPS                  0x0010          /* OTP status */
> +#define         BCMAI_CC_OTPS_PROGFAIL         0x80000000
> +#define         BCMAI_CC_OTPS_PROTECT          0x00000007
> +#define         BCMAI_CC_OTPS_HW_PROTECT       0x00000001
> +#define         BCMAI_CC_OTPS_SW_PROTECT       0x00000002
> +#define         BCMAI_CC_OTPS_CID_PROTECT      0x00000004
> +#define BCMAI_CC_OTPC                  0x0014          /* OTP control */
> +#define         BCMAI_CC_OTPC_RECWAIT          0xFF000000
> +#define         BCMAI_CC_OTPC_PROGWAIT         0x00FFFF00
> +#define         BCMAI_CC_OTPC_PRW_SHIFT        8
> +#define         BCMAI_CC_OTPC_MAXFAIL          0x00000038
> +#define         BCMAI_CC_OTPC_VSEL             0x00000006
> +#define         BCMAI_CC_OTPC_SELVL            0x00000001
> +#define BCMAI_CC_OTPP                  0x0018          /* OTP prog */
> +#define         BCMAI_CC_OTPP_COL              0x000000FF
> +#define         BCMAI_CC_OTPP_ROW              0x0000FF00
> +#define         BCMAI_CC_OTPP_ROW_SHIFT        8
> +#define         BCMAI_CC_OTPP_READERR          0x10000000
> +#define         BCMAI_CC_OTPP_VALUE            0x20000000
> +#define         BCMAI_CC_OTPP_READ             0x40000000
> +#define         BCMAI_CC_OTPP_START            0x80000000
> +#define         BCMAI_CC_OTPP_BUSY             0x80000000
> +#define BCMAI_CC_IRQSTAT               0x0020
> +#define BCMAI_CC_IRQMASK               0x0024
> +#define         BCMAI_CC_IRQ_GPIO              0x00000001      /* gpio  
> intr */
> +#define         BCMAI_CC_IRQ_EXT               0x00000002      /* ro:  
> ext intr pin (corerev >= 3) */
> +#define         BCMAI_CC_IRQ_WDRESET           0x80000000      /*  
> watchdog reset occurred */
> +#define BCMAI_CC_CHIPCTL               0x0028          /* Rev >= 11  
> only */
> +#define BCMAI_CC_CHIPSTAT              0x002C          /* Rev >= 11  
> only */
> +#define BCMAI_CC_JCMD                  0x0030          /* Rev >= 10  
> only */
> +#define  BCMAI_CC_JCMD_START           0x80000000
> +#define  BCMAI_CC_JCMD_BUSY            0x80000000
> +#define  BCMAI_CC_JCMD_PAUSE           0x40000000
> +#define  BCMAI_CC_JCMD0_ACC_MASK       0x0000F000
> +#define  BCMAI_CC_JCMD0_ACC_IRDR       0x00000000
> +#define  BCMAI_CC_JCMD0_ACC_DR         0x00001000
> +#define  BCMAI_CC_JCMD0_ACC_IR         0x00002000
> +#define  BCMAI_CC_JCMD0_ACC_RESET      0x00003000
> +#define  BCMAI_CC_JCMD0_ACC_IRPDR      0x00004000
> +#define  BCMAI_CC_JCMD0_ACC_PDR                0x00005000
> +#define  BCMAI_CC_JCMD0_IRW_MASK       0x00000F00
> +#define  BCMAI_CC_JCMD_ACC_MASK                0x000F0000      /*  
> Changes for corerev 11 */
> +#define  BCMAI_CC_JCMD_ACC_IRDR                0x00000000
> +#define  BCMAI_CC_JCMD_ACC_DR          0x00010000
> +#define  BCMAI_CC_JCMD_ACC_IR          0x00020000
> +#define  BCMAI_CC_JCMD_ACC_RESET       0x00030000
> +#define  BCMAI_CC_JCMD_ACC_IRPDR       0x00040000
> +#define  BCMAI_CC_JCMD_ACC_PDR         0x00050000
> +#define  BCMAI_CC_JCMD_IRW_MASK                0x00001F00
> +#define  BCMAI_CC_JCMD_IRW_SHIFT       8
> +#define  BCMAI_CC_JCMD_DRW_MASK                0x0000003F
> +#define BCMAI_CC_JIR                   0x0034          /* Rev >= 10  
> only */
> +#define BCMAI_CC_JDR                   0x0038          /* Rev >= 10  
> only */
> +#define BCMAI_CC_JCTL                  0x003C          /* Rev >= 10  
> only */
> +#define  BCMAI_CC_JCTL_FORCE_CLK       4               /* Force clock */
> +#define  BCMAI_CC_JCTL_EXT_EN          2               /* Enable  
> external targets */
> +#define  BCMAI_CC_JCTL_EN              1               /* Enable Jtag  
> master */
> +#define BCMAI_CC_FLASHCTL              0x0040
> +#define  BCMAI_CC_FLASHCTL_START       0x80000000
> +#define  BCMAI_CC_FLASHCTL_BUSY                BCMAI_CC_FLASHCTL_START
> +#define BCMAI_CC_FLASHADDR             0x0044
> +#define BCMAI_CC_FLASHDATA             0x0048
> +#define BCMAI_CC_BCAST_ADDR            0x0050
> +#define BCMAI_CC_BCAST_DATA            0x0054
> +#define BCMAI_CC_GPIOIN                        0x0060
> +#define BCMAI_CC_GPIOOUT               0x0064
> +#define BCMAI_CC_GPIOOUTEN             0x0068
> +#define BCMAI_CC_GPIOCTL               0x006C
> +#define BCMAI_CC_GPIOPOL               0x0070
> +#define BCMAI_CC_GPIOIRQ               0x0074
> +#define BCMAI_CC_WATCHDOG              0x0080
> +#define BCMAI_CC_GPIOTIMER             0x0088          /* LED powersave  
> (corerev >= 16) */
> +#define  BCMAI_CC_GPIOTIMER_ONTIME_SHIFT       16
> +#define BCMAI_CC_GPIOTOUTM             0x008C          /* LED powersave  
> (corerev >= 16) */
> +#define BCMAI_CC_CLOCK_N               0x0090
> +#define BCMAI_CC_CLOCK_SB              0x0094
> +#define BCMAI_CC_CLOCK_PCI             0x0098
> +#define BCMAI_CC_CLOCK_M2              0x009C
> +#define BCMAI_CC_CLOCK_MIPS            0x00A0
> +#define BCMAI_CC_CLKDIV                        0x00A4          /* Rev  
> >= 3 only */
> +#define         BCMAI_CC_CLKDIV_SFLASH         0x0F000000
> +#define         BCMAI_CC_CLKDIV_SFLASH_SHIFT   24
> +#define         BCMAI_CC_CLKDIV_OTP            0x000F0000
> +#define         BCMAI_CC_CLKDIV_OTP_SHIFT      16
> +#define         BCMAI_CC_CLKDIV_JTAG           0x00000F00
> +#define         BCMAI_CC_CLKDIV_JTAG_SHIFT     8
> +#define         BCMAI_CC_CLKDIV_UART           0x000000FF
> +#define BCMAI_CC_CAP_EXT               0x00AC          /* Capabilities  
> */
> +#define BCMAI_CC_PLLONDELAY            0x00B0          /* Rev >= 4 only  
> */
> +#define BCMAI_CC_FREFSELDELAY          0x00B4          /* Rev >= 4 only  
> */
> +#define BCMAI_CC_SLOWCLKCTL            0x00B8          /* 6 <= Rev <= 9  
> only */
> +#define  BCMAI_CC_SLOWCLKCTL_SRC       0x00000007      /* slow clock  
> source mask */
> +#define          BCMAI_CC_SLOWCLKCTL_SRC_LPO   0x00000000      /*  
> source of slow clock is LPO */
> +#define   BCMAI_CC_SLOWCLKCTL_SRC_XTAL 0x00000001      /* source of  
> slow clock is crystal */
> +#define          BCMAI_CC_SLOECLKCTL_SRC_PCI   0x00000002      /*  
> source of slow clock is PCI */
> +#define  BCMAI_CC_SLOWCLKCTL_LPOFREQ   0x00000200      /* LPOFreqSel,  
> 1: 160Khz, 0: 32KHz */
> +#define  BCMAI_CC_SLOWCLKCTL_LPOPD     0x00000400      /* LPOPowerDown,  
> 1: LPO is disabled, 0: LPO is enabled */
> +#define  BCMAI_CC_SLOWCLKCTL_FSLOW     0x00000800      /* ForceSlowClk,  
> 1: sb/cores running on slow clock, 0: power logic control */
> +#define  BCMAI_CC_SLOWCLKCTL_IPLL      0x00001000      /*  
> IgnorePllOffReq, 1/0: power logic ignores/honors PLL clock disable  
> requests from core */
> +#define  BCMAI_CC_SLOWCLKCTL_ENXTAL    0x00002000      /*  
> XtalControlEn, 1/0: power logic does/doesn't disable crystal when  
> appropriate */
> +#define  BCMAI_CC_SLOWCLKCTL_XTALPU    0x00004000      /* XtalPU (RO),  
> 1/0: crystal running/disabled */
> +#define  BCMAI_CC_SLOWCLKCTL_CLKDIV    0xFFFF0000      /* ClockDivider  
> (SlowClk = 1/(4+divisor)) */
> +#define  BCMAI_CC_SLOWCLKCTL_CLKDIV_SHIFT      16
> +#define BCMAI_CC_SYSCLKCTL             0x00C0          /* Rev >= 3 only  
> */
> +#define         BCMAI_CC_SYSCLKCTL_IDLPEN      0x00000001      /*  
> ILPen: Enable Idle Low Power */
> +#define         BCMAI_CC_SYSCLKCTL_ALPEN       0x00000002      /*  
> ALPen: Enable Active Low Power */
> +#define         BCMAI_CC_SYSCLKCTL_PLLEN       0x00000004      /*  
> ForcePLLOn */
> +#define         BCMAI_CC_SYSCLKCTL_FORCEALP    0x00000008      /* Force  
> ALP (or HT if ALPen is not set */
> +#define         BCMAI_CC_SYSCLKCTL_FORCEHT     0x00000010      /* Force  
> HT */
> +#define  BCMAI_CC_SYSCLKCTL_CLKDIV     0xFFFF0000      /* ClkDiv  (ILP  
> = 1/(4+divisor)) */
> +#define  BCMAI_CC_SYSCLKCTL_CLKDIV_SHIFT       16
> +#define BCMAI_CC_CLKSTSTR              0x00C4          /* Rev >= 3 only  
> */
> +#define BCMAI_CC_EROM                  0x00FC
> +#define BCMAI_CC_PCMCIA_CFG            0x0100
> +#define BCMAI_CC_PCMCIA_MEMWAIT                0x0104
> +#define BCMAI_CC_PCMCIA_ATTRWAIT       0x0108
> +#define BCMAI_CC_PCMCIA_IOWAIT         0x010C
> +#define BCMAI_CC_IDE_CFG               0x0110
> +#define BCMAI_CC_IDE_MEMWAIT           0x0114
> +#define BCMAI_CC_IDE_ATTRWAIT          0x0118
> +#define BCMAI_CC_IDE_IOWAIT            0x011C
> +#define BCMAI_CC_PROG_CFG              0x0120
> +#define BCMAI_CC_PROG_WAITCNT          0x0124
> +#define BCMAI_CC_FLASH_CFG             0x0128
> +#define BCMAI_CC_FLASH_WAITCNT         0x012C
> +#define BCMAI_CC_CLKCTLST              0x01E0 /* Clock control and  
> status (rev >= 20) */
> +#define  BCMAI_CC_CLKCTLST_FORCEALP    0x00000001 /* Force ALP request  
> */
> +#define  BCMAI_CC_CLKCTLST_FORCEHT     0x00000002 /* Force HT request */
> +#define  BCMAI_CC_CLKCTLST_FORCEILP    0x00000004 /* Force ILP request  
> */
> +#define  BCMAI_CC_CLKCTLST_HAVEALPREQ  0x00000008 /* ALP available  
> request */
> +#define  BCMAI_CC_CLKCTLST_HAVEHTREQ   0x00000010 /* HT available  
> request */
> +#define  BCMAI_CC_CLKCTLST_HWCROFF     0x00000020 /* Force HW clock  
> request off */
> +#define  BCMAI_CC_CLKCTLST_HAVEHT      0x00010000 /* HT available */
> +#define  BCMAI_CC_CLKCTLST_HAVEALP     0x00020000 /* APL available */
> +#define BCMAI_CC_HW_WORKAROUND         0x01E4 /* Hardware workaround  
> (rev >= 20) */
> +#define BCMAI_CC_UART0_DATA            0x0300
> +#define BCMAI_CC_UART0_IMR             0x0304
> +#define BCMAI_CC_UART0_FCR             0x0308
> +#define BCMAI_CC_UART0_LCR             0x030C
> +#define BCMAI_CC_UART0_MCR             0x0310
> +#define BCMAI_CC_UART0_LSR             0x0314
> +#define BCMAI_CC_UART0_MSR             0x0318
> +#define BCMAI_CC_UART0_SCRATCH         0x031C
> +#define BCMAI_CC_UART1_DATA            0x0400
> +#define BCMAI_CC_UART1_IMR             0x0404
> +#define BCMAI_CC_UART1_FCR             0x0408
> +#define BCMAI_CC_UART1_LCR             0x040C
> +#define BCMAI_CC_UART1_MCR             0x0410
> +#define BCMAI_CC_UART1_LSR             0x0414
> +#define BCMAI_CC_UART1_MSR             0x0418
> +#define BCMAI_CC_UART1_SCRATCH         0x041C
> +/* PMU registers (rev >= 20) */
> +#define BCMAI_CC_PMU_CTL                       0x0600 /* PMU control */
> +#define  BCMAI_CC_PMU_CTL_ILP_DIV              0xFFFF0000 /* ILP div  
> mask */
> +#define  BCMAI_CC_PMU_CTL_ILP_DIV_SHIFT                16
> +#define  BCMAI_CC_PMU_CTL_NOILPONW             0x00000200 /* No ILP on  
> wait */
> +#define  BCMAI_CC_PMU_CTL_HTREQEN              0x00000100 /* HT req  
> enable */
> +#define  BCMAI_CC_PMU_CTL_ALPREQEN             0x00000080 /* ALP req  
> enable */
> +#define  BCMAI_CC_PMU_CTL_XTALFREQ             0x0000007C /* Crystal  
> freq */
> +#define  BCMAI_CC_PMU_CTL_XTALFREQ_SHIFT       2
> +#define  BCMAI_CC_PMU_CTL_ILPDIVEN             0x00000002 /* ILP div  
> enable */
> +#define  BCMAI_CC_PMU_CTL_LPOSEL               0x00000001 /* LPO sel */
> +#define BCMAI_CC_PMU_CAP                       0x0604 /* PMU  
> capabilities */
> +#define  BCMAI_CC_PMU_CAP_REVISION             0x000000FF /* Revision  
> mask */
> +#define BCMAI_CC_PMU_STAT                      0x0608 /* PMU status */
> +#define  BCMAI_CC_PMU_STAT_INTPEND             0x00000040 /* Interrupt  
> pending */
> +#define  BCMAI_CC_PMU_STAT_SBCLKST             0x00000030 /* Backplane  
> clock status? */
> +#define  BCMAI_CC_PMU_STAT_HAVEALP             0x00000008 /* ALP  
> available */
> +#define  BCMAI_CC_PMU_STAT_HAVEHT              0x00000004 /* HT  
> available */
> +#define  BCMAI_CC_PMU_STAT_RESINIT             0x00000003 /* Res init */
> +#define BCMAI_CC_PMU_RES_STAT                  0x060C /* PMU res status  
> */
> +#define BCMAI_CC_PMU_RES_PEND                  0x0610 /* PMU res  
> pending */
> +#define BCMAI_CC_PMU_TIMER                     0x0614 /* PMU timer */
> +#define BCMAI_CC_PMU_MINRES_MSK                        0x0618 /* PMU  
> min res mask */
> +#define BCMAI_CC_PMU_MAXRES_MSK                        0x061C /* PMU  
> max res mask */
> +#define BCMAI_CC_PMU_RES_TABSEL                        0x0620 /* PMU  
> res table sel */
> +#define BCMAI_CC_PMU_RES_DEPMSK                        0x0624 /* PMU  
> res dep mask */
> +#define BCMAI_CC_PMU_RES_UPDNTM                        0x0628 /* PMU  
> res updown timer */
> +#define BCMAI_CC_PMU_RES_TIMER                 0x062C /* PMU res timer  
> */
> +#define BCMAI_CC_PMU_CLKSTRETCH                        0x0630 /* PMU  
> clockstretch */
> +#define BCMAI_CC_PMU_WATCHDOG                  0x0634 /* PMU watchdog */
> +#define BCMAI_CC_PMU_RES_REQTS                 0x0640 /* PMU res req  
> timer sel */
> +#define BCMAI_CC_PMU_RES_REQT                  0x0644 /* PMU res req  
> timer */
> +#define BCMAI_CC_PMU_RES_REQM                  0x0648 /* PMU res req  
> mask */
> +#define BCMAI_CC_CHIPCTL_ADDR                  0x0650
> +#define BCMAI_CC_CHIPCTL_DATA                  0x0654
> +#define BCMAI_CC_REGCTL_ADDR                   0x0658
> +#define BCMAI_CC_REGCTL_DATA                   0x065C
> +#define BCMAI_CC_PLLCTL_ADDR                   0x0660
> +#define BCMAI_CC_PLLCTL_DATA                   0x0664
> +
> +
> +
> +/** PMU PLL registers */
> +
> +/* PMU rev 0 PLL registers */
> +#define SSB_PMU0_PLLCTL0                       0
> +#define  SSB_PMU0_PLLCTL0_PDIV_MSK             0x00000001
> +#define  SSB_PMU0_PLLCTL0_PDIV_FREQ            25000 /* kHz */
> +#define SSB_PMU0_PLLCTL1                       1
> +#define  SSB_PMU0_PLLCTL1_WILD_IMSK            0xF0000000 /* Wild int  
> mask (low nibble) */
> +#define  SSB_PMU0_PLLCTL1_WILD_IMSK_SHIFT      28
> +#define  SSB_PMU0_PLLCTL1_WILD_FMSK            0x0FFFFF00 /* Wild frac  
> mask */
> +#define  SSB_PMU0_PLLCTL1_WILD_FMSK_SHIFT      8
> +#define  SSB_PMU0_PLLCTL1_STOPMOD              0x00000040 /* Stop mod */
> +#define SSB_PMU0_PLLCTL2                       2
> +#define  SSB_PMU0_PLLCTL2_WILD_IMSKHI          0x0000000F /* Wild int  
> mask (high nibble) */
> +#define  SSB_PMU0_PLLCTL2_WILD_IMSKHI_SHIFT    0
> +
> +/* PMU rev 1 PLL registers */
> +#define SSB_PMU1_PLLCTL0                       0
> +#define  SSB_PMU1_PLLCTL0_P1DIV                        0x00F00000 /* P1  
> div */
> +#define  SSB_PMU1_PLLCTL0_P1DIV_SHIFT          20
> +#define  SSB_PMU1_PLLCTL0_P2DIV                        0x0F000000 /* P2  
> div */
> +#define  SSB_PMU1_PLLCTL0_P2DIV_SHIFT          24
> +#define SSB_PMU1_PLLCTL1                       1
> +#define  SSB_PMU1_PLLCTL1_M1DIV                        0x000000FF /* M1  
> div */
> +#define  SSB_PMU1_PLLCTL1_M1DIV_SHIFT          0
> +#define  SSB_PMU1_PLLCTL1_M2DIV                        0x0000FF00 /* M2  
> div */
> +#define  SSB_PMU1_PLLCTL1_M2DIV_SHIFT          8
> +#define  SSB_PMU1_PLLCTL1_M3DIV                        0x00FF0000 /* M3  
> div */
> +#define  SSB_PMU1_PLLCTL1_M3DIV_SHIFT          16
> +#define  SSB_PMU1_PLLCTL1_M4DIV                        0xFF000000 /* M4  
> div */
> +#define  SSB_PMU1_PLLCTL1_M4DIV_SHIFT          24
> +#define SSB_PMU1_PLLCTL2                       2
> +#define  SSB_PMU1_PLLCTL2_M5DIV                        0x000000FF /* M5  
> div */
> +#define  SSB_PMU1_PLLCTL2_M5DIV_SHIFT          0
> +#define  SSB_PMU1_PLLCTL2_M6DIV                        0x0000FF00 /* M6  
> div */
> +#define  SSB_PMU1_PLLCTL2_M6DIV_SHIFT          8
> +#define  SSB_PMU1_PLLCTL2_NDIVMODE             0x000E0000 /* NDIV mode  
> */
> +#define  SSB_PMU1_PLLCTL2_NDIVMODE_SHIFT       17
> +#define  SSB_PMU1_PLLCTL2_NDIVINT              0x1FF00000 /* NDIV int */
> +#define  SSB_PMU1_PLLCTL2_NDIVINT_SHIFT                20
> +#define SSB_PMU1_PLLCTL3                       3
> +#define  SSB_PMU1_PLLCTL3_NDIVFRAC             0x00FFFFFF /* NDIV frac  
> */
> +#define  SSB_PMU1_PLLCTL3_NDIVFRAC_SHIFT       0
> +#define SSB_PMU1_PLLCTL4                       4
> +#define SSB_PMU1_PLLCTL5                       5
> +#define  SSB_PMU1_PLLCTL5_CLKDRV               0xFFFFFF00 /* clk drv */
> +#define  SSB_PMU1_PLLCTL5_CLKDRV_SHIFT         8
> +
> +/* BCM4312 PLL resource numbers. */
> +#define SSB_PMURES_4312_SWITCHER_BURST         0
> +#define SSB_PMURES_4312_SWITCHER_PWM           1
> +#define SSB_PMURES_4312_PA_REF_LDO             2
> +#define SSB_PMURES_4312_CORE_LDO_BURST         3
> +#define SSB_PMURES_4312_CORE_LDO_PWM           4
> +#define SSB_PMURES_4312_RADIO_LDO              5
> +#define SSB_PMURES_4312_ILP_REQUEST            6
> +#define SSB_PMURES_4312_BG_FILTBYP             7
> +#define SSB_PMURES_4312_TX_FILTBYP             8
> +#define SSB_PMURES_4312_RX_FILTBYP             9
> +#define SSB_PMURES_4312_XTAL_PU                        10
> +#define SSB_PMURES_4312_ALP_AVAIL              11
> +#define SSB_PMURES_4312_BB_PLL_FILTBYP         12
> +#define SSB_PMURES_4312_RF_PLL_FILTBYP         13
> +#define SSB_PMURES_4312_HT_AVAIL               14
> +
> +/* BCM4325 PLL resource numbers. */
> +#define SSB_PMURES_4325_BUCK_BOOST_BURST       0
> +#define SSB_PMURES_4325_CBUCK_BURST            1
> +#define SSB_PMURES_4325_CBUCK_PWM              2
> +#define SSB_PMURES_4325_CLDO_CBUCK_BURST       3
> +#define SSB_PMURES_4325_CLDO_CBUCK_PWM         4
> +#define SSB_PMURES_4325_BUCK_BOOST_PWM         5
> +#define SSB_PMURES_4325_ILP_REQUEST            6
> +#define SSB_PMURES_4325_ABUCK_BURST            7
> +#define SSB_PMURES_4325_ABUCK_PWM              8
> +#define SSB_PMURES_4325_LNLDO1_PU              9
> +#define SSB_PMURES_4325_LNLDO2_PU              10
> +#define SSB_PMURES_4325_LNLDO3_PU              11
> +#define SSB_PMURES_4325_LNLDO4_PU              12
> +#define SSB_PMURES_4325_XTAL_PU                        13
> +#define SSB_PMURES_4325_ALP_AVAIL              14
> +#define SSB_PMURES_4325_RX_PWRSW_PU            15
> +#define SSB_PMURES_4325_TX_PWRSW_PU            16
> +#define SSB_PMURES_4325_RFPLL_PWRSW_PU         17
> +#define SSB_PMURES_4325_LOGEN_PWRSW_PU         18
> +#define SSB_PMURES_4325_AFE_PWRSW_PU           19
> +#define SSB_PMURES_4325_BBPLL_PWRSW_PU         20
> +#define SSB_PMURES_4325_HT_AVAIL               21
> +
> +/* BCM4328 PLL resource numbers. */
> +#define SSB_PMURES_4328_EXT_SWITCHER_PWM       0
> +#define SSB_PMURES_4328_BB_SWITCHER_PWM                1
> +#define SSB_PMURES_4328_BB_SWITCHER_BURST      2
> +#define SSB_PMURES_4328_BB_EXT_SWITCHER_BURST  3
> +#define SSB_PMURES_4328_ILP_REQUEST            4
> +#define SSB_PMURES_4328_RADIO_SWITCHER_PWM     5
> +#define SSB_PMURES_4328_RADIO_SWITCHER_BURST   6
> +#define SSB_PMURES_4328_ROM_SWITCH             7
> +#define SSB_PMURES_4328_PA_REF_LDO             8
> +#define SSB_PMURES_4328_RADIO_LDO              9
> +#define SSB_PMURES_4328_AFE_LDO                        10
> +#define SSB_PMURES_4328_PLL_LDO                        11
> +#define SSB_PMURES_4328_BG_FILTBYP             12
> +#define SSB_PMURES_4328_TX_FILTBYP             13
> +#define SSB_PMURES_4328_RX_FILTBYP             14
> +#define SSB_PMURES_4328_XTAL_PU                        15
> +#define SSB_PMURES_4328_XTAL_EN                        16
> +#define SSB_PMURES_4328_BB_PLL_FILTBYP         17
> +#define SSB_PMURES_4328_RF_PLL_FILTBYP         18
> +#define SSB_PMURES_4328_BB_PLL_PU              19
> +
> +/* BCM5354 PLL resource numbers. */
> +#define SSB_PMURES_5354_EXT_SWITCHER_PWM       0
> +#define SSB_PMURES_5354_BB_SWITCHER_PWM                1
> +#define SSB_PMURES_5354_BB_SWITCHER_BURST      2
> +#define SSB_PMURES_5354_BB_EXT_SWITCHER_BURST  3
> +#define SSB_PMURES_5354_ILP_REQUEST            4
> +#define SSB_PMURES_5354_RADIO_SWITCHER_PWM     5
> +#define SSB_PMURES_5354_RADIO_SWITCHER_BURST   6
> +#define SSB_PMURES_5354_ROM_SWITCH             7
> +#define SSB_PMURES_5354_PA_REF_LDO             8
> +#define SSB_PMURES_5354_RADIO_LDO              9
> +#define SSB_PMURES_5354_AFE_LDO                        10
> +#define SSB_PMURES_5354_PLL_LDO                        11
> +#define SSB_PMURES_5354_BG_FILTBYP             12
> +#define SSB_PMURES_5354_TX_FILTBYP             13
> +#define SSB_PMURES_5354_RX_FILTBYP             14
> +#define SSB_PMURES_5354_XTAL_PU                        15
> +#define SSB_PMURES_5354_XTAL_EN                        16
> +#define SSB_PMURES_5354_BB_PLL_FILTBYP         17
> +#define SSB_PMURES_5354_RF_PLL_FILTBYP         18
> +#define SSB_PMURES_5354_BB_PLL_PU              19
> +
> +
> +
> +/** Chip specific Chip-Status register contents. */
> +#define BCMAI_CC_CHST_4322_SPROM_EXISTS                0x00000040 /*  
> SPROM present */
> +#define BCMAI_CC_CHST_4325_SPROM_OTP_SEL       0x00000003
> +#define BCMAI_CC_CHST_4325_DEFCIS_SEL          0 /* OTP is powered up,  
> use def. CIS, no SPROM */
> +#define BCMAI_CC_CHST_4325_SPROM_SEL           1 /* OTP is powered up,  
> SPROM is present */
> +#define BCMAI_CC_CHST_4325_OTP_SEL             2 /* OTP is powered up,  
> no SPROM */
> +#define BCMAI_CC_CHST_4325_OTP_PWRDN           3 /* OTP is powered  
> down, SPROM is present */
> +#define BCMAI_CC_CHST_4325_SDIO_USB_MODE       0x00000004
> +#define BCMAI_CC_CHST_4325_SDIO_USB_MODE_SHIFT  2
> +#define BCMAI_CC_CHST_4325_RCAL_VALID          0x00000008
> +#define BCMAI_CC_CHST_4325_RCAL_VALID_SHIFT    3
> +#define BCMAI_CC_CHST_4325_RCAL_VALUE          0x000001F0
> +#define BCMAI_CC_CHST_4325_RCAL_VALUE_SHIFT    4
> +#define BCMAI_CC_CHST_4325_PMUTOP_2B           0x00000200 /* 1 for 2b,  
> 0 for to 2a */
> +
> +/** Macros to determine SPROM presence based on Chip-Status register. */
> +#define BCMAI_CC_CHST_4312_SPROM_PRESENT(status) \
> +       ((status & BCMAI_CC_CHST_4325_SPROM_OTP_SEL) != \
> +               BCMAI_CC_CHST_4325_OTP_SEL)
> +#define BCMAI_CC_CHST_4322_SPROM_PRESENT(status) \
> +       (status & BCMAI_CC_CHST_4322_SPROM_EXISTS)
> +#define BCMAI_CC_CHST_4325_SPROM_PRESENT(status) \
> +       (((status & BCMAI_CC_CHST_4325_SPROM_OTP_SEL) != \
> +               BCMAI_CC_CHST_4325_DEFCIS_SEL) && \
> +        ((status & BCMAI_CC_CHST_4325_SPROM_OTP_SEL) != \
> +               BCMAI_CC_CHST_4325_OTP_SEL))
> +
> +
> +
> +/** Clockcontrol masks and values **/
> +
> +/* BCMAI_CC_CLOCK_N */
> +#define        BCMAI_CC_CLK_N1                 0x0000003F      /* n1  
> control */
> +#define        BCMAI_CC_CLK_N2                 0x00003F00      /* n2  
> control */
> +#define        BCMAI_CC_CLK_N2_SHIFT           8
> +#define        BCMAI_CC_CLK_PLLC               0x000F0000      /* pll  
> control */
> +#define        BCMAI_CC_CLK_PLLC_SHIFT         16
> +
> +/* BCMAI_CC_CLOCK_SB/PCI/UART */
> +#define        BCMAI_CC_CLK_M1                 0x0000003F      /* m1  
> control */
> +#define        BCMAI_CC_CLK_M2                 0x00003F00      /* m2  
> control */
> +#define        BCMAI_CC_CLK_M2_SHIFT           8
> +#define        BCMAI_CC_CLK_M3                 0x003F0000      /* m3  
> control */
> +#define        BCMAI_CC_CLK_M3_SHIFT           16
> +#define        BCMAI_CC_CLK_MC                 0x1F000000      /* mux  
> control */
> +#define        BCMAI_CC_CLK_MC_SHIFT           24
> +
> +/* N3M Clock control magic field values */
> +#define        BCMAI_CC_CLK_F6_2               0x02            /* A  
> factor of 2 in */
> +#define        BCMAI_CC_CLK_F6_3               0x03            /* 6-bit  
> fields like */
> +#define        BCMAI_CC_CLK_F6_4               0x05            /* N1,  
> M1 or M3 */
> +#define        BCMAI_CC_CLK_F6_5               0x09
> +#define        BCMAI_CC_CLK_F6_6               0x11
> +#define        BCMAI_CC_CLK_F6_7               0x21
> +
> +#define        BCMAI_CC_CLK_F5_BIAS            5               /* 5-bit  
> fields get this added */
> +
> +#define        BCMAI_CC_CLK_MC_BYPASS          0x08
> +#define        BCMAI_CC_CLK_MC_M1              0x04
> +#define        BCMAI_CC_CLK_MC_M1M2            0x02
> +#define        BCMAI_CC_CLK_MC_M1M2M3          0x01
> +#define        BCMAI_CC_CLK_MC_M1M3            0x11
> +
> +/* Type 2 Clock control magic field values */
> +#define        BCMAI_CC_CLK_T2_BIAS            2               /* n1,  
> n2, m1 & m3 bias */
> +#define        BCMAI_CC_CLK_T2M2_BIAS          3               /* m2  
> bias */
> +
> +#define        BCMAI_CC_CLK_T2MC_M1BYP         1
> +#define        BCMAI_CC_CLK_T2MC_M2BYP         2
> +#define        BCMAI_CC_CLK_T2MC_M3BYP         4
> +
> +/* Type 6 Clock control magic field values */
> +#define        BCMAI_CC_CLK_T6_MMASK           1               /* bits  
> of interest in m */
> +#define        BCMAI_CC_CLK_T6_M0              120000000       /* sb  
> clock for m = 0 */
> +#define        BCMAI_CC_CLK_T6_M1              100000000       /* sb  
> clock for m = 1 */
> +#define        BCMAI_CC_CLK_SB2MIPS_T6(sb)     (2 * (sb))
> +
> +/* Common clock base */
> +#define        BCMAI_CC_CLK_BASE1              24000000        /* Half  
> the clock freq */
> +#define BCMAI_CC_CLK_BASE2             12500000        /* Alternate  
> crystal on some PLL's */
> +
> +/* Clock control values for 200Mhz in 5350 */
> +#define        BCMAI_CC_CLK_5350_N             0x0311
> +#define        BCMAI_CC_CLK_5350_M             0x04020009
> +
> +
> +/** Bits in the config registers **/
> +
> +#define        BCMAI_CC_CFG_EN                 0x0001          /*  
> Enable */
> +#define        BCMAI_CC_CFG_EXTM               0x000E          /* Extif  
> Mode */
> +#define         BCMAI_CC_CFG_EXTM_ASYNC        0x0002          /*  
> Async/Parallel flash */
> +#define         BCMAI_CC_CFG_EXTM_SYNC         0x0004          /*  
> Synchronous */
> +#define         BCMAI_CC_CFG_EXTM_PCMCIA       0x0008          /*  
> PCMCIA */
> +#define         BCMAI_CC_CFG_EXTM_IDE          0x000A          /* IDE */
> +#define        BCMAI_CC_CFG_DS16               0x0010          /* Data  
> size, 0=8bit, 1=16bit */
> +#define        BCMAI_CC_CFG_CLKDIV             0x0060          /* Sync:  
> Clock divisor */
> +#define        BCMAI_CC_CFG_CLKEN              0x0080          /* Sync:  
> Clock enable */
> +#define        BCMAI_CC_CFG_BSTRO              0x0100          /* Sync:  
> Size/Bytestrobe */
> +
> +
> +/** Flash-specific control/status values */
> +
> +/* flashcontrol opcodes for ST flashes */
> +#define BCMAI_CC_FLASHCTL_ST_WREN      0x0006          /* Write Enable  
> */
> +#define BCMAI_CC_FLASHCTL_ST_WRDIS     0x0004          /* Write Disable  
> */
> +#define BCMAI_CC_FLASHCTL_ST_RDSR      0x0105          /* Read Status  
> Register */
> +#define BCMAI_CC_FLASHCTL_ST_WRSR      0x0101          /* Write Status  
> Register */
> +#define BCMAI_CC_FLASHCTL_ST_READ      0x0303          /* Read Data  
> Bytes */
> +#define BCMAI_CC_FLASHCTL_ST_PP                0x0302          /* Page  
> Program */
> +#define BCMAI_CC_FLASHCTL_ST_SE                0x02D8          /*  
> Sector Erase */
> +#define BCMAI_CC_FLASHCTL_ST_BE                0x00C7          /* Bulk  
> Erase */
> +#define BCMAI_CC_FLASHCTL_ST_DP                0x00B9          /* Deep  
> Power-down */
> +#define BCMAI_CC_FLASHCTL_ST_RSIG      0x03AB          /* Read  
> Electronic Signature */
> +
> +/* Status register bits for ST flashes */
> +#define BCMAI_CC_FLASHSTA_ST_WIP       0x01            /* Write In  
> Progress */
> +#define BCMAI_CC_FLASHSTA_ST_WEL       0x02            /* Write Enable  
> Latch */
> +#define BCMAI_CC_FLASHSTA_ST_BP                0x1C            /* Block  
> Protect */
> +#define BCMAI_CC_FLASHSTA_ST_BP_SHIFT  2
> +#define BCMAI_CC_FLASHSTA_ST_SRWD      0x80            /* Status  
> Register Write Disable */
> +
> +/* flashcontrol opcodes for Atmel flashes */
> +#define BCMAI_CC_FLASHCTL_AT_READ              0x07E8
> +#define BCMAI_CC_FLASHCTL_AT_PAGE_READ         0x07D2
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_READ /* FIXME */
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_READ /* FIXME */
> +#define BCMAI_CC_FLASHCTL_AT_STATUS            0x01D7
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_WRITE                0x0384
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_WRITE                0x0387
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_ERASE_PRGM   0x0283  /* Erase program  
> */
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_ERASE_PRGM   0x0286  /* Erase program  
> */
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_PROGRAM      0x0288
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_PROGRAM      0x0289
> +#define BCMAI_CC_FLASHCTL_AT_PAGE_ERASE                0x0281
> +#define BCMAI_CC_FLASHCTL_AT_BLOCK_ERASE       0x0250
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_WRER_PRGM    0x0382  /* Write erase  
> program */
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_WRER_PRGM    0x0385  /* Write erase  
> program */
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_LOAD         0x0253
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_LOAD         0x0255
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_COMPARE      0x0260
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_COMPARE      0x0261
> +#define BCMAI_CC_FLASHCTL_AT_BUF1_REPROGRAM    0x0258
> +#define BCMAI_CC_FLASHCTL_AT_BUF2_REPROGRAM    0x0259
> +
> +/* Status register bits for Atmel flashes */
> +#define BCMAI_CC_FLASHSTA_AT_READY     0x80
> +#define BCMAI_CC_FLASHSTA_AT_MISMATCH  0x40
> +#define BCMAI_CC_FLASHSTA_AT_ID                0x38
> +#define BCMAI_CC_FLASHSTA_AT_ID_SHIFT  3
> +
> +
> +/** OTP **/
> +
> +/* OTP regions */
> +#define        BCMAI_CC_OTP_HW_REGION  BCMAI_CC_OTPS_HW_PROTECT
> +#define        BCMAI_CC_OTP_SW_REGION  BCMAI_CC_OTPS_SW_PROTECT
> +#define        BCMAI_CC_OTP_CID_REGION BCMAI_CC_OTPS_CID_PROTECT
> +
> +/* OTP regions (Byte offsets from otp size) */
> +#define        BCMAI_CC_OTP_SWLIM_OFF          (-8)
> +#define        BCMAI_CC_OTP_CIDBASE_OFF        0
> +#define        BCMAI_CC_OTP_CIDLIM_OFF         8
> +
> +/* Predefined OTP words (Word offset from otp size) */
> +#define        BCMAI_CC_OTP_BOUNDARY_OFF       (-4)
> +#define        BCMAI_CC_OTP_HWSIGN_OFF         (-3)
> +#define        BCMAI_CC_OTP_SWSIGN_OFF         (-2)
> +#define        BCMAI_CC_OTP_CIDSIGN_OFF        (-1)
> +
> +#define        BCMAI_CC_OTP_CID_OFF            0
> +#define        BCMAI_CC_OTP_PKG_OFF            1
> +#define        BCMAI_CC_OTP_FID_OFF            2
> +#define        BCMAI_CC_OTP_RSV_OFF            3
> +#define        BCMAI_CC_OTP_LIM_OFF            4
> +
> +#define        BCMAI_CC_OTP_SIGNATURE          0x578A
> +#define        BCMAI_CC_OTP_MAGIC              0x4E56
> +
> +/* Data for the PMU, if available.
> + * Check availability with ((struct ssb_chipcommon)->capabilities &  
> BCMAI_CC_CAP_PMU)
> + */
> +struct bcmai_chipcommon_pmu {
> +       u8 rev;                 /* PMU revision */
> +       u32 crystalfreq;        /* The active crystal frequency (in kHz)  
> */
> +};
> +
> +struct bcmai_drv_cc {
> +       struct bcmai_device *core;
> +       u32 status;
> +       u32 capabilities;
> +       u32 capabilities_ext;
> +       /* Fast Powerup Delay constant */
> +       u16 fast_pwrup_delay;
> +       struct bcmai_chipcommon_pmu pmu;
> +};
> +
> +/* Register access */
> +#define bcmai_cc_read32(cc, offset)            bcmai_read32((cc)->core,  
> offset)
> +#define bcmai_cc_write32(cc, offset, val)       
> bcmai_write32((cc)->core, offset, val)
> +
> +#define bcmai_cc_mask32(cc, offset, mask) \
> +               bcmai_cc_write32(cc, offset, bcmai_cc_read32(cc, offset)  
> & (mask))
> +#define bcmai_cc_set32(cc, offset, set) \
> +               bcmai_cc_write32(cc, offset, bcmai_cc_read32(cc, offset)  
> | (set))
> +#define bcmai_cc_maskset32(cc, offset, mask, set) \
> +               bcmai_cc_write32(cc, offset, (bcmai_cc_read32(cc,  
> offset) & (mask)) | (set))
> +
> +extern void bcmai_core_chipcommon_init(struct bcmai_drv_cc *cc);
> +
> +extern void bcmai_chipco_suspend(struct bcmai_drv_cc *cc);
> +extern void bcmai_chipco_resume(struct bcmai_drv_cc *cc);
> +
> +extern void bcmai_chipco_get_clockcpu(struct bcmai_drv_cc *cc,
> +                                    u32 *plltype, u32 *n, u32 *m);
> +extern void bcmai_chipco_get_clockcontrol(struct bcmai_drv_cc *cc,
> +                                       u32 *plltype, u32 *n, u32 *m);
> +extern void bcmai_chipco_timing_init(struct bcmai_drv_cc *cc,
> +                                  unsigned long ns_per_cycle);
> +
> +enum bcmai_clkmode {
> +       BCMAI_CLKMODE_SLOW,
> +       BCMAI_CLKMODE_FAST,
> +       BCMAI_CLKMODE_DYNAMIC,
> +};
> +
> +extern void bcmai_chipco_set_clockmode(struct bcmai_drv_cc *cc,
> +                                    enum bcmai_clkmode mode);
> +
> +extern void bcmai_chipco_watchdog_timer_set(struct bcmai_drv_cc *cc,
> +                                         u32 ticks);
> +
> +void bcmai_chipco_irq_mask(struct bcmai_drv_cc *cc, u32 mask, u32  
> value);
> +
> +u32 bcmai_chipco_irq_status(struct bcmai_drv_cc *cc, u32 mask);
> +
> +/* Chipcommon GPIO pin access. */
> +u32 bcmai_chipco_gpio_in(struct bcmai_drv_cc *cc, u32 mask);
> +u32 bcmai_chipco_gpio_out(struct bcmai_drv_cc *cc, u32 mask, u32 value);
> +u32 bcmai_chipco_gpio_outen(struct bcmai_drv_cc *cc, u32 mask, u32  
> value);
> +u32 bcmai_chipco_gpio_control(struct bcmai_drv_cc *cc, u32 mask, u32  
> value);
> +u32 bcmai_chipco_gpio_intmask(struct bcmai_drv_cc *cc, u32 mask, u32  
> value);
> +u32 bcmai_chipco_gpio_polarity(struct bcmai_drv_cc *cc, u32 mask, u32  
> value);
> +
> +#ifdef CONFIG_SSB_SERIAL
> +extern int bcmai_chipco_serial_init(struct bcmai_drv_cc *cc,
> +                                 struct ssb_serial_port *ports);
> +#endif /* CONFIG_SSB_SERIAL */
> +
> +/* PMU support */
> +extern void bcmai_pmu_init(struct bcmai_drv_cc *cc);
> +
> +#endif /* LINUX_BCMAI_DRIVER_CC_H_ */
> diff --git a/include/linux/bcmai/bcmai_driver_pci.h  
> b/include/linux/bcmai/bcmai_driver_pci.h
> new file mode 100644
> index 0000000..113f84b
> --- /dev/null
> +++ b/include/linux/bcmai/bcmai_driver_pci.h
> @@ -0,0 +1,92 @@
> +#ifndef LINUX_BCMAI_DRIVER_PCI_H_
> +#define LINUX_BCMAI_DRIVER_PCI_H_
> +
> +#include <linux/types.h>
> +
> +struct pci_dev;
> +
> +/* PCI core registers. */
> +#define BCMAI_CORE_PCI_CTL                     0x0000  /* PCI Control */
> +#define  BCMAI_CORE_PCI_CTL_RST_OE             0x00000001 /* PCI_RESET  
> Output Enable */
> +#define  BCMAI_CORE_PCI_CTL_RST                        0x00000002 /*  
> PCI_RESET driven out to pin */
> +#define  BCMAI_CORE_PCI_CTL_CLK_OE             0x00000004 /* Clock gate  
> Output Enable */
> +#define  BCMAI_CORE_PCI_CTL_CLK                        0x00000008 /*  
> Gate for clock driven out to pin */
> +#define BCMAI_CORE_PCI_ARBCTL                  0x0010  /* PCI Arbiter  
> Control */
> +#define  BCMAI_CORE_PCI_ARBCTL_INTERN          0x00000001 /* Use  
> internal arbiter */
> +#define  BCMAI_CORE_PCI_ARBCTL_EXTERN          0x00000002 /* Use  
> external arbiter */
> +#define  BCMAI_CORE_PCI_ARBCTL_PARKID          0x00000006 /* Mask,  
> selects which agent is parked on an idle bus */
> +#define   BCMAI_CORE_PCI_ARBCTL_PARKID_LAST    0x00000000 /* Last  
> requestor */
> +#define   BCMAI_CORE_PCI_ARBCTL_PARKID_4710    0x00000002 /* 4710 */
> +#define   BCMAI_CORE_PCI_ARBCTL_PARKID_EXT0    0x00000004 /* External  
> requestor 0 */
> +#define   BCMAI_CORE_PCI_ARBCTL_PARKID_EXT1    0x00000006 /* External  
> requestor 1 */
> +#define BCMAI_CORE_PCI_ISTAT                   0x0020  /* Interrupt  
> status */
> +#define  BCMAI_CORE_PCI_ISTAT_INTA             0x00000001 /* PCI INTA#  
> */
> +#define  BCMAI_CORE_PCI_ISTAT_INTB             0x00000002 /* PCI INTB#  
> */
> +#define  BCMAI_CORE_PCI_ISTAT_SERR             0x00000004 /* PCI SERR#  
> (write to clear) */
> +#define  BCMAI_CORE_PCI_ISTAT_PERR             0x00000008 /* PCI PERR#  
> (write to clear) */
> +#define  BCMAI_CORE_PCI_ISTAT_PME              0x00000010 /* PCI PME# */
> +#define BCMAI_CORE_PCI_IMASK                   0x0024  /* Interrupt  
> mask */
> +#define  BCMAI_CORE_PCI_IMASK_INTA             0x00000001 /* PCI INTA#  
> */
> +#define  BCMAI_CORE_PCI_IMASK_INTB             0x00000002 /* PCI INTB#  
> */
> +#define  BCMAI_CORE_PCI_IMASK_SERR             0x00000004 /* PCI SERR#  
> */
> +#define  BCMAI_CORE_PCI_IMASK_PERR             0x00000008 /* PCI PERR#  
> */
> +#define  BCMAI_CORE_PCI_IMASK_PME              0x00000010 /* PCI PME# */
> +#define BCMAI_CORE_PCI_MBOX                    0x0028  /* Backplane to  
> PCI Mailbox */
> +#define  BCMAI_CORE_PCI_MBOX_F0_0              0x00000100 /* PCI  
> function 0, INT 0 */
> +#define  BCMAI_CORE_PCI_MBOX_F0_1              0x00000200 /* PCI  
> function 0, INT 1 */
> +#define  BCMAI_CORE_PCI_MBOX_F1_0              0x00000400 /* PCI  
> function 1, INT 0 */
> +#define  BCMAI_CORE_PCI_MBOX_F1_1              0x00000800 /* PCI  
> function 1, INT 1 */
> +#define  BCMAI_CORE_PCI_MBOX_F2_0              0x00001000 /* PCI  
> function 2, INT 0 */
> +#define  BCMAI_CORE_PCI_MBOX_F2_1              0x00002000 /* PCI  
> function 2, INT 1 */
> +#define  BCMAI_CORE_PCI_MBOX_F3_0              0x00004000 /* PCI  
> function 3, INT 0 */
> +#define  BCMAI_CORE_PCI_MBOX_F3_1              0x00008000 /* PCI  
> function 3, INT 1 */
> +#define BCMAI_CORE_PCI_BCAST_ADDR              0x0050  /* Backplane  
> Broadcast Address */
> +#define  BCMAI_CORE_PCI_BCAST_ADDR_MASK                0x000000FF
> +#define BCMAI_CORE_PCI_BCAST_DATA              0x0054  /* Backplane  
> Broadcast Data */
> +#define BCMAI_CORE_PCI_GPIO_IN                 0x0060  /* rev >= 2 only  
> */
> +#define BCMAI_CORE_PCI_GPIO_OUT                        0x0064  /* rev  
> >= 2 only */
> +#define BCMAI_CORE_PCI_GPIO_ENABLE             0x0068  /* rev >= 2 only  
> */
> +#define BCMAI_CORE_PCI_GPIO_CTL                        0x006C  /* rev  
> >= 2 only */
> +#define BCMAI_CORE_PCI_SBTOPCI0                        0x0100  /*  
> Backplane to PCI translation 0 (sbtopci0) */
> +#define  BCMAI_CORE_PCI_SBTOPCI0_MASK          0xFC000000
> +#define BCMAI_CORE_PCI_SBTOPCI1                        0x0104  /*  
> Backplane to PCI translation 1 (sbtopci1) */
> +#define  BCMAI_CORE_PCI_SBTOPCI1_MASK          0xFC000000
> +#define BCMAI_CORE_PCI_SBTOPCI2                        0x0108  /*  
> Backplane to PCI translation 2 (sbtopci2) */
> +#define  BCMAI_CORE_PCI_SBTOPCI2_MASK          0xC0000000
> +#define BCMAI_CORE_PCI_PCICFG0                 0x0400  /* PCI config  
> space 0 (rev >= 8) */
> +#define BCMAI_CORE_PCI_PCICFG1                 0x0500  /* PCI config  
> space 1 (rev >= 8) */
> +#define BCMAI_CORE_PCI_PCICFG2                 0x0600  /* PCI config  
> space 2 (rev >= 8) */
> +#define BCMAI_CORE_PCI_PCICFG3                 0x0700  /* PCI config  
> space 3 (rev >= 8) */
> +#define BCMAI_CORE_PCI_SPROM(wordoffset)       (0x0800 + ((wordoffset)  
> * 2)) /* SPROM shadow area (72 bytes) */
> +
> +/* SBtoPCIx */
> +#define BCMAI_CORE_PCI_SBTOPCI_MEM             0x00000000
> +#define BCMAI_CORE_PCI_SBTOPCI_IO              0x00000001
> +#define BCMAI_CORE_PCI_SBTOPCI_CFG0            0x00000002
> +#define BCMAI_CORE_PCI_SBTOPCI_CFG1            0x00000003
> +#define BCMAI_CORE_PCI_SBTOPCI_PREF            0x00000004 /* Prefetch  
> enable */
> +#define BCMAI_CORE_PCI_SBTOPCI_BURST           0x00000008 /* Burst  
> enable */
> +#define BCMAI_CORE_PCI_SBTOPCI_MRM             0x00000020 /* Memory  
> Read Multiple */
> +#define BCMAI_CORE_PCI_SBTOPCI_RC              0x00000030 /* Read  
> Command mask (rev >= 11) */
> +#define  BCMAI_CORE_PCI_SBTOPCI_RC_READ                0x00000000 /*  
> Memory read */
> +#define  BCMAI_CORE_PCI_SBTOPCI_RC_READL       0x00000010 /* Memory  
> read line */
> +#define  BCMAI_CORE_PCI_SBTOPCI_RC_READM       0x00000020 /* Memory  
> read multiple */
> +
> +/* PCIcore specific boardflags */
> +#define BCMAI_CORE_PCI_BFL_NOPCI               0x00000400 /* Board  
> leaves PCI floating */
> +
> +struct bcmai_drv_pci {
> +       struct bcmai_device *core;
> +       u8 setup_done:1;
> +};
> +
> +extern void bcmai_core_pci_init(struct bcmai_drv_pci *pc);
> +
> +/* Enable IRQ routing for a specific device */
> +extern int bcmai_pcicore_dev_irqvecs_enable(struct bcmai_drv_pci *pc,
> +                                           struct bcmai_device *core);
> +
> +int ssb_pcicore_plat_dev_init(struct pci_dev *d);
> +int ssb_pcicore_pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8  
> pin);
> +
> +#endif /* LINUX_BCMAI_DRIVER_PCI_H_ */
> diff --git a/include/linux/bcmai/bcmai_regs.h  
> b/include/linux/bcmai/bcmai_regs.h
> new file mode 100644
> index 0000000..68ab97f
> --- /dev/null
> +++ b/include/linux/bcmai/bcmai_regs.h
> @@ -0,0 +1,34 @@
> +#ifndef LINUX_BCMAI_REGS_H_
> +#define LINUX_BCMAI_REGS_H_
> +
> +/* Agent registers (common for every core) */
> +#define BCMAI_IOCTL                    0x0408
> +#define  BCMAI_IOCTL_CORE_BITS         0x3FFC
> +#define  BCMAI_IOCTL_CLK               0x0001
> +#define  BCMAI_IOCTL_FGC               0x0002
> +#define  BCMAI_IOCTL_PME_EN            0x4000
> +#define  BCMAI_IOCTL_BIST_EN           0x8000
> +#define BCMAI_RESET_CTL                        0x0800
> +#define  BCMAI_RESET_CTL_RESET         0x0001
> +
> +/* SSB PCI config space registers. */
> +#define BCMAI_PCI_PMCSR                        0x44
> +#define  BCMAI_PCI_PE                  0x100
> +#define        BCMAI_PCI_BAR0_WIN              0x80    /* Backplane  
> address space 0 */
> +#define        BCMAI_PCI_BAR1_WIN              0x84    /* Backplane  
> address space 1 */
> +#define        BCMAI_PCI_SPROMCTL              0x88    /* SPROM control  
> */
> +#define  BCMAI_PCI_SPROMCTL_WE         0x10    /* SPROM write enable */
> +#define        BCMAI_PCI_BAR1_CONTROL          0x8c    /* Address space  
> 1 burst control */
> +#define BCMAI_PCI_IRQS                 0x90    /* PCI interrupts */
> +#define BCMAI_PCI_IRQMASK              0x94    /* PCI IRQ control and  
> mask (pcirev >= 6 only) */
> +#define BCMAI_PCI_BACKPLANE_IRQS       0x98    /* Backplane Interrupts  
> */
> +#define BCMAI_PCI_BAR0_WIN2            0xAC
> +#define BCMAI_PCI_GPIO_IN              0xB0    /* GPIO Input (pcirev >=  
> 3 only) */
> +#define BCMAI_PCI_GPIO_OUT             0xB4    /* GPIO Output (pcirev  
> >= 3 only) */
> +#define BCMAI_PCI_GPIO_OUT_ENABLE      0xB8    /* GPIO Output  
> Enable/Disable (pcirev >= 3 only) */
> +#define  BCMAI_PCI_GPIO_SCS            0x10    /* PCI config space bit  
> 4 for 4306c0 slow clock source */
> +#define  BCMAI_PCI_GPIO_HWRAD          0x20    /* PCI config space GPIO  
> 13 for hw radio disable */
> +#define  BCMAI_PCI_GPIO_XTAL           0x40    /* PCI config space GPIO  
> 14 for Xtal powerup */
> +#define  BCMAI_PCI_GPIO_PLL            0x80    /* PCI config space GPIO  
> 15 for PLL powerdown */
> +
> +#endif /* LINUX_BCMAI_REGS_H_ */
> diff --git a/include/linux/mod_devicetable.h  
> b/include/linux/mod_devicetable.h
> index 48c007d..b4869cd 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -382,6 +382,21 @@ struct ssb_device_id {
>  #define SSB_ANY_ID             0xFFFF
>  #define SSB_ANY_REV            0xFF
>
> +/* AI core, see drivers/bcmai/ */
> +struct bcmai_device_id {
> +       __u16   manuf;
> +       __u16   id;
> +       __u8    rev;
> +};
> +#define BCMAI_CORE(_manuf, _id, _rev)  \
> +       { .manuf = _manuf, .id = _id, .rev = _rev, }
> +#define BCMAI_CORETABLE_END  \
> +       { 0, },
> +
> +#define BCMAI_ANY_MANUF                0xFFFF
> +#define BCMAI_ANY_ID           0xFFFF
> +#define BCMAI_ANY_REV          0xFF
> +
>  struct virtio_device_id {
>         __u32 device;
>         __u32 vendor;
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index 88f3f07..c048e5f 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -702,6 +702,22 @@ static int do_ssb_entry(const char *filename,
>         return 1;
>  }
>
> +/* Looks like: bcmai:mNidNrevN. */
> +static int do_bcmai_entry(const char *filename,
> +                         struct bcmai_device_id *id, char *alias)
> +{
> +       id->manuf = TO_NATIVE(id->manuf);
> +       id->id = TO_NATIVE(id->id);
> +       id->rev = TO_NATIVE(id->rev);
> +
> +       strcpy(alias, "bcmai:");
> +       ADD(alias, "m", id->manuf != BCMAI_ANY_MANUF, id->manuf);
> +       ADD(alias, "id", id->id != BCMAI_ANY_ID, id->id);
> +       ADD(alias, "rev", id->rev != BCMAI_ANY_REV, id->rev);
> +       add_wildcard(alias);
> +       return 1;
> +}
> +
>  /* Looks like: virtio:dNvN */
>  static int do_virtio_entry(const char *filename, struct  
> virtio_device_id *id,
>                            char *alias)
> @@ -968,6 +984,10 @@ void handle_moddevtable(struct module *mod, struct  
> elf_info *info,
>                 do_table(symval, sym->st_size,
>                          sizeof(struct ssb_device_id), "ssb",
>                          do_ssb_entry, mod);
> +       else if (sym_is(symname, "__mod_bcmai_device_table"))
> +               do_table(symval, sym->st_size,
> +                        sizeof(struct bcmai_device_id), "bcmai",
> +                        do_bcmai_entry, mod);
>         else if (sym_is(symname, "__mod_virtio_device_table"))
>                 do_table(symval, sym->st_size,
>                          sizeof(struct virtio_device_id), "virtio",
> --
> 1.7.3.4
>
>


-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

