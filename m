Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2CHVBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:01:55 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:15868 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2CHVBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:01:53 -0500
Message-ID: <1331240475.1156.104.camel@misato.fc.hp.com>
Subject: Re: [PATCH 3.3.0-rc3] Fix use-after-free in acpi_map_lsapic
From: Toshi Kani <toshi.kani@hp.com>
To: Alok Kataria <akataria@vmware.com>
Cc: Petr Vandrovec <petr@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        dcovelli@vmware.com
Date: Thu, 08 Mar 2012 14:01:15 -0700
In-Reply-To: <1331149730.25361.24.camel@ank32.eng.vmware.com>
References: <20120216000643.GA7508@petr-dev3.eng.vmware.com>
	 <1331149730.25361.24.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 11:48 -0800, Alok Kataria wrote:
> Len, anyone else, 
> 
> Any comments on this one ? This fixes a important bug during cpu hotadd
> where the kernel fails to recognize all the newly added cpus.
> 
> Thanks,
> Alok
> 
> 
> On Wed, 2012-02-15 at 16:06 -0800, Petr Vandrovec wrote:
> > From: Petr Vandrovec <petr@vmware.com>
> > 
> > When processor is being hot-added to the system, acpi_map_lsapic invokes
> > ACPI _MAT method to find APIC ID and flags, verifies that returned structure
> > is indeed ACPI's local APIC structure, and that flags contain MADT_ENABLED
> > bit.  Then saves APIC ID, frees structure - and accesses structure when
> > computing arguments for acpi_register_lapic call.  Which sometime leads
> > to acpi_register_lapic call being made with second argument zero, failing
> > to bring processor online with error 'Unable to map lapic to logical cpu
> > number'.
> > 
> > As lapic->lapic_flags & ACPI_MADT_ENABLED was already confirmed to be non-zero
> > few lines above, we can just pass unconditional ACPI_MADT_ENABLED to the
> > acpi_register_lapic.
> > 
> > Thanks, Petr
> > 
> > Signed-off-by: Petr Vandrovec <petr@vmware.com>
> > Signed-off-by: Alok Kataria <akataria@vmware.com>
> > 
> > 
> > diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> > index ce664f3..a4a0901 100644
> > --- a/arch/x86/kernel/acpi/boot.c
> > +++ b/arch/x86/kernel/acpi/boot.c
> > @@ -650,7 +650,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
> >  		goto free_tmp_map;
> >  
> >  	cpumask_copy(tmp_map, cpu_present_mask);
> > -	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
> > +	acpi_register_lapic(physid, ACPI_MADT_ENABLED);

The change looks good. I suggest you also add the following line to
prevent such bug in future.

        kfree(buffer.pointer);
        buffer.length = ACPI_ALLOCATE_BUFFER;
        buffer.pointer = NULL;
+       lapic = NULL;

Thanks,
-Toshi


> >  
> >  	/*
> >  	 * If mp_register_lapic successfully generates a new logical cpu
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


