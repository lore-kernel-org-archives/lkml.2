Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2HOTP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:15:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64793 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2HOTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:15:24 -0400
MIME-Version: 1.0
In-Reply-To: <201208122326.07318.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1208110959320.21252-100000@netrider.rowland.org>
 <201208112356.26719.rjw@sisk.pl> <201208122326.07318.rjw@sisk.pl>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Aug 2012 13:15:02 -0600
Message-ID: <CAErSpo7XZZ=ehzSx256aL8FomDX8AjR2jYsa-y5K+9QGGHghKA@mail.gmail.com>
Subject: Re: [PATCH] PCI: EHCI: fix crash during hibernation on ASUS computers
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        AceLan Kao <acelan.kao@canonical.com>, alex.hung@canonical.com,
        Oleksij Rempel <bug-track@fisher-privat.net>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        linux-pci@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 3:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Commit dbf0e4c (PCI: EHCI: fix crash during suspend on ASUS
> computers) added a workaround for an ASUS suspend issue related to
> USB EHCI and a bug in a number of ASUS BIOSes that attemt to shut
> down the EHCI controller during system suspend if its PCI command
> register doesn't contain 0 at that time.
>
> It turns out that the same workaround is necessary in the analogous
> hibernation code path, so add it.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=45811
> Reported-and-tested-by: Oleksij Rempel <bug-track@fisher-privat.net>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: stable@vger.kernel.org
> ---
>
> Hi Bjorn,
>
> Please push this to Linus ASAP, we need it in 3.6 and -stable.

Applied to my for-linus branch, thanks.  I'll ask Linus to pull it in
a couple days, after it's had a chance in -next.

> ---
>  drivers/pci/pci-driver.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> Index: linux/drivers/pci/pci-driver.c
> ===================================================================
> --- linux.orig/drivers/pci/pci-driver.c
> +++ linux/drivers/pci/pci-driver.c
> @@ -959,6 +959,13 @@ static int pci_pm_poweroff_noirq(struct
>         if (!pci_dev->state_saved && !pci_is_bridge(pci_dev))
>                 pci_prepare_to_sleep(pci_dev);
>
> +       /*
> +        * The reason for doing this here is the same as for the analogous code
> +        * in pci_pm_suspend_noirq().
> +        */
> +       if (pci_dev->class == PCI_CLASS_SERIAL_USB_EHCI)
> +               pci_write_config_word(pci_dev, PCI_COMMAND, 0);
> +
>         return 0;
>  }
>
