Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1BPTqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 14:46:03 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38592 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1BPTqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 14:46:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qCgMIlD0k+b6O2ZSPgGxW/7G9KLVPtbM8a+mNU/XlsnJjmZ6ayxMYbXaS9RqfXrDUT
         HXDbauY5kdzkxPapzCuOAjyoeLe5FJykWRWxZXOAsAadU3Ai2C4FLzOvRc3L/jF6EhDm
         +Fm77UsMvQBpC9PPG6quBp0MI92PfzoFSr1cI=
Message-ID: <4D5C2974.4070608@garzik.org>
Date: Wed, 16 Feb 2011 14:45:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joerg Dorchain <joerg@dorchain.net>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: [Patch] enable AHCI mode on certain ich chipsets
References: <20110216090548.GQ5778@Redstar.dorchain.net>
In-Reply-To: <20110216090548.GQ5778@Redstar.dorchain.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 04:05 AM, Joerg Dorchain wrote:
> Hello all,
>
> this patch allows to force ICH7/8/9 into AHCI mode.  This is needed
> because some BIOSes do not make AHCI-mode operation available to the
> user.
> As the Intel documentation states that the OS should not carry
> out the operation - the user must force this on the kernel
> commandline using quirk_ich_force_ahci
>
> As this quirk gets called whilst the PCI subsystem is
> walking the PCI bus, we declare this quirk against the LPC
> (device 00:1f.0), so that we can frob 00:1f.2 before the PCI
> code has scanned it.
> Note: the pci id might change due to this (e.g. from 27c4 to 27c5)
>
> For working suspend/resume, the next patch is required, too.
>
> Bye,
>
> Joerg
>
>
> Signed-Off-By: joerg Dorchain<joerg@dorchain.net>
>
> --- linux/drivers/pci/quirks.c.orig	2011-02-04 18:29:03.000000000 +0100
> +++ linux/drivers/pci/quirks.c	2011-02-12 07:07:57.000000000 +0100
> @@ -2684,6 +2684,74 @@
>   DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_HINT, 0x0020, quirk_hotplug_bridge);
>
>   /*
> + * Force ICH7/8/9 into AHCI mode.  This is needed because some
> + * BIOSes do not make AHCI-mode operation available to the user.
> + * As the Intel documentation states that the OS should not carry
> + * out the operation - the user must force this on the kernel
> + * commandline using quirk_ich_force_ahci
> + *
> + * As this quirk gets called whilst the PCI subsystem is
> + * walking the PCI bus, we declare this quirk against the LPC
> + * (device 00:1f.0), so that we can frob 00:1f.2 before the PCI
> + * code has scanned it.
> + * Note: the pci id might change due to this (e.g. from 27c4 to 27c5)
> + *
> + */
> +
> +static bool ich_force_ahci_mode; /* defaults to false */
> +
> +static int __init ich789_force_ahci_mode_setup(char *str)
> +{
> +	ich_force_ahci_mode = true;
> +	return 0;
> +}
> +early_param("quirk_ich_force_ahci", ich789_force_ahci_mode_setup);
> +
> +static void ich789_force_ahci_mode(struct pci_dev *pdev)
> +{
> +	u8 amrval;
> +	u8 sclkgc;
> +	const int ich89_address_map_reg = 0x90;
> +	const int ich89_sata_clock_gen_config_reg = 0x9c;
> +
> +	if (!ich_force_ahci_mode)
> +		return;
> +
> +	/* ICH8 datasheet section 12.1.33 */
> +	if (!pci_bus_read_config_byte(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 2),
> +		ich89_address_map_reg,&amrval)) {
> +
> +		if (amrval&  (BIT(6) | BIT(7))) {
> +			dev_printk(KERN_DEBUG,&pdev->dev,
> +				"ICH7/8/9 SATA controller not in IDE mode.  Not modifying.\n");
> +			return;
> +		}
> +		if (amrval&  (BIT(0) | BIT(1)))
> +			dev_printk(KERN_DEBUG,&pdev->dev,
> +				"ICH7/8/9 in SATA/PATA combined mode.  Untested.\n");
> +		/* AHCI mode */
> +		amrval |= BIT(6);
> +		amrval&= ~BIT(7);
> +		pci_bus_read_config_byte(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 2),
> +			ich89_sata_clock_gen_config_reg,&sclkgc);
> +		dev_printk(KERN_DEBUG,&pdev->dev, "sclkgc is %#0x\n", sclkgc);
> +		pci_bus_write_config_byte(pdev->bus, PCI_DEVFN(PCI_SLOT(pdev->devfn), 2),
> +			ich89_address_map_reg, amrval);
> +		dev_printk(KERN_DEBUG,&pdev->dev, "Forced ICH7/8/9 mode PIIX->AHCI\n");

How is the assignment of the AHCI BAR handled?  Does this happen 
automatically because it's an early fixup?

That is traditionally the stumbling block...

	Jeff


