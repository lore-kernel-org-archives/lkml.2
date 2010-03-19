Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab0CSPgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 11:36:47 -0400
Received: from mga10.intel.com ([192.55.52.92]:56025 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751062Ab0CSPgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 11:36:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,275,1267430400"; 
   d="scan'208";a="550526209"
Date: Fri, 19 Mar 2010 16:37:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4 v2] MFD: add support for the RDC321x southbridge
Message-ID: <20100319153735.GA30409@sortiz.org>
References: <201003110942.09251.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003110942.09251.florian@openwrt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

My comments below:

On Thu, Mar 11, 2010 at 09:42:09AM +0100, Florian Fainelli wrote:
> +
> +static struct pci_dev *rdc321x_sb_pdev;
That's not very nice. I would have prefered to pass the pci_dev pointer along
with the platform data to the gpio and watchdog drivers. And then those could
call pci_read_config_dword() directly.


> +/*
> + * Unlocked PCI configuration space accessors
> + */
> +int rdc321x_pci_read(int reg, u32 *val)
> +{
> +	int err;
> +
> +	err = pci_read_config_dword(rdc321x_sb_pdev, reg, val);
> +	if (err)
> +		return err;
> +
> +	return err;
If you want to keep your static pci_dev pointer around, please replace this
routine with:

int rdc321x_pci_read(int reg, u32 *val)
{
	return pci_read_config_dword(rdc321x_sb_pdev, reg, val);
}


> +EXPORT_SYMBOL(rdc321x_pci_read);
> +
> +int rdc321x_pci_write(int reg, u32 val)
> +{
> +	int err;
> +
> +	err = pci_write_config_dword(rdc321x_sb_pdev, reg, val);
> +	if (err)
> +		return err;
> +
> +	return err;
> +}
Ditto.

> +static int __devinit rdc321x_sb_probe(struct pci_dev *pdev,
> +					const struct pci_device_id *ent)
> +{
> +	int err;
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		printk(KERN_ERR "failed to enable device\n");
Please use dev_err()

> --- /dev/null
> +++ b/include/linux/mfd/rdc321x.h
> @@ -0,0 +1,24 @@
> +#ifndef __RDC321X_MFD_H
> +#define __RDC321X_MFD_H
> +
> +#include <linux/types.h>
> +
> +/* Offsets to be accessed in the southbridge PCI
> + * device configuration register */
> +#define RDC321X_WDT_CTRL	0x44
> +#define RDC321X_GPIO_CTRL_REG1	0x48
> +#define RDC321X_GPIO_DATA_REG1	0x4c
> +#define RDC321X_GPIO_CTRL_REG2	0x84
> +#define RDC321X_GPIO_DATA_REG2	0x88
> +
> +#define RDC321X_MAX_GPIO	58
As Wim pointed out, moving those definitions from rdc321x_defs.h to here
should be done in one patch, to avoid bisection breakage.
So, please merge the first patch of your serie with this one, and add a
watchdog driver fix that includes inux/mfd/rdc321x.h instead of
rdc321x_defs.h.

Cheers,
Samuel.


> +/* Definitions for the shared southbridge accessors */
> +int rdc321x_pci_write(int reg, u32 val);
> +int rdc321x_pci_read(int reg, u32 *val);
> +
> +struct rdc321x_gpio_pdata {
> +	unsigned max_gpios;
> +};
> +
> +#endif /* __RDC321X_MFD_H */

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
