Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab2HYEyI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 00:54:08 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51034 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2HYEyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 00:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120825042409.GD26127@jshin-Toonie>
References: <1345852516-3125-1-git-send-email-jacob.shin@amd.com>
	<1345852516-3125-4-git-send-email-jacob.shin@amd.com>
	<CAE9FiQUjaBSn0q=+om7+CPjLXVD9Pemf=mNvgYG7C3bE5XxOSw@mail.gmail.com>
	<20120825042409.GD26127@jshin-Toonie>
Date: Fri, 24 Aug 2012 21:54:04 -0700
X-Google-Sender-Auth: AiR3FKrinbd7Wyr8V3m9YSfktDI
Message-ID: <CAE9FiQX2DApN=OU=xTK3VA+p1mDJ=U+qFyyRkaeTiH+xF5dQXw@mail.gmail.com>
Subject: Re: [PATCH 3/5] x86: Only direct map addresses that are marked as E820_RAM
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 9:24 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> On Fri, Aug 24, 2012 at 06:07:01PM -0700, Yinghai Lu wrote:
>> On Fri, Aug 24, 2012 at 4:55 PM, Jacob Shin <jacob.shin@amd.com> wrote:
>> > Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
>> > and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
>> > backed by actual DRAM. This is fine for holes under 4GB which are covered
>> > by fixed and variable range MTRRs to be UC. However, we run into trouble
>> > on higher memory addresses which cannot be covered by MTRRs.
>> >
>> > Our system with 1TB of RAM has an e820 that looks like this:
>> >
>> >  BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
>> >  BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
>> >  BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
>> >  BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
>> >  BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
>> >  BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
>> >  BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
>> >  BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
>> >  BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>> >  BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
>> >  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
>> >  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
>> >  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
>> >
>> > and so direct mappings are created for huge memory hole between
>> > 0x000000e038000000 to 0x0000010000000000. Even though the kernel never
>> > generates memory accesses in that region, since the page tables mark
>> > them incorrectly as being WB, our (AMD) processor ends up causing a MCE
>> > while doing some memory bookkeeping/optimizations around that area.
>> >
>> > This patch iterates through e820 and only direct maps ranges that are
>> > marked as E820_RAM, and keeps track of those pfn ranges. Depending on
>> > the alignment of E820 ranges, this may possibly result in using smaller
>> > size (i.e. 4K instead of 2M or 1G) page tables.
>> >
>> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
>> > ---
>> >  arch/x86/include/asm/page_types.h |    9 +++
>> >  arch/x86/kernel/setup.c           |  125 +++++++++++++++++++++++++++++--------
>> >  arch/x86/mm/init.c                |    2 +
>> >  arch/x86/mm/init_64.c             |    6 +-
>> >  4 files changed, 112 insertions(+), 30 deletions(-)
>> >
>> > diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
>> > index e21fdd1..409047a 100644
>> > --- a/arch/x86/include/asm/page_types.h
>> > +++ b/arch/x86/include/asm/page_types.h
>> > @@ -3,6 +3,7 @@
>> >
>> >  #include <linux/const.h>
>> >  #include <linux/types.h>
>> > +#include <asm/e820.h>
>> >
>> >  /* PAGE_SHIFT determines the page size */
>> >  #define PAGE_SHIFT     12
>> > @@ -40,12 +41,20 @@
>> >  #endif /* CONFIG_X86_64 */
>> >
>> >  #ifndef __ASSEMBLY__
>> > +#include <linux/range.h>
>> >
>> >  extern int devmem_is_allowed(unsigned long pagenr);
>> >
>> >  extern unsigned long max_low_pfn_mapped;
>> >  extern unsigned long max_pfn_mapped;
>> >
>> > +extern struct range pfn_mapped[E820_X_MAX];
>> > +extern int nr_pfn_mapped;
>> > +
>> > +extern void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn);
>> > +extern bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
>> > +extern bool pfn_is_mapped(unsigned long pfn);
>> > +
>> >  static inline phys_addr_t get_max_mapped(void)
>> >  {
>> >         return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
>> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> > index 751e020..4217fb4 100644
>> > --- a/arch/x86/kernel/setup.c
>> > +++ b/arch/x86/kernel/setup.c
>> > @@ -115,13 +115,46 @@
>> >  #include <asm/prom.h>
>> >
>> >  /*
>> > - * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
>> > - * The direct mapping extends to max_pfn_mapped, so that we can directly access
>> > - * apertures, ACPI and other tables without having to play with fixmaps.
>> > + * max_low_pfn_mapped: highest direct mapped pfn under 4GB
>> > + * max_pfn_mapped:     highest direct mapped pfn over 4GB
>> > + *
>> > + * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
>> > + * represented by pfn_mapped
>> >   */
>> >  unsigned long max_low_pfn_mapped;
>> >  unsigned long max_pfn_mapped;
>> >
>> > +struct range pfn_mapped[E820_X_MAX];
>> > +int nr_pfn_mapped;
>> > +
>> > +void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
>> > +{
>> > +       nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
>> > +                                            nr_pfn_mapped, start_pfn, end_pfn);
>> > +
>> > +       max_pfn_mapped = max(max_pfn_mapped, end_pfn);
>> > +
>> > +       if (end_pfn <= (1UL << (32 - PAGE_SHIFT)))
>> > +               max_low_pfn_mapped = max(max_low_pfn_mapped, end_pfn);
>> > +}
>> > +
>> > +bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
>> > +{
>> > +       int i;
>> > +
>> > +       for (i = 0; i < nr_pfn_mapped; i++)
>> > +               if ((start_pfn >= pfn_mapped[i].start) &&
>> > +                   (end_pfn <= pfn_mapped[i].end))
>> > +                       return true;
>> > +
>> > +       return false;
>> > +}
>> > +
>> > +bool pfn_is_mapped(unsigned long pfn)
>> > +{
>> > +       return pfn_range_is_mapped(pfn, pfn + 1);
>> > +}
>> > +
>>
>> looks like you could avoid add pfn_mapped[] array.
>>
>> pfn_range_is_mapped() should be
>> check max_low_pfn_mapped, max_pfn_mapped with
>> e820_all_mapped(start, end, E820_RAM).
>
> Hmm .. I guess that could work .. but what about EFI code that keys off of
> EFI memory map? Does the EFI code update e820 and mark as E820_RAM whatever
> ranges that it calls init_memory_mapping on (via efi_ioremap?)

they are converted to e820 memmap before init_memory_mapping is called.

Thanks

Yinghai
