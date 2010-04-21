Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab0DUPW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:22:56 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:15191 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0DUPWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:22:54 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai <yinghai.lu@oracle.com>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
Date: Wed, 21 Apr 2010 09:21:49 -0600
User-Agent: KMail/1.9.10
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
References: <20100409223532.GC11130@hexapodia.org> <4BCE8E3E.4030809@oracle.com> <4BCE8EBF.5050207@oracle.com>
In-Reply-To: <4BCE8EBF.5050207@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004210921.50502.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 April 2010 11:35:59 pm Yinghai wrote:
> 
> Don't clear root bus resource too early, until We can make sure _CRS works

Please observe English conventions like capitalizing the first word
of a sentence (and not things like "We" in the middle) and using
a period at the end.

> also restore it, if all _CRS get rejected because of conflicts
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/acpi.c |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/acpi.c
> +++ linux-2.6/arch/x86/pci/acpi.c
> @@ -196,9 +196,6 @@ get_current_resources(struct acpi_device
>  	struct pci_root_info info;
>  	size_t size;
>  
> -	if (pci_use_crs)
> -		pci_bus_remove_resources(bus);
> -
>  	info.bridge = device;
>  	info.bus = bus;
>  	info.res_num = 0;
> @@ -217,10 +214,20 @@ get_current_resources(struct acpi_device
>  		goto name_alloc_fail;
>  	sprintf(info.name, "PCI Bus %04x:%02x", domain, busnum);
>  
> +	/* Only clear that when _CRS works for sure*/

If you put a comment here, please at least add a space before the
closing "*/".  Otherwise it looks sloppy.

> +	if (pci_use_crs)
> +		pci_bus_remove_resources(bus);
> +
>  	info.res_num = 0;
>  	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
>  				&info);
>  
> +	if (pci_use_crs && !info.res_num) {
> +		/* Restore default one */
> +		bus->resource[0] = &ioport_resource;
> +		bus->resource[1] = &iomem_resource;

This is ugly because it just repeats this code from pci_create_bus(),
and there's no indication either here or there that they are connected.

Admittedly, I think it's also sort of ugly that pci_bus_remove_resources()
exists at all -- I'd rather have some sort of hook so we could set the
bus resources correctly the first time.

Maybe you could at least add a pci_bus_set_default_resources() that
could be called both here and from pci_create_bus().

Why are you doing this patch?  Did you see a machine where the host
bridge was left with no resources because of _CRS issues?  If so,
this patch feels like a band-aid.  I'd rather investigate the issue
directly, because that would probably be a Linux problem we could fix.

Also, if there *is* a reported problem, you should include a link to
the bugzilla or email thread.

Bjorn

> +	}
> +
>  	return;
>  
>  name_alloc_fail:
> 


