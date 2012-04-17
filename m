Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2DQGDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:03:37 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55631 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2DQGDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <1334641676-14566-2-git-send-email-ming.m.lin@intel.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
	<1334641676-14566-2-git-send-email-ming.m.lin@intel.com>
Date: Tue, 17 Apr 2012 14:03:34 +0800
Message-ID: <CAC=cRTPkFM5=az2B0A22miqt_X+XxcWPLrqPfeeRabho9yx-1Q@mail.gmail.com>
Subject: Re: [PATCH 1/6] ACPI: D3cold state is always valid
From: huang ying <huang.ying.caritas@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.og>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lu@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 1:47 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> ACPI_STATE_D3 actually means ACPI D3hot which is not always valid.
> Instead, ACPI D3cold is always valid.
>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/acpi/scan.c |   11 ++---------
>  1 files changed, 2 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 767e2dc..fb56388 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -884,13 +884,6 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
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
> @@ -908,8 +901,8 @@ static int acpi_bus_get_power_flags(struct acpi_device *device)
>        /* Set defaults for D0 and D3 states (always valid) */
>        device->power.states[ACPI_STATE_D0].flags.valid = 1;
>        device->power.states[ACPI_STATE_D0].power = 100;
> -       device->power.states[ACPI_STATE_D3].flags.valid = 1;
> -       device->power.states[ACPI_STATE_D3].power = 0;
> +       device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> +       device->power.states[ACPI_STATE_D3_COLD].power = 0;
>
>        acpi_bus_init_power(device);

I think D3_HOT should be always valid, while D3_COLD should be valid
for some situation.

 - has _PS3, no _PR3
   - support D3_HOT, D3_COLD
   - set state
     - D3_HOT: do nothing in ACPI
     - D3_COLD: _PS3

 - has _PR3, no _PS3
   - support D3_HOT, D3_COLD
   - set state
     - D3_HOT: _PR3 on, _PR0 off
     - D3_COLD: _PR3 on, _PR0 off, _PR3 off

 - has _PS3, has _PR3
   - support D3_HOT, D3_COLD
   - set state
     - D3_HOT: _PS3, _PR3 on, _PR0 off
     - D3_COLD: _PS3, _PR3 on, _PR0 off, _PR3 off

 - no _PS3, no _PR3
   - support D3_HOT
   - set state
     - D3_HOT: do nothing in ACPI

Best Regards,
Huang Ying
