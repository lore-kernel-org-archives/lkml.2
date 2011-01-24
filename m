Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1AXVH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:07:56 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:60105 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486Ab1AXVHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:07:54 -0500
Date: Mon, 24 Jan 2011 22:07:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Yoichi Yuasa <yuasa@linux-mips.org>,
        linux-mips <linux-mips@linux-mips.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix build error when CONFIG_SWAP is not set
Message-ID: <20110124210752.GA10819@merkur.ravnborg.org>
References: <20110124210813.ba743fc5.yuasa@linux-mips.org> <4D3DD366.8000704@mvista.com> <20110124124412.69a7c814.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124124412.69a7c814.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 12:44:12PM -0800, Andrew Morton wrote:
> On Mon, 24 Jan 2011 22:30:46 +0300
> Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> 
> > Hello.
> > 
> > Yoichi Yuasa wrote:
> > 
> > > In file included from
> > > linux-2.6/arch/mips/include/asm/tlb.h:21,
> > >                  from mm/pgtable-generic.c:9:
> > > include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> > > include/asm-generic/tlb.h:76: error: implicit declaration of function
> > > 'release_pages'
> > > include/asm-generic/tlb.h: In function 'tlb_remove_page':
> > > include/asm-generic/tlb.h:105: error: implicit declaration of function
> > > 'page_cache_release'
> > > make[1]: *** [mm/pgtable-generic.o] Error 1
> > > 
> > > Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
> > [...]
> > 
> > > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > > index 4d55932..92c1be6 100644
> > > --- a/include/linux/swap.h
> > > +++ b/include/linux/swap.h
> > > @@ -8,6 +8,7 @@
> > >  #include <linux/memcontrol.h>
> > >  #include <linux/sched.h>
> > >  #include <linux/node.h>
> > > +#include <linux/pagemap.h>
> > 
> >     Hm, if the errors are in <asm-generic/tlb.h>, why add #include in 
> > <linux/swap.h>?
> > 
> 
> The build error is caused by macros which are defined in swap.h.
> 
> I worry about the effects of the patch - I don't know which of swap.h
> and pagemap.h is the "innermost" header file.  There's potential for
> new build errors due to strange inclusion graphs.
> 
> err, there's also this, in swap.h:
> 
> /* only sparc can not include linux/pagemap.h in this file
>  * so leave page_cache_release and release_pages undeclared... */

I just checked.
sparc32 with a defconfig barfed out like this:
  CC      arch/sparc/kernel/traps_32.o
In file included from /home/sam/kernel/linux-2.6.git/include/linux/pagemap.h:7:0,
                 from /home/sam/kernel/linux-2.6.git/include/linux/swap.h:11,
                 from /home/sam/kernel/linux-2.6.git/arch/sparc/include/asm/pgtable_32.h:15,
                 from /home/sam/kernel/linux-2.6.git/arch/sparc/include/asm/pgtable.h:6,
                 from /home/sam/kernel/linux-2.6.git/arch/sparc/kernel/traps_32.c:23:
/home/sam/kernel/linux-2.6.git/include/linux/mm.h: In function 'is_vmalloc_addr':
/home/sam/kernel/linux-2.6.git/include/linux/mm.h:301:17: error: 'VMALLOC_START' undeclared (first use in this function)
/home/sam/kernel/linux-2.6.git/include/linux/mm.h:301:17: note: each undeclared identifier is reported only once for each function it appears in
/home/sam/kernel/linux-2.6.git/include/linux/mm.h:301:41: error: 'VMALLOC_END' undeclared (first use in this function)
/home/sam/kernel/linux-2.6.git/include/linux/mm.h: In function 'maybe_mkwrite':
/home/sam/kernel/linux-2.6.git/include/linux/mm.h:483:3: error: implicit declaration of function 'pte_mkwrite'

When I removed the include it could build again.

	Sam
