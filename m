Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934004Ab1DNTQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:16:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61106 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172Ab1DNTQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IM82ZwX85gDtS7L/zP9QQLg/VywrSCXca5QGOTkeedTen26n9+QOXUFyyzms3wKMB/
         oXG7iADduOlD4ksShepbW+INfw/sc35DcNfyb4Fm2BbuyjledGJLGr35rQJrrRqP0T8e
         N5TxS8UZtrYeozRZCAS9me+KwRBHhlPtL/o84=
Date: Thu, 14 Apr 2011 21:16:27 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>,
        Thomas Renninger <trenn@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH v4] hwmon: Add driver for AMD family 15h processor power
 information
Message-ID: <20110414191627.GA773@alberich.amd.com>
References: <20110404160733.GA11818@alberich.amd.com>
 <20110405144536.GA5054@alberich.amd.com>
 <20110406135424.GC2177@alberich.amd.com>
 <20110408135407.GA12014@alberich.amd.com>
 <20110413150633.775cf527@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413150633.775cf527@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:06:33PM +0200, Jean Delvare wrote:
> Hi Andreas,
> 
> On Fri, 8 Apr 2011 15:54:07 +0200, Andreas Herrmann wrote:
> > From: Andreas Herrmann <andreas.herrmann3@amd.com>
> > 
> > This CPU family provides NB register values to gather following
> > TDP information
> > 
> > * ProcessorPwrWatts: Specifies in Watts the maximum amount of power
> >   the processor can support.
> > * CurrPwrWatts: Specifies in Watts the current amount of power being
> >   consumed by the processor.
> > 
> > This driver provides
> > 
> > * power1_max (ProcessorPwrWatts)
> 
> Still questionable whether power1_crit would be more appropriate...

Finally, I've changed it.

> > * power1_input (CurrPwrWatts)
> > 
> > Changes from v2:
> >  - fix format strings
> >  - removed paranoid checks for existense of functions 3 and 5
> >  - changed return type of function f15h_power_is_internal_node0
> >  - use power1_max instead of power1_cap
> >  - use dev_warn instead of WARN_ON
> >  - rebased against 2.6.39-rc2
> >  - added Documentation/hwmon/f15h_power
> > 
> > Changes from v3:
> >  - read static power information only once (during driver initialization)
> >  - made use of attribute groups
> >  - renamed f15h_power to fam15h_power
> > 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  Documentation/hwmon/fam15h_power |   37 ++++++
> >  drivers/hwmon/Kconfig            |   10 ++
> >  drivers/hwmon/Makefile           |    1 +
> >  drivers/hwmon/fam15h_power.c     |  229 ++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 277 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/hwmon/fam15h_power
> >  create mode 100644 drivers/hwmon/fam15h_power.c
> > 
> > At this stage I consider the _max attribute as the right one for
> > reporting ProcessorPwrWatts.
> > 
> > Hopefully I've addressed all your coments.
> > Please apply.
> 
> It seems I have some more comments, but these are very small things you
> should have no problem addressing quickly:
> 
> > diff --git a/Documentation/hwmon/fam15h_power b/Documentation/hwmon/fam15h_power
> > new file mode 100644
> > index 0000000..2f4d291
> > --- /dev/null
> > +++ b/Documentation/hwmon/fam15h_power
> > @@ -0,0 +1,37 @@
> > +Kernel driver fam15h_power
> > +==========================
> > +
> > +Supported chips:
> > +* AMD Family 15h Processors
> > +
> > +  Prefix: 'fam15h_power'
> > +  Addresses scanned: PCI space
> > +  Datasheets:
> > +  BIOS and Kernel Developer's Guide (BKDG) For AMD Family 15h Processors
> > +    (not yet published)
> > +
> > +Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> > +
> > +Description
> > +-----------
> > +
> > +This driver permits reading of registers providing power information
> > +of AMD Family 15h processors.
> > +
> > +For AMD Family 15h processors the following power values can be
> > +calculated using different processor northbridge function registers:
> > +
> > +* BasePwrWatts: Specifies in watts the maximum amount of power
> > +  consumed by the processor for NB and logic external to the core.
> > +* ProcessorPwrWatts: Specifies in watts the maximum amount of power
> > +  the processor can support.
> > +* CurrPwrWatts: Specifies in watts the current amount of power being
> > +  consumed by the processor.
> > +
> > +This driver provides ProcessorPwrWatts and CurrPwrWatts:
> > +* power1_max (ProcessorPwrWatts)
> > +* power1_input (CurrPwrWatts)
> > +
> > +On multi-node processors the calculated value is for the entire
> > +package and not for a single node. Thus the driver creates sysfs
> > +attributes only for internal node0 of a multi-node processor.
> > diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> > index 060ef63..fb3e334 100644
> > --- a/drivers/hwmon/Kconfig
> > +++ b/drivers/hwmon/Kconfig
> > @@ -249,6 +249,16 @@ config SENSORS_K10TEMP
> >  	  This driver can also be built as a module.  If so, the module
> >  	  will be called k10temp.
> >  
> > +config SENSORS_FAM15H_POWER
> > +	tristate "AMD Family 15h processor power"
> > +	depends on X86 && PCI
> > +	help
> > +	  If you say yes here you get support for processor power
> > +	  information of your AMD family 15h CPU.
> > +
> > +	  This driver can also be built as a module.  If so, the module
> > +	  will be called fam15h_power.
> > +
> >  config SENSORS_ASB100
> >  	tristate "Asus ASB100 Bach"
> >  	depends on X86 && I2C && EXPERIMENTAL
> > diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> > index 967d0ea..236d3f9 100644
> > --- a/drivers/hwmon/Makefile
> > +++ b/drivers/hwmon/Makefile
> > @@ -49,6 +49,7 @@ obj-$(CONFIG_SENSORS_EMC2103)	+= emc2103.o
> >  obj-$(CONFIG_SENSORS_F71805F)	+= f71805f.o
> >  obj-$(CONFIG_SENSORS_F71882FG)	+= f71882fg.o
> >  obj-$(CONFIG_SENSORS_F75375S)	+= f75375s.o
> > +obj-$(CONFIG_SENSORS_FAM15H_POWER) += fam15h_power.o
> >  obj-$(CONFIG_SENSORS_FSCHMD)	+= fschmd.o
> >  obj-$(CONFIG_SENSORS_G760A)	+= g760a.o
> >  obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
> > diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
> > new file mode 100644
> > index 0000000..cb6eb99
> > --- /dev/null
> > +++ b/drivers/hwmon/fam15h_power.c
> > @@ -0,0 +1,229 @@
> > +/*
> > + * fam15h_power.c - AMD Family 15h processor power monitoring
> > + *
> > + * Copyright (c) 2011 Advanced Micro Devices, Inc.
> > + * Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> > + *
> > + *
> > + * This driver is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License; either
> > + * version 2 of the License, or (at your option) any later version.
> > + *
> > + * This driver is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> > + * See the GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this driver; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/err.h>
> > +#include <linux/hwmon.h>
> > +#include <linux/hwmon-sysfs.h>
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/pci.h>
> > +#include <linux/bitops.h>
> > +#include <asm/processor.h>
> > +
> > +MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
> > +MODULE_AUTHOR("Andreas Herrmann <andreas.herrmann3@amd.com>");
> > +MODULE_LICENSE("GPL");
> > +
> > +/* D18F3 */
> > +#define REG_NORTHBRIDGE_CAP		0xe8
> > +
> > +/* D18F4 */
> > +#define REG_PROCESSOR_TDP		0x1b8
> > +
> > +/* D18F5 */
> > +#define REG_TDP_RUNNING_AVERAGE		0xe0
> > +#define REG_TDP_LIMIT3			0xe8
> > +
> > +struct fam15h_power_data {
> > +	struct device *hwmon_dev;
> > +	unsigned int tdp_to_watt;
> > +	unsigned int base_tdp;
> > +	unsigned int processor_pwr_watts;
> 
> watt vs. watts is inconsistent, isn't it?

Changed.

> > +};
> > +
> > +static ssize_t show_power(struct device *dev,
> > +			  struct device_attribute *attr, char *buf)
> > +{
> > +	u32 val, tdp_limit, running_avg_range;
> > +	s32 running_avg_capture;
> > +	u64 curr_pwr_watts;
> > +	struct pci_dev *f4 = to_pci_dev(dev);
> > +	struct fam15h_power_data *data = pci_get_drvdata(f4);
> 
> dev_get_drvdata(dev) would be more efficient.
> 
> > +
> > +	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
> > +				  REG_TDP_RUNNING_AVERAGE, &val);
> > +	running_avg_capture = (val >> 4) & 0x3fffff;
> > +	running_avg_capture = sign_extend32(running_avg_capture, 22);
> > +	running_avg_range = val & 0xf;
> > +
> > +	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
> > +				  REG_TDP_LIMIT3, &val);
> > +
> > +	tdp_limit = val >> 16;
> > +	curr_pwr_watts = tdp_limit  + data->base_tdp -
> 
> Doubled space.

Whoops!

> > +		(s32)(running_avg_capture >> (running_avg_range + 1));
> > +	curr_pwr_watts *= data->tdp_to_watt;
> > +
> > +	/*
> > +	 * Convert to microWatt
> > +	 *
> > +	 * power is in Watt provided as fixed point integer with
> > +	 * scaling factor 1/(2^16).  For conversion we use
> > +	 * (10^6)/(2^16) = 15625/(2^10)
> > +	 */
> > +	curr_pwr_watts = (curr_pwr_watts * 15625) >> 10;
> > +	return sprintf(buf, "%u\n", (unsigned int) curr_pwr_watts);
> > +}
> > +static DEVICE_ATTR(power1_input, S_IRUGO, show_power, NULL);
> > +
> > +static ssize_t show_power_max(struct device *dev,
> > +			     struct device_attribute *attr, char *buf)
> > +{
> > +	struct pci_dev *f4 = to_pci_dev(dev);
> > +	struct fam15h_power_data *data = pci_get_drvdata(f4);
> 
> dev_get_drvdata(dev) would be more efficient (you don't even need f4
> then.)
> 
> > +	return sprintf(buf, "%u\n", data->processor_pwr_watts);
> > +}
> > +static DEVICE_ATTR(power1_max, S_IRUGO, show_power_max, NULL);
> > +
> > +static ssize_t show_name(struct device *dev,
> > +			 struct device_attribute *attr, char *buf)
> > +{
> > +	return sprintf(buf, "fam15h_power\n");
> > +}
> > +static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
> > +
> > +static struct attribute *fam15h_power_attrs[] = {
> > +	&dev_attr_power1_input.attr,
> > +	&dev_attr_power1_max.attr,
> > +	&dev_attr_name.attr,
> > +	NULL
> > +};
> > +
> > +static struct attribute_group fam15h_power_attr_group = {
> 
> Can be made const.

Done this ....

> > +	.attrs	= fam15h_power_attrs,
> > +};
> > +
> > +static bool __devinit fam15h_power_is_internal_node0(struct pci_dev *f4)
> > +{
> > +	u32 val;
> > +
> > +	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 3),
> > +				  REG_NORTHBRIDGE_CAP, &val);
> > +	if ((val & BIT(29)) && ((val >> 30) & 3))
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> > +static void __devinit fam15h_power_init_data(struct pci_dev *f4,
> > +					     struct fam15h_power_data *data)
> > +{
> > +	u32 val;
> > +	u64 tmp;
> > +
> > +	pci_read_config_dword(f4, REG_PROCESSOR_TDP, &val);
> > +	data->base_tdp = val >> 16;
> > +	tmp = val & 0xffff;
> > +
> > +	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
> > +				  REG_TDP_LIMIT3, &val);
> > +
> > +	data->tdp_to_watt = ((val & 0x3ff) << 6) | ((val >> 10) & 0x3f);
> > +	tmp *= data->tdp_to_watt;
> > +
> > +	/* result not allowed to be >= 256W */
> > +	if ((tmp>>16) >= 256)
> 
> Please add spaces around ">>" for consistency.

... and that.

> > +		dev_warn(&f4->dev, "Bogus value for ProcessorPwrWatts "
> > +			 "(processor_pwr_watts>=%u)\n",
> > +			 (unsigned int) (tmp >> 16));
> > +
> > +	/* convert to microWatt */
> > +	data->processor_pwr_watts = (tmp * 15625) >> 10;
> > +}
> > +
> > +static int __devinit fam15h_power_probe(struct pci_dev *pdev,
> > +					const struct pci_device_id *id)
> > +{
> > +	struct fam15h_power_data *data;
> > +	struct device *dev;
> > +	int err;
> > +
> > +	if (!fam15h_power_is_internal_node0(pdev)) {
> > +		err = -ENODEV;
> > +		goto exit;
> > +	}
> > +
> > +	data = kzalloc(sizeof(struct fam15h_power_data), GFP_KERNEL);
> > +	if (!data) {
> > +		err = -ENOMEM;
> > +		goto exit;
> > +	}
> > +	fam15h_power_init_data(pdev, data);
> > +
> > +	dev = &pdev->dev;
> > +	err = sysfs_create_group(&dev->kobj, &fam15h_power_attr_group);
> > +	if (err)
> > +		goto exit_free_data;
> > +
> > +	data->hwmon_dev = hwmon_device_register(&pdev->dev);
> > +	if (IS_ERR(data->hwmon_dev)) {
> > +		err = PTR_ERR(data->hwmon_dev);
> > +		goto exit_remove_group;
> > +	}
> > +	pci_set_drvdata(pdev, data);
> 
> This is racy. pci_set_drvdata() should be called before creating the
> sysfs attributes, because the sysfs callbacks need it.

Oops -- fixed.


> > +
> > +	return 0;

[snip]


Thanks again for the review


Andreas
