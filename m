Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab1ESIz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:55:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63911 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932370Ab1ESIz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:55:27 -0400
Subject: Re: [PATCH] ARM: sparsemem: allow pfn_valid to be overridden when
 using SPARSEMEM
From: Will Deacon <will.deacon@arm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110518165910.GS5279@suse.de>
References: <1305734639-6561-1-git-send-email-will.deacon@arm.com>
	 <20110518165910.GS5279@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 May 2011 09:55:17 +0100
Message-ID: <1305795317.29560.9.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Thanks for looking at this.

On Wed, 2011-05-18 at 17:59 +0100, Mel Gorman wrote:
> On Wed, May 18, 2011 at 05:03:59PM +0100, Will Deacon wrote:
> > In commit eb33575c ("[ARM] Double check memmap is actually valid with a
> > memmap has unexpected holes V2"), a new function, memmap_valid_within,
> > was introduced to mmzone.h so that holes in the memmap which pass
> > pfn_valid in SPARSEMEM configurations can be detected and avoided.
> >
> > The fix to this problem checks that the pfn <-> page linkages are
> > correct by calculating the page for the pfn and then checking that
> > page_to_pfn on that page returns the original pfn. Unfortunately, in
> > SPARSEMEM configurations, this results in reading from the page flags to
> > determine the correct section. Since the memmap here has been freed,
> > junk is read from memory and the check is no longer robust.
> >
> > In the best case, reading from /proc/pagetypeinfo will give you the
> > wrong answer. In the worst case, you get SEGVs, Kernel OOPses and hung
> > CPUs.
> >
> > This patch allows architectures to provide their own pfn_valid function
> > instead of using the default implementation used by sparsemem. The
> > architecture-specific version is aware of the memmap state and will
> > return false when passed a pfn for a freed page within a valid section.
> >
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> I don't have an ARM machine to test on and I'm not particularly
> sensitive to the requirements of ARM so I'm not the best reviewer. If
> this passes tests, I see little problem with it other than the
> architecture-specific pfn_valid is slower than the sparsemem equivalent
> and the cache footprint is probably higher as memblock_is_memory
> is searching a list of blocks. 

Yes, it is slower than just checking to see if the sparsemem section is
valid but that is the price you pay for partially populated sections. At
the end of the day, we're just falling back to the pfn_valid definition
that is used when !CONFIG_SPARSEMEM.

> If this problem is exclusive to
> reading /proc/pagetypeinfo, you might want to consider only using
> memblock_is_memory in that case. Otherwise, functionally it looks like
> it should work.

I initially thought it was exclusive to that operation, but it turns out
the problem is more far-reaching as pfn_valid is used by things like the
ioremap code to ensure that we don't remap normal memory.

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index e56f835..72225dd 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -1053,12 +1053,14 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> >       return __nr_to_section(pfn_to_section_nr(pfn));
> >  }
> > 
> > +#ifndef CONFIG_ARCH_PROVIDES_PFN_VALID
> >  static inline int pfn_valid(unsigned long pfn)
> >  {
> >       if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
> >               return 0;
> >       return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
> >  }
> > +#endif
> > 
> >  static inline int pfn_present(unsigned long pfn)
> >  {

Can I add your Ack for the changes to mmzone.h please?

Thanks,

Will

