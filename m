Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab1KHVie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:38:34 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51377 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1KHVid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <1320719974-3598-7-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com>
	<1320719974-3598-7-git-send-email-ying.huang@intel.com>
Date: Tue, 8 Nov 2011 14:38:32 -0700
Message-ID: <CAL-B5D1z35ReG9dKVBLNkktrJ-c8OVspsCYTUAO16wCK1B_4dA@mail.gmail.com>
Subject: Re: [PATCH 6/9] ACPI, Add RAM mapping support to ACPI atomic IO support
From: Myron Stowe <myron.stowe@gmail.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 7:39 PM, Huang Ying <ying.huang@intel.com> wrote:
> On one of our testing machine, the following EINJ command lines:
>
>  # echo 0x10000000 > param1
>  # echo 0xfffffffffffff000 > param2
>  # echo 0x8 > error_type
>  # echo 1 > error_inject
>
> Will get:
>
>  echo: write error: Input/output error
>
> The EIO comes from:
>
>    rc = apei_exec_pre_map_gars(&trigger_ctx);
>
> The root cause is as follow.  Normally, ACPI atomic IO support is used
> to access IO memory.  But in EINJ of that machine, it is used to
> access RAM to trigger the injected error.  And the ioremap() called by
> apei_exec_pre_map_gars() can not map the RAM.
>
> This patch add RAM mapping support to ACPI atomic IO support to
> satisfy EINJ requirement.
>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/acpi/atomicio.c |   34 ++++++++++++++++++++++++++++++----
>  1 file changed, 30 insertions(+), 4 deletions(-)
>

Hi Huang:

This patch collides with my series to remove atomicio.[ch]:
  https://mail.google.com/mail/?shva=1#label/linux-acpi+list/133805812264a542
and I don't want such functionality to get lost if/when the removal series
is accepted.  I'm interested in working with you, not against you, so would
you like me to do anything with respect to this patch within the osl.c based
mapping routines so this capability would not become lost?

The obvious choices would be for me to post a new patch, copying this
functionality into osl.c's mapping routines, that would apply on top of the
removal series.  Another tact could be for me to do basically the same
thing but within the removal series (by adding this into it, and reposting).
The latter tactic seems like it could be a constant problem if more changes
to atomicio occur during this interim period.  Of course you may have other
ideas here as how to progress.

This type of occurrence, among many others, is a good example of why we
need to get down to just one set of mapping routines as soon as possible.
During this interim period I'll try and monitor the linux-acpi-list
for future such
occurrences but if you could, please try and cc me on any future atomicio
modifications.

Thanks,
 Myron

> --- a/drivers/acpi/atomicio.c
> +++ b/drivers/acpi/atomicio.c
> @@ -32,6 +32,8 @@
>  #include <linux/rculist.h>
>  #include <linux/interrupt.h>
>  #include <linux/slab.h>
> +#include <linux/mm.h>
> +#include <linux/highmem.h>
>  #include <acpi/atomicio.h>
>
>  #define ACPI_PFX "ACPI: "
> @@ -97,6 +99,30 @@ static void __iomem *__acpi_try_ioremap(
>                return NULL;
>  }
>
> +static void __iomem *acpi_map(phys_addr_t pg_off, unsigned long pg_sz)
> +{
> +       unsigned long pfn;
> +
> +       pfn = pg_off >> PAGE_SHIFT;
> +       if (page_is_ram(pfn)) {
> +               if (pg_sz > PAGE_SIZE)
> +                       return NULL;
> +               return (void __iomem __force *)kmap(pfn_to_page(pfn));
> +       } else
> +               return ioremap(pg_off, pg_sz);
> +}
> +
> +static void acpi_unmap(phys_addr_t pg_off, void __iomem *vaddr)
> +{
> +       unsigned long pfn;
> +
> +       pfn = pg_off >> PAGE_SHIFT;
> +       if (page_is_ram(pfn))
> +               kunmap(pfn_to_page(pfn));
> +       else
> +               iounmap(vaddr);
> +}
> +
>  /*
>  * Used to pre-map the specified IO memory area. First try to find
>  * whether the area is already pre-mapped, if it is, increase the
> @@ -119,7 +145,7 @@ static void __iomem *acpi_pre_map(phys_a
>
>        pg_off = paddr & PAGE_MASK;
>        pg_sz = ((paddr + size + PAGE_SIZE - 1) & PAGE_MASK) - pg_off;
> -       vaddr = ioremap(pg_off, pg_sz);
> +       vaddr = acpi_map(pg_off, pg_sz);
>        if (!vaddr)
>                return NULL;
>        map = kmalloc(sizeof(*map), GFP_KERNEL);
> @@ -135,7 +161,7 @@ static void __iomem *acpi_pre_map(phys_a
>        vaddr = __acpi_try_ioremap(paddr, size);
>        if (vaddr) {
>                spin_unlock_irqrestore(&acpi_iomaps_lock, flags);
> -               iounmap(map->vaddr);
> +               acpi_unmap(pg_off, map->vaddr);
>                kfree(map);
>                return vaddr;
>        }
> @@ -144,7 +170,7 @@ static void __iomem *acpi_pre_map(phys_a
>
>        return map->vaddr + (paddr - map->paddr);
>  err_unmap:
> -       iounmap(vaddr);
> +       acpi_unmap(pg_off, vaddr);
>        return NULL;
>  }
>
> @@ -177,7 +203,7 @@ static void acpi_post_unmap(phys_addr_t
>                return;
>
>        synchronize_rcu();
> -       iounmap(map->vaddr);
> +       acpi_unmap(map->paddr, map->vaddr);
>        kfree(map);
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
