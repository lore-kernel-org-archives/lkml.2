Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2BFStV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 13:49:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60989 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab2BFStR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 13:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <1328425088-6562-2-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org> <1328425088-6562-2-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 6 Feb 2012 10:48:56 -0800
Message-ID: <CAErSpo4HJH+3EQAWowyVxZFa5jVy1EOo=SoybJqqcjhVdo0nzw@mail.gmail.com>
Subject: Re: [PATCH 01/24] PCI: Add iobusn_resource
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 10:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> also add busn_res into struct pci_bus.
>
> will use them to have bus number resource tree.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/ioport.h |    1 +
>  include/linux/pci.h    |    1 +
>  kernel/resource.c      |    8 ++++++++
>  3 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index e885ba2..6fe9e19 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -136,6 +136,7 @@ struct resource {
>  /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
>  extern struct resource ioport_resource;
>  extern struct resource iomem_resource;
> +extern struct resource iobusn_resource;
>
>  extern struct resource *request_resource_conflict(struct resource *root, struct resource *new);
>  extern int request_resource(struct resource *root, struct resource *new);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index f8caaab..94ad468 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -419,6 +419,7 @@ struct pci_bus {
>        struct list_head slots;         /* list of slots on this bus */
>        struct resource *resource[PCI_BRIDGE_RESOURCE_NUM];
>        struct list_head resources;     /* address space routed to this bus */
> +       struct resource busn_res;       /* track registered bus num range */
>
>        struct pci_ops  *ops;           /* configuration access functions */
>        void            *sysdata;       /* hook for sys-specific extension */
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 7640b3a..53b42f0 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -38,6 +38,14 @@ struct resource iomem_resource = {
>  };
>  EXPORT_SYMBOL(iomem_resource);
>
> +struct resource iobusn_resource = {
> +       .name   = "PCI busn",
> +       .start  = 0,
> +       .end    = 0xffffff,
> +       .flags  = IORESOURCE_BUS,
> +};

I'm not sure this should be global.  iomem_resource and
ioport_resource *are* really global, because they refer to processor
address space that is the same for everybody.  But PCI bus numbers are
specific to PCI.  Some machines don't have PCI at all, and there are
different bus architectures to which this doesn't apply.

The 0-0xffffff range is misleading because it includes both the domain
and the bus number, and it's meaningless to allocate ranges that cross
domain boundaries.  For example, [bus 0x0000f0-0x000120] includes bus
numbers from domain 0000 and domain 0001, which doesn't make any sense
because a bus can only be in one domain.

I think it would make more sense to keep this bus number resource in a
per-host bridge structure.  Then we wouldn't need to include the
domain number at all because the host bridge determines the domain.

> +EXPORT_SYMBOL(iobusn_resource);
> +
>  /* constraints to be met while allocating resources */
>  struct resource_constraint {
>        resource_size_t min, max, align;
> --
> 1.7.7
>
