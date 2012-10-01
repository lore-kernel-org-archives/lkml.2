Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab2JAOT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 10:19:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:35222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab2JAOTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 10:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,517,1344236400"; 
   d="scan'208";a="199215367"
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: RE: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver
Thread-Topic: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller
 enumeration driver
Thread-Index: AQHNnUx4YaROkQfVYU+gelfZPaq2VZejgsMAgAD9daA=
Date: Mon, 1 Oct 2012 14:19:49 +0000
Message-ID: <744357E9AAD1214791ACBA4B0B90926322D970@SHSMSX101.ccr.corp.intel.com>
References: <1348818032.10877.325.camel@rui.sh.intel.com>
 <20121001065526.GH15548@intel.com>
In-Reply-To: <20121001065526.GH15548@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-
> owner@vger.kernel.org] On Behalf Of Mika Westerberg
> Sent: Monday, October 01, 2012 2:55 PM
> To: Zhang, Rui
> Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> Subject: Re: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller
> enumeration driver
> Importance: High
> 
> On Fri, Sep 28, 2012 at 03:40:32PM +0800, Zhang Rui wrote:
> > +acpi_status __init i2c_enumerate_slave(acpi_handle handle, u32 level,
> > +				       void *data, void **return_value) {
> > +	int result;
> > +	acpi_status status;
> > +	struct acpi_buffer buffer;
> > +	struct acpi_resource *resource;
> > +	struct acpi_resource_gpio *gpio;
> > +	struct acpi_resource_i2c_serialbus *i2c;
> > +	int i;
> > +	struct acpi_i2c_root *root = data;
> > +	struct i2c_board_info info;
> > +	struct acpi_device *device;
> > +
> > +	if (acpi_bus_get_device(handle, &device))
> > +		return AE_OK;
> > +
> > +	status = acpi_get_current_resources(handle, &buffer);
> > +	if (ACPI_FAILURE(status)) {
> > +		dev_err(&device->dev, "Failed to get ACPI resources\n");
> > +		return AE_OK;
> > +	}
> > +
> > +	for (i = 0; i < buffer.length; i += sizeof(struct acpi_resource))
> {
> > +		resource = (struct acpi_resource *)(buffer.pointer + i);
> > +
> > +		switch (resource->type) {
> > +		case ACPI_RESOURCE_TYPE_GPIO:
> > +			gpio = &resource->data.gpio;
> > +
> > +			if (gpio->connection_type ==
> ACPI_RESOURCE_GPIO_TYPE_INT) {
> > +				result =
> > +				    acpi_device_get_gpio_irq
> > +				    (gpio->resource_source.string_ptr,
> > +				     gpio->pin_table[0], &info.irq);
> 
> acpi_device_get_gpio_irq() is not defined in this patch series?
> 
ACPI GPIO controller patch has already been sent out, but in ACPI mailing list only.

> Also you need to do the gpio_request()/gpio_to_irq() things somewhere.
> Are they handled in acpi_device_get_gpio_irq()?
>
Yep.
 
> How about GpioIo resources?
> 
This is not covered in this patch set, but will be in the next patch set.

> > +				if (result)
> > +					dev_err(&device->dev,
> > +						"Failed to get IRQ\n");
> > +			}
> > +			break;
> > +		case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> > +			i2c = &resource->data.i2c_serial_bus;
> > +
> > +			info.addr = i2c->slave_address;
> > +			break;
> > +		default:
> > +			break;
> > +		}
> > +	}
> > +
> > +	add_slave(root, &info);
> > +
> > +	kfree(buffer.pointer);
> > +	return AE_OK;
> > +}
> > +
> > +static int __devinit acpi_i2c_root_add(struct acpi_device *device) {
> > +	acpi_status status;
> > +	struct acpi_i2c_root *root;
> > +	struct resource *resources;
> > +	int result;
> > +
> > +	if (!device->pnp.unique_id) {
> > +		dev_err(&device->dev,
> > +			"Unsupported ACPI I2C controller. No UID\n");
> 
> Where does this restriction come from? As far as I understand UID is
> optional.
>

_UID is optional.
But it seems to be required for SPB buses that need ACPI device enumeration.
At least this is true for the ACPI 5 compatible ACPI tables I have.

Thanks,
rui
