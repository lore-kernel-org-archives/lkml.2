Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2KLOnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:43:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:29378 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab2KLOnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:43:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,762,1344236400"; 
   d="scan'208";a="247623909"
Date: Mon, 12 Nov 2012 16:46:21 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/3] ACPI: Evaluate _CRS while creating device node
 objects
Message-ID: <20121112144621.GE31759@intel.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <2429141.J1r7BIpiiT@vostro.rjw.lan>
 <11281928.0BBlrNprhI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11281928.0BBlrNprhI@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 01:02:11PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Currently, whoever wants to use ACPI device resources has to call
> acpi_walk_resources() to browse the buffer returned by the _CRS
> method for the given device and create filters passed to that
> routine to apply to the individual resource items.  This generally
> is cumbersome, time-consuming and inefficient.  Moreover, it may
> be problematic if resource conflicts need to be resolved, because
> the different users of _CRS will need to do that in a consistent
> way.
> 
> For this reason, add code to the ACPI core to execute _CRS once,
> when the struct acpi_device object is created for a given device
> node, and attach a list of ACPI resources returned by _CRS to that
> object for future processing.
> 
> Convert the ACPI code that creates platform device objects to using
> the new resources list instead of executing acpi_walk_resources() by
> itself, which makes it much more straightforward and easier to
> follow.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/acpi_platform.c |   90 ++++++++++++-------------------------------
>  drivers/acpi/resource.c      |   12 +++++
>  drivers/acpi/scan.c          |   56 ++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h      |    6 ++
>  include/linux/acpi.h         |    1 
>  5 files changed, 102 insertions(+), 63 deletions(-)
> 
> Index: linux/include/acpi/acpi_bus.h
> ===================================================================
> --- linux.orig/include/acpi/acpi_bus.h
> +++ linux/include/acpi/acpi_bus.h
> @@ -259,6 +259,11 @@ struct acpi_device_physical_node {
>  	struct device *dev;
>  };
>  
> +struct acpi_resource_list_entry {
> +	struct list_head node;
> +	struct acpi_resource resource;
> +};
> +
>  /* set maximum of physical nodes to 32 for expansibility */
>  #define ACPI_MAX_PHYSICAL_NODE	32
>  
> @@ -268,6 +273,7 @@ struct acpi_device {
>  	acpi_handle handle;		/* no handle for fixed hardware */
>  	struct acpi_device *parent;
>  	struct list_head children;
> +	struct list_head resources;	/* Device resources. */
>  	struct list_head node;
>  	struct list_head wakeup_list;
>  	struct acpi_device_status status;
> Index: linux/drivers/acpi/scan.c
> ===================================================================
> --- linux.orig/drivers/acpi/scan.c
> +++ linux/drivers/acpi/scan.c
> @@ -382,6 +382,52 @@ static void acpi_device_remove_files(str
>  			ACPI Bus operations
>     -------------------------------------------------------------------------- */
>  
> +static void acpi_bus_drop_resources(struct acpi_device *adev)
> +{
> +	struct acpi_resource_list_entry *entry, *s;
> +
> +	list_for_each_entry_safe(entry, s, &adev->resources, node) {
> +		list_del(&entry->node);
> +		kfree(entry);
> +	}
> +}
> +
> +static acpi_status acpi_bus_add_resource(struct acpi_resource *res,
> +					 void *context)
> +{
> +	struct list_head *list = context;
> +	struct acpi_resource_list_entry *entry;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return AE_NO_MEMORY;
> +
> +	entry->resource = *res;

This does not work well with all resource types - specifically those that
contain pointers, like acpi_resource_gpio and acpi_resource_source.

The memory for the resources gets freed once acpi_walk_resources() is done.

> +	INIT_LIST_HEAD(&entry->node);
> +	list_add_tail(&entry->node, list);
> +	return AE_OK;
> +}
