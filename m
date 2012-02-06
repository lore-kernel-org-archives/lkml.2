Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab2BFS7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:59:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:59205 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab2BFS7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:59:33 -0500
MIME-Version: 1.0
In-Reply-To: <1328425088-6562-5-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org> <1328425088-6562-5-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 6 Feb 2012 10:59:12 -0800
Message-ID: <CAErSpo6=t1XtdUMBAn7Ag5XNLS3wKueybfrsUzmht6GL9XSGLQ@mail.gmail.com>
Subject: Re: [PATCH 04/24] PCI: Add busn_res operation functions
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 10:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> will use them insert/update busn res in pci_bus
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |    3 +++
>  2 files changed, 45 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index a114173..8d4de5e 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1622,6 +1622,48 @@ err_out:
>        return NULL;
>  }
>
> +void pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
> +{
> +       struct resource *res = &b->busn_res;
> +       struct resource *parent_res = &iobusn_resource;
> +       int ret;
> +
> +       res->start = busn(pci_domain_nr(b), bus);
> +       res->end = busn(pci_domain_nr(b), bus_max);
> +       res->flags = IORESOURCE_BUS;
> +
> +       if (!pci_is_root_bus(b))
> +               parent_res = &b->parent->busn_res;
> +
> +       ret = insert_resource(parent_res, res);
> +
> +       dev_printk(KERN_DEBUG, &b->dev,
> +                       "busn_res: %pR %s inserted under %pR\n",
> +                       res, ret ? "can not be" : "is", parent_res);
> +}
> +
> +void pci_bus_update_busn_res_end(struct pci_bus *b, int bus_max)
> +{
> +       struct resource *res = &b->busn_res;
> +       struct resource old_res = *res;
> +
> +       res->end = busn_update_bus_nr(res->end, bus_max);

I think this design is a mistake.  Here's what you're doing:

  - initialize struct resource (keys are "start" and "end")
  - insert into tree (placed in tree by kernel/resource.c based on
"start" and "end")
  - update "end"

You "know" in this case that the update is safe because the caller has
validated "bus_max."  But that still breaks the kernel/resource.c
encapsulation.  If we change the kernel/resource.c implementation,
this code might break.

I think it would be better to remove the bus resource from the tree,
change its "end," then re-insert it.

> +       dev_printk(KERN_DEBUG, &b->dev,
> +                       "busn_res: %pR end updated to %pR\n",
> +                       &old_res, res);
> +}
> +
> +void pci_bus_release_busn_res(struct pci_bus *b)
> +{
> +       struct resource *res = &b->busn_res;
> +       int ret;
> +
> +       ret = release_resource(res);
> +       dev_printk(KERN_DEBUG, &b->dev,
> +                       "busn_res: %pR %s released\n",
> +                       res, ret ? "can not be" : "is");
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
