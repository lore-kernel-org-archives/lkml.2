Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab1KFVK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:10:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53474 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1KFVKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:10:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH -v2] acpi: Fix possible recursive locking in hwregs.c
Date: Sun, 6 Nov 2011 22:13:02 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-acpi" <linux-acpi@vger.kernel.org>, akpm@linux-foundation.org,
        ming Lin <ming.m.lin@intel.com>, len.brown@intel.com,
        srivatsa.bhat@linux.vnet.ibm.com, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1320592697.7439.3.camel@localhost.localdomain>
In-Reply-To: <1320592697.7439.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111062213.02844.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 06, 2011, Rakib Mullick wrote:
> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status, acpi_os_acquire_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which tries to hold acpi_gbl_gpe_lock. Both acpi_gbl_hardware_lock and acpi_gbl_gpe_lock are at same lock-class and which might cause lock recursion deadlock. 
> 
> Following patch fixes this scenario by just releasing acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list.
> 
>  Changes since v0(https://lkml.org/lkml/2011/9/21/355):
> 	- Fix changelog, thanks to Lin Ming.
> 
>  Changes since v1 (https://lkml.org/lkml/2011/11/3/89):
> 	- Update changelog and rename goto label, courtesy Srivatsa S. Bhat.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> Cc: Lin Ming <ming.m.lin@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
> 
> diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
> index 55accb7..cc70f3f 100644
> --- a/drivers/acpi/acpica/hwregs.c
> +++ b/drivers/acpi/acpica/hwregs.c
> @@ -269,16 +269,17 @@ acpi_status acpi_hw_clear_acpi_status(void)
>  
>  	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
>  					ACPI_BITMASK_ALL_FIXED_STATUS);
> -	if (ACPI_FAILURE(status)) {
> -		goto unlock_and_exit;
> -	}
> +
> +	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
> +
> +	if (ACPI_FAILURE(status))
> +		goto exit;
>  
>  	/* Clear the GPE Bits in all GPE registers in all GPE blocks */
>  
>  	status = acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
>  
> -      unlock_and_exit:
> -	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
> +exit:
>  	return_ACPI_STATUS(status);
>  }
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

