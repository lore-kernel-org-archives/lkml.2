Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0ICHyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:54:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426Ab0ICHyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:54:45 -0400
Date: Fri, 3 Sep 2010 09:54:38 +0200
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2 v2] Make is_mem_section_removable more conformable
 with offlining code
Message-ID: <20100903075437.GB10686@tiehlicka.suse.cz>
References: <20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
 <20100902082829.GA10265@tiehlicka.suse.cz>
 <20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
 <20100902092454.GA17971@tiehlicka.suse.cz>
 <AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
 <20100902131855.GC10265@tiehlicka.suse.cz>
 <AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
 <20100902143939.GD10265@tiehlicka.suse.cz>
 <20100902150554.GE10265@tiehlicka.suse.cz>
 <20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 03-09-10 12:10:03, KAMEZAWA Hiroyuki wrote:
> On Thu, 2 Sep 2010 17:05:54 +0200
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> >  extern int mem_online_node(int nid);
> > diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> > index a4cfcdc..2b736ed 100644
> > --- a/mm/memory_hotplug.c
> > +++ b/mm/memory_hotplug.c
> > @@ -569,16 +569,25 @@ out:
> >  EXPORT_SYMBOL_GPL(add_memory);
> >  
> >  #ifdef CONFIG_MEMORY_HOTREMOVE
> > +
> >  /*
> > - * A free page on the buddy free lists (not the per-cpu lists) has PageBuddy
> > - * set and the size of the free page is given by page_order(). Using this,
> > - * the function determines if the pageblock contains only free pages.
> > - * Due to buddy contraints, a free page at least the size of a pageblock will
> > - * be located at the start of the pageblock
> > + * A free or LRU pages block are removable
> > + * Do not use MIGRATE_MOVABLE because it can be insufficient and
> > + * other MIGRATE types are tricky.
> >   */
> > -static inline int pageblock_free(struct page *page)
> > -{
> > -	return PageBuddy(page) && page_order(page) >= pageblock_order;
> > +bool is_page_removable(struct page *page)
> > +{
> > +	int page_block = 1 << pageblock_order;
> > +	while (page_block > 0) {
> > +		if (PageBuddy(page)) {
> > +			page_block -= page_order(page);
> > +		} else if (PageLRU(page))
> > +			page_block--;
> > +		else 
> > +			return false;
> > +	}
> 
> still seems wrong..."page" pointer should be updated.

You are right. I should have double checked that (never send patches
before leaving from the office...).

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
