Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668Ab2IZUPR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:15:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46597 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2IZUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <1348243658-5127-1-git-send-email-jiang.liu@huawei.com>
References: <CAErSpo5QwebVypZK21R9_mXaWic0NJqMPzx8vd-FVfTDq9Ui4Q@mail.gmail.com>
 <1348243658-5127-1-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Sep 2012 14:14:51 -0600
Message-ID: <CAErSpo4Wa1s3O3pnt67_KVBEKkV0D-CQhtRX9yCjrnTmoHbN0w@mail.gmail.com>
Subject: Re: [PATCH v4] PCI: introduce two interfaces to walk PCI buses
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 10:07 AM, Jiang Liu <liuj97@gmail.com> wrote:
> The pci_find_next_bus() is not hotplug safe, so introduce PCI hotplug
> safe interfaces to walk PCI buses. To avoid some deadlock scenarios,
> two interfaces are introduced.
>
> The first one is pci_for_each_bus(), which walks all PCI buses holding
> read lock on the pci_bus_sem.
>
> The second one is pci_for_each_started_bus(), which walks all started
> PCI buses without holding any global locks. Started PCI buses are those
> which have been added to the device tree by calling device_add().
> ---
> Hi Bjorn,
>         How about this PCI bus iterator design? It's a little ugly that
> we need to two interfaces to work around some deadlock scenarios.
> And I plan to split the task into two parts:
>         1) a hotplug safe PCI bus iteraror to replace pci_find_next_bus
>         2) handle hotplug notifications to update bus related states.
>
> My patchset at http://www.spinics.net/lists/linux-pci/msg17515.html has
> patially solved issue 2 above for x86/ACPI, and will add more supports
> for other platforms.
>         Thanks!
>         Gerry

I like this interface:

    int pci_for_each_bus(int (* cb)(struct pci_bus *, void *), void *data)

quite a bit because it has the potential for removing all the list
knowledge from the callers, but there are two things I don't like:

  1) The interface would allow the PCI core to call the callback for
future hot-added buses, but your implementation doesn't have that yet.

  2) I'd rather have something like "pci_for_each_dev()"  so this is
device-based instead of bus-based.  The struct pci_bus is of limited
usefulness outside the core, except as a container for a set of
devices.  So the users of pci_for_each_bus() would often iterate
through that set of devices, and given the complications of SR-IOV
virtual buses, I don't think it's really clear how to do that
iteration correctly.

> ---
>  drivers/pci/bus.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    1 +
>  2 files changed, 43 insertions(+)
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index e16a8f0f..21b0ade 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -327,6 +327,48 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>  }
>  EXPORT_SYMBOL_GPL(pci_walk_bus);
>
> +static int pci_bus_iter(struct pci_bus *bus,
> +                       int (* cb)(struct pci_bus *, void *), void *data)
> +{
> +       int rc;
> +
> +       rc = cb(bus, data);
> +       if (rc == 0)
> +               list_for_each_entry(bus, &bus->children, node) {
> +                       rc = pci_bus_iter(bus, cb, data);
> +                       if (rc)
> +                               break;
> +               }
> +
> +       return rc;
> +}
> +
> +/** pci_for_each_bus - walk all PCI buses and call the provided callback.
> + *  @cb   callback to be called for each bus found
> + *  @data arbitrary pointer to be passed to callback.
> + *
> + *  Walk all PCI buses and call the provided callback with pci_bus_sem held.
> + *
> + *  We check the return of @cb each time. If it returns anything
> + *  other than 0, we break out.
> + */
> +int pci_for_each_bus(int (* cb)(struct pci_bus *, void *), void *data)
> +{
> +       int rc = 0;
> +       struct pci_bus *bus;
> +
> +       down_read(&pci_bus_sem);
> +       list_for_each_entry(bus, &pci_root_buses, node) {
> +               rc = pci_bus_iter(bus, cb, data);
> +               if (rc)
> +                       break;
> +       }
> +       up_read(&pci_bus_sem);
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL(pci_for_each_bus);
> +
>  struct pci_bus *pci_bus_get(struct pci_bus *bus)
>  {
>         if (bus)
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 3c5017d..1423a24 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1060,6 +1060,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
>
>  void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
>                   void *userdata);
> +int pci_for_each_bus(int (* cb)(struct pci_bus *, void *), void *data);
>  int pci_cfg_space_size_ext(struct pci_dev *dev);
>  int pci_cfg_space_size(struct pci_dev *dev);
>  unsigned char pci_bus_max_busnr(struct pci_bus *bus);
> --
> 1.7.9.5
>
