Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917Ab2HIWfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 18:35:01 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:46645 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892Ab2HIWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 18:34:58 -0400
Message-ID: <1344551691.10751.12.camel@ejdallLaptop>
Subject: Re: [PATCH] x86, pci: Fix all early PCI scans to check the vendor
 ID first
From: Betty Dall <betty.dall@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Thu, 09 Aug 2012 16:34:51 -0600
In-Reply-To: <1344464246-14618-1-git-send-email-andi@firstfloor.org>
References: <1344464246-14618-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andi,

On Wed, 2012-08-08 at 15:17 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> According to the Intel PCI experts it's not safe to check any
> other field than vendor ID for 0xffff when doing PCI scans
> to see if the device exists.
> 
> Several of the early PCI scans violated this. I changed
> them all to always check the vendor ID first.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/aperture_64.c        |    5 +++++
>  arch/x86/kernel/early-quirks.c       |    3 +++
>  arch/x86/kernel/pci-calgary_64.c     |    8 ++++++--
>  arch/x86/pci/early.c                 |    3 +++
>  drivers/firewire/init_ohci1394_dma.c |    3 +++
>  5 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> index d5fd66f..e1ca7cd 100644
> --- a/arch/x86/kernel/aperture_64.c
> +++ b/arch/x86/kernel/aperture_64.c
> @@ -206,6 +206,11 @@ static u32 __init search_agp_bridge(u32 *order, int *valid_agp)
>  			for (func = 0; func < 8; func++) {
>  				u32 class, cap;
>  				u8 type;
> +
> +				if (read_pci_config_16(bus, slot, func, PCI_VENDOR_ID) 
> +				    == 0xffff)
> +					continue;

I thought this should be a break instead of a continue since the code
does a break if the class is 0xffffffff. If the function does not have a
valid VENDOR_ID, then the remaining function numbers do not have to be
scanned because functions are required to be implemented in order (no
skipping a function number.)

> +
>  				class = read_pci_config(bus, slot, func,
>  							PCI_CLASS_REVISION);
>  				if (class == 0xffffffff)
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 3755ef4..f76b930 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -250,6 +250,9 @@ static int __init check_dev_quirk(int num, int slot, int func)
>  
>  	vendor = read_pci_config_16(num, slot, func, PCI_VENDOR_ID);
>  
> +	if (vendor == 0xffff)
> +		return -1;
> +
>  	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
>  
>  	for (i = 0; early_qrk[i].f != NULL; i++) {
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index 299d493..05798a0 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -1324,8 +1324,9 @@ static void __init get_tce_space_from_tar(void)
>  		unsigned short pci_device;
>  		u32 val;
>  
> -		val = read_pci_config(bus, 0, 0, 0);
> -		pci_device = (val & 0xFFFF0000) >> 16;
> +		if (read_pci_config_16(bus, 0, 0, PCI_VENDOR_ID) == 0xffff)
> +			continue;
> +		pci_device = read_pci_config_16(bus, 0, 0, PCI_DEVICE_ID);
>  
>  		if (!is_cal_pci_dev(pci_device))
>  			continue;
> @@ -1426,6 +1427,9 @@ int __init detect_calgary(void)
>  		unsigned short pci_device;
>  		u32 val;
>  
> +		if (read_pci_config_16(bus, 0, 0, PCI_VENDOR_ID) == 0xffff)
> +			continue;
> +
>  		val = read_pci_config(bus, 0, 0, 0);
>  		pci_device = (val & 0xFFFF0000) >> 16;

I liked how you replaced the read_pci_config(bus, 0, 0, 0) with
read_pci_config_16(bus, 0, 0, PCI_DEVICE_ID) in the previous diff for
the function get_tce_space_from_tar(). Could you do that in this
detect_calgary() function too?

>  
> diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
> index d1067d5..4fb6847 100644
> --- a/arch/x86/pci/early.c
> +++ b/arch/x86/pci/early.c
> @@ -91,6 +91,9 @@ void early_dump_pci_devices(void)
>  				u32 class;
>  				u8 type;
>  
> +				if (read_pci_config_16(bus, slot, func, PCI_VENDOR_ID) == 0xffff)
> +					continue;
> +
>  				class = read_pci_config(bus, slot, func,
>  							PCI_CLASS_REVISION);
>  				if (class == 0xffffffff)
> diff --git a/drivers/firewire/init_ohci1394_dma.c b/drivers/firewire/init_ohci1394_dma.c
> index a9a347a..dd3bd84 100644
> --- a/drivers/firewire/init_ohci1394_dma.c
> +++ b/drivers/firewire/init_ohci1394_dma.c
> @@ -279,6 +279,9 @@ void __init init_ohci1394_dma_on_all_controllers(void)
>  	for (num = 0; num < 32; num++) {
>  		for (slot = 0; slot < 32; slot++) {
>  			for (func = 0; func < 8; func++) {
> +				if (read_pci_config_16(num, slot, func, PCI_VENDOR_ID) == 0xffff)
> +					continue;
> +
>  				class = read_pci_config(num, slot, func,
>  							PCI_CLASS_REVISION);
>  				if (class == 0xffffffff)

It is interesting that these last two functions are doing basically the
same pci discovery as the code in search_agp_bridge(), except that they
uses continue instead of break. It might be beyond the scope of what you
are trying to fix, but those continues could be changed to breaks for
the same reason it is a break in search_agp_bridge().

-Betty

