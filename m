Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab2CHAEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:04:04 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51873 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758585Ab2CHAEB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-17-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org> <1331018040-30725-17-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Mar 2012 17:03:39 -0700
Message-ID: <CAErSpo59kzBL1ApWuWWcymd9UR3m3vB3zkUoJezn66As+-97dQ@mail.gmail.com>
Subject: Re: [PATCH 16/23] PCI: add pci bus removal through /sys/.../pci_bus/.../remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> it supports both pci root bus and pci bus under pci bridge.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-doc@vger.kernel.org
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++++
>  drivers/pci/pci-sysfs.c                 |   28 ++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
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

Is this the interface we want?  It seems like the ultimate goal is to
remove the *host bridge*, i.e., the PNP0A08 device on x86.  If that's
the case, the logical thing seems like a
/sys/bus/acpi/devices/PNP0A08:00/remove file.

All the current "remove" attributes are for *devices*, e.g.,
/sys/devices/pci0000:00/0000:00:03.0/remove, not for *buses*.

I'm not sure it makes sense to talk about removing a "bus" and leaving
the upstream bridge (either a host bridge or a P2P bridge).  I think
it'd make more sense to remove the bridge itself, which would of
course have the consequence of removing the secondary bus.

> +               Depends on CONFIG_HOTPLUG.
> +
>  What:          /sys/bus/pci/devices/.../pci_bus/.../rescan
>  Date:          May 2011
>  Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 1794508..f855b4b 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -385,6 +385,33 @@ remove_store(struct device *dev, struct device_attribute *dummy,
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
> +       int ret = 0;
> +       unsigned long val;
> +
> +       if (kstrtoul(buf, 0, &val) < 0)
> +               return -EINVAL;
> +
> +       if (val)
> +               ret = device_schedule_callback(dev, bus_remove_callback);
> +
> +       if (ret)
> +               count = ret;
> +
> +       return count;
> +}
> +
>  static void bus_rescan_callback(struct device *dev)
>  {
>        struct pci_bus *bus = to_pci_bus(dev);
> @@ -444,6 +471,7 @@ struct device_attribute pci_dev_attrs[] = {
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
