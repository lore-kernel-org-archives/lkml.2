Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab2EYRx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:53:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40490 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2EYRxZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120525043651.GA1391@google.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
Date: Fri, 25 May 2012 10:53:25 -0700
X-Google-Sender-Auth: 39i4wlKY6bemveJuvkKuaHUbA5M
Message-ID: <CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 9:36 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, May 23, 2012 at 11:40:46AM -0700, Yinghai Lu wrote:
>> On Wed, May 23, 2012 at 10:30 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Wed, May 23, 2012 at 8:57 AM, Linus Torvalds
>> > <torvalds@linux-foundation.org> wrote:
>> >> On Tue, May 22, 2012 at 11:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> >>> and will fall back to below 4g if it can not find any above 4g.
>> >>
>> >> Has this been tested on 32-bit machines without PAE? There might be
>> >> things that just happen to work because their allocations were always
>> >> done bottom-up.
>> >
>> > Good point. that problem should be addressed at first before this patch.
>>
>> Just checked code for 32bit machines without PAE.
>>
>> when X86_PAE is not set, phys_addr_t aka resource_size_t will be 32bit.
>> so in drivers/pci/bus.c::pci_bus_alloc_resource_fit()
>> will have bottom to 0.
>>     resource_size_t bottom = PCIBIOS_MAX_MEM_32 + 1ULL;
>> also in arch/x86/kernel/setup.c::setup_arch()
>>    iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
>> will have iomem_resource.end to 0xffffffff
>>
>> when X86_PAE is set, but CPU does not support PAE.
>> phys_addr_t aka resource_size_t will be 32bit.
>
> I think you meant phys_addr_t and resource_size_t will be *64* bit
> when X86_PAE is set.  Obvious to you, but quite confusing to non-x86
> experts like me :)
>
>> so in drivers/pci/bus.c::pci_bus_alloc_resource_fit()
>> will have bottom to 4g.
>>     resource_size_t bottom = PCIBIOS_MAX_MEM_32 + 1ULL;
>> but
>> in arch/x86/kernel/setup.c::setup_arch()
>>    iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
>> will have iomem_resource.end to 0xffffffff, because x86_phys_bits is 32 when PAE
>> is not detected in arch/x86/kernel/cpu/common.c::get_cpu_cap.
>> that mean first try will fail, so it will go to second try with bottom to 0.
>>
>> so both case are safe with this patch.
>
> I don't really like the dependency on PCIBIOS_MAX_MEM_32 + 1ULL
> overflowing to zero -- that means the reader has to know what the
> value of PCIBIOS_MAX_MEM_32 is, and things would break in non-obvious
> ways if we changed it.
>
> What do you think of a patch like the following?  It makes it
> explicit that we can only allocate space the CPU can address.
>
> commit feded2ae21d6160292726ccd5128080d42395be4
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Thu May 24 22:15:26 2012 -0600
>
>    PCI: try to allocate 64-bit resources above 4GB
>
>    If we have a 64-bit resource, try to allocate it above 4GB first.  If that
>    fails, either because there's no space or the CPU can't address space above
>    4GB (iomem_resource.end is the highest address the CPU supports), we'll
>    fall back to allocating space below 4GB.
>
> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
> index 4ce5ef2..2c56693 100644
> --- a/drivers/pci/bus.c
> +++ b/drivers/pci/bus.c
> @@ -121,14 +121,18 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>  {
>        int i, ret = -ENOMEM;
>        struct resource *r;
> -       resource_size_t max = -1;
> +       resource_size_t start = 0;
> +       resource_size_t end = PCIBIOS_MAX_MEM_32;
>
>        type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
>
> -       /* don't allocate too high if the pref mem doesn't support 64bit*/
> -       if (!(res->flags & IORESOURCE_MEM_64))
> -               max = PCIBIOS_MAX_MEM_32;
> +       /* If this is a 64-bit resource, prefer space above 4GB */
> +       if (res->flags & IORESOURCE_MEM_64) {
> +               start = PCIBIOS_MAX_MEM_32 + 1ULL;
> +               end = iomem_resource.end;

but here we still have PCIBIOS_MAX_MEM_32 + 1ULL ...will still have
overflow to 0..

also because all mmio will in iomem_resource, so we don't need to
specify it, and still keep using -1 as max.
aka avoid referring global iomem_resource here.

So this version is the same as old version, and just reverse checking
           res->flags & IORESOURCE_MEM_64

> +       }
>
> +again:
>        pci_bus_for_each_resource(bus, r, i) {
>                if (!r)
>                        continue;
> @@ -145,12 +149,18 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>
>                /* Ok, try it out.. */
>                ret = allocate_resource(r, res, size,
> -                                       r->start ? : min,
> -                                       max, align,
> +                                       max(start, r->start ? : min),
> +                                       end, align,
>                                        alignf, alignf_data);
>                if (ret == 0)
> -                       break;
> +                       return 0;
>        }
> +
> +       if (start != 0) {
> +               start = 0;
> +               goto again;
> +       }
> +
>        return ret;
>  }
>
