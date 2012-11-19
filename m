Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2KSJj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:39:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:42738 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318Ab2KSJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:39:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,278,1352102400"; 
   d="scan'208";a="249316736"
Date: Mon, 19 Nov 2012 11:42:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] ACPI: Allow ACPI handles of devices to be
 initialized in advance
Message-ID: <20121119094234.GH17774@intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121118155539.GE17774@intel.com>
 <1758879.PKgPhTGcB7@vostro.rjw.lan>
 <5604758.tWMNMRG2En@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5604758.tWMNMRG2En@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 10:12:52PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Currently, the ACPI handles of devices are initialized from within
> device_add(), by acpi_bind_one() called from acpi_platform_notify()
> which first uses the .find_device() routine provided by the device's
> bus type to find the matching device node in the ACPI namespace.
> This is a source of some computational overhead and, moreover, the
> correctness of the result depends on the implementation of
> .find_device() which is known to fail occasionally for some bus types
> (e.g. PCI).  In some cases, however, the corresponding ACPI device
> node is known already before calling device_add() for the given
> struct device object and the whole .find_device() dance in
> acpi_platform_notify() is then simply unnecessary.
> 
> For this reason, make it possible to initialize the ACPI handles of
> devices before calling device_add() for them.  Modify
> acpi_platform_notify() to call acpi_bind_one() in advance to check
> the device's existing ACPI handle and skip the .find_device()
> search if that is successful.  Change acpi_bind_one() accordingly.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/glue.c |   42 +++++++++++++++++++++++++++++++++---------
>  1 file changed, 33 insertions(+), 9 deletions(-)
> 
> Index: linux/drivers/acpi/glue.c
> ===================================================================
> --- linux.orig/drivers/acpi/glue.c
> +++ linux/drivers/acpi/glue.c
> @@ -135,41 +135,54 @@ static int acpi_bind_one(struct device *
>  	int retval = -EINVAL;
>  
>  	if (dev->acpi_handle) {
> -		dev_warn(dev, "Drivers changed 'acpi_handle'\n");
> -		return -EINVAL;
> +		if (handle) {
> +			dev_warn(dev, "ACPI handle is already set\n");
> +			return -EINVAL;
> +		} else {
> +			handle = dev->acpi_handle;
> +		}
>  	}
> +	if (!handle)
> +		return -EINVAL;
>  
>  	get_device(dev);
>  	status = acpi_bus_get_device(handle, &acpi_dev);
>  	if (ACPI_FAILURE(status))
>  		goto err;
>  
> -	physical_node = kzalloc(sizeof(struct acpi_device_physical_node),
> -		GFP_KERNEL);
> +	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);

Here we allocate memory for the physical node...

>  	if (!physical_node) {
>  		retval = -ENOMEM;
>  		goto err;
>  	}
>  
>  	mutex_lock(&acpi_dev->physical_node_lock);
> +
> +	/* Sanity check. */
> +	list_for_each_entry(physical_node, &acpi_dev->physical_node_list, node)

.. and overwrite it here ;-)

Maybe using a different variable for the sanity check?

I've changed the SPI/I2C patches to use this as well and they got a lot
smaller as we don't have to do the .find_device() magic.

Once you have fixed the above, you can add my

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

to these two patches, if you like.
