Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab2JBGKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 02:10:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:8752 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2JBGKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 02:10:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,521,1344236400"; 
   d="scan'208";a="228879545"
Date: Tue, 2 Oct 2012 09:12:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller enumeration
 driver
Message-ID: <20121002061253.GO15548@intel.com>
References: <1348818032.10877.325.camel@rui.sh.intel.com>
 <20121001065526.GH15548@intel.com>
 <744357E9AAD1214791ACBA4B0B90926322D970@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744357E9AAD1214791ACBA4B0B90926322D970@SHSMSX101.ccr.corp.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 02:19:49PM +0000, Zhang, Rui wrote:
> 
> 
> > -----Original Message-----
> > From: linux-i2c-owner@vger.kernel.org [mailto:linux-i2c-
> > owner@vger.kernel.org] On Behalf Of Mika Westerberg
> > Sent: Monday, October 01, 2012 2:55 PM
> > To: Zhang, Rui
> > Cc: LKML; linux-pm; linux-i2c; linux-acpi@vger.kernel.org; Len, Brown;
> > Rafael J. Wysocki; Grant Likely; Dirk Brandewie
> > Subject: Re: [RFC PATCH 5/6] ACPI: Introduce ACPI I2C controller
> > enumeration driver
> > Importance: High
> > 
> > On Fri, Sep 28, 2012 at 03:40:32PM +0800, Zhang Rui wrote:
> > > +acpi_status __init i2c_enumerate_slave(acpi_handle handle, u32 level,
> > > +				       void *data, void **return_value) {
> > > +	int result;
> > > +	acpi_status status;
> > > +	struct acpi_buffer buffer;
> > > +	struct acpi_resource *resource;
> > > +	struct acpi_resource_gpio *gpio;
> > > +	struct acpi_resource_i2c_serialbus *i2c;
> > > +	int i;
> > > +	struct acpi_i2c_root *root = data;
> > > +	struct i2c_board_info info;
> > > +	struct acpi_device *device;
> > > +
> > > +	if (acpi_bus_get_device(handle, &device))
> > > +		return AE_OK;
> > > +
> > > +	status = acpi_get_current_resources(handle, &buffer);
> > > +	if (ACPI_FAILURE(status)) {
> > > +		dev_err(&device->dev, "Failed to get ACPI resources\n");
> > > +		return AE_OK;
> > > +	}
> > > +
> > > +	for (i = 0; i < buffer.length; i += sizeof(struct acpi_resource))
> > {
> > > +		resource = (struct acpi_resource *)(buffer.pointer + i);
> > > +
> > > +		switch (resource->type) {
> > > +		case ACPI_RESOURCE_TYPE_GPIO:
> > > +			gpio = &resource->data.gpio;
> > > +
> > > +			if (gpio->connection_type ==
> > ACPI_RESOURCE_GPIO_TYPE_INT) {
> > > +				result =
> > > +				    acpi_device_get_gpio_irq
> > > +				    (gpio->resource_source.string_ptr,
> > > +				     gpio->pin_table[0], &info.irq);
> > 
> > acpi_device_get_gpio_irq() is not defined in this patch series?
> > 
> ACPI GPIO controller patch has already been sent out, but in ACPI mailing list only.

It would have been good idea to mention this in the cover letter at least.

> 
> > Also you need to do the gpio_request()/gpio_to_irq() things somewhere.
> > Are they handled in acpi_device_get_gpio_irq()?
> >
> Yep.
>  
> > How about GpioIo resources?
> > 
> This is not covered in this patch set, but will be in the next patch set.
> 
> > > +				if (result)
> > > +					dev_err(&device->dev,
> > > +						"Failed to get IRQ\n");
> > > +			}
> > > +			break;
> > > +		case ACPI_RESOURCE_TYPE_SERIAL_BUS:
> > > +			i2c = &resource->data.i2c_serial_bus;
> > > +
> > > +			info.addr = i2c->slave_address;
> > > +			break;
> > > +		default:
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	add_slave(root, &info);
> > > +
> > > +	kfree(buffer.pointer);
> > > +	return AE_OK;
> > > +}
> > > +
> > > +static int __devinit acpi_i2c_root_add(struct acpi_device *device) {
> > > +	acpi_status status;
> > > +	struct acpi_i2c_root *root;
> > > +	struct resource *resources;
> > > +	int result;
> > > +
> > > +	if (!device->pnp.unique_id) {
> > > +		dev_err(&device->dev,
> > > +			"Unsupported ACPI I2C controller. No UID\n");
> > 
> > Where does this restriction come from? As far as I understand UID is
> > optional.
> >
> 
> _UID is optional.
> But it seems to be required for SPB buses that need ACPI device enumeration.
> At least this is true for the ACPI 5 compatible ACPI tables I have.

Yes but if some vendor is not setting it (as it is optional) you still want
your code to work, right?
