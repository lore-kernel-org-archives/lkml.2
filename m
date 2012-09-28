Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab2I1OL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:11:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:4717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab2I1OL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:11:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,502,1344236400"; 
   d="scan'208";a="199368210"
Date: Fri, 28 Sep 2012 17:13:47 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Len, Brown" <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [RFC PATCH 1/6] Introduce acpi_match_device_id().
Message-ID: <20120928141347.GC15548@intel.com>
References: <1348817910.10877.321.camel@rui.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348817910.10877.321.camel@rui.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 03:38:30PM +0800, Zhang Rui wrote:
> >From 72df5d1f51fb27a4ba7f70a3b07df759d32b8288 Mon Sep 17 00:00:00 2001
> From: Zhang Rui <rui.zhang@intel.com>
> Date: Thu, 27 Sep 2012 15:11:55 +0800
> Subject: [RFC PATCH 1/6] Introduce acpi_match_device_id().
> 
> This API is used to check if a device id string is compatible
> with an ACPI device,
> either PNP id exported via _HID or compatible ids exported
> via _CID control method.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  drivers/acpi/scan.c     |   22 ++++++++++++++++++++++
>  include/acpi/acpi_bus.h |    6 ++++++
>  2 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index d1ecca2..936a7c9 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -312,6 +312,28 @@ int acpi_match_device_ids(struct acpi_device *device,
>  }
>  EXPORT_SYMBOL(acpi_match_device_ids);
>  
> +int acpi_match_device_id(const struct device *dev, const char *id)

Would be good idea to implement this in terms of of_match_device() so that
it returns pointer to the matched id. This way drivers can get the
->driver_data pretty easily if needed.

> +{
> +	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);

If the device is not bound to an ACPI handle this will return NULL. And I
don't see you doing that in this series meaning that..

> +	struct acpi_device *device;
> +	struct acpi_hardware_id *hwid;
> +	acpi_status status;
> +
> +	if (!handle || !id)
> +		return -ENODEV;

..you always return -ENODEV here, right?

> +
> +	status = acpi_bus_get_device(handle, &device);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	list_for_each_entry(hwid, &device->pnp.ids, list)
> +		if (!strcmp(id, hwid->id))
> +			return 0;
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(acpi_match_device_id);
