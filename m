Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2AUPFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:05:05 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64358 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab2AUPFC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:05:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120121021330.14723.72537.stgit@amt.stowe>
References: <20120121021318.14723.45698.stgit@amt.stowe> <20120121021330.14723.72537.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 21 Jan 2012 08:04:39 -0700
Message-ID: <CAErSpo5KDxkcMn3OrvujeSHhzF7PjG0hsYqMXe1HmpPJaLHvDg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ACPI, APEI: Add RAM mapping support to ACPI
To: Myron Stowe <myron.stowe@redhat.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl,
        ying.huang@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 7:13 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> From: Myron Stowe <mstowe@redhat.com>
>
> This patch adds support for RAM to ACPI's mapping capabilities in order
> to support APEI error injection (EINJ) actions.
>
> This patch re-factors similar functionality introduced in commit
> 76da3fb3575, bringing it into osl.c in preparation for removing
> ./drivers/acpi/atomicio.[ch].
>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---
>
>  drivers/acpi/osl.c |   36 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index f363a55..8ee64ea 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -31,6 +31,7 @@
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
>  #include <linux/mm.h>
> +#include <linux/highmem.h>
>  #include <linux/pci.h>
>  #include <linux/interrupt.h>
>  #include <linux/kmod.h>
> @@ -321,6 +322,37 @@ acpi_map_lookup_virt(void __iomem *virt, acpi_size size)
>        return NULL;
>  }
>
> +#ifndef CONFIG_IA64
> +#define should_use_kmap(pfn)   page_is_ram(pfn)
> +#else
> +/* ioremap will take care of cache attributes */
> +#define should_use_kmap(pfn)   0
> +#endif
> +
> +static void __iomem *acpi_map(acpi_physical_address pg_off, unsigned long pg_sz)
> +{
> +       unsigned long pfn;
> +
> +       pfn = pg_off >> PAGE_SHIFT;
> +       if (should_use_kmap(pfn)) {
> +               if (pg_sz > PAGE_SIZE)
> +                       return NULL;
> +               return (void __iomem __force *)kmap(pfn_to_page(pfn));
> +       } else
> +               return acpi_os_ioremap(pg_off, pg_sz);

This implies that ioremap() works differently on ia64 than on x86.
Apparently one can ioremap() RAM on x86, but not on ia64.  Why is this
different?  Shouldn't we instead fix ioremap() on ia64 so it works the
same as on x86?

I looked at the ia64 ioremap(), and I can't see the reason it fails
for RAM.  Huang, do you remember the details from 76da3fb3575?

> +}
> +
> +static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
> +{
> +       unsigned long pfn;
> +
> +       pfn = pg_off >> PAGE_SHIFT;
> +       if (page_is_ram(pfn))
> +               kunmap(pfn_to_page(pfn));
> +       else
> +               iounmap(vaddr);

I hope we can resolve the ioremap() question so we don't need this
patch at all.  But if we do need this, I don't like the asymmetry here
-- on x86 RAM, I think we use ioremap() and kunmap(), which seems
wrong.  We should be able to use ioremap() and iounmap().

> +}
> +
>  void __iomem *__init_refok
>  acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
>  {
> @@ -353,7 +385,7 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
>
>        pg_off = round_down(phys, PAGE_SIZE);
>        pg_sz = round_up(phys + size, PAGE_SIZE) - pg_off;
> -       virt = acpi_os_ioremap(pg_off, pg_sz);
> +       virt = acpi_map(pg_off, pg_sz);
>        if (!virt) {
>                mutex_unlock(&acpi_ioremap_lock);
>                kfree(map);
> @@ -384,7 +416,7 @@ static void acpi_os_map_cleanup(struct acpi_ioremap *map)
>  {
>        if (!map->refcount) {
>                synchronize_rcu();
> -               iounmap(map->virt);
> +               acpi_unmap(map->phys, map->virt);
>                kfree(map);
>        }
>  }
>
