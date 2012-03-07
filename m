Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221Ab2CGTsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:48:54 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:35249 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760057Ab2CGTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:48:50 -0500
Subject: Re: [PATCH 3.3.0-rc3] Fix use-after-free in acpi_map_lsapic
From: Alok Kataria <akataria@vmware.com>
To: Petr Vandrovec <petr@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        dcovelli@vmware.com
In-Reply-To: <20120216000643.GA7508@petr-dev3.eng.vmware.com>
References: <20120216000643.GA7508@petr-dev3.eng.vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2012 11:48:50 -0800
Message-Id: <1331149730.25361.24.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, anyone else, 

Any comments on this one ? This fixes a important bug during cpu hotadd
where the kernel fails to recognize all the newly added cpus.

Thanks,
Alok


On Wed, 2012-02-15 at 16:06 -0800, Petr Vandrovec wrote:
> From: Petr Vandrovec <petr@vmware.com>
> 
> When processor is being hot-added to the system, acpi_map_lsapic invokes
> ACPI _MAT method to find APIC ID and flags, verifies that returned structure
> is indeed ACPI's local APIC structure, and that flags contain MADT_ENABLED
> bit.  Then saves APIC ID, frees structure - and accesses structure when
> computing arguments for acpi_register_lapic call.  Which sometime leads
> to acpi_register_lapic call being made with second argument zero, failing
> to bring processor online with error 'Unable to map lapic to logical cpu
> number'.
> 
> As lapic->lapic_flags & ACPI_MADT_ENABLED was already confirmed to be non-zero
> few lines above, we can just pass unconditional ACPI_MADT_ENABLED to the
> acpi_register_lapic.
> 
> Thanks, Petr
> 
> Signed-off-by: Petr Vandrovec <petr@vmware.com>
> Signed-off-by: Alok Kataria <akataria@vmware.com>
> 
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index ce664f3..a4a0901 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -650,7 +650,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
>  		goto free_tmp_map;
>  
>  	cpumask_copy(tmp_map, cpu_present_mask);
> -	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
> +	acpi_register_lapic(physid, ACPI_MADT_ENABLED);
>  
>  	/*
>  	 * If mp_register_lapic successfully generates a new logical cpu

