Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab2HWXot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:44:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58364 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab2HWXoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <1345739803-21017-2-git-send-email-mjg@redhat.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com> <1345739803-21017-2-git-send-email-mjg@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 23 Aug 2012 17:44:22 -0600
Message-ID: <CAErSpo4Y=z-sP6cjJSzCtD-Gsnrm6-CWWKJpqiScv6QdbzTeyA@mail.gmail.com>
Subject: Re: [PATCH V3 1/4] EFI: Stash ROMs if they're not in the PCI BAR
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org, mfleming@intel.com, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 10:36 AM, Matthew Garrett <mjg@redhat.com> wrote:
> EFI provides support for providing PCI ROMs via means other than the ROM
> BAR. This support vanishes after we've exited boot services, so add support
> for stashing copies of the ROMs in setup_data if they're not otherwise
> available.

-ENO_SIGNED_OFF_BY

I'll add it if you confirm it.

> ---
>  arch/x86/boot/compressed/eboot.c | 118 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/include/asm/bootparam.h |   1 +
>  arch/x86/include/asm/pci.h       |  12 ++++
>  include/linux/efi.h              |  71 +++++++++++++++++++++++
>  4 files changed, 202 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index b3e0227..8630578 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -8,6 +8,7 @@
>   * ----------------------------------------------------------------------- */
>
>  #include <linux/efi.h>
> +#include <linux/pci.h>
>  #include <asm/efi.h>
>  #include <asm/setup.h>
>  #include <asm/desc.h>
> @@ -243,6 +244,121 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
>         *size = len;
>  }
>
> +static efi_status_t setup_efi_pci(struct boot_params *params)
> +{
> +       efi_pci_io_protocol *pci;
> +       efi_status_t status;
> +       void **pci_handle;
> +       efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
> +       unsigned long nr_pci, size = 0;
> +       int i;
> +       struct setup_data *data;
> +
> +       data = (struct setup_data *)params->hdr.setup_data;
> +
> +       while (data && data->next)
> +               data = (struct setup_data *)data->next;
> +
> +       status = efi_call_phys5(sys_table->boottime->locate_handle,
> +                               EFI_LOCATE_BY_PROTOCOL, &pci_proto,
> +                               NULL, &size, pci_handle);
> +
> +       if (status == EFI_BUFFER_TOO_SMALL) {
> +               status = efi_call_phys3(sys_table->boottime->allocate_pool,
> +                                       EFI_LOADER_DATA, size, &pci_handle);
> +
> +               if (status != EFI_SUCCESS)
> +                       return status;
> +
> +               status = efi_call_phys5(sys_table->boottime->locate_handle,
> +                                       EFI_LOCATE_BY_PROTOCOL, &pci_proto,
> +                                       NULL, &size, pci_handle);
> +       }
> +
> +       if (status != EFI_SUCCESS)
> +               goto free_handle;
> +
> +       nr_pci = size / sizeof(void *);
> +       for (i = 0; i < nr_pci; i++) {
> +               void *h = pci_handle[i];
> +               uint64_t attributes;
> +               struct pci_setup_rom *rom;
> +
> +               status = efi_call_phys3(sys_table->boottime->handle_protocol,
> +                                       h, &pci_proto, &pci);
> +
> +               if (status != EFI_SUCCESS)
> +                       continue;
> +
> +               if (!pci)
> +                       continue;
> +
> +               status = efi_call_phys4(pci->attributes, pci,
> +                                       EfiPciIoAttributeOperationGet, 0,
> +                                       &attributes);
> +
> +               if (status != EFI_SUCCESS)
> +                       continue;
> +
> +               if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
> +                       continue;
> +
> +               if (!pci->romimage || !pci->romsize)
> +                       continue;
> +
> +               size = pci->romsize + sizeof(*rom);
> +
> +               status = efi_call_phys3(sys_table->boottime->allocate_pool,
> +                               EFI_LOADER_DATA, size, &rom);
> +
> +               if (status != EFI_SUCCESS)
> +                       continue;
> +
> +               rom->data.type = SETUP_PCI;
> +               rom->data.len = size - sizeof(struct setup_data);
> +               rom->data.next = 0;
> +               rom->pcilen = pci->romsize;
> +
> +               status = efi_call_phys5(pci->pci.read, pci,
> +                                       EfiPciIoWidthUint16, PCI_VENDOR_ID,
> +                                       1, &(rom->vendor));
> +
> +               if (status != EFI_SUCCESS)
> +                       goto free_struct;
> +
> +               status = efi_call_phys5(pci->pci.read, pci,
> +                                       EfiPciIoWidthUint16, PCI_DEVICE_ID,
> +                                       1, &(rom->devid));
> +
> +               if (status != EFI_SUCCESS)
> +                       goto free_struct;
> +
> +               status = efi_call_phys5(pci->get_location, pci,
> +                                       &(rom->segment), &(rom->bus),
> +                                       &(rom->device), &(rom->function));
> +
> +               if (status != EFI_SUCCESS)
> +                       goto free_struct;
> +
> +               memcpy(rom->romdata, pci->romimage, pci->romsize);
> +
> +               if (data)
> +                       data->next = (uint64_t)rom;
> +               else
> +                       params->hdr.setup_data = (uint64_t)rom;
> +
> +               data = (struct setup_data *)rom;
> +
> +               continue;
> +       free_struct:
> +               efi_call_phys1(sys_table->boottime->free_pool, rom);
> +       }
> +
> +free_handle:
> +       efi_call_phys1(sys_table->boottime->free_pool, pci_handle);
> +       return status;
> +}
> +
>  /*
>   * See if we have Graphics Output Protocol
>   */
> @@ -1020,6 +1136,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
>
>         setup_graphics(boot_params);
>
> +       setup_efi_pci(boot_params);
> +
>         status = efi_call_phys3(sys_table->boottime->allocate_pool,
>                                 EFI_LOADER_DATA, sizeof(*gdt),
>                                 (void **)&gdt);
> diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
> index 2ad874c..92862cd 100644
> --- a/arch/x86/include/asm/bootparam.h
> +++ b/arch/x86/include/asm/bootparam.h
> @@ -13,6 +13,7 @@
>  #define SETUP_NONE                     0
>  #define SETUP_E820_EXT                 1
>  #define SETUP_DTB                      2
> +#define SETUP_PCI                      3
>
>  /* extensible setup data list node */
>  struct setup_data {
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index df75d07..11491d1 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -171,4 +171,16 @@ cpumask_of_pcibus(const struct pci_bus *bus)
>  }
>  #endif
>
> +struct pci_setup_rom {
> +       struct setup_data data;
> +       uint16_t vendor;
> +       uint16_t devid;
> +       uint64_t pcilen;
> +       unsigned long segment;
> +       unsigned long bus;
> +       unsigned long device;
> +       unsigned long function;
> +       uint8_t romdata[0];
> +};
> +
>  #endif /* _ASM_X86_PCI_H */
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index ec45ccd..bf7e867 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -196,6 +196,77 @@ typedef struct {
>         void *create_event_ex;
>  } efi_boot_services_t;
>
> +typedef enum {
> +       EfiPciIoWidthUint8,
> +       EfiPciIoWidthUint16,
> +       EfiPciIoWidthUint32,
> +       EfiPciIoWidthUint64,
> +       EfiPciIoWidthFifoUint8,
> +       EfiPciIoWidthFifoUint16,
> +       EfiPciIoWidthFifoUint32,
> +       EfiPciIoWidthFifoUint64,
> +       EfiPciIoWidthFillUint8,
> +       EfiPciIoWidthFillUint16,
> +       EfiPciIoWidthFillUint32,
> +       EfiPciIoWidthFillUint64,
> +       EfiPciIoWidthMaximum
> +} EFI_PCI_IO_PROTOCOL_WIDTH;
> +
> +typedef enum {
> +       EfiPciIoAttributeOperationGet,
> +       EfiPciIoAttributeOperationSet,
> +       EfiPciIoAttributeOperationEnable,
> +       EfiPciIoAttributeOperationDisable,
> +       EfiPciIoAttributeOperationSupported,
> +    EfiPciIoAttributeOperationMaximum
> +} EFI_PCI_IO_PROTOCOL_ATTRIBUTE_OPERATION;
> +
> +
> +typedef struct {
> +       void *read;
> +       void *write;
> +} efi_pci_io_protocol_access_t;
> +
> +typedef struct {
> +       void *poll_mem;
> +       void *poll_io;
> +       efi_pci_io_protocol_access_t mem;
> +       efi_pci_io_protocol_access_t io;
> +       efi_pci_io_protocol_access_t pci;
> +       void *copy_mem;
> +       void *map;
> +       void *unmap;
> +       void *allocate_buffer;
> +       void *free_buffer;
> +       void *flush;
> +       void *get_location;
> +       void *attributes;
> +       void *get_bar_attributes;
> +       void *set_bar_attributes;
> +       uint64_t romsize;
> +       void *romimage;
> +} efi_pci_io_protocol;
> +
> +#define EFI_PCI_IO_ATTRIBUTE_ISA_MOTHERBOARD_IO 0x0001
> +#define EFI_PCI_IO_ATTRIBUTE_ISA_IO 0x0002
> +#define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO 0x0004
> +#define EFI_PCI_IO_ATTRIBUTE_VGA_MEMORY 0x0008
> +#define EFI_PCI_IO_ATTRIBUTE_VGA_IO 0x0010
> +#define EFI_PCI_IO_ATTRIBUTE_IDE_PRIMARY_IO 0x0020
> +#define EFI_PCI_IO_ATTRIBUTE_IDE_SECONDARY_IO 0x0040
> +#define EFI_PCI_IO_ATTRIBUTE_MEMORY_WRITE_COMBINE 0x0080
> +#define EFI_PCI_IO_ATTRIBUTE_IO 0x0100
> +#define EFI_PCI_IO_ATTRIBUTE_MEMORY 0x0200
> +#define EFI_PCI_IO_ATTRIBUTE_BUS_MASTER 0x0400
> +#define EFI_PCI_IO_ATTRIBUTE_MEMORY_CACHED 0x0800
> +#define EFI_PCI_IO_ATTRIBUTE_MEMORY_DISABLE 0x1000
> +#define EFI_PCI_IO_ATTRIBUTE_EMBEDDED_DEVICE 0x2000
> +#define EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM 0x4000
> +#define EFI_PCI_IO_ATTRIBUTE_DUAL_ADDRESS_CYCLE 0x8000
> +#define EFI_PCI_IO_ATTRIBUTE_ISA_IO_16 0x10000
> +#define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
> +#define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
> +
>  /*
>   * Types and defines for EFI ResetSystem
>   */
> --
> 1.7.11.2
>
