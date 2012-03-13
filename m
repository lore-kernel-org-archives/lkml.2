Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759461Ab2CMDK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 23:10:26 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63699 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756715Ab2CMDKY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 23:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <1331362837-10740-21-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org> <1331362837-10740-21-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Mar 2012 21:10:02 -0600
Message-ID: <CAErSpo5WKLf4C_f+roqDtbvs0vU_qTKp6OZ83AXXZggPrynt2A@mail.gmail.com>
Subject: Re: [PATCH v2 20/37] PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 12:00 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> it supports both pci root bus and pci bus under pci bridge.
>
> -v2: Change to three returns way in dev_bus_remove_store.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
>  drivers/pci/pci-sysfs.c                 |   30 ++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 95f0f37..22392de 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -92,6 +92,14 @@ Description:
>                hot-remove the PCI device and any of its children.
>                Depends on CONFIG_HOTPLUG.
>
> +What:          /sys/bus/pci/devices/.../pci_bus/.../remove
> +Date:          March 2012
> +Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
> +Description:
> +               Writing a non-zero value to this attribute will
> +               hot-remove the PCI bus and any of its children.
> +               Depends on CONFIG_HOTPLUG.

I don't think this interface makes sense.  This stops every device on
the bus, removes the bus, unregisters the host bridge device if we're
removing a root bus.

I think we should just have a "remove *bridge*" interface.  It makes
no sense to me to remove a bus but leave the bridge, and it makes the
code quite complicated.

The point of hotplug is to add and remove devices.  We'll get
interrupts saying "please remove this device" or "please rescan the
bus behind this bridge because something might have changed."

If we're removing a host bridge, the platform, e.g., ACPI, will tell
us about the bridge that is going away.  The notification is attached
to the *bridge*, not the bus it leads to.

The expected mechanism on x86 is an SCI from the platform, but if we
need a sysfs way to start host bridge removal, I think it should be
something like this:

    echo 1 > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/remove

That corresponds to the way ACPI works, and it corresponds to the way
we manually remove PCI devices.

>  What:          /sys/bus/pci/devices/.../pci_bus/.../rescan
>  Date:          May 2011
>  Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 4697afe..4d122cb 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -388,6 +388,35 @@ remove_store(struct device *dev, struct device_attribute *dummy,
>        return count;
>  }
>
> +static void bus_remove_callback(struct device *dev)
> +{
> +       struct pci_bus *bus = to_pci_bus(dev);
> +
> +       mutex_lock(&pci_remove_rescan_mutex);
> +       pci_stop_and_remove_bus(bus);
> +       mutex_unlock(&pci_remove_rescan_mutex);
> +}
> +static ssize_t
> +dev_bus_remove_store(struct device *dev, struct device_attribute *attr,
> +                const char *buf, size_t count)
> +{
> +       int err;
> +       unsigned long val;
> +
> +       if (kstrtoul(buf, 0, &val) < 0)
> +               return -EINVAL;
> +
> +       if (!val)
> +               return count;
> +
> +       err = device_schedule_callback(dev, bus_remove_callback);
> +
> +       if (err)
> +               return err;
> +
> +       return count;
> +}
> +
>  static void bus_rescan_callback(struct device *dev)
>  {
>        struct pci_bus *bus = to_pci_bus(dev);
> @@ -447,6 +476,7 @@ struct device_attribute pci_dev_attrs[] = {
>  struct device_attribute pcibus_dev_attrs[] = {
>  #ifdef CONFIG_HOTPLUG
>        __ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, dev_bus_rescan_store),
> +       __ATTR(remove, (S_IWUSR|S_IWGRP), NULL, dev_bus_remove_store),
>  #endif
>        __ATTR(cpuaffinity, S_IRUGO, pci_bus_show_cpumaskaffinity, NULL),
>        __ATTR(cpulistaffinity, S_IRUGO, pci_bus_show_cpulistaffinity, NULL),
> --
> 1.7.7
>
