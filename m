Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab2CHVd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:33:27 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:44395 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977Ab2CHVdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:33:24 -0500
Subject: Re: [PATCH 3.3.0-rc3] Fix use-after-free in acpi_map_lsapic
From: Alok Kataria <akataria@vmware.com>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Petr Vandrovec <petr@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, lenb@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        dcovelli@vmware.com
In-Reply-To: <1331240475.1156.104.camel@misato.fc.hp.com>
References: <20120216000643.GA7508@petr-dev3.eng.vmware.com>
	 <1331149730.25361.24.camel@ank32.eng.vmware.com>
	 <1331240475.1156.104.camel@misato.fc.hp.com>
Content-Type: text/plain
Date: Thu, 08 Mar 2012 13:33:24 -0800
Message-Id: <1331242404.5753.7.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi, 

On Thu, 2012-03-08 at 14:01 -0700, Toshi Kani wrote:
> On Wed, 2012-03-07 at 11:48 -0800, Alok Kataria wrote:
> > Len, anyone else, 
> > 
> > Any comments on this one ? This fixes a important bug during cpu hotadd
> > where the kernel fails to recognize all the newly added cpus.
> > 
> > Thanks,
> > Alok
> > 
> > 
> > On Wed, 2012-02-15 at 16:06 -0800, Petr Vandrovec wrote:
> > > From: Petr Vandrovec <petr@vmware.com>
> > > 
> > > When processor is being hot-added to the system, acpi_map_lsapic invokes
> > > ACPI _MAT method to find APIC ID and flags, verifies that returned structure
> > > is indeed ACPI's local APIC structure, and that flags contain MADT_ENABLED
> > > bit.  Then saves APIC ID, frees structure - and accesses structure when
> > > computing arguments for acpi_register_lapic call.  Which sometime leads
> > > to acpi_register_lapic call being made with second argument zero, failing
> > > to bring processor online with error 'Unable to map lapic to logical cpu
> > > number'.
> > > 
> > > As lapic->lapic_flags & ACPI_MADT_ENABLED was already confirmed to be non-zero
> > > few lines above, we can just pass unconditional ACPI_MADT_ENABLED to the
> > > acpi_register_lapic.
> > > 
> > > Thanks, Petr
> > > 
> > > Signed-off-by: Petr Vandrovec <petr@vmware.com>
> > > Signed-off-by: Alok Kataria <akataria@vmware.com>
> > > 
> > > 
> > > diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> > > index ce664f3..a4a0901 100644
> > > --- a/arch/x86/kernel/acpi/boot.c
> > > +++ b/arch/x86/kernel/acpi/boot.c
> > > @@ -650,7 +650,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
> > >  		goto free_tmp_map;
> > >  
> > >  	cpumask_copy(tmp_map, cpu_present_mask);
> > > -	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
> > > +	acpi_register_lapic(physid, ACPI_MADT_ENABLED);
> 
> The change looks good. I suggest you also add the following line to
> prevent such bug in future.
> 
>         kfree(buffer.pointer);
>         buffer.length = ACPI_ALLOCATE_BUFFER;
>         buffer.pointer = NULL;
> +       lapic = NULL;

That's a good suggestion, below is the updated patch. Thanks !!
--

From: Petr Vandrovec <petr@vmware.com>

When processor is being hot-added to the system, acpi_map_lsapic invokes
ACPI _MAT method to find APIC ID and flags, verifies that returned structure
is indeed ACPI's local APIC structure, and that flags contain MADT_ENABLED
bit.  Then saves APIC ID, frees structure - and accesses structure when
computing arguments for acpi_register_lapic call.  Which sometime leads
to acpi_register_lapic call being made with second argument zero, failing
to bring processor online with error 'Unable to map lapic to logical cpu
number'.

As lapic->lapic_flags & ACPI_MADT_ENABLED was already confirmed to be non-zero
few lines above, we can just pass unconditional ACPI_MADT_ENABLED to the
acpi_register_lapic.

Signed-off-by: Petr Vandrovec <petr@vmware.com>
Signed-off-by: Alok N Kataria <akataria@vmware.com>
Cc : Toshi Kani <toshi.kani@hp.com>


Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c	2012-01-24 14:48:56.000000000 -0800
+++ linux-2.6/arch/x86/kernel/acpi/boot.c	2012-03-08 13:25:39.000000000 -0800
@@ -642,6 +642,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 	kfree(buffer.pointer);
 	buffer.length = ACPI_ALLOCATE_BUFFER;
 	buffer.pointer = NULL;
+	lapic = NULL;
 
 	if (!alloc_cpumask_var(&tmp_map, GFP_KERNEL))
 		goto out;
@@ -650,7 +651,7 @@ static int __cpuinit _acpi_map_lsapic(ac
 		goto free_tmp_map;
 
 	cpumask_copy(tmp_map, cpu_present_mask);
-	acpi_register_lapic(physid, lapic->lapic_flags & ACPI_MADT_ENABLED);
+	acpi_register_lapic(physid, ACPI_MADT_ENABLED);
 
 	/*
 	 * If mp_register_lapic successfully generates a new logical cpu




