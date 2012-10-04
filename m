Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2JDMtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:49:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40314 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab2JDMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:49:05 -0400
Date: Thu, 4 Oct 2012 08:49:35 -0400
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/6] ARM: davinci: sram: ioremap the davinci_soc_info
 specified sram regions
Message-ID: <20121004124935.GD11149@beef>
References: <1349276133-26408-1-git-send-email-mporter@ti.com>
 <1349276133-26408-2-git-send-email-mporter@ti.com>
 <506D7799.2090307@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506D7799.2090307@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 05:18:41PM +0530, Sekhar Nori wrote:
> On 10/3/2012 8:25 PM, Matt Porter wrote:
> > From: Ben Gardiner <bengardiner@nanometrics.ca>
> > 
> > The current davinci init sets up SRAM in iotables. There has been an observed
> > failure to boot a da850 with 128K specified in the iotable.
> > 
> > Make the davinci sram allocator -- now based on RMK's consolidated SRAM
> > support -- do an ioremap of the region specified by the entries in
> 
> The part about being based on RMK's consolidated SRAM support should be
> dropped.

Ok, cruft from trying to preserve Ben's original patch comments. Will
remove.

 
> > davinci_soc_info before registering with gen_pool_add_virt().
> > 
> > This commit breaks runtime of davinci boards since the regions that
> > the sram init is now trying to ioremap have been iomapped by their
> > iotable entries. The iotable entries will be removed in the patches
> > to come.
> 
> I would prefer merging 2/6 into this for this reason.

Ok, makes sense. This again comes from me trying to just use the
original patches. I'll squash these together for v4.

> 
> > 
> > Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
> > [rebased to mainline as the consolidated SRAM support was dropped]
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/mach-davinci/sram.c |   17 ++++++++++++++---
> >  1 file changed, 14 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
> > index db0f778..0e8ca4f 100644
> > --- a/arch/arm/mach-davinci/sram.c
> > +++ b/arch/arm/mach-davinci/sram.c
> > @@ -10,6 +10,7 @@
> >   */
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> > +#include <linux/io.h>
> >  #include <linux/genalloc.h>
> >  
> >  #include <mach/common.h>
> > @@ -32,7 +33,7 @@ void *sram_alloc(size_t len, dma_addr_t *dma)
> >  		return NULL;
> >  
> >  	if (dma)
> > -		*dma = dma_base + (vaddr - SRAM_VIRT);
> > +		*dma = gen_pool_virt_to_phys(sram_pool, vaddr);
> >  	return (void *)vaddr;
> >  
> >  }
> > @@ -53,8 +54,10 @@ EXPORT_SYMBOL(sram_free);
> >   */
> >  static int __init sram_init(void)
> >  {
> > +	phys_addr_t phys = davinci_soc_info.sram_dma;
> >  	unsigned len = davinci_soc_info.sram_len;
> >  	int status = 0;
> > +	void *addr;
> >  
> >  	if (len) {
> >  		len = min_t(unsigned, len, SRAM_SIZE);
> > @@ -62,8 +65,16 @@ static int __init sram_init(void)
> >  		if (!sram_pool)
> >  			status = -ENOMEM;
> >  	}
> > -	if (sram_pool)
> > -		status = gen_pool_add(sram_pool, SRAM_VIRT, len, -1);
> > +
> > +	if (sram_pool) {
> > +		addr = ioremap(phys, len);
> > +		if (!addr)
> > +			return -ENOMEM;
> > +		if((status = gen_pool_add_virt(sram_pool, (unsigned)addr,
> > +					       phys, len, -1)))
> 
> Nit: prefer to set status outside of if().

Ok. Will change.

> 
> Looks good otherwise. Thanks for reviving this.

No problem, I'm just glad we seem to have a workable solution now.

Also, if you could check the conversation with Phillip about
gen_pool_find_by_phys(), I wonder what you think about depending on that
now, or waiting to convert to it when it goes upstream.

I'm torn as I see all the pdata going away anyway when Davinci is fully
converted to DT, and then also any use of find_by_phys() would go away
in favor of using the of helpers with his driver.

-Matt
