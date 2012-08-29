Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2H2Vqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 17:46:38 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:40659
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab2H2Vqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 17:46:36 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI9371I168aJ1432Izz1202hzz8275bhz2dh668h839h944hd25hd2bhf0ah107ah1220h)
X-WSS-ID: 0M9JDTG-01-I96-02
X-M-MSG: 
Date: Wed, 29 Aug 2012 16:46:08 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Dave Young <dyoung@redhat.com>, Chao Wang <chaowang@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/6] x86: Only direct map addresses that are marked as
 E820_RAM
Message-ID: <20120829214605.GA10216@jshin-Toonie>
References: <1346267046-6724-1-git-send-email-jacob.shin@amd.com>
 <1346267046-6724-5-git-send-email-jacob.shin@amd.com>
 <CAE9FiQWcYmROV1SHzk0_RUQfniDwgbyiCbcbRbXatYvYhuGp7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAE9FiQWcYmROV1SHzk0_RUQfniDwgbyiCbcbRbXatYvYhuGp7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 02:17:51PM -0700, Yinghai Lu wrote:
> On Wed, Aug 29, 2012 at 12:04 PM, Jacob Shin <jacob.shin@amd.com> wrote:
> > Currently direct mappings are created for [ 0 to max_low_pfn<<PAGE_SHIFT )
> > and [ 4GB to max_pfn<<PAGE_SHIFT ), which may include regions that are not
> > backed by actual DRAM. This is fine for holes under 4GB which are covered
> > by fixed and variable range MTRRs to be UC. However, we run into trouble
> > on higher memory addresses which cannot be covered by MTRRs.
> >
> > Our system with 1TB of RAM has an e820 that looks like this:
> >
> >  BIOS-e820: [mem 0x0000000000000000-0x00000000000983ff] usable
> >  BIOS-e820: [mem 0x0000000000098400-0x000000000009ffff] reserved
> >  BIOS-e820: [mem 0x00000000000d0000-0x00000000000fffff] reserved
> >  BIOS-e820: [mem 0x0000000000100000-0x00000000c7ebffff] usable
> >  BIOS-e820: [mem 0x00000000c7ec0000-0x00000000c7ed7fff] ACPI data
> >  BIOS-e820: [mem 0x00000000c7ed8000-0x00000000c7ed9fff] ACPI NVS
> >  BIOS-e820: [mem 0x00000000c7eda000-0x00000000c7ffffff] reserved
> >  BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
> >  BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> >  BIOS-e820: [mem 0x00000000fff00000-0x00000000ffffffff] reserved
> >  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
> >  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
> >  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> >
> > and so direct mappings are created for huge memory hole between
> > 0x000000e038000000 to 0x0000010000000000. Even though the kernel never
> > generates memory accesses in that region, since the page tables mark
> > them incorrectly as being WB, our (AMD) processor ends up causing a MCE
> > while doing some memory bookkeeping/optimizations around that area.
> >
> > This patch iterates through e820 and only direct maps ranges that are
> > marked as E820_RAM, and keeps track of those pfn ranges. Depending on
> > the alignment of E820 ranges, this may possibly result in using smaller
> > size (i.e. 4K instead of 2M or 1G) page tables.
> >
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  arch/x86/include/asm/page_types.h |    9 ++++
> >  arch/x86/kernel/setup.c           |  100 +++++++++++++++++++++++++++++++------
> >  arch/x86/mm/init.c                |    2 +
> >  arch/x86/mm/init_64.c             |    6 +--
> >  4 files changed, 99 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
> > index e21fdd1..409047a 100644
> > --- a/arch/x86/include/asm/page_types.h
> > +++ b/arch/x86/include/asm/page_types.h
> > @@ -3,6 +3,7 @@
> >
> >  #include <linux/const.h>
> >  #include <linux/types.h>
> > +#include <asm/e820.h>
> >
> >  /* PAGE_SHIFT determines the page size */
> >  #define PAGE_SHIFT     12
> > @@ -40,12 +41,20 @@
> >  #endif /* CONFIG_X86_64 */
> >
> >  #ifndef __ASSEMBLY__
> > +#include <linux/range.h>
> >
> >  extern int devmem_is_allowed(unsigned long pagenr);
> >
> >  extern unsigned long max_low_pfn_mapped;
> >  extern unsigned long max_pfn_mapped;
> >
> > +extern struct range pfn_mapped[E820_X_MAX];
> > +extern int nr_pfn_mapped;
> > +
> > +extern void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn);
> > +extern bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
> > +extern bool pfn_is_mapped(unsigned long pfn);
> > +
> >  static inline phys_addr_t get_max_mapped(void)
> >  {
> >         return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index d6e8c03..a2e392e 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -115,13 +115,47 @@
> >  #include <asm/prom.h>
> >
> >  /*
> > - * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> > - * The direct mapping extends to max_pfn_mapped, so that we can directly access
> > - * apertures, ACPI and other tables without having to play with fixmaps.
> > + * max_low_pfn_mapped: highest direct mapped pfn under 4GB
> > + * max_pfn_mapped:     highest direct mapped pfn over 4GB
> > + *
> > + * The direct mapping only covers E820_RAM regions, so the ranges and gaps are
> > + * represented by pfn_mapped
> >   */
> >  unsigned long max_low_pfn_mapped;
> >  unsigned long max_pfn_mapped;
> >
> > +struct range pfn_mapped[E820_X_MAX];
> > +int nr_pfn_mapped;
> 
> change to static?

Hm .. yeah I guess we could, the initial reason why I didn't make it
static was because max_pfn_mapped was not static. But I guess as long
as everyone down the line uses pfn_range_is_mapped() to test for direct
mappings, I guess we can change it to static.

> 
> > +
> > +void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
> > +{
> > +       nr_pfn_mapped = add_range_with_merge(pfn_mapped, E820_X_MAX,
> > +                                            nr_pfn_mapped, start_pfn, end_pfn);
> > +       nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
> > +
> > +       max_pfn_mapped = max(max_pfn_mapped, end_pfn);
> > +
> > +       if (end_pfn <= (1UL << (32 - PAGE_SHIFT)))
> > +               max_low_pfn_mapped = max(max_low_pfn_mapped, end_pfn);
> > +}
> > +
> > +bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < nr_pfn_mapped; i++)
> > +               if ((start_pfn >= pfn_mapped[i].start) &&
> > +                   (end_pfn <= pfn_mapped[i].end))
> > +                       return true;
> > +
> > +       return false;
> > +}
> > +
> > +bool pfn_is_mapped(unsigned long pfn)
> > +{
> > +       return pfn_range_is_mapped(pfn, pfn + 1);
> > +}
> 
> wonder if those functions have to be in arch/x86/kernel/setup.c.

Where do you suggest we move it to?

> 
> also do we need to update the tracking array when we have do memory hot-remove?

Hm .. how is it handled right now? does the hot-remove tear down direct
mappings? If it does, I guess we could hook remove range code where that
happens ..



> 
> Thanks
> 
> Yinghai
> 

