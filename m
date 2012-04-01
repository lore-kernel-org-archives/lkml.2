Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab2DAGpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:45:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47540 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2DAGpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:45:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v2 1/2] ACPI: Introduce ACPI D3_COLD state support
Date: Sun, 1 Apr 2012 08:50:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1332834624-29310-1-git-send-email-ming.m.lin@intel.com> <1332834624-29310-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1332834624-29310-2-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201204010850.03736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 27, 2012, Lin Ming wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> If a device has _PR3, it means the device supports D3_COLD.
> Add the ability to validate and enter D3_COLD state in ACPI.

This is not the way I understand D3_cold in ACPI.

Namely, _PR3 lists power resources that are supposed to be "on"
in D3, which means that in that state the device is not completely
off, so this must be D3_hot and _not_ D3_cold.

So. _PR3 means D3_hot is supported.  D3_cold, on the other hand,
is always supported, although it may not be accessible through any
direct software action (for example, it may be necessary to power
a bus to put devices on it into D3_cold).

Thanks,
Rafael


> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/acpi/power.c |    4 ++--
>  drivers/acpi/scan.c  |    7 +++++++
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 9ac2a9f..0d681fb 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -500,14 +500,14 @@ int acpi_power_transition(struct acpi_device *device, int state)
>  {
>  	int result;
>  
> -	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3))
> +	if (!device || (state < ACPI_STATE_D0) || (state > ACPI_STATE_D3_COLD))
>  		return -EINVAL;
>  
>  	if (device->power.state == state)
>  		return 0;
>  
>  	if ((device->power.state < ACPI_STATE_D0)
> -	    || (device->power.state > ACPI_STATE_D3))
> +	    || (device->power.state > ACPI_STATE_D3_COLD))
>  		return -ENODEV;
>  
>  	/* TBD: Resources must be ordered. */
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 8ab80ba..571396c 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -885,6 +885,13 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  				acpi_bus_add_power_resource(ps->resources.handles[j]);
>  		}
>  
> +		/* The exist of _PR3 indicates D3Cold support */
> +		if (i == ACPI_STATE_D3) {
> +			status = acpi_get_handle(device->handle, object_name, &handle);
> +			if (ACPI_SUCCESS(status))
> +				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> +		}
> +
>  		/* Evaluate "_PSx" to see if we can do explicit sets */
>  		object_name[2] = 'S';
>  		status = acpi_get_handle(device->handle, object_name, &handle);
> 

