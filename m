Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0DCRJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 13:09:25 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49313 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab0DCRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 13:09:21 -0400
Date: Sat, 3 Apr 2010 18:09:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] hwmon: Add driver for intel PCI thermal subsystem
Message-ID: <20100403170917.GA11397@srcf.ucam.org>
References: <1260546750-6206-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260546750-6206-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:52:30AM -0500, Matthew Garrett wrote:
> Recent Intel chipsets have support for a PCI device providing access
> to on-board thermal monitoring. Previous versions have merely used this
> to allow the BIOS to set trip points, but Ibex Peak documents a set of
> registers to read values. This driver implements an hwmon interface to
> read them.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Jean, did you pick this up at any point? I can't see it in your git 
tree.

>  MAINTAINERS                   |    6 +
>  drivers/hwmon/Kconfig         |    9 +
>  drivers/hwmon/Makefile        |    1 +
>  drivers/hwmon/intel_thermal.c |  376 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 392 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/intel_thermal.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 98d5ca1..e038300 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2821,6 +2821,12 @@ F:	drivers/net/igb/
>  F:	drivers/net/ixgb/
>  F:	drivers/net/ixgbe/
>  
> +INTEL PCI THERMAL SUBSYSTEM DRIVER
> +M:	Matthew Garrett <mjg@redhat.com>
> +L:	lm-sensors@lm-sensors.org
> +S:	Maintained
> +F:	drivers/hwmon/intel_thermal.c
> +
>  INTEL PRO/WIRELESS 2100 NETWORK CONNECTION SUPPORT
>  M:	Zhu Yi <yi.zhu@intel.com>
>  M:	Reinette Chatre <reinette.chatre@intel.com>
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 9e640c6..f923f7a 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -414,6 +414,15 @@ config SENSORS_IBMPEX
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called ibmpex.
>  
> +config SENSORS_INTEL
> +        tristate "Intel Thermal Subsystem"
> +	help
> +	 Driver for the Intel Thermal Subsystem found in some PM55-based
> +	 machines.
> +
> +	 This driver can also be built as a module. If so, the module will
> +	 be called intel_thermal.
> +
>  config SENSORS_IT87
>  	tristate "ITE IT87xx and compatibles"
>  	select HWMON_VID
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 33c2ee1..a138df9 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
>  obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
>  obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
>  obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
> +obj-$(CONFIG_SENSORS_INTEL)	+= intel_thermal.o
>  obj-$(CONFIG_SENSORS_IT87)	+= it87.o
>  obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
>  obj-$(CONFIG_SENSORS_LIS3LV02D) += lis3lv02d.o hp_accel.o
> diff --git a/drivers/hwmon/intel_thermal.c b/drivers/hwmon/intel_thermal.c
> new file mode 100644
> index 0000000..9b8296e
> --- /dev/null
> +++ b/drivers/hwmon/intel_thermal.c
> @@ -0,0 +1,376 @@
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +
> +#define INTEL_THERMAL_SENSOR_TEMP	0x03
> +#define INTEL_THERMAL_CORE_TEMP		0x30
> +#define INTEL_THERMAL_PROCESSOR_TEMP	0x60
> +#define INTEL_THERMAL_DIMM_TEMP		0xb0
> +#define INTEL_THERMAL_INTERNAL_TEMP	0xd8
> +
> +static void __iomem *intel_thermal_addr;
> +static struct device *intel_thermal_dev;
> +
> +static struct pci_device_id intel_thermal_pci_ids[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3b32) },
> +	{ 0, }
> +};
> +
> +MODULE_DEVICE_TABLE(pci, intel_thermal_pci_ids);
> +
> +struct intel_thermal_sensor {
> +	int (*read_sensor)(void);
> +	char *name;
> +	struct attribute_group *attrs;
> +};
> +
> +static struct intel_thermal_sensor intel_thermal_sensors[];
> +
> +static ssize_t intel_thermal_sensor_label(struct device *dev,
> +					  struct device_attribute *devattr,
> +					  char *buf)
> +{
> +	int sensor = to_sensor_dev_attr(devattr)->index;
> +
> +	return sprintf(buf, "%s\n", intel_thermal_sensors[sensor].name);
> +}
> +
> +static ssize_t intel_thermal_sensor_show(struct device *dev,
> +					 struct device_attribute *devattr,
> +					 char *buf)
> +{
> +	int sensor = to_sensor_dev_attr(devattr)->index;
> +
> +	return sprintf(buf, "%d\n",
> +		       intel_thermal_sensors[sensor].read_sensor());
> +}
> +
> +static int intel_thermal_sensor_temp(void)
> +{
> +	int value = readb(intel_thermal_addr + INTEL_THERMAL_SENSOR_TEMP);
> +
> +	if (value > 0x7f)
> +		return -1;
> +
> +	return value * 1000;
> +}
> +
> +static int intel_thermal_core_temp(int core)
> +{
> +	int temp;
> +	int value;
> +
> +	value = readw(intel_thermal_addr + INTEL_THERMAL_CORE_TEMP + 2 * core);
> +
> +	if (!value  || (value & 0x8000))
> +		return -1;
> +
> +	temp = ((value & 0xffc0) >> 6) * 1000;
> +	temp += ((value & 0x3f) * 1000) / 64;
> +
> +	return temp;
> +}
> +
> +static int intel_thermal_core0_temp(void)
> +{
> +	return intel_thermal_core_temp(0);
> +}
> +
> +static int intel_thermal_core1_temp(void)
> +{
> +	return intel_thermal_core_temp(1);
> +}
> +
> +static int intel_thermal_processor_temp(void)
> +{
> +	int value = readw(intel_thermal_addr + INTEL_THERMAL_PROCESSOR_TEMP);
> +
> +	return (value & 0xff) * 1000;
> +}
> +
> +static int intel_thermal_dimm_temp(int dimm)
> +{
> +	int value = readl(intel_thermal_addr + INTEL_THERMAL_DIMM_TEMP);
> +	int shift = dimm * 8;
> +	int temp = (value & (0xff << shift)) >> shift;
> +
> +	if (!temp || temp == 0xff)
> +		return -1;
> +
> +	return temp * 1000;
> +}
> +
> +static int intel_thermal_dimm0_temp(void)
> +{
> +	return intel_thermal_dimm_temp(0);
> +}
> +
> +static int intel_thermal_dimm1_temp(void)
> +{
> +	return intel_thermal_dimm_temp(1);
> +}
> +
> +static int intel_thermal_dimm2_temp(void)
> +{
> +	return intel_thermal_dimm_temp(2);
> +}
> +
> +static int intel_thermal_dimm3_temp(void)
> +{
> +	return intel_thermal_dimm_temp(3);
> +}
> +
> +static int intel_thermal_internal_temp(void)
> +{
> +	int value = readl(intel_thermal_addr + INTEL_THERMAL_INTERNAL_TEMP);
> +	int temp = value & 0xff;
> +
> +	if (!temp)
> +		return -1;
> +
> +	return temp * 1000;
> +}
> +
> +SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, intel_thermal_sensor_show, NULL, 0);
> +SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, intel_thermal_sensor_label, NULL, 0);
> +SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, intel_thermal_sensor_show, NULL, 1);
> +SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, intel_thermal_sensor_label, NULL, 1);
> +SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, intel_thermal_sensor_show, NULL, 2);
> +SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, intel_thermal_sensor_label, NULL, 2);
> +SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, intel_thermal_sensor_show, NULL, 3);
> +SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, intel_thermal_sensor_label, NULL, 3);
> +SENSOR_DEVICE_ATTR(temp5_input, S_IRUGO, intel_thermal_sensor_show, NULL, 4);
> +SENSOR_DEVICE_ATTR(temp5_label, S_IRUGO, intel_thermal_sensor_label, NULL, 4);
> +SENSOR_DEVICE_ATTR(temp6_input, S_IRUGO, intel_thermal_sensor_show, NULL, 5);
> +SENSOR_DEVICE_ATTR(temp6_label, S_IRUGO, intel_thermal_sensor_label, NULL, 5);
> +SENSOR_DEVICE_ATTR(temp7_input, S_IRUGO, intel_thermal_sensor_show, NULL, 6);
> +SENSOR_DEVICE_ATTR(temp7_label, S_IRUGO, intel_thermal_sensor_label, NULL, 6);
> +SENSOR_DEVICE_ATTR(temp8_input, S_IRUGO, intel_thermal_sensor_show, NULL, 7);
> +SENSOR_DEVICE_ATTR(temp8_label, S_IRUGO, intel_thermal_sensor_label, NULL, 7);
> +SENSOR_DEVICE_ATTR(temp9_input, S_IRUGO, intel_thermal_sensor_show, NULL, 8);
> +SENSOR_DEVICE_ATTR(temp9_label, S_IRUGO, intel_thermal_sensor_label, NULL, 8);
> +
> +static struct attribute *sensor_attributes[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_sensor_attribute_group = {
> +	.attrs = sensor_attributes,
> +};
> +
> +static struct attribute *core0_attributes[] = {
> +	&sensor_dev_attr_temp2_input.dev_attr.attr,
> +	&sensor_dev_attr_temp2_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_core0_attribute_group = {
> +	.attrs = core0_attributes,
> +};
> +
> +static struct attribute *core1_attributes[] = {
> +	&sensor_dev_attr_temp3_input.dev_attr.attr,
> +	&sensor_dev_attr_temp3_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_core1_attribute_group = {
> +	.attrs = core1_attributes,
> +};
> +
> +static struct attribute *processor_attributes[] = {
> +	&sensor_dev_attr_temp4_input.dev_attr.attr,
> +	&sensor_dev_attr_temp4_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_processor_attribute_group = {
> +	.attrs = processor_attributes,
> +};
> +
> +static struct attribute *dimm0_attributes[] = {
> +	&sensor_dev_attr_temp5_input.dev_attr.attr,
> +	&sensor_dev_attr_temp5_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_dimm0_attribute_group = {
> +	.attrs = dimm0_attributes,
> +};
> +
> +static struct attribute *dimm1_attributes[] = {
> +	&sensor_dev_attr_temp6_input.dev_attr.attr,
> +	&sensor_dev_attr_temp6_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_dimm1_attribute_group = {
> +	.attrs = dimm1_attributes,
> +};
> +
> +static struct attribute *dimm2_attributes[] = {
> +	&sensor_dev_attr_temp7_input.dev_attr.attr,
> +	&sensor_dev_attr_temp7_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_dimm2_attribute_group = {
> +	.attrs = dimm2_attributes,
> +};
> +
> +static struct attribute *dimm3_attributes[] = {
> +	&sensor_dev_attr_temp8_input.dev_attr.attr,
> +	&sensor_dev_attr_temp8_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_dimm3_attribute_group = {
> +	.attrs = dimm3_attributes,
> +};
> +
> +static struct attribute *internal_attributes[] = {
> +	&sensor_dev_attr_temp9_input.dev_attr.attr,
> +	&sensor_dev_attr_temp9_label.dev_attr.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group intel_internal_attribute_group = {
> +	.attrs = internal_attributes,
> +};
> +
> +static struct intel_thermal_sensor intel_thermal_sensors[] = {
> +	{intel_thermal_sensor_temp, "thermal sensor",
> +	 &intel_sensor_attribute_group},
> +	{intel_thermal_core0_temp, "core 0", &intel_core0_attribute_group},
> +	{intel_thermal_core1_temp, "core 1", &intel_core1_attribute_group},
> +	{intel_thermal_processor_temp, "processor",
> +	 &intel_processor_attribute_group},
> +	{intel_thermal_dimm0_temp, "dimm 0", &intel_dimm0_attribute_group},
> +	{intel_thermal_dimm1_temp, "dimm 1", &intel_dimm1_attribute_group},
> +	{intel_thermal_dimm2_temp, "dimm 2", &intel_dimm2_attribute_group},
> +	{intel_thermal_dimm3_temp, "dimm 3", &intel_dimm3_attribute_group},
> +	{intel_thermal_internal_temp, "internal temperature",
> +	&intel_internal_attribute_group},
> +	{0, },
> +};
> +
> +static ssize_t show_name(struct device *dev, struct device_attribute *attr,
> +			 char *buf)
> +{
> +	return sprintf(buf, "intel\n");
> +}
> +
> +static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
> +
> +static int __devinit intel_thermal_pci_probe(struct pci_dev *pdev,
> +					     const struct pci_device_id *ent)
> +{
> +	int ret;
> +	int i;
> +
> +	ret = pci_request_region(pdev, 0, "Intel Thermal Subsystem");
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to request region\n");
> +		return -ENODEV;
> +	}
> +
> +	intel_thermal_addr = pci_ioremap_bar(pdev, 0);
> +	if (!intel_thermal_addr) {
> +		dev_err(&pdev->dev, "failed to remap registers\n");
> +		ret = -ENODEV;
> +		goto release;
> +	}
> +
> +	for (i = 0; intel_thermal_sensors[i].read_sensor != NULL; i++) {
> +		int temp = intel_thermal_sensors[i].read_sensor();
> +
> +		if (temp <= 0)
> +			continue;
> +
> +		ret = sysfs_create_group(&pdev->dev.kobj,
> +					 intel_thermal_sensors[i].attrs);
> +		if (ret) {
> +			dev_err(&pdev->dev, "failed to create attrs\n");
> +			ret = -ENOMEM;
> +			goto device;
> +		}
> +	}
> +
> +	ret = device_create_file(&pdev->dev, &dev_attr_name);
> +
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to create attr\n");
> +		ret = -ENOMEM;
> +		goto device;
> +	}
> +
> +	intel_thermal_dev = hwmon_device_register(&pdev->dev);
> +
> +	if (!intel_thermal_dev) {
> +		dev_err(&pdev->dev, "failed to create hwmon device\n");
> +		ret = -ENOMEM;
> +		goto groups;
> +	}
> +
> +	return 0;
> +device:
> +	device_remove_file(&pdev->dev, &dev_attr_name);
> +	hwmon_device_unregister(intel_thermal_dev);
> +groups:
> +	for (i = 0; intel_thermal_sensors[i].read_sensor; i++) {
> +		sysfs_remove_group(&pdev->dev.kobj,
> +				   intel_thermal_sensors[i].attrs);
> +	}
> +	iounmap(intel_thermal_addr);
> +release:
> +	pci_release_region(pdev, 0);
> +	return ret;
> +}
> +
> +static void __devexit intel_thermal_pci_remove(struct pci_dev *pdev)
> +{
> +	int i;
> +
> +	device_remove_file(&pdev->dev, &dev_attr_name);
> +
> +	for (i = 0; intel_thermal_sensors[i].read_sensor; i++) {
> +		sysfs_remove_group(&pdev->dev.kobj,
> +				   intel_thermal_sensors[i].attrs);
> +	}
> +
> +	hwmon_device_unregister(intel_thermal_dev);
> +
> +	iounmap(intel_thermal_addr);
> +	pci_release_region(pdev, 0);
> +}
> +
> +static struct pci_driver intel_thermal_pci_driver = {
> +	.name		= "intel-thermal",
> +	.id_table	= intel_thermal_pci_ids,
> +	.probe		= intel_thermal_pci_probe,
> +	.remove		= intel_thermal_pci_remove,
> +};
> +
> +static int __init intel_thermal_init(void)
> +{
> +	return pci_register_driver(&intel_thermal_pci_driver);
> +}
> +
> +static void __exit intel_thermal_exit(void)
> +{
> +	pci_unregister_driver(&intel_thermal_pci_driver);
> +}
> +
> +module_init(intel_thermal_init)
> +module_exit(intel_thermal_exit);
> +
> +MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
> +MODULE_DESCRIPTION("Intel thermal subsystem hwmon driver");
> +MODULE_LICENSE("GPL");
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
