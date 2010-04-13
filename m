Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab0DMVCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 17:02:54 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:19802 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab0DMVCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 17:02:51 -0400
Subject: Re: [PATCH -v2 2/2] x86,pci, acpi: Inherent BUSY flag when
	setup_resource for root bus
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
In-Reply-To: <4BC39FAF.4030808@oracle.com>
References: <20100409223532.GC11130@hexapodia.org>
	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>
	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>
	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>
	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>
	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>
	 <4BC39FAF.4030808@oracle.com>
Content-Type: text/plain
Date: Tue, 13 Apr 2010 15:02:28 -0600
Message-Id: <1271192548.6035.46.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-12 at 15:33 -0700, Yinghai wrote:
> So make pci root resource from _CRS honor the range We reserve in e820 below 1M
> then  will not assign them to unsigned pci BAR
> 
> -v2: let pci_bus_alloc_resource() honor IORESOURCE_BUSY
>      driver can not use those range, so skip it

This -v2 text doesn't belong in the changelog.  If you need it, it
should be in a cover message so it doesn't clutter the permanent git
logs.

> Index: linux-2.6/arch/x86/pci/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/acpi.c
> +++ linux-2.6/arch/x86/pci/acpi.c
> @@ -175,6 +175,10 @@ setup_resource(struct acpi_resource *acp
>  			"conflicts with %s %pR\n",
>  			res, conflict->name, conflict);
>  	} else {
> +		/* In case it falls in big reserved region */
> +		if (res->parent->flags & IORESOURCE_BUSY)
> +			res->flags |= IORESOURCE_BUSY;
> +
>  		pci_bus_add_resource(info->bus, res, 0);
>  		info->res_num++;
>  		if (addr.translation_offset)
> Index: linux-2.6/drivers/pci/bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/bus.c
> +++ linux-2.6/drivers/pci/bus.c
> @@ -103,6 +103,10 @@ pci_bus_alloc_resource(struct pci_bus *b
>  		if (!r)
>  			continue;
>  
> +		/* Driver can not reserve it later, so don't use it */
> +		if (r->flags & IORESOURCE_BUSY)
> +			continue;
> +
>  		/* type_mask must match */
>  		if ((res->flags ^ r->flags) & type_mask)
>  			continue;

I think this makes sense, but I think it should be in two separate
patches.  The first would be the pci_bus_alloc_resource() change, which
is of interest to all architectures, with a changelog like this:

  PCI: don't allocate from a BUSY bus resource

  Drivers typically use pci_request_regions() to reserve the resources
  they use, but that fails if the resource is already busy.  Therefore,
  we should ignore busy resources when we're assigning resources to a
  device.

and the second would be:

  x86/PCI: host bridge windows inherit BUSY flag from parent

  If a host bridge window falls inside a region the architecture has
  marked busy, the window should inherit the busy flag so we don't
  try to assign that region to a device.

Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>


