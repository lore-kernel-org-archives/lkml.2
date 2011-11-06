Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab1KFTqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:46:52 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45674 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1KFTqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:46:49 -0500
Message-ID: <4EB6E416.4080201@linux.vnet.ibm.com>
Date: Mon, 07 Nov 2011 01:16:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>, akpm@linux-foundation.org,
        ming Lin <ming.m.lin@intel.com>, len.brown@intel.com
Subject: Re: [PATCH -v2] acpi: Fix possible recursive locking in hwregs.c
References: <1320592697.7439.3.camel@localhost.localdomain>
In-Reply-To: <1320592697.7439.3.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 08:48 PM, Rakib Mullick wrote:
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
> ---
> 

It would be a good idea to also give the lockdep warning in the changelog
(though you triggered it in a modified kernel), since that would make
it very clear as to what problem your patch is trying to solve.
[And please line-wrap your changelog to 80 characters at most, per line].

Code-wise, the patch looks good to me. So,
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

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
