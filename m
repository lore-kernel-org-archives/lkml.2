Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab1KCRlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:41:01 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39395 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab1KCRlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:41:00 -0400
Message-ID: <4EB2D225.60808@linux.vnet.ibm.com>
Date: Thu, 03 Nov 2011 23:10:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Rakib Mullick <rakib.mullick@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -v1] acpi: Fix possible recursive locking in hwregs.c
References: <1320317323.5711.5.camel@localhost.localdomain> <1320321770.2813.10.camel@hp6530s>
In-Reply-To: <1320321770.2813.10.camel@hp6530s>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/03/2011 05:32 PM, Lin Ming wrote:
> On Thu, 2011-11-03 at 18:48 +0800, Rakib Mullick wrote:
>> Calling pm-suspend might trigger a recursive lock in it's code path. In function acpi_hw_clear_acpi_status, 
> 
> As I replied at https://lkml.org/lkml/2011/9/22/6, I still don't think
> there is a recursive lock.
> 

At first look, it definitely doesn't look like a recursive lock, as Lin said.
But, quoting Documentation/lockdep-design.txt:

"Multi-lock dependency rules:
----------------------------

The same lock-class must not be acquired twice, because this could lead
to lock recursion deadlocks."

So, Rakib, do the 2 locks belong to the same lock-class? If yes, then I think
that is the reason for the lockdep splat. Could you show the lockdep warning?

By the way, another way to look at this patch is as an optimization..
i.e., if acpi_gbl_hardware_lock doesn't need to be held to call
acpi_ev_walk_gpe_list(), then we can move from the coarse-grained locking
to finer-grained locking by releasing it earlier, as you did in your patch.
[Note that you will have to update the goto label also, i.e., rename it as
'exit' or something like that]

>> acpi_os_acquire_lock holds the lock acpi_gbl_hardware_lock before calling acpi_hw_register_write(), then 
>> without releasing acpi_gbl_hardware_lock, this function calls acpi_ev_walk_gpe_list, which tries to hold 
>> acpi_gbl_gpe_lock and thus might causes possible recursive lock.
>>
>> Following patch fixes this scenario by just releasing acpi_gbl_hardware_lock before calling acpi_ev_walk_gpe_list.
>>
>>  Changes since v0(https://lkml.org/lkml/2011/9/21/355):
>> 	- Fix changelog, thanks to Lin Ming.
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
>> Cc: Lin Ming <ming.m.lin@intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Len Brown <len.brown@intel.com>
>> ---
>>
>> diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
>> index 55accb7..e3110ac 100644
>> --- a/drivers/acpi/acpica/hwregs.c
>> +++ b/drivers/acpi/acpica/hwregs.c
>> @@ -269,6 +269,9 @@ acpi_status acpi_hw_clear_acpi_status(void)
>>  
>>  	status = acpi_hw_register_write(ACPI_REGISTER_PM1_STATUS,
>>  					ACPI_BITMASK_ALL_FIXED_STATUS);
>> +
>> +	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
>> +
>>  	if (ACPI_FAILURE(status)) {
>>  		goto unlock_and_exit;
>>  	}
>> @@ -278,7 +281,6 @@ acpi_status acpi_hw_clear_acpi_status(void)
>>  	status = acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
>>  
>>        unlock_and_exit:
>> -	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
>>  	return_ACPI_STATUS(status);
>>  }
>>  
>>


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
