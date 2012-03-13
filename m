Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab2CMDMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:12:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:46616 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758368Ab2CMDMQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:12:16 -0400
MIME-Version: 1.0
In-Reply-To: <1331362837-10740-22-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-22-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 21:11:55 -0600
Message-ID: <CAErSpo4j31natwy0uFO=DL6Wn+w7fgE4k83o_mKb8KePO0FLDA@mail.gmail.com>
Subject: Re: [PATCH v2 21/37] PCI, ACPI: Make acpi_pci_root_remove remove pci
 root bus too
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> It will call new added pci_stop_and_remove_bus() to stop/remove pci root bus.
>
> Also checking if that pci_root_bus get removed already in bus remove in /sys
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/pci_root.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index 7aff631..b38e347 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -643,10 +643,24 @@ static int acpi_pci_root_remove(struct acpi_device *device, int type)
>  {
>        struct acpi_pci_root *root = acpi_driver_data(device);
>
> +       /* that root bus could be removed already */
> +       if (!pci_find_bus(root->segment, root->secondary.start)) {
> +               dev_printk(KERN_DEBUG, &device->dev,
> +                 "freeing acpi_pci_root, but pci root bus was removed before");
> +               goto out;

I don't think we should handle the root bus separately from the host
bridge, as I mentioned before.  If we handle them together, checks
like this won't be needed.

> +       }
> +
>        device_set_run_wake(root->bus->bridge, false);
>        pci_acpi_remove_bus_pm_notifier(device);
>
> +       dev_printk(KERN_DEBUG, &device->dev,
> +               "freeing acpi_pci_root, will remove pci root bus at first");
> +       pci_stop_and_remove_bus(root->bus);
> +
> +out:
> +       list_del(&root->node);
>        kfree(root);
> +
>        return 0;
>  }
>
> --
> 1.7.7
>
