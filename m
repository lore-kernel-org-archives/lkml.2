Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964836Ab2KUUpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:45:38 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:58843 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964771Ab2KUUph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:45:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] acpi: Fix logging when no pci_irq is allocated
Date: Wed, 21 Nov 2012 21:50:05 +0100
Message-ID: <1483298.SPL34HcZVJ@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353505564.24807.12.camel@joe-AO722>
References: <1353487401-10279-1-git-send-email-daniel@numascale-asia.com> <1353505564.24807.12.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 21, 2012 05:46:04 AM Joe Perches wrote:
> On Wed, 2012-11-21 at 16:43 +0800, Daniel J Blueman wrote:
> > Previously a new line is implicitly added in the no GSI case:
> > 
> > [    7.185182] pci 0001:00:12.0: can't derive routing for PCI INT A
> > [    7.191352] pci 0001:00:12.0: PCI INT A: no GSI
> > [    7.195956]  - using ISA IRQ 10
> > 
> > The code thus prints a blank line where no legacy IRQ is available:
> > 
> > [    1.650124] pci 0000:00:14.0: can't derive routing for PCI INT A
> > [    1.650126] pci 0000:00:14.0: PCI INT A: no GSI
> > [    1.650126] 
> > [    1.650180] pci 0000:00:14.0: can't derive routing for PCI INT A
> > 
> > Fix this by making the newline explicit and removing the superfluous
> > one.
> 
> This breaks the logging code below it when there is an ISA irq.
> 
> The below works, but is a workaround for a defect in the printk
> subsystem introduced by a logging change that will be fixed in
> a near future release.

What exactly do you mean by "near future"?

Rafael


> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/acpi/pci_irq.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index f288e00..68a921d 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -458,19 +458,19 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>  	 */
>  	if (gsi < 0) {
>  		u32 dev_gsi;
> -		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
>  		/* Interrupt Line values above 0xF are forbidden */
>  		if (dev->irq > 0 && (dev->irq <= 0xF) &&
>  		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
> -			printk(" - using ISA IRQ %d\n", dev->irq);
> +			dev_warn(&dev->dev, "PCI INT %c: no GSI - using ISA IRQ %d\n",
> +				 pin_name(pin), dev->irq);
>  			acpi_register_gsi(&dev->dev, dev_gsi,
>  					  ACPI_LEVEL_SENSITIVE,
>  					  ACPI_ACTIVE_LOW);
> -			return 0;
>  		} else {
> -			printk("\n");
> -			return 0;
> +			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
> +				 pin_name(pin));
>  		}
> +		return 0;
>  	}
>  
>  	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
