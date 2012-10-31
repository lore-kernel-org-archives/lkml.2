Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709Ab2JaNwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:52:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab2JaNwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:52:18 -0400
Date: Wed, 31 Oct 2012 09:39:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: akpm@linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Subject: Re: dma_mapping_error() interfaces
Message-ID: <20121031133939.GD27288@phenom.dumpdata.com>
References: <1351194980.2432.88.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351194980.2432.88.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 01:56:20PM -0600, Shuah Khan wrote:
> I am working on changing dma_mapping_error() interfaces to add call to
> debug_dma_mapping_error() interface. I found several dma_mapping_error()
> defines in various arch specific dma-mapping.h files.
> 
> Majority of these arch specific defines look identical - simply
> 
> static inline int dma_mapping_error(struct device *dev, dma_ addr_t
> dma_addr)
> {
>        struct dma_map_ops *dma_ops = get_dma_ops(dev);
> 
>        if (dma_ops->mapping_error)
>                 return dma_ops->mapping_error(dev, dma_addr);
> }
> 
> Maybe a generic dma_mapping_error() could be added to augment the
> existing dma_map_page() and dma_map_single() generic interfaces in
> include/asm-generic/dma-mapping-common.h (Future work)
> 
> For the most part, architecture specific
> dma_map_page()/dma_map_single(), dma_unmap_page() interfaces are
> implemented as a pair, however arch/m68k/include/asm/dma-mapping.h is an
> exception. In this case generic dma_map_page()/dma_map_single() are
> used, and arch specific dma_unmap_page() is defined. Couple of issues,
> unmap routines do nothing. Maybe just fine for this architecture.

Could you CC the maintainer of said architecture and find out? Perhaps
this was intended.. or just a bug.


> However, when dma_debug is enabled, debug is lopsided and debug entries
> don't get releases.
> 
> For the present here is what I am planning to do:
> 
> Change dma_mapping_error() defines to add debug_dma_mapping_error() on
> architectures that use the generic dma_map_page() and dma_map_single()
> interfaces from include/asm-generic/dma-mapping-common.h to debug
> inconsistency between invoking dma-debug at mapping time and missing
> debug at error check time. Inconsistency will result in false warnings.
> The following fall into this category.
> 
> arch/alpha/include/asm/dma-mapping.h
> arch/arm/include/asm/dma-mapping.h
> arch/arm64/include/asm/dma-mapping.h
> arch/c6x/include/asm/dma-mapping.h
> arch/frv/include/asm/dma-mapping.h
> arch/hexagon/include/asm/dma-mapping.h
> arch/ia64/include/asm/dma-mapping.h
> arch/m68k/include/asm/dma-mapping.h
> arch/microblaze/include/asm/dma-mapping.h
> arch/mips/include/asm/dma-mapping.h
> arch/powerpc/include/asm/dma-mapping.h
> arch/sh/include/asm/dma-mapping.h
> arch/sparc/include/asm/dma-mapping.h

Sounds good.
> 
> Leave dma_mapping_error() defines as is in arch header files that also
> define dma_map_page() and dma_map_single() and not call
> debug_dma_map_page() interface. The following fall into this category.
> 
> arch/avr32/include/asm/dma-mapping.h
> arch/blackfin/include/asm/dma-mapping.h
> arch/cris/include/asm/dma-mapping.h
> arch/mn10300/include/asm/dma-mapping.h
> arch/parisc/include/asm/dma-mapping.h
> arch/xtensa/include/asm/dma-mapping.h

Any reason to skip those?

> 
> - There is this inconsistency now with the debug_dma_mapping_error()
> interface in linux-next. If this is unacceptable, I will send a patch
> that marks dma debug entries checked for mapping errors in the interim
> (an easy change to initialize the flag to have been checked) while I get
> the existing dma_mapping_error() interface patches done.
> 
> Comments, concerns.
> 
> Thanks,
> -- Shuah
> 
> 
> 
> - 
> 
