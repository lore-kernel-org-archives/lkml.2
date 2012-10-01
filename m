Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2JAGxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:53:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:7344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2JAGxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:53:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,514,1344236400"; 
   d="scan'208";a="228943812"
Date: Mon, 1 Oct 2012 09:55:26 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver
Message-ID: <20121001065526.GH15548@intel.com>
References: <1348818032.10877.325.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348818032.10877.325.camel@rui.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:40:32PM +0800, Zhang Rui wrote:
> +acpi_status __init i2c_enumerate_slave(acpi_handle handle, u32 level,
> +				       void *data, void **return_value)
> +{
> +	int result;
> +	acpi_status status;
> +	struct acpi_buffer buffer;
> +	struct acpi_resource *resource;
> +	struct acpi_resource_gpio *gpio;
> +	struct acpi_resource_i2c_serialbus *i2c;
> +	int i;
> +	struct acpi_i2c_root *root = data;
> +	struct i2c_board_info info;
> +	struct acpi_device *device;
> +
> +	if (acpi_bus_get_device(handle, &device))
> +		return AE_OK;
> +
> +	status = acpi_get_current_resources(handle, &buffer);
> +	if (ACPI_FAILURE(status)) {
> +		dev_err(&device->dev, "Failed to get ACPI resources\n");
> +		return AE_OK;
> +	}
> +
> +	for (i = 0; i < buffer.length; i += sizeof(struct acpi_resource)) {
> +		resource = (struct acpi_resource *)(buffer.pointer + i);
> +
> +		switch (resource->type) {
> +		case ACPI_RESOURCE_TYPE_GPIO:
> +			gpio = &resource->data.gpio;
> +
> +			if (gpio->connection_type == ACPI_RESOURCE_GPIO_TYPE_INT) {
> +				result =
> +				    acpi_device_get_gpio_irq
> +				    (gpio->resource_source.string_ptr,
> +				     gpio->pin_table[0], &info.irq);

acpi_device_get_gpio_irq() is not defined in this patch series?

Also you need to do the gpio_request()/gpio_to_irq() things somewhere. Are
they handled in acpi_device_get_gpio_irq()?

How about GpioIo resources?

> +				if (result)
> +					dev_err(&device->dev,
> +						"Failed to get IRQ\n");
> +			}
> +			break;
> +		case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> +			i2c = &resource->data.i2c_serial_bus;
> +
> +			info.addr = i2c->slave_address;
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	add_slave(root, &info);
> +
> +	kfree(buffer.pointer);
> +	return AE_OK;
> +}
> +
> +static int __devinit acpi_i2c_root_add(struct acpi_device *device)
> +{
> +	acpi_status status;
> +	struct acpi_i2c_root *root;
> +	struct resource *resources;
> +	int result;
> +
> +	if (!device->pnp.unique_id) {
> +		dev_err(&device->dev,
> +			"Unsupported ACPI I2C controller. No UID\n");

Where does this restriction come from? As far as I understand UID is
optional.

> +		return -ENODEV;
> +	}
> +
> +	root = kzalloc(sizeof(struct acpi_i2c_root), GFP_KERNEL);
> +	if (!root)
> +		return -ENOMEM;
> +
> +	root->device = device;
> +
> +	kstrtoint(device->pnp.unique_id, 10, &root->busnum);
> +
> +	/* enumerate I2C controller */
> +	root->pdev =
> +	    platform_device_alloc(acpi_device_hid(device), root->busnum);
> +	if (!root->pdev) {
> +		dev_err(&device->dev, "Failed to alloc platform device\n");
> +		goto err;
> +	}
> +
> +	result = acpi_get_generic_resources(device, &resources);
> +	if (result < 0) {
> +		dev_err(&device->dev, "Failed to get resources\n");
> +		goto err;
> +	}
> +
> +	platform_device_add_resources(root->pdev, resources, result);
> +	platform_device_add(root->pdev);
> +
> +	/* enumerate I2C slave devices */
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle, 1,
> +				     i2c_enumerate_slave, NULL, root, NULL);
> +
> +	if (ACPI_FAILURE(status)) {
> +		dev_err(&root->device->dev, "i2c ACPI namespace walk error!\n");
> +		kfree(root);
> +		return -ENODEV;
> +	}
> +
> +	register_slaves(root);
> +
> +	return 0;
> +err:
> +	kfree(root);
> +	return -ENODEV;
> +}
