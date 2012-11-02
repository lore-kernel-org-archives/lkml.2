Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721Ab2KBQxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 12:53:11 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:39748 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760624Ab2KBQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 12:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <1351061654-8339-2-git-send-email-ying.huang@intel.com>
References: <1351061654-8339-1-git-send-email-ying.huang@intel.com> <1351061654-8339-2-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Nov 2012 10:52:45 -0600
Message-ID: <CAErSpo5bKDrfOC86Cxv+0yFiyj1bMgWF=6XuY+DWFjaMBTQC0A@mail.gmail.com>
Subject: Re: [BUGFIX 2/2] PCI/PM: Resume device before shutdown
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> Some actions during shutdown need device to be in D0 state, such as
> MSI shutdown etc, so resume device before shutdown.

Is there a problem report or bugzilla for this issue?  What are the
symptoms by which a user could figure out that he needs this fix?

Should this be put in the stable tree as well?  If so, for v3.6 only?

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/pci/pci-driver.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -398,6 +398,8 @@ static void pci_device_shutdown(struct d
>         struct pci_dev *pci_dev = to_pci_dev(dev);
>         struct pci_driver *drv = pci_dev->driver;
>
> +       pm_runtime_resume(dev);
> +
>         if (drv && drv->shutdown)
>                 drv->shutdown(pci_dev);
>         pci_msi_shutdown(pci_dev);
> @@ -408,16 +410,6 @@ static void pci_device_shutdown(struct d
>          * continue to do DMA
>          */
>         pci_disable_device(pci_dev);
> -
> -       /*
> -        * Devices may be enabled to wake up by runtime PM, but they need not
> -        * be supposed to wake up the system from its "power off" state (e.g.
> -        * ACPI S5).  Therefore disable wakeup for all devices that aren't
> -        * supposed to wake up the system at this point.  The state argument
> -        * will be ignored by pci_enable_wake().
> -        */
> -       if (!device_may_wakeup(dev))
> -               pci_enable_wake(pci_dev, PCI_UNKNOWN, false);
>  }
>
>  #ifdef CONFIG_PM
