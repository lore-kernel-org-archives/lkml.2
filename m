Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2B0RpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:45:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45757 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2B0RpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:45:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.97.196 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330299202-3838-5-git-send-email-yinghai@kernel.org>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org> <1330299202-3838-5-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 10:44:48 -0700
Message-ID: <CAErSpo7XZG3OqpBQMH46ptN9ZnAu9vF0wuNuhKCfQ_xZsNjaMg@mail.gmail.com>
Subject: Re: [PATCH 4/8] PCI: make pci_host_bridge more robust
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 4:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> 1. change pci_host_bridge to find_pci_root_bridge.
> 2. separate find_pci_root_bus().
> 3. on any possible path return NULL.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  drivers/pci/host-bridge.c |   35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
>
> Index: linux-2.6/drivers/pci/host-bridge.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/host-bridge.c
> +++ linux-2.6/drivers/pci/host-bridge.c
> @@ -16,19 +16,31 @@ void add_to_pci_host_bridges(struct pci_
>        list_add_tail(&bridge->list, &pci_host_bridges);
>  }
>
> -static struct pci_host_bridge *pci_host_bridge(struct pci_dev *dev)
> +static struct pci_bus *find_pci_root_bus(struct pci_dev *dev)
>  {
>        struct pci_bus *bus;
> -       struct pci_host_bridge *bridge;
>
>        bus = dev->bus;
>        while (bus->parent)
>                bus = bus->parent;
>
> -       list_for_each_entry(bridge, &pci_host_bridges, list) {
> +       if (!pci_is_root_bus(bus))
> +               return NULL;

pci_is_root_bus() returns "!(pbus->parent)", so the effect of this patch is:

    while (bus->parent)
        bus = bus->parent;

    if (bus->parent)
        return NULL;

The only reason we exited the "while" loop is because "bus->parent ==
NULL", so what's the point of adding the "if" check afterwards?

> +       return bus;
> +}
> +
> +static struct pci_host_bridge *find_pci_host_bridge(struct pci_dev *dev)
> +{
> +       struct pci_bus *bus = find_pci_root_bus(dev);
> +       struct pci_host_bridge *bridge;
> +
> +       if (!bus)
> +               return NULL;

This should never happen.  If there's a way we can create a pci_dev
that's not under a pci_host_bridge, I think that is a bug, and we
should fix that rather than papering over it here.

I don't think we should apply this patch.

Bjorn

> +       list_for_each_entry(bridge, &pci_host_bridges, list)
>                if (bridge->bus == bus)
>                        return bridge;
> -       }
>
>        return NULL;
>  }
> @@ -42,10 +54,13 @@ void __weak pcibios_resource_to_bus(stru
>                                    struct pci_bus_region *region,
>                                    struct resource *res)
>  {
> -       struct pci_host_bridge *bridge = pci_host_bridge(dev);
> +       struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
>        struct pci_host_bridge_window *window;
>        resource_size_t offset = 0;
>
> +       if (!bridge)
> +               goto no_bridge;
> +
>        list_for_each_entry(window, &bridge->windows, list) {
>                if (resource_type(res) != resource_type(window->res))
>                        continue;
> @@ -56,6 +71,7 @@ void __weak pcibios_resource_to_bus(stru
>                }
>        }
>
> +no_bridge:
>        region->start = res->start - offset;
>        region->end = res->end - offset;
>  }
> @@ -70,12 +86,16 @@ static bool region_contains(struct pci_b
>  void __weak pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>                                    struct pci_bus_region *region)
>  {
> -       struct pci_host_bridge *bridge = pci_host_bridge(dev);
> +       struct pci_host_bridge *bridge = find_pci_host_bridge(dev);
>        struct pci_host_bridge_window *window;
> -       struct pci_bus_region bus_region;
>        resource_size_t offset = 0;
>
> +       if (!bridge)
> +               goto no_bridge;
> +
>        list_for_each_entry(window, &bridge->windows, list) {
> +               struct pci_bus_region bus_region;
> +
>                if (resource_type(res) != resource_type(window->res))
>                        continue;
>
> @@ -88,6 +108,7 @@ void __weak pcibios_bus_to_resource(stru
>                }
>        }
>
> +no_bridge:
>        res->start = region->start + offset;
>        res->end = region->end + offset;
>  }
