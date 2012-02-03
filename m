Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2BCQgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:36:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52816 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2BCQgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:36:23 -0500
MIME-Version: 1.0
In-Reply-To: <1328136242-17725-3-git-send-email-yinghai@kernel.org>
References: <1328136242-17725-1-git-send-email-yinghai@kernel.org> <1328136242-17725-3-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 3 Feb 2012 08:36:02 -0800
Message-ID: <CAErSpo44bef-Vj4LPB0QJ8HRjWxqRFK_=kpMq8hYEe=4t58zGQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] PCI: Add iobusn_resource
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

On Wed, Feb 1, 2012 at 2:43 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> also add busn_res into struct pci_bus.
>
> will use them to have bus number resource tree.

Will you make this tree visible in /proc?  Seems like that would be
useful for debugging and for symmetry with /proc/iomem and
/proc/ioports.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
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

Is this different from bus.secondary and bus.subordinate?  Do we need
both busn_res and secondary/subordinate?  If we need both, in what
circumstance with they contain different information?

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
> +EXPORT_SYMBOL(iobusn_resource);
> +
>  /* constraints to be met while allocating resources */
>  struct resource_constraint {
>        resource_size_t min, max, align;
> --
> 1.7.7
>
