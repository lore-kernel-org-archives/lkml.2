Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab2DAGtP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:49:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47549 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2DAGtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:49:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org, Len Brown <lenb@kernel.org>,
        Lin Ming <ming.m.lin@intel.com>
Subject: Re: [linux-pm] [PATCH 46/76] ACPI: Introduce ACPI D3_COLD state support
Date: Sun, 1 Apr 2012 08:53:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org> <3ebc81b8937d2bc1d0d0064bed29434dfce490aa.1333101989.git.len.brown@intel.com>
In-Reply-To: <3ebc81b8937d2bc1d0d0064bed29434dfce490aa.1333101989.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204010853.33667.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 30, 2012, Len Brown wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> If a device has _PR3, it means the device supports D3_COLD.
> Add the ability to validate and enter D3_COLD state in ACPI.

This patch is wrong, IMO.

Namely, _PR3 lists power resources that are supposed to be "on"
in D3, which means that in that state the device is not completely
off, so this must be D3_hot and not D3_cold.

So. _PR3 means D3_hot is supported.  D3_cold, on the other hand,
is always supported, although it may not be accessible through any
direct software action (for example, it may be necessary to power
down a bus to put devices on it into D3_cold).

Thanks,
Rafael


> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
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

