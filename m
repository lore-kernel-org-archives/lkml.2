Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab2CIAw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:52:27 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38124 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016Ab2CIAwZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:52:25 -0500
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-3-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org> <1331018040-30725-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 8 Mar 2012 17:52:03 -0700
Message-ID: <CAErSpo72gJAPvyvo6EpcuEwqFaZQ_viUrgLAuA0CHttuxXkCXw@mail.gmail.com>
Subject: Re: [PATCH 02/23] PCI, sysfs: create rescan_bridge under
 /sys/.../pci/devices/... for pci bridges
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Current code will create rescan for every pci device under parent bus.
> that is not right. the device is already there, there is no reason to rescan it.
>
> We could have rescan for pci bridges. less confusing.

Yes, but now we have *three* rescan attributes for a single bridge/bus:

    /sys/devices/pci0000:00/0000:00:01.0/pci_bus/0000:01/rescan
    /sys/devices/pci0000:00/0000:00:01.0/rescan_bridge
    /sys/devices/pci0000:00/0000:00:01.0/rescan

and this for an endpoint:

    /sys/devices/pci0000:00/0000:00:05.0/rescan

I think endpoints should not have a "rescan" attribute at all, and
bridges should have only a "rescan" attribute (not "rescan" and
"rescan_bridge").

I'm not sure about "pci_bus/.../rescan".  I know you didn't add that,
but I'm not sure it makes sense to have both that and a "rescan" on
the bridge device.  If we have both, what's the difference between
them?

> Need to move rescan attr to pci dev bridge attribute group.
> And We should rescan bridge's secondary bus instead of primary bus.
>
> -v3: Use device_type for pci dev.
> -v4: Seperate pci device type change out
> -v5: add rescan_bridge for bridge type, and still keep the old rescan.
>        may remove the old rescan later.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |   10 ++++++++++
>  drivers/pci/pci-sysfs.c                 |   24 ++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index 34f5110..95f0f37 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -111,6 +111,16 @@ Description:
>                from this part of the device tree.
>                Depends on CONFIG_HOTPLUG.
>
> +What:          /sys/bus/pci/devices/.../rescan_bridge
> +Date:          February 2012
> +Contact:       Linux PCI developers <linux-pci@vger.kernel.org>
> +Description:
> +               Writing a non-zero value to this attribute will
> +               force a rescan of the bridge and all child buses, and
> +               re-discover devices removed earlier from this part of
> +               the device tree.
> +               Depends on CONFIG_HOTPLUG.
> +
>  What:          /sys/bus/pci/devices/.../reset
>  Date:          July 2009
>  Contact:       Michael S. Tsirkin <mst@redhat.com>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 39d15e6..d5c8ffb 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -325,6 +325,27 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>        return count;
>  }
>
> +static ssize_t
> +dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
> +                const char *buf, size_t count)
> +{
> +       unsigned long val;
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       if (kstrtoul(buf, 0, &val) < 0)
> +               return -EINVAL;
> +
> +       if (val) {
> +               mutex_lock(&pci_remove_rescan_mutex);
> +               pci_rescan_bus(pdev->subordinate);
> +               mutex_unlock(&pci_remove_rescan_mutex);
> +       }
> +       return count;
> +}
> +
> +static struct device_attribute pci_dev_bridge_rescan_attr =
> +       __ATTR(rescan_bridge, (S_IWUSR|S_IWGRP), NULL, dev_bridge_rescan_store);
> +
>  static void remove_callback(struct device *dev)
>  {
>        struct pci_dev *pdev = to_pci_dev(dev);
> @@ -1337,6 +1358,9 @@ static int __init pci_sysfs_init(void)
>  late_initcall(pci_sysfs_init);
>
>  static struct attribute *pci_dev_bridge_attrs[] = {
> +#ifdef CONFIG_HOTPLUG
> +       &pci_dev_bridge_rescan_attr.attr,
> +#endif
>        NULL,
>  };
>
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
