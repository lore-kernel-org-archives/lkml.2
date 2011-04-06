Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1DFOON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:14:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21962 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1DFOOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:14:12 -0400
Date: Wed, 6 Apr 2011 16:14:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: Add driver for AMD family 15h processor power
  information
Message-ID: <20110406161401.1c0ab6de@endymion.delvare>
In-Reply-To: <20110405144536.GA5054@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
	<20110405144536.GA5054@alberich.amd.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 16:45:36 +0200, Andreas Herrmann wrote:
> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> This CPU family provides NB register values to gather following
> TDP information
> 
> * ProcessorPwrWatts: Specifies in Watts the maximum amount of power
>   the processor can support.
> * CurrPwrWatts: Specifies in Watts the current amount of power being
>   consumed by the processor.
> 
> This driver provides
> 
> * power1_cap (ProcessorPwrWatts)
> * power1_input (CurrPwrWatts)

Just a few random comments as I don't have the time for a complete
review:

> 
> Changes from v1::
>  - removed deprecated code line,
>  - fixed comment,
>  - report power only once per socket (Power information is provided
>    for the entire package. On multi-node processors it should only be
>    reported on internal node 0.)
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/hwmon/Kconfig      |   10 ++
>  drivers/hwmon/Makefile     |    1 +
>  drivers/hwmon/f15h_power.c |  216 ++++++++++++++++++++++++++++++++++++++++++++

I would prefer fam15h to f15h. The latter is a little too cryptic for
me.

>  3 files changed, 227 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/f15h_power.c
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 8e84b31..0268623 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -249,6 +249,16 @@ config SENSORS_K10TEMP
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called k10temp.
>  
> +config SENSORS_F15H_POWER
> +	tristate "AMD Family 15h processor power"
> +	depends on X86 && PCI
> +	help
> +	  If you say yes here you get support for processor power
> +	  information of your AMD family 15h CPU.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called f15hpower.
> +
>  config SENSORS_ASB100
>  	tristate "Asus ASB100 Bach"
>  	depends on X86 && I2C && EXPERIMENTAL
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index dde02d9..e554b88 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -62,6 +62,7 @@ obj-$(CONFIG_SENSORS_JC42)	+= jc42.o
>  obj-$(CONFIG_SENSORS_JZ4740)	+= jz4740-hwmon.o
>  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
>  obj-$(CONFIG_SENSORS_K10TEMP)	+= k10temp.o
> +obj-$(CONFIG_SENSORS_F15H_POWER) += f15h_power.o

Alphabetic order please.

>  obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
>  obj-$(CONFIG_SENSORS_LIS3_SPI)	+= lis3lv02d.o lis3lv02d_spi.o
>  obj-$(CONFIG_SENSORS_LIS3_I2C)	+= lis3lv02d.o lis3lv02d_i2c.o
> diff --git a/drivers/hwmon/f15h_power.c b/drivers/hwmon/f15h_power.c
> new file mode 100644
> index 0000000..40e3cbd
> --- /dev/null
> +++ b/drivers/hwmon/f15h_power.c
> @@ -0,0 +1,216 @@
> +/*
> + * f15h_power.c - AMD Family 15h processor power monitoring
> + *
> + * Copyright (c) 2011 Advanced Micro Devices, Inc.
> + * Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> + *
> + *
> + * This driver is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This driver is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> + * See the GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this driver; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/bitops.h>
> +#include <asm/processor.h>
> +
> +MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
> +MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
> +MODULE_LICENSE("GPL");
> +
> +/* D18F3 */
> +#define REG_NORTHBRIDGE_CAP		0xe8
> +
> +/* D18F4 */
> +#define REG_PROCESSOR_TDP		0x1b8
> +
> +/* D18F5 */
> +#define REG_TDP_RUNNING_AVERAGE		0xe0
> +#define REG_TDP_LIMIT3			0xe8
> +
> +static ssize_t show_power(struct device *dev,
> +			  struct device_attribute *attr, char *buf)
> +{
> +	u32 val, btdp, tdpl, tdp2w, arange;
> +	s32 acap;
> +	u64 ctdp;

These variable names aren't easy to understand.

> +	struct pci_dev *f4 = to_pci_dev(dev);
> +	struct pci_dev *f5;
> +
> +	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
> +	btdp = (val >> 16) & 0xffff;

Useless masking.

> +
> +	f5 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5));
> +	if (!f5) {
> +		dev_err(dev, "no function 5 available on this slot\n");
> +		return 0;
> +	}
> +
> +	pci_read_config_dword(f5, REG_TDP_RUNNING_AVERAGE, &val);

Does this value change over time?

> +	acap = (val >> 4) & 0x3fffff;
> +	acap = sign_extend32(acap, 22);
> +	arange = val & 0xf;
> +
> +	pci_read_config_dword(f5, REG_TDP_LIMIT3, &val);

Same question here. If these values don't change over time, they should
be stored in a per-device structure to avoid repeated PCI configuration
space access.

> +	pci_dev_put(f5);
> +
> +	tdpl = (val >> 16) & 0x1fff;
> +	tdp2w = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
> +	ctdp = tdpl - (s32)(acap >> (arange + 1)) + btdp;
> +	ctdp *= tdp2w;
> +
> +	/*
> +	 * Convert to microWatt
> +	 *
> +	 * power is in Watt provided as fixed point integer with
> +	 * scaling factor 1/(2^16).  For conversion we use
> +	 * (10^6)/(2^16) = 15625/(2^10)
> +	 */
> +	ctdp = (ctdp * 15625) >> 10;
> +	return sprintf(buf, "%d\n", (u32) ctdp);

%d and u32 aren't compatible. %lu and long unsigned int would be OK.

> +}
> +static DEVICE_ATTR(power1_input, S_IRUGO, show_power, NULL);
> +
> +static ssize_t show_power_cap(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	u32 val, tdp2w;
> +	u64 ptdp;
> +	struct pci_dev *f4 = to_pci_dev(dev);
> +	struct pci_dev *f5;
> +
> +	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
> +	ptdp = val & 0xffff;
> +
> +	f5 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5));
> +	if (!f5) {
> +		dev_err(dev, "no function 5 available on this slot\n");
> +		return 0;
> +	}
> +
> +	pci_read_config_dword(f5, REG_TDP_LIMIT3, &val);

Same question as above, can this value change over time?

> +	pci_dev_put(f5);
> +
> +	tdp2w = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
> +	ptdp *= tdp2w;
> +
> +	/* result not allowed to be >= 256W */
> +	WARN_ON(ptdp>>16 >= 256);
> +
> +	/* convert to microWatt */
> +	ptdp = (ptdp * 15625) >> 10;
> +	return sprintf(buf, "%d\n", (u32) ptdp);

%d and u32 aren't compatible. %lu and long unsigned int would be OK.

> +}
> +static DEVICE_ATTR(power1_cap, S_IRUGO, show_power_cap, NULL);
> +
> +static ssize_t show_name(struct device *dev,
> +			 struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "f15h_power\n");
> +}
> +static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
> +
> +static int __devinit f15h_power_is_internal_node0(struct pci_dev *f4)
> +{
> +	u32 val;
> +	struct pci_dev *f3;
> +
> +	f3 = pci_get_slot(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3));
> +	if (!f3) {
> +		dev_err(&f4->dev, "no function 3 available on this slot\n");

Please use %d and pass the number as a parameter, and do the same for
the 2 similar messages above. This will let the compiler reuse the
string.

> +		return 0;
> +	}
> +
> +	pci_read_config_dword(f3, REG_NORTHBRIDGE_CAP, &val);
> +	pci_dev_put(f3);
> +
> +	if ((val & BIT(29)) && ((val >> 30) & 3))
> +		return 0;
> +
> +	return 1;
> +}
> +
> +static int __devinit f15h_power_probe(struct pci_dev *pdev,
> +				      const struct pci_device_id *id)
> +{
> +	struct device *hwmon_dev;
> +	int err = -ENODEV;

You should move this initialization to the only case which needs it.
Otherwise you're slowing down the success path with no good reason.

> +
> +	if (!f15h_power_is_internal_node0(pdev))
> +		goto exit;
> +
> +	err = device_create_file(&pdev->dev, &dev_attr_power1_input);
> +	if (err)
> +		goto exit;
> +	err = device_create_file(&pdev->dev, &dev_attr_power1_cap);
> +	if (err)
> +		goto exit_remove;
> +
> +	err = device_create_file(&pdev->dev, &dev_attr_name);
> +	if (err)
> +		goto exit_remove;

Please consider defining and using an attribute group, it makes the
code more simple.

> +
> +	hwmon_dev = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(hwmon_dev)) {
> +		err = PTR_ERR(hwmon_dev);
> +		goto exit_remove;
> +	}
> +	dev_set_drvdata(&pdev->dev, hwmon_dev);

pci_set_drvdata()

> +
> +	return 0;
> +
> +exit_remove:
> +	device_remove_file(&pdev->dev, &dev_attr_name);
> +	device_remove_file(&pdev->dev, &dev_attr_power1_input);
> +	device_remove_file(&pdev->dev, &dev_attr_power1_cap);
> +exit:
> +	return err;
> +}
> +
> +static void __devexit f15h_power_remove(struct pci_dev *pdev)
> +{
> +	hwmon_device_unregister(dev_get_drvdata(&pdev->dev));
> +	device_remove_file(&pdev->dev, &dev_attr_name);
> +	device_remove_file(&pdev->dev, &dev_attr_power1_input);
> +	device_remove_file(&pdev->dev, &dev_attr_power1_cap);
> +	dev_set_drvdata(&pdev->dev, NULL);

pci_set_drvdata()

> +}
> +
> +static const struct pci_device_id f15h_power_id_table[] = {
> +	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },

Not defined anywhere, causing the driver to fail building:

drivers/hwmon/f15h_power.c:193:1: error: 'PCI_DEVICE_ID_AMD_15H_NB_LINK' undeclared here (not in a function)
make[2]: *** [drivers/hwmon/f15h_power.o] Error 1
make[1]: *** [drivers/hwmon] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

> +	{}
> +};
> +MODULE_DEVICE_TABLE(pci, f15h_power_id_table);
> +
> +static struct pci_driver f15h_power_driver = {
> +	.name = "f15h_power",
> +	.id_table = f15h_power_id_table,
> +	.probe = f15h_power_probe,
> +	.remove = __devexit_p(f15h_power_remove),
> +};
> +
> +static int __init f15h_power_init(void)
> +{
> +	return pci_register_driver(&f15h_power_driver);
> +}
> +
> +static void __exit f15h_power_exit(void)
> +{
> +	pci_unregister_driver(&f15h_power_driver);
> +}
> +
> +module_init(f15h_power_init)
> +module_exit(f15h_power_exit)


-- 
Jean Delvare
