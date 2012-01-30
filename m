Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2A3P3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:29:19 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42604 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2A3P3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:29:17 -0500
MIME-Version: 1.0
In-Reply-To: <1327718971-9598-3-git-send-email-yinghai@kernel.org>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org> <1327718971-9598-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Jan 2012 07:28:56 -0800
Message-ID: <CAErSpo7ji9R3azc7Xiu8K-=QXm26w=0oSWmcBh=j8dy=MttEvg@mail.gmail.com>
Subject: Re: [PATCH 02/13] PCI: Add busn_res operation functions
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
> will use them insert/update busn res in pci_bus
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    3 +++
>  2 files changed, 47 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a114173..71261da 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1622,6 +1622,50 @@ err_out:
>        return NULL;
>  }
>
> +void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
> +{
> +       struct resource *res = &b->busn_res;
> +       struct resource *parent_res = &iobusn_resource;
> +       int ret;
> +
> +       res->start = (pci_domain_nr(b) << 8) | bus;
> +       res->end = (pci_domain_nr(b) << 8) | bus_max;
> +       res->flags = IORESOURCE_BUS;
> +
> +       if (!pci_is_root_bus(b))
> +               parent_res = &b->parent->busn_res;
> +
> +       ret = insert_resource(parent_res, res);
> +
> +       dev_printk(KERN_DEBUG, &b->dev,
> +        "busn_res: %06llx-%06llx %s inserted under %06llx-%06llx\n",
> +                       (unsigned long long)res->start,
> +                       (unsigned long long)res->end,
> +                        ret ? "can not be" : "is",
> +                       (unsigned long long)parent_res->start,
> +                       (unsigned long long)parent_res->end);

Please update the %pR implementation so you can use it instead of
having to fiddle around with start/end separately and casts.

> +}
> +
> +void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
> +{
> +       struct resource *res = &b->busn_res;
> +       unsigned long long old_end = res->end;
> +
> +       res->end &= ~0xff;
> +       res->end |= bus_max;

This updates a resource in place, without removing it from the
resource tree and re-inserting it.  Doesn't this make it possible to
corrupt the resource tree?  For example, let's say you have this tree:

    00-3f : host bridge A
      00-1f : P2P bridge B
    40-7f : host bridge C

Now you use pci_bus_update_busn_res_end() to update the resource for
P2P bridge B,  setting its end to 5f.  I think the resource tree is
now corrupted.

> +       dev_printk(KERN_DEBUG, &b->dev,
> +                "busn_res: %06llx-%06llx end updated to %06llx-%06llx\n",
> +                       (unsigned long long)res->start,
> +                       old_end,
> +                       (unsigned long long)res->start,
> +                       (unsigned long long)res->end);
> +}
> +
> +void pci_bus_release_busn_res(struct pci_bus *b)
> +{
> +       release_resource(&b->busn_res);
> +}
> +
>  struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>                struct pci_ops *ops, void *sysdata, struct list_head *resources)
>  {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 94ad468..3da935c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -665,6 +665,9 @@ struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *sysdata);
>  struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>                                    struct pci_ops *ops, void *sysdata,
>                                    struct list_head *resources);
> +void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
> +void pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
> +void pci_bus_release_busn_res(struct pci_bus *b);
>  struct pci_bus * __devinit pci_scan_root_bus(struct device *parent, int bus,
>                                             struct pci_ops *ops, void *sysdata,
>                                             struct list_head *resources);
> --
> 1.7.7
>
