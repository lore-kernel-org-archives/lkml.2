Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482Ab2D0Hst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:48:49 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34266 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271Ab2D0Hsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <1335143029.4927.45.camel@minggr>
References: <1335143029.4927.45.camel@minggr>
Date: Fri, 27 Apr 2012 15:48:46 +0800
Message-ID: <CAC=cRTNcvgREd4C-MZfBLa_6F94o=jG9avM0Ooyv3hKhFH4vTg@mail.gmail.com>
Subject: Re: [PATCH v3] ACPI: D3 states cleanup
From: huang ying <huang.ying.caritas@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, lenb <lenb@kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, aaron.lu@amd.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ming,

On Mon, Apr 23, 2012 at 9:03 AM, Lin Ming <ming.m.lin@intel.com> wrote:
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

The changelog should say why we make the change instead of how we make
the change.  The code itself can tell me how we have done well.  I
prefer to see the description about

- the history of ACPI_STATE_D3, ACPI_STATE_D3_HOT, ACPI_STATE_D3_COLD
- if no _PR3, _PS3 may put device into D3_HOT or D3_COLD, decided by
platform.  But we will assume _PS3 will put device into D3_COLD,
because it is safe to treat device in D3_HOT as D3_COLD, but not in
contrary way.

And I think it will be more clear if we list the power state
supporting under various combination, for example,

- has _PS3, no _PR3
  - Valid states: D3_COLD
  - Set power state
    - D3_COLD: exec _PS3

> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>
> v3: D3hot is only valid if _PR3 present
>
>  drivers/acpi/power.c   |    2 +-
>  drivers/acpi/scan.c    |   17 +++++++----------
>  drivers/pci/pci-acpi.c |    4 ++--
>  include/acpi/actypes.h |    7 ++++---
>  4 files changed, 14 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index 7049a7d..330bb4d 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -631,7 +631,7 @@ int acpi_power_get_inferred_state(struct acpi_device *device, int *state)
>         * We know a device's inferred power state when all the resources
>         * required for a given D-state are 'on'.
>         */
> -       for (i = ACPI_STATE_D0; i < ACPI_STATE_D3; i++) {
> +       for (i = ACPI_STATE_D0; i < ACPI_STATE_D3_HOT; i++) {
>                list = &device->power.states[i].resources;
>                if (list->count < 1)
>                        continue;
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 767e2dc..7417267 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -869,7 +869,7 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>        /*
>         * Enumerate supported power management states
>         */
> -       for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3; i++) {
> +       for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
>                struct acpi_device_power_state *ps = &device->power.states[i];
>                char object_name[5] = { '_', 'P', 'R', '0' + i, '\0' };
>
> @@ -884,21 +884,18 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>                                acpi_bus_add_power_resource(ps->resources.handles[j]);
>                }
>
> -               /* The exist of _PR3 indicates D3Cold support */
> -               if (i == ACPI_STATE_D3) {
> -                       status = acpi_get_handle(device->handle, object_name, &handle);
> -                       if (ACPI_SUCCESS(status))
> -                               device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> -               }
> -
>                /* Evaluate "_PSx" to see if we can do explicit sets */
>                object_name[2] = 'S';
>                status = acpi_get_handle(device->handle, object_name, &handle);
>                if (ACPI_SUCCESS(status))
>                        ps->flags.explicit_set = 1;
>
> -               /* State is valid if we have some power control */
> -               if (ps->resources.count || ps->flags.explicit_set)
> +               /*
> +                * State is valid if there are means to put the device into it.
> +                * D3hot is only valid if _PR3 present.
> +                */
> +               if (ps->resources.count ||
> +                   (ps->flags.explicit_set && i < ACPI_STATE_D3_HOT))
>                        ps->flags.valid = 1;

I think we should add some comments here about why we do that.  Why
D3_HOT is not valid if only _PS3 presents.

>                ps->power = -1; /* Unknown - driver assigned */
> diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
> index 0f150f2..1929c0c 100644
> --- a/drivers/pci/pci-acpi.c
> +++ b/drivers/pci/pci-acpi.c
> @@ -200,7 +200,7 @@ static pci_power_t acpi_pci_choose_state(struct pci_dev *pdev)
>                return PCI_D1;
>        case ACPI_STATE_D2:
>                return PCI_D2;
> -       case ACPI_STATE_D3:
> +       case ACPI_STATE_D3_HOT:
>                return PCI_D3hot;
>        case ACPI_STATE_D3_COLD:
>                return PCI_D3cold;
> @@ -223,7 +223,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
>                [PCI_D0] = ACPI_STATE_D0,
>                [PCI_D1] = ACPI_STATE_D1,
>                [PCI_D2] = ACPI_STATE_D2,
> -               [PCI_D3hot] = ACPI_STATE_D3,
> +               [PCI_D3hot] = ACPI_STATE_D3_HOT,
>                [PCI_D3cold] = ACPI_STATE_D3
>        };
>        int error = -EINVAL;
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index eba6604..e8bcc47 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -499,9 +499,10 @@ typedef u64 acpi_integer;
>  #define ACPI_STATE_D0                   (u8) 0
>  #define ACPI_STATE_D1                   (u8) 1
>  #define ACPI_STATE_D2                   (u8) 2
> -#define ACPI_STATE_D3                   (u8) 3
> -#define ACPI_STATE_D3_COLD              (u8) 4
> -#define ACPI_D_STATES_MAX               ACPI_STATE_D3_COLD
> +#define ACPI_STATE_D3_HOT               (u8) 3
> +#define ACPI_STATE_D3                   (u8) 4
> +#define ACPI_STATE_D3_COLD              ACPI_STATE_D3
> +#define ACPI_D_STATES_MAX               ACPI_STATE_D3
>  #define ACPI_D_STATE_COUNT              5
>
>  #define ACPI_STATE_C0                   (u8) 0

Best Regards,
Huang Ying
