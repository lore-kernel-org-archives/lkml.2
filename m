Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab2A3Pul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:50:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64499 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2A3Pui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:50:38 -0500
MIME-Version: 1.0
In-Reply-To: <1327718971-9598-9-git-send-email-yinghai@kernel.org>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org> <1327718971-9598-9-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Jan 2012 07:50:17 -0800
Message-ID: <CAErSpo6dihCWme3bgVV0AjHXnKd78BskLVj2LZqHocoAp83h+Q@mail.gmail.com>
Subject: Re: [PATCH 08/13] PCI: Add pci_bus_extend/shrink_top()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> extend or shrink bus and parent buses top (subordinate)
>
> extended range is verified safe range, and stop at recorded parent_res.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 50 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 55404c3..3e62f45 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -624,6 +624,56 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
>        }
>  }
>
> +static void __devinit pci_bus_extend_top(struct pci_bus *parent,
> +                resource_size_t size, struct resource *parent_res)
> +{
> +       struct resource *res;
> +
> +       if (!size)
> +               return;
> +
> +       while (parent) {
> +               res = &parent->busn_res;
> +               if (res == parent_res)
> +                       break;
> +               res->end += size;
> +               parent->subordinate += size;

This makes me nervous for the same reason as
pci_bus_update_busn_res_end() -- we're changing res->end for resources
already in a tree.  How do we know the tree remains consistent?

> +               pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
> +                                        parent->subordinate);
> +               dev_printk(KERN_DEBUG, &parent->dev,
> +                               "busn_res: extended %02llx to %06llx-%06llx\n",
> +                               (unsigned long long)size,
> +                               (unsigned long long)res->start,
> +                               (unsigned long long)res->end);
> +               parent = parent->parent;
> +       }
> +}
> +
> +static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
> +                resource_size_t size, struct resource *parent_res)
> +{
> +       struct resource *res;
> +
> +       if (!size)
> +               return;
> +
> +       while (parent) {
> +               res = &parent->busn_res;
> +               if (res == parent_res)
> +                       break;
> +               res->end -= size;
> +               parent->subordinate -= size;
> +               pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
> +                                        parent->subordinate);
> +               dev_printk(KERN_DEBUG, &parent->dev,
> +                               "busn_res: shrunk %02llx to %06llx-%06llx\n",
> +                               (unsigned long long)size,
> +                               (unsigned long long)res->start,
> +                               (unsigned long long)res->end);
> +               parent = parent->parent;
> +       }
> +}
> +
>  /*
>  * If it's a bridge, configure it and scan the bus behind it.
>  * For CardBus bridges, we don't scan behind as the devices will
> --
> 1.7.7
>
