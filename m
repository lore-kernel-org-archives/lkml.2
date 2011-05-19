Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652Ab1ESU0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:26:30 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56251 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727Ab1ESU02 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:26:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=f7gmOjyrHpLrhAM4x3xdaX1yB3W72fIU3B3hZo/lnhyolh0tdHfAQRDtCvAZgffima
         4C16Bce2/y5f8r9VFHEzqzc5uolADMcI8mDx2HmJm7j1NvSYreX+u9HYv0wxXjPz+AxC
         7sCnKtQ8lXyvL5Z1/Kx5Gej+R3C+R6GRHKbos=
MIME-Version: 1.0
In-Reply-To: <1305826343-3302-1-git-send-email-mjg@redhat.com>
References: <1305826343-3302-1-git-send-email-mjg@redhat.com>
Date: Thu, 19 May 2011 13:26:27 -0700
X-Google-Sender-Auth: D291bJUOWMNg-z2TxRB2LVAHBA8
Message-ID: <BANLkTi=fViUQ+7i3PopGH4jkEcvCUqkrMg@mail.gmail.com>
Subject: Re: [PATCH] efi: Retain boot service code until after switching to
 virtual mode
From: Yinghai Lu <yinghai@kernel.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@vkernel.org, hpa@zytor.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:32 AM, Matthew Garrett <mjg@redhat.com> wrote:
> UEFI stands for "Unified Extensible Firmware Interface", where "Firmware"
> is an ancient African word meaning "Why do something right when you can
> do it so wrong that children will weep and brave adults will cower before
> you", and "UEI" is Celtic for "We missed DOS so we burned it into your
> ROMs". The UEFI specification provides for runtime services (ie, another
> way for the operating system to be forced to depend on the firmware) and
> we rely on these for certain trivial tasks such as setting up the
> bootloader. But some hardware fails to work if we attempt to use these
> runtime services from physical mode, and so we have to switch into virtual
> mode. So far so dreadful.
>
> The specification makes it clear that the operating system is free to do
> whatever it wants with boot services code after ExitBootServices() has been
> called. SetVirtualAddressMap() can't be called until ExitBootServices() has
> been. So, obviously, a whole bunch of EFI implementations call into boot
> services code when we do that. Since we've been charmingly naive and
> trusted that the specification may be somehow relevant to the real world,
> we've already stuffed a picture of a penguin or something in that address
> space. And just to make things more entertaining, we've also marked it
> non-executable.
>
> This patch allocates the boot services regions during EFI init and makes
> sure that they're executable. Then, after SetVirtualAddressMap(), it
> discards them and everyone lives happily ever after. Except for the ones
> who have to work on EFI, who live sad lives haunted by the knowledge that
> someone's eventually going to write yet another firmware specification.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/platform/efi/efi.c    |   51 +++++++++++++++++++++++++++++++++++++++-
>  arch/x86/platform/efi/efi_64.c |    5 ++-
>  2 files changed, 53 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index b30aa26..8237c6e 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -304,6 +304,40 @@ static void __init print_efi_memmap(void)
>  }
>  #endif  /*  EFI_DEBUG  */
>
> +static void __init reserve_efi_boot_services(void)
> +{
> +       void *p;
> +
> +       for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +               efi_memory_desc_t *md = p;
> +               unsigned long long start = md->phys_addr;
> +               unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> +
> +               if (md->type != EFI_BOOT_SERVICES_CODE &&
> +                   md->type != EFI_BOOT_SERVICES_DATA)
> +                       continue;
> +
> +               memblock_x86_reserve_range(start, start + size, "EFI Boot");
> +       }
> +}
> +
> +static void __init free_efi_boot_services(void)
> +{
> +       void *p;
> +
> +       for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> +               efi_memory_desc_t *md = p;
> +               unsigned long long start = md->phys_addr;
> +               unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> +
> +               if (md->type != EFI_BOOT_SERVICES_CODE &&
> +                   md->type != EFI_BOOT_SERVICES_DATA)
> +                       continue;
> +
> +               memblock_x86_free_range(start, start + size);
> +       }
> +}
> +
>  void __init efi_init(void)
>  {
>        efi_config_table_t *config_tables;
> @@ -441,6 +475,12 @@ void __init efi_init(void)
>                printk(KERN_WARNING
>                  "Kernel-defined memdesc doesn't match the one from EFI!\n");
>
> +       /*
> +        * The EFI specification says that boot service code won't be called
> +        * after ExitBootServices(). This is, in fact, a lie.
> +        */
> +       reserve_efi_boot_services();
> +
>        if (add_efi_memmap)
>                do_add_efi_memmap();
>

how many entries are listed in memmap?

Did you test this system that have lots of those entries ? like > 128?

because efi_init() is called before memblock_x86_fill(), that means
memblock array for reserved can not be doubled yet. --- no usable
entries in memblock array for ram.

> @@ -536,7 +576,9 @@ void __init efi_enter_virtual_mode(void)
>
>        for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>                md = p;
> -               if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +               if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> +                   md->type != EFI_BOOT_SERVICES_CODE &&
> +                   md->type != EFI_BOOT_SERVICES_DATA)
>                        continue;
>
>                size = md->num_pages << EFI_PAGE_SHIFT;
> @@ -593,6 +635,13 @@ void __init efi_enter_virtual_mode(void)
>        }
>
>        /*
> +        * Thankfully, it does seem that no runtime services other than
> +        * SetVirtualAddressMap() will touch boot services code, so we can
> +        * get rid of it all at this point
> +        */
> +       free_efi_boot_services();
> +

No, at that point memblock is not used any more.  after mm_init()/mem_init()

need to use free_bootmem_late() in free_efi_boot_services

Thanks

Yinghai
