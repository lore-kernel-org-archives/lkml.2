Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992498Ab2KAV5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:57:37 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45924 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab2KAV5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:57:33 -0400
Message-ID: <1351807050.2647.61.camel@lorien2>
Subject: Re: dma_mapping_error() interfaces
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: akpm@linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Thu, 01 Nov 2012 15:57:30 -0600
In-Reply-To: <20121031133939.GD27288@phenom.dumpdata.com>
References: <1351194980.2432.88.camel@lorien2>
	 <20121031133939.GD27288@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-31 at 09:39 -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 25, 2012 at 01:56:20PM -0600, Shuah Khan wrote:
> > I am working on changing dma_mapping_error() interfaces to add call to
> > debug_dma_mapping_error() interface. I found several dma_mapping_error()
> > defines in various arch specific dma-mapping.h files.
> > 
> > Majority of these arch specific defines look identical - simply
> > 
> > static inline int dma_mapping_error(struct device *dev, dma_ addr_t
> > dma_addr)
> > {
> >        struct dma_map_ops *dma_ops = get_dma_ops(dev);
> > 
> >        if (dma_ops->mapping_error)
> >                 return dma_ops->mapping_error(dev, dma_addr);
> > }
> > 
> > Maybe a generic dma_mapping_error() could be added to augment the
> > existing dma_map_page() and dma_map_single() generic interfaces in
> > include/asm-generic/dma-mapping-common.h (Future work)
> > 
> > For the most part, architecture specific
> > dma_map_page()/dma_map_single(), dma_unmap_page() interfaces are
> > implemented as a pair, however arch/m68k/include/asm/dma-mapping.h is an
> > exception. In this case generic dma_map_page()/dma_map_single() are
> > used, and arch specific dma_unmap_page() is defined. Couple of issues,
> > unmap routines do nothing. Maybe just fine for this architecture.
> 
> Could you CC the maintainer of said architecture and find out? Perhaps
> this was intended.. or just a bug.

Did more looking into this. I was wrong and it does defines arch
specific dma_map_page(), dma_map_single(), and dma_mapping_error()
interfaces. None of these call dma-debug at this time and there is no
need to change dma_mapping_error() to call debug_dma_mapping_error().

> 
> 
> > However, when dma_debug is enabled, debug is lopsided and debug entries
> > don't get releases.
> > 
> > For the present here is what I am planning to do:
> > 
> > Change dma_mapping_error() defines to add debug_dma_mapping_error() on
> > architectures that use the generic dma_map_page() and dma_map_single()
> > interfaces from include/asm-generic/dma-mapping-common.h to debug
> > inconsistency between invoking dma-debug at mapping time and missing
> > debug at error check time. Inconsistency will result in false warnings.
> > The following fall into this category.
> > 
> > arch/alpha/include/asm/dma-mapping.h
> > arch/arm/include/asm/dma-mapping.h
> > arch/arm64/include/asm/dma-mapping.h
> > arch/c6x/include/asm/dma-mapping.h
> > arch/frv/include/asm/dma-mapping.h
> > arch/hexagon/include/asm/dma-mapping.h
> > arch/ia64/include/asm/dma-mapping.h
> > arch/m68k/include/asm/dma-mapping.h
> > arch/microblaze/include/asm/dma-mapping.h
> > arch/mips/include/asm/dma-mapping.h
> > arch/powerpc/include/asm/dma-mapping.h
> > arch/sh/include/asm/dma-mapping.h
> > arch/sparc/include/asm/dma-mapping.h
> 
> Sounds good.

I did send arch patches last week tagging them for linux-next. I should
follow-up to see what is happening to them.

> > 
> > Leave dma_mapping_error() defines as is in arch header files that also
> > define dma_map_page() and dma_map_single() and not call
> > debug_dma_map_page() interface. The following fall into this category.
> > 
> > arch/avr32/include/asm/dma-mapping.h
> > arch/blackfin/include/asm/dma-mapping.h
> > arch/cris/include/asm/dma-mapping.h
> > arch/mn10300/include/asm/dma-mapping.h
> > arch/parisc/include/asm/dma-mapping.h
> > arch/xtensa/include/asm/dma-mapping.h
> 
> Any reason to skip those?

All of these define architecture specific dma interfaces and none of
them use dma debug at this time. Maybe something that could be enhanced,
however there is nothing to fix based on the change I made to add
debug_dma_mapping_error() to the dma-debug.

-- Shuah

