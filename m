Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2DWBxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 21:53:11 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:35097
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab2DWBxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 21:53:09 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1803M1432N98dK4015Izz1202hzz8275bhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2WT8C-02-4FR-02
X-M-MSG: 
Date: Mon, 23 Apr 2012 09:52:54 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb <lenb@kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ACPI: D3 states cleanup
Message-ID: <20120423015247.GA1119@localhost.amd.com>
References: <1335143029.4927.45.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335143029.4927.45.camel@minggr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 23 Apr 2012 01:52:54.0699 (UTC) FILETIME=[CCB247B0:01CD20F3]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:03:49AM +0800, Lin Ming wrote:
> There are two ACPI D3 states defined now:
> ACPI_STATE_D3 and ACPI_STATE_D3_COLD.
> 
> But the uses of these states are not clear/correct in some code.
> For example, some code refer ACPI_STATE_D3 as D3hot and others refer
> it as D3cold.
> 
> This patch introduces ACPI_STATE_D3_HOT to refer to ACPI D3hot state.
> D3hot is only valid if _PR3 present.
> And changes ACPI_STATE_D3 to refer to ACPI D3cold state only.
> Also redefines ACPI_STATE_D3_COLD the same as ACPI_STATE_D3.
> 

Reviewed-by: Aaron Lu <aaron.lu@amd.com>

Thanks,
Aaron

> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
> 
> v3: D3hot is only valid if _PR3 present
> 
>  drivers/acpi/power.c   |    2 +-
>  drivers/acpi/scan.c    |   17 +++++++----------
>  drivers/pci/pci-acpi.c |    4 ++--
>  include/acpi/actypes.h |    7 ++++---
>  4 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 7049a7d..330bb4d 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -631,7 +631,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
>  	 * We know a device's inferred power state when all the resources
>  	 * required for a given D-state are 'on'.
>  	 */
> -	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3; i++) {
> +	for (i = ACPI_STATE_D0; i < ACPI_STATE_D3_HOT; i++) {
>  		list = &device->power.states[i].resources;
>  		if (list->count < 1)
>  			continue;
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 767e2dc..7417267 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -869,7 +869,7 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  	/*
>  	 * Enumerate supported power management states
>  	 */
> -	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3; i++) {
> +	for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
>  		struct acpi_device_power_state *ps = &device->power.states[i];
>  		char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
>  
> @@ -884,21 +884,18 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>  				acpi_bus_add_power_resource(ps->resources.handles[j]);
>  		}
>  
> -		/* The exist of _PR3 indicates D3Cold support */
> -		if (i == ACPI_STATE_D3) {
> -			status = acpi_get_handle(device->handle, object_name, &handle);
> -			if (ACPI_SUCCESS(status))
> -				device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> -		}
> -
>  		/* Evaluate "_PSx" to see if we can do explicit sets */
>  		object_name[2] = 'S';
>  		status = acpi_get_handle(device->handle, object_name, &handle);
>  		if (ACPI_SUCCESS(status))
>  			ps->flags.explicit_set = 1;
>  
> -		/* State is valid if we have some power control */
> -		if (ps->resources.count || ps->flags.explicit_set)
> +		/*
> +		 * State is valid if there are means to put the device into it.
> +		 * D3hot is only valid if _PR3 present.
> +		 */
> +		if (ps->resources.count ||
> +		    (ps->flags.explicit_set && i < ACPI_STATE_D3_HOT))
>  			ps->flags.valid = 1;
>  
>  		ps->power = -1;	/* Unknown - driver assigned */
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 0f150f2..1929c0c 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -200,7 +200,7 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
>  		return PCI_D1;
>  	case ACPI_STATE_D2:
>  		return PCI_D2;
> -	case ACPI_STATE_D3:
> +	case ACPI_STATE_D3_HOT:
>  		return PCI_D3hot;
>  	case ACPI_STATE_D3_COLD:
>  		return PCI_D3cold;
> @@ -223,7 +223,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>  		[PCI_D0] = ACPI_STATE_D0,
>  		[PCI_D1] = ACPI_STATE_D1,
>  		[PCI_D2] = ACPI_STATE_D2,
> -		[PCI_D3hot] = ACPI_STATE_D3,
> +		[PCI_D3hot] = ACPI_STATE_D3_HOT,
>  		[PCI_D3cold] = ACPI_STATE_D3
>  	};
>  	int error = -EINVAL;
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index eba6604..e8bcc47 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -499,9 +499,10 @@ typedef u64 acpi_integer;
>  #define ACPI_STATE_D0                   (u8) 0
>  #define ACPI_STATE_D1                   (u8) 1
>  #define ACPI_STATE_D2                   (u8) 2
> -#define ACPI_STATE_D3                   (u8) 3
> -#define ACPI_STATE_D3_COLD              (u8) 4
> -#define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD
> +#define ACPI_STATE_D3_HOT               (u8) 3
> +#define ACPI_STATE_D3                   (u8) 4
> +#define ACPI_STATE_D3_COLD              ACPI_STATE_D3
> +#define ACPI_D_STATES_MAX               ACPI_STATE_D3
>  #define ACPI_D_STATE_COUNT              5
>  
>  #define ACPI_STATE_C0                   (u8) 0
> -- 
> 1.7.2.5
> 
> 
> 
> 

