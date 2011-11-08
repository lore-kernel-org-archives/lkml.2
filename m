Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1KHPkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:40:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44310 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1KHPkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:40:22 -0500
MIME-Version: 1.0
In-Reply-To: <1320719974-3598-4-git-send-email-ying.huang@intel.com>
References: <1320719974-3598-1-git-send-email-ying.huang@intel.com> <1320719974-3598-4-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 8 Nov 2011 08:40:00 -0700
Message-ID: <CAErSpo7XSi-xsLYmv7B0u2qmdjyGJ91gdOH7wPqFq5JYEo68OQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] ACPI, Record ACPI NVS regions
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 7:39 PM, Huang Ying <ying.huang@intel.com> wrote:
> Some firmware will access memory in ACPI NVS region via APEI.  That
> is, instructions in APEI ERST/EINJ table will read/write ACPI NVS
> region.  The original resource conflict checking in APEI code will
> check memory/ioport accessed by APEI via general resource management
> mechanism.  But ACPI NVS region is marked as busy already, so that the
> false resource conflict will prevent APEI ERST/EINJ to work.
>
> To fix this, this patch record ACPI NVS regions, so that we can avoid
> request resources for memory region inside it.

I don't really like these patches (3 & 4), as I mentioned before:
  https://lkml.org/lkml/2011/8/22/270
  https://lkml.org/lkml/2011/9/19/397

To recap, e820 currently marks everything except E820_RESERVED areas
as "BUSY" in the iomem_resource tree.  That basically means that RAM,
ACPI, and NVS are marked as BUSY.  Later APEI attempts a
request_mem_region() on a a resource, and it fails because e820 has
already marked it BUSY.

It makes sense for e820 to mark RAM as BUSY, because we we don't use
iomem_resource to manage it; we pass it all off to memblock and
eventually the regular memory allocator.  But from e820's point of
view, everything else (RESERVED, ACPI, NVS, etc) is just a clue  that
something uses that region and we shouldn't place anything else on top
of it.

We normally mark something BUSY when a driver calls request_region()
to indicate that it owns the region and any other requests for the
same region should fail.  I think it's a mistake for e820 to mark
things BUSY because it really is not the the owner of any of those
regions (except for RAM, because in that case e820 *is* essentially
taking ownership of RAM and passing it off to memblock).

I think a better solution for the APEI problem would be to have e820
leave non-RAM regions in iomem_resource, but not mark them BUSY, as in
this patch from Yinghai:

--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -995,7 +995,8 @@ void __init e820_reserve_resources(void)
 		 * pcibios_resource_survey()
 		 */
 		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
-			res->flags |= IORESOURCE_BUSY;
+			if (e820.map[i].type != E820_NVS)
+				res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
 		res++;

That's much simpler than having e820 pretend to be the owner of NVS
regions, building an extra list of the NVS regions, and subtracting
them from the regions APEI needs to request ownership of.

Bjorn

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/kernel/e820.c |    4 +--
>  drivers/acpi/Makefile  |    3 +-
>  drivers/acpi/nvs.c     |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/acpi.h   |   20 ++++++++++++------
>  4 files changed, 70 insertions(+), 10 deletions(-)
>
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -714,7 +714,7 @@ void __init e820_mark_nosave_regions(uns
>  }
>  #endif
>
> -#ifdef CONFIG_HIBERNATION
> +#ifdef CONFIG_ACPI
>  /**
>  * Mark ACPI NVS memory region, so that we can save/restore it during
>  * hibernation and the subsequent resume.
> @@ -727,7 +727,7 @@ static int __init e820_mark_nvs_memory(v
>                struct e820entry *ei = &e820.map[i];
>
>                if (ei->type == E820_NVS)
> -                       suspend_nvs_register(ei->addr, ei->size);
> +                       acpi_nvs_register(ei->addr, ei->size);
>        }
>
>        return 0;
> --- a/drivers/acpi/Makefile
> +++ b/drivers/acpi/Makefile
> @@ -20,11 +20,12 @@ obj-y                               += acpi.o \
>  # All the builtin files are in the "acpi." module_param namespace.
>  acpi-y                         += osl.o utils.o reboot.o
>  acpi-y                         += atomicio.o
> +acpi-y                         += nvs.o
>
>  # sleep related files
>  acpi-y                         += wakeup.o
>  acpi-y                         += sleep.o
> -acpi-$(CONFIG_ACPI_SLEEP)      += proc.o nvs.o
> +acpi-$(CONFIG_ACPI_SLEEP)      += proc.o
>
>
>  #
> --- a/drivers/acpi/nvs.c
> +++ b/drivers/acpi/nvs.c
> @@ -15,6 +15,56 @@
>  #include <linux/acpi_io.h>
>  #include <acpi/acpiosxf.h>
>
> +/* ACPI NVS regions, APEI may use it */
> +
> +struct nvs_region {
> +       __u64 phys_start;
> +       __u64 size;
> +       struct list_head node;
> +};
> +
> +static LIST_HEAD(nvs_region_list);
> +
> +#ifdef CONFIG_ACPI_SLEEP
> +static int suspend_nvs_register(unsigned long start, unsigned long size);
> +#else
> +static inline int suspend_nvs_register(unsigned long a, unsigned long b)
> +{
> +       return 0;
> +}
> +#endif
> +
> +int acpi_nvs_register(__u64 start, __u64 size)
> +{
> +       struct nvs_region *region;
> +
> +       region = kmalloc(sizeof(*region), GFP_KERNEL);
> +       if (!region)
> +               return -ENOMEM;
> +       region->phys_start = start;
> +       region->size = size;
> +       list_add_tail(&region->node, &nvs_region_list);
> +
> +       return suspend_nvs_register(start, size);
> +}
> +
> +int acpi_nvs_for_each_region(int (*func)(__u64 start, __u64 size, void *data),
> +                            void *data)
> +{
> +       int rc;
> +       struct nvs_region *region;
> +
> +       list_for_each_entry(region, &nvs_region_list, node) {
> +               rc = func(region->phys_start, region->size, data);
> +               if (rc)
> +                       return rc;
> +       }
> +
> +       return 0;
> +}
> +
> +
> +#ifdef CONFIG_ACPI_SLEEP
>  /*
>  * Platforms, like ACPI, may want us to save some memory used by them during
>  * suspend and to restore the contents of this memory during the subsequent
> @@ -41,7 +91,7 @@ static LIST_HEAD(nvs_list);
>  *     things so that the data from page-aligned addresses in this region will
>  *     be copied into separate RAM pages.
>  */
> -int suspend_nvs_register(unsigned long start, unsigned long size)
> +static int suspend_nvs_register(unsigned long start, unsigned long size)
>  {
>        struct nvs_page *entry, *next;
>
> @@ -159,3 +209,4 @@ void suspend_nvs_restore(void)
>                if (entry->data)
>                        memcpy(entry->kaddr, entry->data, entry->size);
>  }
> +#endif
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -306,6 +306,11 @@ extern acpi_status acpi_pci_osc_control_
>                                             u32 *mask, u32 req);
>  extern void acpi_early_init(void);
>
> +extern int acpi_nvs_register(__u64 start, __u64 size);
> +
> +extern int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
> +                                   void *data);
> +
>  #else  /* !CONFIG_ACPI */
>
>  #define acpi_disabled 1
> @@ -348,15 +353,18 @@ static inline int acpi_table_parse(char
>  {
>        return -1;
>  }
> -#endif /* !CONFIG_ACPI */
>
> -#ifdef CONFIG_ACPI_SLEEP
> -int suspend_nvs_register(unsigned long start, unsigned long size);
> -#else
> -static inline int suspend_nvs_register(unsigned long a, unsigned long b)
> +static inline int acpi_nvs_register(__u64 start, __u64 size)
>  {
>        return 0;
>  }
> -#endif
> +
> +static inline int acpi_nvs_for_each_region(int (*func)(__u64, __u64, void *),
> +                                          void *data)
> +{
> +       return 0;
> +}
> +
> +#endif /* !CONFIG_ACPI */
>
>  #endif /*_LINUX_ACPI_H*/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
