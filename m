Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab0G0ISs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:18:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36717 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0G0ISo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:18:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Jul 2010 17:13:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Milton Miller <miltonm@bga.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v4
Message-Id: <20100727171351.98d5fb60.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <pfn.valid.v4.reply.2@mdm.bga.com>
References: <1280159163-23386-1-git-send-email-minchan.kim@gmail.com>
	<alpine.DEB.2.00.1007261136160.5438@router.home>
	<pfn.valid.v4.reply.1@mdm.bga.com>
	<AANLkTimtTVvorrR9pDVTyPKj0HbYOYY3aR7B-QWGhTei@mail.gmail.com>
	<pfn.valid.v4.reply.2@mdm.bga.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 03:12:38 -0500
Milton Miller <miltonm@bga.com> wrote:

> > > > > +/*
> > > > > + * Fill pg->private on valid mem_map with page itself.
> > > > > + * pfn_valid() will check this later. (see include/linux/mmzone.h)
> > > > > + * Every arch for supporting hole of mem_map should call
> > > > > + * mark_valid_memmap(start, end). please see usage in ARM.
> > > > > + */
> > > > > +void mark_valid_memmap(unsigned long start, unsigned long end)
> > > > > +{
> > > > > +	struct mem_section *ms;
> > > > > +	unsigned long pos, next;
> > > > > +	struct page *pg;
> > > > > +	void *memmap, *mapend;
> > > > > +
> > > > > +	for (pos = start; pos < end; pos = next) {
> > > > > +		next = (pos + PAGES_PER_SECTION) & PAGE_SECTION_MASK;
> > > > > +		ms = __pfn_to_section(pos);
> > > > > +		if (!valid_section(ms))
> > > > > +			continue;
> > > > > +	
> > > > > +		for (memmap = (void*)pfn_to_page(pos),
> > > > > +					/* The last page in section */
> > > > > +					mapend = pfn_to_page(next-1);
> > > > > +				memmap < mapend; memmap += PAGE_SIZE) {
> > > > > +			pg = virt_to_page(memmap);
> > > > > +			set_page_private(pg, (unsigned long)pg);
> > > > > +		}
> > > > > +	}
> > > > > +}
> 
> Hmm, this loop would need to change for sections.   And sizeof(struct
> page) % PAGE_SIZE may not be 0, so we want a global symbol for sparsemem
> too. 
IIUC, sizeof(struct page) % PAGE_SIZE is not a probelm.


> Perhaps the mem_section array.  Using a symbol that is part of
> the model pre-checks can remove a global symbol lookup and has the side
> effect of making sure our pfn_valid is for the right model.
> 

But yes, maybe it's good to make use of a fixed-(magic)-value.


Tanks,
-Kame



