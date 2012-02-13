Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2BMUV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:21:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab2BMUVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:21:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH 1/6] ACPI: Introduce ACPI D3_COLD state support
Date: Mon, 13 Feb 2012 21:25:15 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <1329124271-29464-1-git-send-email-ming.m.lin@intel.com> <1329124271-29464-2-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1329124271-29464-2-git-send-email-ming.m.lin@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201202132125.15537.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 13, 2012, Lin Ming wrote:
> From: Zhang Rui <rui.zhang@intel.com>
> 
> If a device has _PR3._ON, it means the device supports D3_HOT.
> If a device has _PR3._OFF, it means the device supports D3_COLD.
> Add the ability to validate and enter D3_COLD state in ACPI.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

This is supposed to be ACPI 5.0 support, right?

So can anyone please tell me what part of the ACPI 5.0 spec is the
basis of this patch, because I can't see that immediately?

The only places where D3Cold is _mentioned_ are Section 7.2.12 (_PRE, which
appears to be new in 5.0), Section 7.2.20 (_S0W), Section 7.2.21 (_S1W),
Section 7.2.22 (_S2W), Section 7.2.23 (_S3W) and Section 7.2.24 (_S4W).
None of them mentions those _PR3._ON and _PR3._OFF things above.

Moreover, my understanding of the spec is that D3Cold means all of the
power resources returned by _PR3 are "off" (whereas some of them will be
"on" in D3hot).

> ---
>  drivers/acpi/power.c |    4 ++--
>  drivers/acpi/scan.c  |   10 +++++++++-
>  2 files changed, 11 insertions(+), 3 deletions(-)
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
> index 8ab80ba..a9d4391 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -881,8 +881,16 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  
>  			device->power.flags.power_resources = 1;
>  			ps->flags.valid = 1;
> -			for (j = 0; j < ps->resources.count; j++)
> +			for (j = 0; j < ps->resources.count; j++) {
>  				acpi_bus_add_power_resource(ps->resources.handles[j]);
> +				/* Check for D3_COLD support. _PR3._OFF equals D3_COLD ? */
> +				if (i == ACPI_STATE_D3) {
> +					if (j == 0)
> +						device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> +					status = acpi_get_handle(ps->resources.handles[j], "_OFF",  &handle);
> +					device->power.states[ACPI_STATE_D3_COLD].flags.valid &= ACPI_SUCCESS(status);
> +				}
> +			}

Sorry, but this doesn't make sense to me.  Power resources always have
the _OFF method, right?

>  		}
>  
>  		/* Evaluate "_PSx" to see if we can do explicit sets */
> 

Rafael
