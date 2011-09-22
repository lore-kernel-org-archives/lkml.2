Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1IVBAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 21:00:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63572 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1IVA76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 20:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <1316628589.7341.11.camel@localhost.localdomain>
References: <1316628589.7341.11.camel@localhost.localdomain>
Date: Thu, 22 Sep 2011 08:59:57 +0800
X-Google-Sender-Auth: FGhAdyajsk8x71RK8-CYUUMWbD0
Message-ID: <CAF1ivSbZf5zgJphyaLeUZfSgz-oPvAY0bG6V2OMeWPS60nsxxQ@mail.gmail.com>
Subject: Re: [PATCH] acpi: Fix possible recursive locking in hwregs.c
From: Lin Ming <ming.m.lin@intel.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:09 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status,
> acpi_os_release_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then
> without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which also tries to
> hold acpi_gbl_hardware_lock and thus causes possible recursive lock.

No, acpi_ev_walk_gpe_list holds acpi_gbl_gpe_lock.

Lin Ming

>
> Following patch fixes this scenario by just releasing acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list.
>
> [This patch was created against 3.0-rc3. Since kernel.org is down, I don't have the updated tree. So, before applying
> it might require some adjustment.]
>
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
>
> diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
> index 55accb7..e3110ac 100644
> --- a/drivers/acpi/acpica/hwregs.c
> +++ b/drivers/acpi/acpica/hwregs.c
> @@ -269,6 +269,9 @@ acpi_status acpi_hw_clear_acpi_status(void)
>
>        status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
>                                        ACPI_BITMASK_ALL_FIXED_STATUS);
> +
> +       acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
> +
>        if (ACPI_FAILURE(status)) {
>                goto unlock_and_exit;
>        }
> @@ -278,7 +281,6 @@ acpi_status acpi_hw_clear_acpi_status(void)
>        status = acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
>
>       unlock_and_exit:
> -       acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
>        return_ACPI_STATUS(status);
>  }
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
