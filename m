Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2CPTgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:36:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58546 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757307Ab2CPTgp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:36:45 -0400
MIME-Version: 1.0
In-Reply-To: <1330570837-26638-29-git-send-email-yinghai@kernel.org>
References: <1330570837-26638-1-git-send-email-yinghai@kernel.org> <1330570837-26638-29-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 16 Mar 2012 13:36:23 -0600
Message-ID: <CAErSpo7JS6N3XzVm=_A-oFF_VpmuQaAG_KagxAOEzpEPnhRP_g@mail.gmail.com>
Subject: Re: [PATCH 28/36] PCI: Add pci_bus_extend/shrink_top()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 8:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> extend or shrink bus and parent buses top (subordinate)
>
> extended range is verified safe range, and stop at recorded parent_res.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 1c07aba..96259f8 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -655,6 +655,42 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
>        }
>  }
>
> +static void __devinit pci_bus_update_top(struct pci_bus *parent,
> +                long size, struct resource *parent_res)
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

I've objected to this before on the grounds that it's not safe to
update res->end because res is already linked into the resource tree,
but I just noticed another problem.

Tree updates are protected by resource_lock, but we don't hold that
here.  I'm sure you "know" that this update can't race with any other
conflicting resource operations, but its safety certainly is not
obvious from the patch.

I think a better implementation would be to add something like
"resource_extend()" that could live in kernel/resource.c so it could
do the appropriate locking and checking.  Such an interface could also
be independent of the resource type, which may be useful when doing
mem/io resource reassignment.

This patch is already in Jesse's linux-next branch (commit
c901d4c0407), so I'm leaving it up to you and Jesse to figure out
what, if anything, to do about this.

Bjorn

> +               parent->subordinate += size;
> +               pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS,
> +                                        parent->subordinate);
> +               dev_printk(KERN_DEBUG, &parent->dev,
> +                               "busn_res: %s %02lx to %pR\n",
> +                               (size > 0) ? "extended" : "shrunk",
> +                               abs(size), res);
> +               parent = parent->parent;
> +       }
> +}
> +
> +static void __devinit pci_bus_extend_top(struct pci_bus *parent,
> +                long size, struct resource *parent_res)
> +{
> +       pci_bus_update_top(parent, size, parent_res);
> +}
> +
> +static void __devinit pci_bus_shrink_top(struct pci_bus *parent,
> +                long size, struct resource *parent_res)
> +{
> +       pci_bus_update_top(parent, -size, parent_res);
> +}
> +
>  /*
>  * If it's a bridge, configure it and scan the bus behind it.
>  * For CardBus bridges, we don't scan behind as the devices will
> --
> 1.7.7
>
