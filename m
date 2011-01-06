Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1AFTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:25:13 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9129 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab1AFTZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:25:11 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Date: Thu, 6 Jan 2011 12:24:39 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1294327066-23518-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061224.40596.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 06, 2011 08:17:46 am Jiri Slaby wrote:
> There are BIOSes out there where they provide ACPI mapping that
> conflicts with fixed one. Then e.g. an IDE controller doesn't work due
> to I/O space conflict:
> pci 0000:00:1f.1: address space collision: [io  0x0170-0x0177] conflicts with 0000:00:1f.0 [io  0x0100-0x017f]
> 
> 0x0170-0x0177 for IDE controllers is created in pci_setup_device.
> 0x0100-0x017f for the ICH4 ISA bridge is created in quirk_ich4_lpc_acpi

This might be the right thing to do, but it feels hacky to add more
magic numbers (">= 0x180"), so I'd like to understand it better.
(Is there a bugzilla for this?  Is it a regression?  Sounds like an
old machine where we should have seen this before.)

My guess is that we found this "conflict" and tried to move the
controller, but it's hardwired to stay at 0x170 when in compatibility
mode.  So the hardware is really still at 0x170, but Linux thinks it
moved it elsewhere, so it doesn't work.

The fixed IDE resources in pci_setup_device() make sense to me; I
think section 2.1 of the PCI IDE spec justifies specific OS knowledge
of the compatibility mode regions.

But I don't know the quirk_ich4_lpc_acpi() history, and this quirk
is the sort of information the OS should not have to know about.
Theoretically, ACPI tells us about the GPIO/TCO/etc. regions in a
generic way via namespace devices or something in the static tables.
Is that generic information missing, or is it there and Linux is
ignoring it?  If we're ignoring it, I'd rather fix that.

The main reason for claiming I/O regions is to keep us from placing
another device on top of them.  But we've had PCIBIOS_MIN_IO = 0x1000
forever, which should keep us from putting anything below that anyway
(at least for PCI devices).  So there must be some other reason for
claiming space in this quirk.

Bjorn

> The former is fixed, according to specs at that address.
> The latter is read from the bridge confspace which contains:
> 00000000  86 80 a1 25 0f 00 80 02  02 00 01 06 00 00 80 00 |...%............|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
> 00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
> 00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 |................|
> 00000040  01 01 00 00 10 00 00 00  00 00 00 00 00 00 01 00 |................|
> 00000050  00 00 00 00 00 00 00 00  01 05 00 00 10 00 00 00 |................|
> ...
> I.e. 0x00000101 as a base (ORed by 1 meaning I/O space) for ACPI per
> ICH4 specs.
> 
> Don't accept bases below 0x180 for this dynamic mapping.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/pci/quirks.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 53a786f..6d241eb 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -543,7 +543,14 @@ static void __devinit quirk_ich4_lpc_acpi(struct pci_dev *dev)
>  	u32 region;
>  
>  	pci_read_config_dword(dev, 0x40, &region);
> -	quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES, "ICH4 ACPI/GPIO/TCO");
> +	/*
> +	 * some BIOSes are bogus and create this dynamic mapping so that it
> +	 * conflicts with fixed. There is no space below 0x180 for
> +	 * ACPI/GPIO/TCO which is 128B long and 128B aligned.
> +	 */
> +	if (region >= 0x180)
> +		quirk_io_region(dev, region, 128, PCI_BRIDGE_RESOURCES,
> +				"ICH4 ACPI/GPIO/TCO");
>  
>  	pci_read_config_dword(dev, 0x58, &region);
>  	quirk_io_region(dev, region, 64, PCI_BRIDGE_RESOURCES+1, "ICH4 GPIO");
> 
