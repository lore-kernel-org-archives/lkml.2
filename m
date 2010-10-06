Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab0JFPsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 11:48:19 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:1590 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab0JFPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 11:48:18 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Venkatesh Pallipadi <venki@google.com>
Subject: Re: [PATCH v2] x86, HPET: mark HPET PCI BARs as IORESOURCE_PCI_FIXED
Date: Wed, 6 Oct 2010 09:47:11 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Prarit Bhargava <prarit@redhat.com>, fredlwm@gmail.com,
        Simon Arlott <simon@fire.lp0.eu>, x86@kernel.org,
        Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>
References: <20101005161325.22039.70478.stgit@bob.kio>
In-Reply-To: <20101005161325.22039.70478.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010060947.12465.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 05, 2010 10:13:26 am Bjorn Helgaas wrote:
> We often discover the HPET early, via the static ACPI HPET table, before
> enumerating PCI devices.  If the HPET is implemented as a PCI function,
> we will discover it again during PCI device enumeration.  We must make
> sure we never move the PCI function out from under the driver.
> 
> Doing this for *any* PCI BAR that matches a previously discovered HPET
> should be more generic than the previous ATI-specific quirk.
> 
> This is for a regression from 2.6.34, but the reporter has been unable
> to test it yet.

Since I don't have any way to test this, and it is an old regression,
I'd like to get it in -next and get some runtime on it.

> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=18482
> Reported-by: Simon Arlott <simon@fire.lp0.eu>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
> 
>  arch/x86/kernel/quirks.c |   19 +++++++++++++++++++
>  arch/x86/pci/fixup.c     |   28 ----------------------------
>  2 files changed, 19 insertions(+), 28 deletions(-)
> 
> 
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index 939b9e9..9510f53 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -507,6 +507,25 @@ static void force_disable_hpet_msi(struct pci_dev *unused)
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
>  			 force_disable_hpet_msi);
>  
> +static void quirk_pci_hpet(struct pci_dev *dev)
> +{
> +	int i;
> +
> +	if (!hpet_address)
> +		return;
> +
> +	for (i = 0; i < 6; i++) {
> +		struct resource *res = &dev->resource[i];
> +
> +		if (resource_type(res) == IORESOURCE_MEM &&
> +		    res->start == hpet_address) {
> +			dev_info(&dev->dev, "BAR %d: %pR is an HPET we found earlier; making it immovable\n",
> +				 i, res);
> +			res->flags |= IORESOURCE_PCI_FIXED;
> +		}
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, quirk_pci_hpet);
>  #endif
>  
>  #if defined(CONFIG_PCI) && defined(CONFIG_NUMA)
> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index 6dd8955..08eba69 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -493,31 +493,3 @@ static void __devinit pci_siemens_interrupt_controller(struct pci_dev *dev)
>  }
>  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_SIEMENS, 0x0015,
>  			  pci_siemens_interrupt_controller);
> -
> -/*
> - * SB600: Disable BAR1 on device 14.0 to avoid HPET resources from
> - * confusing the PCI engine:
> - */
> -static void sb600_disable_hpet_bar(struct pci_dev *dev)
> -{
> -	u8 val;
> -
> -	/*
> -	 * The SB600 and SB700 both share the same device
> -	 * ID, but the PM register 0x55 does something different
> -	 * for the SB700, so make sure we are dealing with the
> -	 * SB600 before touching the bit:
> -	 */
> -
> -	pci_read_config_byte(dev, 0x08, &val);
> -
> -	if (val < 0x2F) {
> -		outb(0x55, 0xCD6);
> -		val = inb(0xCD7);
> -
> -		/* Set bit 7 in PM register 0x55 */
> -		outb(0x55, 0xCD6);
> -		outb(val | 0x80, 0xCD7);
> -	}
> -}
> -DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
> 
> 
