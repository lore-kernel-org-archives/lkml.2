Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2I3Wtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 18:49:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:8190 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2I3Wti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 18:49:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="199009582"
Date: Mon, 1 Oct 2012 00:49:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        oakad@yahoo.com, bp@alien8.de
Subject: Re: [PATCH v6 1/3] drivers/mfd: Add realtek pcie card reader driver
Message-ID: <20120930224933.GB12231@sortiz-mobl>
References: <cover.1347330871.git.wei_wang@realsil.com.cn>
 <b3b7a3d03d9591c1f393f4c4f488efbd15756c7c.1347330871.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3b7a3d03d9591c1f393f4c4f488efbd15756c7c.1347330871.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Tue, Sep 11, 2012 at 12:54:22PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek PCI-E card reader driver adapts requests from upper-level
> sdmmc/memstick layer to the real physical card reader.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Tested-by: Borislav Petkov <bp@alien8.de>
> ---
>  drivers/mfd/Kconfig             |    9 +
>  drivers/mfd/Makefile            |    4 +
>  drivers/mfd/rts5209.c           |  188 ++++++
>  drivers/mfd/rts5229.c           |  179 ++++++
>  drivers/mfd/rtsx_pcr.c          | 1345 +++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.h          |   31 +
>  include/linux/mfd/rtsx_common.h |   47 ++
>  include/linux/mfd/rtsx_pci.h    |  773 ++++++++++++++++++++++
>  8 files changed, 2576 insertions(+)
>  create mode 100644 drivers/mfd/rts5209.c
>  create mode 100644 drivers/mfd/rts5229.c
>  create mode 100644 drivers/mfd/rtsx_pcr.c
>  create mode 100644 drivers/mfd/rtsx_pcr.h
>  create mode 100644 include/linux/mfd/rtsx_common.h
>  create mode 100644 include/linux/mfd/rtsx_pci.h
Although  pretty big, the patch looks mostly good to me.
I only have a few comments:

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index d1facef..4c07a34 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -63,6 +63,15 @@ config MFD_SM501_GPIO
>  	 lines on the SM501. The platform data is used to supply the
>  	 base number for the first GPIO line to register.
>  
> +config MFD_RTSX_PCI
> +	tristate "Support for Realtek PCI-E driver-based card reader"
> +	depends on PCI
> +	help
> +	  This supports for Realtek PCI-Express driver-based card reader including
> +	  rts5209, rts5229, etc. Realtek driver-based card reader supports access
driver-based ?

> diff --git a/drivers/mfd/rts5209.c b/drivers/mfd/rts5209.c
> new file mode 100644
> index 0000000..6680d6d
> --- /dev/null
> +++ b/drivers/mfd/rts5209.c
> @@ -0,0 +1,188 @@
> +/* Driver for Realtek PCI-Express card reader
> + *
> + * Copyright(c) 2009 Realtek Semiconductor Corp. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the
> + * Free Software Foundation; either version 2, or (at your option) any
> + * later version.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + *
> + * Author:
> + *   Wei WANG <wei_wang@realsil.com.cn>
> + *   No. 450, Shenhu Road, Suzhou Industry Park, Suzhou, China
> + */
> +
> +#include <linux/module.h>
> +#include <linux/mfd/rtsx_pci.h>
> +
> +#include "rtsx_pcr.h"
> +
> +static u8 rts5209_get_ic_version(struct rtsx_pcr *pcr)
> +{
> +	u8 val;
> +
> +	val = rtsx_pci_readb(pcr, 0x1C);
> +	return val & 0x0F;
For your IO accesses, it would e worth looking at the regmap MMIO routines. It
would also simplify your main probe routine.


> +static int rts5209_turn_on_led(struct rtsx_pcr *pcr)
> +{
> +	return rtsx_pci_write_register(pcr, 0xFD58, 0x01, 0x00);
You have many hardcoded register adresses around this code. Defining them in
your header file wouldn't hurt.


> +static struct platform_device *rtsx_pci_create_subdev(struct rtsx_pcr *pcr,
> +		const char *name, int slot_id)
> +{
> +	struct platform_device *p_dev;
> +	int err;
> +
> +	p_dev = platform_device_alloc(name, pcr->id);
> +	if (p_dev == NULL) {
> +		dev_dbg(&(pcr->pci->dev), "alloc platform device fail!\n");
> +		return NULL;
> +	}
> +
> +	p_dev->dev.parent = &(pcr->pci->dev);
> +	platform_set_drvdata(p_dev, pcr);
> +	pcr->slots[slot_id].p_dev = p_dev;
> +
> +	err = platform_device_add(p_dev);
> +	if (err) {
> +		dev_dbg(&(pcr->pci->dev), "add platform device fail!\n");
> +		pcr->slots[slot_id].p_dev = NULL;
> +		platform_device_put(p_dev);
> +		return NULL;
> +	}
> +
> +	return p_dev;
> +}
Please use the MFD device addition API for that.


> +static irqreturn_t rtsx_pci_isr(int irq, void *dev_id)
> +{
> +	struct rtsx_pcr *pcr = dev_id;
> +	u32 int_reg;
> +
> +	if (!pcr)
> +		return IRQ_NONE;
> +
> +	spin_lock(&pcr->lock);
> +
> +	int_reg = rtsx_pci_readl(pcr, RTSX_BIPR);
> +	/* Clear interrupt flag */
> +	rtsx_pci_writel(pcr, RTSX_BIPR, int_reg);
> +	if ((int_reg & pcr->bier) == 0) {
> +		spin_unlock(&pcr->lock);
> +		return IRQ_NONE;
> +	}
> +	if (int_reg == 0xFFFFFFFF) {
> +		spin_unlock(&pcr->lock);
> +		return IRQ_HANDLED;
> +	}
> +
> +	int_reg &= (pcr->bier | 0x7FFFFF);
> +
> +	if (int_reg & SD_INT) {
> +		if (int_reg & SD_EXIST) {
> +			pcr->need_reset |= SD_EXIST;
> +		} else {
> +			pcr->need_release |= SD_EXIST;
> +			pcr->need_reset &= ~SD_EXIST;
> +		}
> +	}
> +
> +	if (int_reg & MS_INT) {
> +		if (int_reg & MS_EXIST) {
> +			pcr->need_reset |= MS_EXIST;
> +		} else {
> +			pcr->need_release |= MS_EXIST;
> +			pcr->need_reset &= ~MS_EXIST;
> +		}
> +	}
> +
> +	if (pcr->need_reset || pcr->need_release)
> +		queue_delayed_work(workqueue, &pcr->carddet_work,
> +				msecs_to_jiffies(200));
Why do we need a delayed work here ?


> +static void rtsx_pci_enter_idle(unsigned long __data)
> +{
> +	struct rtsx_pcr *pcr = (struct rtsx_pcr *)__data;
> +
> +	queue_work(workqueue, &pcr->idle_work);
> +}
OT: We need threaded timers...


> +static int __init rtsx_pci_drv_init(void)
> +{
> +	workqueue = create_freezable_workqueue("rtsx_pci_wq");
> +	if (!workqueue)
> +		return -ENOMEM;
Are you sure you really need to create your won workqueue ? My guess is that
you probably don't.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
