Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab2CIA4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:56:53 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49079 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759342Ab2CIA4r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:56:47 -0500
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-7-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org> <1331018040-30725-7-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 8 Mar 2012 17:56:25 -0700
Message-ID: <CAErSpo4ynKbMWUUo2QdVr6fbRYoexSXpQrgYbE+AXhXgg5yzvA@mail.gmail.com>
Subject: Re: [PATCH 06/23] PCI: rescan with bus or bridge using callback
 method too
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Just like removal.
>
> Because We could add new bus under the bridges...
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/pci-sysfs.c |   43 +++++++++++++++++++++++++++++++------------
>  1 files changed, 31 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 2049b2f..1794508 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -325,21 +325,31 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>        return count;
>  }
>
> +static void bridge_rescan_callback(struct device *dev)
> +{
> +       struct pci_dev *pdev = to_pci_dev(dev);
> +
> +       mutex_lock(&pci_remove_rescan_mutex);
> +       pci_rescan_bus_bridge_resize(pdev);
> +       mutex_unlock(&pci_remove_rescan_mutex);
> +}
> +
>  static ssize_t
>  dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
>                 const char *buf, size_t count)
>  {
> +       int ret = 0;
>        unsigned long val;
> -       struct pci_dev *pdev = to_pci_dev(dev);
>
>        if (kstrtoul(buf, 0, &val) < 0)
>                return -EINVAL;
>
> -       if (val) {
> -               mutex_lock(&pci_remove_rescan_mutex);
> -               pci_rescan_bus_bridge_resize(pdev);
> -               mutex_unlock(&pci_remove_rescan_mutex);
> -       }
> +       if (val)
> +               ret = device_schedule_callback(dev, bridge_rescan_callback);
> +
> +       if (ret)
> +               count = ret;
> +
>        return count;

I see that you copied this style from remove_store(), but it's ugly
and hard to follow.  I think this would be more readable:

    if (!val)
        return count;

    err = device_schedule_callback(dev, bridge_rescan_callback);
    if (err)
        return err;

    return count;

>  }
>
> @@ -375,21 +385,30 @@ remove_store(struct device *dev, struct device_attribute *dummy,
>        return count;
>  }
>
> +static void bus_rescan_callback(struct device *dev)
> +{
> +       struct pci_bus *bus = to_pci_bus(dev);
> +
> +       mutex_lock(&pci_remove_rescan_mutex);
> +       pci_rescan_bus(bus);
> +       mutex_unlock(&pci_remove_rescan_mutex);
> +}
>  static ssize_t
>  dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
>                 const char *buf, size_t count)
>  {
> +       int ret = 0;
>        unsigned long val;
> -       struct pci_bus *bus = to_pci_bus(dev);
>
>        if (strict_strtoul(buf, 0, &val) < 0)
>                return -EINVAL;
>
> -       if (val) {
> -               mutex_lock(&pci_remove_rescan_mutex);
> -               pci_rescan_bus(bus);
> -               mutex_unlock(&pci_remove_rescan_mutex);
> -       }
> +       if (val)
> +               ret = device_schedule_callback(dev, bus_rescan_callback);
> +
> +       if (ret)
> +               count = ret;
> +
>        return count;
>  }
>
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
