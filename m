Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0INLiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 07:38:55 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:51796 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab0INLiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 07:38:54 -0400
Message-ID: <f041c95ed553edce2bb319fd31a9dc5402863437@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <201009131716.18197.bjorn.helgaas@hp.com>
References: <de55082de958760245f23930b79ab42b7c54c838@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
    <201009131716.18197.bjorn.helgaas@hp.com>
Date: Tue, 14 Sep 2010 12:38:49 +0100
Subject: Re: GA-MA69VM-S2 requires pci=nocrs with 2.6.35.4
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Bjorn Helgaas" <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, "Jordan Crouse" <jordan.crouse@amd.com>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, September 14, 2010 00:16, Bjorn Helgaas wrote:
> On Thursday, September 09, 2010 06:16:33 am Simon Arlott wrote:
>> With a Gigabyte GA-MA69VM-S2 690V motherboard, it stalls in
>> qurk_usb_early_handoff unless pci=nocrs is used:
>
> Huh.  It looks like the HPET appears as a PCI device, in addition to
> being described in the HPET table (and possibly in the ACPI namespace):
>
> [    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> [    0.454232] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.461348] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
> [    0.468004] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
> [    0.474004] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
> [    0.481004] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
> [    0.489004] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xfebfffff]
> [    1.034049] pci 0000:00:14.0: no compatible bridge window for [mem 0xfed00000-0xfed003ff]
> [    1.651998] pci 0000:00:14.0: BAR 1: assigned [mem 0x80000000-0x800003ff]
>
> Since the 00:14.0 BAR looks invalid (it's outside all the host bridge
> windows), we moved it to 0x80000000, and that probably broke the HPET
> driver, which still thinks it's at 0xfed00000.
>
> I've heard about this problem, but I haven't ever looked into it in
> detail.  The best way to handle this would be to figure out why Windows
> doesn't have this problem, since it also moves PCI devices in this
> situation.

You're assuming Windows works on this hardware.

> Simon, if you have a way to boot Windows, the output of Everest (free
> trial at http://www.lavalys.com/) would be a great help.

Windows would take too long to install to try this.

> I can see from the stalled.txt log that we did call sb600_disable_hpet_bar(),
> and it *looks* like that should have disabled BAR 1.  But apparently it
> didn't.  Would you mind collecting another log with the patch below?

Whenever I next need to reboot, I can try the patch, but that won't be soon...

> Bjorn
>
>
> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index 6dd8955..f793efd 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -510,6 +510,7 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
>  	 */
>
>  	pci_read_config_byte(dev, 0x08, &val);
> +	dev_info(&dev->dev, "read %#02x\n", val);
>
>  	if (val < 0x2F) {
>  		outb(0x55, 0xCD6);
> @@ -517,7 +518,9 @@ static void sb600_disable_hpet_bar(struct pci_dev *dev)
>
>  		/* Set bit 7 in PM register 0x55 */
>  		outb(0x55, 0xCD6);
> -		outb(val | 0x80, 0xCD7);
> +		outb(val | 0x7f, 0xCD7);

?

> +		dev_info(&dev->dev, "disabled BAR 1 (%pR)\n",
> +			 &dev->resource[1]);
>  	}
>  }
>  DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_ATI, 0x4385, sb600_disable_hpet_bar);
>


-- 
Simon Arlott
