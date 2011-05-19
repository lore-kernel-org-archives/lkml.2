Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab1ESJXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:23:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab1ESJXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:23:36 -0400
Date: Thu, 19 May 2011 10:23:33 +0100
From: Mel Gorman <mgorman@suse.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: sparsemem: allow pfn_valid to be overridden when
 using SPARSEMEM
Message-ID: <20110519092333.GU5279@suse.de>
References: <1305734639-6561-1-git-send-email-will.deacon@arm.com>
 <20110518165910.GS5279@suse.de>
 <1305795317.29560.9.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1305795317.29560.9.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 09:55:17AM +0100, Will Deacon wrote:
> Hi Mel,
> 
> Thanks for looking at this.
> 
> On Wed, 2011-05-18 at 17:59 +0100, Mel Gorman wrote:
> > On Wed, May 18, 2011 at 05:03:59PM +0100, Will Deacon wrote:
> > > In commit eb33575c ("[ARM] Double check memmap is actually valid with a
> > > memmap has unexpected holes V2"), a new function, memmap_valid_within,
> > > was introduced to mmzone.h so that holes in the memmap which pass
> > > pfn_valid in SPARSEMEM configurations can be detected and avoided.
> > >
> > > The fix to this problem checks that the pfn <-> page linkages are
> > > correct by calculating the page for the pfn and then checking that
> > > page_to_pfn on that page returns the original pfn. Unfortunately, in
> > > SPARSEMEM configurations, this results in reading from the page flags to
> > > determine the correct section. Since the memmap here has been freed,
> > > junk is read from memory and the check is no longer robust.
> > >
> > > In the best case, reading from /proc/pagetypeinfo will give you the
> > > wrong answer. In the worst case, you get SEGVs, Kernel OOPses and hung
> > > CPUs.
> > >
> > > This patch allows architectures to provide their own pfn_valid function
> > > instead of using the default implementation used by sparsemem. The
> > > architecture-specific version is aware of the memmap state and will
> > > return false when passed a pfn for a freed page within a valid section.
> > >
> > > Cc: Russell King <linux@arm.linux.org.uk>
> > > Cc: Mel Gorman <mgorman@suse.de>
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > 
> > I don't have an ARM machine to test on and I'm not particularly
> > sensitive to the requirements of ARM so I'm not the best reviewer. If
> > this passes tests, I see little problem with it other than the
> > architecture-specific pfn_valid is slower than the sparsemem equivalent
> > and the cache footprint is probably higher as memblock_is_memory
> > is searching a list of blocks. 
> 
> Yes, it is slower than just checking to see if the sparsemem section is
> valid but that is the price you pay for partially populated sections. At
> the end of the day, we're just falling back to the pfn_valid definition
> that is used when !CONFIG_SPARSEMEM.
> 

Ok.

> > If this problem is exclusive to
> > reading /proc/pagetypeinfo, you might want to consider only using
> > memblock_is_memory in that case. Otherwise, functionally it looks like
> > it should work.
> 
> I initially thought it was exclusive to that operation, but it turns out
> the problem is more far-reaching as pfn_valid is used by things like the
> ioremap code to ensure that we don't remap normal memory.
> 

That would justify it. Might want to stick that into the changelog
because we'll forget it and someone will "fix" it :)

> > > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > > index e56f835..72225dd 100644
> > > --- a/include/linux/mmzone.h
> > > +++ b/include/linux/mmzone.h
> > > @@ -1053,12 +1053,14 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> > >       return __nr_to_section(pfn_to_section_nr(pfn));
> > >  }
> > > 
> > > +#ifndef CONFIG_ARCH_PROVIDES_PFN_VALID
> > >  static inline int pfn_valid(unsigned long pfn)
> > >  {
> > >       if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
> > >               return 0;
> > >       return valid_section(__nr_to_section(pfn_to_section_nr(pfn)));
> > >  }
> > > +#endif
> > > 
> > >  static inline int pfn_present(unsigned long pfn)
> > >  {
> 
> Can I add your Ack for the changes to mmzone.h please?
> 

Minor nit on the name but it'd be nice if it was simile to
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID as they are both related to the
memory model. Whether you do it or not in a v2, I'll ack the mmzone.h
change;

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
