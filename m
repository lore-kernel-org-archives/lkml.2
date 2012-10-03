Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069Ab2JCQvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:51:22 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:18767
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965019Ab2JCQvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:51:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -8
X-BigFish: VPS-8(zz98dI1e84M1dbaI1432Izz1202h1d1ah1d2ahzz8275dhz2dh668h839h944hd25hd2bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
X-WSS-ID: 0MBBTHC-01-476-02
X-M-MSG: 
Date: Wed, 3 Oct 2012 11:51:06 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
Message-ID: <20121003165105.GA30214@jshin-Toonie>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
 <1348991844-12285-5-git-send-email-yinghai@kernel.org>
 <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 12:00:26PM +0100, Stefano Stabellini wrote:
> On Sun, 30 Sep 2012, Yinghai Lu wrote:
> > After
> > 
> > | commit 8548c84da2f47e71bbbe300f55edb768492575f7
> > | Author: Takashi Iwai <tiwai@suse.de>
> > | Date:   Sun Oct 23 23:19:12 2011 +0200
> > |
> > |    x86: Fix S4 regression
> > |
> > |    Commit 4b239f458 ("x86-64, mm: Put early page table high") causes a S4
> > |    regression since 2.6.39, namely the machine reboots occasionally at S4
> > |    resume.  It doesn't happen always, overall rate is about 1/20.  But,
> > |    like other bugs, once when this happens, it continues to happen.
> > |
> > |    This patch fixes the problem by essentially reverting the memory
> > |    assignment in the older way.
> > 
> > Have some page table around 512M again, that will prevent kdump to find 512M
> > under 768M.
> > 
> > We need revert that reverting, so we could put page table high again for 64bit.
> > 
> > Takashi agreed that S4 regression could be something else.
> > 
> > 	https://lkml.org/lkml/2012/6/15/182
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > ---
> >  arch/x86/mm/init.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> > index 9f69180..aadb154 100644
> > --- a/arch/x86/mm/init.c
> > +++ b/arch/x86/mm/init.c
> > @@ -76,8 +76,8 @@ static void __init find_early_table_space(struct map_range *mr,
> >  #ifdef CONFIG_X86_32
> >  	/* for fixmap */
> >  	tables += roundup(__end_of_fixed_addresses * sizeof(pte_t), PAGE_SIZE);
> > -#endif
> >  	good_end = max_pfn_mapped << PAGE_SHIFT;
> > +#endif
> >  
> >  	base = memblock_find_in_range(start, good_end, tables, PAGE_SIZE);
> >  	if (!base)
> 
> Isn't this going to cause init_memory_mapping to allocate pagetable
> pages from memory not yet mapped?
> Last time I spoke with HPA and Thomas about this, they seem to agree
> that it isn't a very good idea.
> Also, it is proven to cause a certain amount of headaches on Xen,
> see commit d8aa5ec3382e6a545b8f25178d1e0992d4927f19.
> 

Any comments, thoughts? hpa? Yinghai?

So it seems that during init_memory_mapping Xen needs to modify page table 
bits and the memory where the page tables live needs to be direct mapped at
that time.

Since we now call init_memory_mapping for every E820_RAM range sequencially,
the only way to satisfy Xen is to find_early_page_table_space (good_end needs
to be within memory already mapped at the time) for every init_memory_mapping
call.

What do you think Yinghai?

