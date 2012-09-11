Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2IKXYv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:24:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40712 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2IKXYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:24:48 -0400
MIME-Version: 1.0
In-Reply-To: <1344355862-2726-8-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-8-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Sep 2012 17:24:25 -0600
Message-ID: <CAErSpo6Q9s0tqR6=mycXsHi7PoUZRMirZOogDxPNdtEFxw1kKQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 07/22] PCI: introduce PCI bus lock to serialize PCI
 hotplug operations
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

On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
> There are multiple ways to trigger concurrent PCI hotplug operations for
> a specific PCI bus, but we have no way to serialize those PCI hotplug
> operations yet and thus breaks the PCI hotplug logic. This patch introduces
> a bus lock mechanism and state machine for PCI buses to serialize PCI
> hotplug operations.
>
> The state machine for PCI buses is:
>           __________________________     ______________
>           |                        v     |            v
> INITIALIZED->REGISTERED->WORKING->STOPPING->STOPPED->REMOVED->DESTOYED
>                      |_________________________^
>
> The PCI buses is hierarchy, so need to obey the locking rules:
> 1) The PCI bus must be locked when changing any child devices of it.
> 2) The PCI bus must be locked when changing its state
> 3) The global PCI host bridge hotplug lock must be held when hotplugging
>    PCI root buses
>
> The lock interfaces cordinated with the state machine will be used to
> avoid race conditions when hotplugging PCI devices/host bridges.
> A typical usage is (lock bus if it's in WORKING state, and then do hotplug):
> if (pci_bus_lock_states(bus, PCI_BUS_STATE_WORKING) > 0) {
>         do_pci_hotplug();
>         pci_bus_unlock(bus);
> }
>
> The PCI_BUS_LOCK config option is a temporary solution to avoid breaking
> bisect, it will be removed when all Archs have been converted to the new
> PCI bus lock mechanism.

I'm going to wait until I understand the global lock issues better
before I even look at these PCI bus lock patches.

> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/Kconfig |    4 +++
>  drivers/pci/bus.c   |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |   44 ++++++++++++++++++++++++++
>  3 files changed, 134 insertions(+)
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 848bfb8..a6df8b1 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -120,3 +120,7 @@ config PCI_IOAPIC
>  config PCI_LABEL
>         def_bool y if (DMI || ACPI)
>         select NLS
> +
> +config PCI_BUS_LOCK
> +       bool
> +       default n
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 0e18270..aa25fcf 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -15,9 +15,12 @@
>  #include <linux/proc_fs.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> +#include <linux/sched.h>
>
>  #include "pci.h"
>
> +static DECLARE_WAIT_QUEUE_HEAD(pci_bus_state_wait_queue);
> +
>  void pci_add_resource_offset(struct list_head *resources, struct resource *res,
>                              resource_size_t offset)
>  {
> @@ -340,6 +343,89 @@ void pci_bus_put(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_bus_put);
>
> +static bool pci_bus_wait_for_states(struct pci_bus *bus, int states)
> +{
> +       int t = atomic_read(&bus->state);
> +
> +       /* Bus state is bigger than any of the requested states. */
> +       if ((t & PCI_BUS_STATE_MASK) > states)
> +               return true;
> +
> +       /* Bus is in one of the requested states and unlocked. */
> +       if ((t & states) && !(t & PCI_BUS_STATE_LOCK))
> +               return true;
> +
> +       return false;
> +}
> +
> +/*
> + * Wait for the bus to reach one of the requested states and then lock it.
> + * Return current bus state if succeed to lock the bus, and return -EINVAL
> + * if current bus state is already bigger than any of the requested states.
> + */
> +int pci_bus_lock_states(struct pci_bus *bus, int states)
> +{
> +       int t;
> +
> +       BUG_ON(states & ~PCI_BUS_STATE_MASK);
> +       do {
> +               do {
> +                       wait_event(pci_bus_state_wait_queue,
> +                                  pci_bus_wait_for_states(bus, states));
> +                       t = atomic_read(&bus->state);
> +                       if ((t & PCI_BUS_STATE_MASK) > states)
> +                               return -EINVAL;
> +               } while (!(t & states));
> +
> +               t &= ~PCI_BUS_STATE_LOCK;
> +       } while (atomic_cmpxchg(&bus->state, t , t | PCI_BUS_STATE_LOCK) != t);
> +
> +       return t & PCI_BUS_STATE_MASK;
> +}
> +EXPORT_SYMBOL(pci_bus_lock_states);
> +
> +/* Unlock the bus and wake up waiters, must be called with the bus locked. */
> +void pci_bus_unlock(struct pci_bus *bus)
> +{
> +       int t;
> +
> +       BUG_ON(!pci_bus_is_locked(bus));
> +       do {
> +               t = atomic_read(&bus->state);
> +       } while (atomic_cmpxchg(&bus->state,
> +                               t, t & ~PCI_BUS_STATE_LOCK) != t);
> +
> +       if (waitqueue_active(&pci_bus_state_wait_queue))
> +               wake_up_all(&pci_bus_state_wait_queue);
> +}
> +EXPORT_SYMBOL(pci_bus_unlock);
> +
> +/*
> + * Change the bus from old state to new state. It must be called with the bus
> + * locked, and the new state must be bigger than the old state.
> + */
> +void pci_bus_change_state(struct pci_bus *bus, int old, int new, bool unlock)
> +{
> +       int t;
> +
> +       BUG_ON(!pci_bus_is_locked(bus));
> +       BUG_ON(new < old || pci_bus_get_state(bus) != old ||
> +              (new & ~PCI_BUS_STATE_MASK));
> +
> +       old |= PCI_BUS_STATE_LOCK;
> +       if (!unlock)
> +               new |= PCI_BUS_STATE_LOCK;
> +
> +       do {
> +               t = atomic_read(&bus->state);
> +               t &= ~(PCI_BUS_STATE_MASK | PCI_BUS_STATE_LOCK);
> +       } while (atomic_cmpxchg(&bus->state, t | old, t | new) != (t | old));
> +
> +       if (waitqueue_active(&pci_bus_state_wait_queue))
> +               wake_up_all(&pci_bus_state_wait_queue);
> +}
> +EXPORT_SYMBOL(pci_bus_change_state);
> +
>  EXPORT_SYMBOL(pci_bus_alloc_resource);
>  EXPORT_SYMBOL_GPL(pci_bus_add_device);
>  EXPORT_SYMBOL(pci_bus_add_devices);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index e02f130..e2ef517 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -443,8 +443,52 @@ struct pci_bus {
>         struct bin_attribute    *legacy_io; /* legacy I/O for this bus */
>         struct bin_attribute    *legacy_mem; /* legacy mem */
>         unsigned int            is_added:1;
> +       atomic_t                state;
>  };
>
> +/*
> + * State machine for PCI buses.
> + *          __________________________     ______________
> + *          |                        v     |            v
> + * INITIALIZED->REGISTERED->WORKING->STOPPING->STOPPED->REMOVED->DESTOYED
> + *                     |_________________________^
> + */
> +#define        PCI_BUS_STATE_UNKNOWN           0x0     /* invalid state */
> +#define        PCI_BUS_STATE_INITIALIZED       0x1     /* device_initialize called */
> +#define        PCI_BUS_STATE_REGISTERED        0x2     /* device_add called */
> +#define        PCI_BUS_STATE_WORKING           0x4     /* working state */
> +#define        PCI_BUS_STATE_STOPPING          0x8     /* stopping devices */
> +#define        PCI_BUS_STATE_STOPPED           0x10    /* device_del called */
> +#define        PCI_BUS_STATE_REMOVED           0x20    /* bus deleted  */
> +#define        PCI_BUS_STATE_DESTROYED         0x40    /* invalid state */
> +#define        PCI_BUS_STATE_MASK              0x7F
> +
> +#ifdef CONFIG_PCI_BUS_LOCK
> +#define        PCI_BUS_STATE_LOCK              0x10000 /* for pci core only */
> +
> +static inline bool pci_bus_is_locked(struct pci_bus *bus)
> +{
> +       return !!(atomic_read(&bus->state) & PCI_BUS_STATE_LOCK);
> +}
> +#else /* CONFIG_PCI_BUS_LOCK */
> +#define        PCI_BUS_STATE_LOCK              0x0000  /* for pci core only */
> +
> +static inline bool pci_bus_is_locked(struct pci_bus *bus)
> +{
> +       return true;
> +}
> +#endif /* CONFIG_PCI_BUS_LOCK */
> +
> +static inline int pci_bus_get_state(struct pci_bus *bus)
> +{
> +       return atomic_read(&bus->state) & PCI_BUS_STATE_MASK;
> +}
> +
> +extern int pci_bus_lock_states(struct pci_bus *bus, int states);
> +extern void pci_bus_unlock(struct pci_bus *bus);
> +extern void pci_bus_change_state(struct pci_bus *bus, int new, int old,
> +                                bool unlock);
> +
>  #define pci_bus_b(n)   list_entry(n, struct pci_bus, node)
>  #define to_pci_bus(n)  container_of(n, struct pci_bus, dev)
>
> --
> 1.7.9.5
>
