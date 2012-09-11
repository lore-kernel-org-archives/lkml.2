Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab2IKXWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:22:10 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43456 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654Ab2IKXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <1344355862-2726-22-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-22-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Sep 2012 17:21:43 -0600
Message-ID: <CAErSpo4ubTSu5cSrLVfs5UHc44KgtzO_OxL_QganfhqYn2hUWQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 21/22] PCI: cleanups for PCI bus lock implementation
To: Jiang Liu <liuj97@gmail.com>
Cc: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:11 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Now all Archs have been converted to the new PCI bus lock mechanism,
> so clean up unused code.

When you say "all arches," do you really mean "x86 and ia64"?  I
assume all the other architectures have similar issues.  Or is this
somehow ACPI-specific?

> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/Kconfig     |    3 ---
>  drivers/pci/bus.c       |    1 -
>  drivers/pci/pci-sysfs.c |    9 ---------
>  drivers/pci/probe.c     |    4 +---
>  include/linux/pci.h     |   10 ----------
>  5 files changed, 1 insertion(+), 26 deletions(-)
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 5a796c0..848bfb8 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -120,6 +120,3 @@ config PCI_IOAPIC
>  config PCI_LABEL
>         def_bool y if (DMI || ACPI)
>         select NLS
> -
> -config PCI_BUS_LOCK
> -       def_bool y if (X86 || IA64)
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 371f20a..308c376 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -196,7 +196,6 @@ int pci_bus_add_child(struct pci_bus *bus)
>                         pci_create_legacy_files(bus);
>                         pci_bus_change_state(bus, PCI_BUS_STATE_INITIALIZED,
>                                         PCI_BUS_STATE_WORKING, false);
> -                       bus->is_added = 1;
>                 }
>         }
>
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index 11043b4..a5a4195 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -284,7 +284,6 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
>  }
>
>  #ifdef CONFIG_HOTPLUG
> -static DEFINE_MUTEX(pci_remove_rescan_mutex);
>  static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>                                 size_t count)
>  {
> @@ -296,13 +295,11 @@ static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
>
>         if (val) {
>                 pci_host_bridge_hotplug_lock();
> -               mutex_lock(&pci_remove_rescan_mutex);
>                 while ((b = pci_find_next_bus(b)) != NULL)
>                         if (pci_bus_lock_states(b, PCI_BUS_STATE_WORKING) > 0) {
>                                 pci_rescan_bus(b);
>                                 pci_bus_unlock(b);
>                         }
> -               mutex_unlock(&pci_remove_rescan_mutex);
>                 pci_host_bridge_hotplug_unlock();
>         }
>         return count;
> @@ -326,13 +323,11 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>         if (val) {
>                 struct pci_bus *bus = pdev->bus;
>
> -               mutex_lock(&pci_remove_rescan_mutex);
>                 if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
>                         if (pdev->is_added)
>                                 pci_rescan_bus(bus);
>                         pci_bus_unlock(bus);
>                 }
> -               mutex_unlock(&pci_remove_rescan_mutex);
>         }
>         return count;
>  }
> @@ -342,13 +337,11 @@ static void remove_callback(struct device *dev)
>         struct pci_dev *pdev = to_pci_dev(dev);
>         struct pci_bus *bus = pdev->bus;
>
> -       mutex_lock(&pci_remove_rescan_mutex);
>         if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
>                 pci_bus_get(bus);
>                 pci_stop_and_remove_bus_device(pdev);
>                 pci_unlock_and_put_bus(bus);
>         }
> -       mutex_unlock(&pci_remove_rescan_mutex);
>  }
>
>  static ssize_t
> @@ -382,14 +375,12 @@ dev_bus_rescan_store(struct device *dev, struct device_attribute *attr,
>                 return -EINVAL;
>
>         if (val) {
> -               mutex_lock(&pci_remove_rescan_mutex);
>                 if (!pci_is_root_bus(bus))
>                         pci_rescan_bus_bridge_resize(bus->self);
>                 else if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
>                         pci_rescan_bus(bus);
>                         pci_bus_unlock(bus);
>                 }
> -               mutex_unlock(&pci_remove_rescan_mutex);
>         }
>         return count;
>  }
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index da6f04c..09517c3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1626,11 +1626,9 @@ unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
>         if (pci_bus_get_state(bus) < PCI_BUS_STATE_WORKING) {
>                 dev_dbg(&bus->dev, "fixups for bus\n");
>                 pcibios_fixup_bus(bus);
> -               if (pci_is_root_bus(bus)) {
> +               if (pci_is_root_bus(bus))
>                         pci_bus_change_state(bus, PCI_BUS_STATE_REGISTERED,
>                                              PCI_BUS_STATE_WORKING, false);
> -                       bus->is_added = 1;
> -               }
>         }
>
>         for (pass=0; pass < 2; pass++)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9e52e88..0e50ec8 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -442,7 +442,6 @@ struct pci_bus {
>         struct device           dev;
>         struct bin_attribute    *legacy_io; /* legacy I/O for this bus */
>         struct bin_attribute    *legacy_mem; /* legacy mem */
> -       unsigned int            is_added:1;
>         atomic_t                state;
>  };
>
> @@ -463,21 +462,12 @@ struct pci_bus {
>  #define        PCI_BUS_STATE_DESTROYED         0x40    /* invalid state */
>  #define        PCI_BUS_STATE_MASK              0x7F
>
> -#ifdef CONFIG_PCI_BUS_LOCK
>  #define        PCI_BUS_STATE_LOCK              0x10000 /* for pci core only */
>
>  static inline bool pci_bus_is_locked(struct pci_bus *bus)
>  {
>         return !!(atomic_read(&bus->state) & PCI_BUS_STATE_LOCK);
>  }
> -#else /* CONFIG_PCI_BUS_LOCK */
> -#define        PCI_BUS_STATE_LOCK              0x0000  /* for pci core only */
> -
> -static inline bool pci_bus_is_locked(struct pci_bus *bus)
> -{
> -       return true;
> -}
> -#endif /* CONFIG_PCI_BUS_LOCK */
>
>  static inline int pci_bus_get_state(struct pci_bus *bus)
>  {
> --
> 1.7.9.5
>
