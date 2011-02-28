Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab1B1JxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 04:53:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:56667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1B1JxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 04:53:18 -0500
Date: Mon, 28 Feb 2011 10:53:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM v4
Message-ID: <20110228095316.GC4648@tiehlicka.suse.cz>
References: <20110223151047.GA7275@tiehlicka.suse.cz>
 <1298485162.7236.4.camel@nimitz>
 <20110224134045.GA22122@tiehlicka.suse.cz>
 <20110225122522.8c4f1057.kamezawa.hiroyu@jp.fujitsu.com>
 <20110225095357.GA23241@tiehlicka.suse.cz>
 <20110228095347.7510b1d4.kamezawa.hiroyu@jp.fujitsu.com>
 <20110228091256.GA4648@tiehlicka.suse.cz>
 <20110228182322.a34cc1fd.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228182322.a34cc1fd.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-02-11 18:23:22, KAMEZAWA Hiroyuki wrote:
[...]
> > From 84a9555741b59cb2a0a67b023e4bd0f92c670ca1 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Thu, 24 Feb 2011 11:25:44 +0100
> > Subject: [PATCH] page_cgroup: Reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM
> > 
> > Currently we are allocating a single page_cgroup array per memory
> > section (stored in mem_section->base) when CONFIG_SPARSEMEM is selected.
> > This is correct but memory inefficient solution because the allocated
> > memory (unless we fall back to vmalloc) is not kmalloc friendly:
> >         - 32b - 16384 entries (20B per entry) fit into 327680B so the
> >           524288B slab cache is used
> >         - 32b with PAE - 131072 entries with 2621440B fit into 4194304B
> >         - 64b - 32768 entries (40B per entry) fit into 2097152 cache
> > 
> > This is ~37% wasted space per memory section and it sumps up for the
> > whole memory. On a x86_64 machine it is something like 6MB per 1GB of
> > RAM.
> > 
> > We can reduce the internal fragmentation by using alloc_pages_exact
> > which allocates PAGE_SIZE aligned blocks so we will get down to <4kB
> > wasted memory per section which is much better.
> > 
> > We still need a fallback to vmalloc because we have no guarantees that
> > we will have a continuous memory of that size (order-10) later on during
> > the hotplug events.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > CC: Dave Hansen <dave@linux.vnet.ibm.com>
> > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks. I will repost it with Andrew in the CC.

> 
> But...nitpick, it may be from my fault..
[...]
> > +static void free_page_cgroup(void *addr)
> > +{
> > +	if (is_vmalloc_addr(addr)) {
> > +		vfree(addr);
> > +	} else {
> > +		struct page *page = virt_to_page(addr);
> > +		if (!PageReserved(page)) { /* Is bootmem ? */
> 
> I think we never see PageReserved if we just use alloc_pages_exact()/vmalloc().

I have checked that and we really do not (unless I am missing some
subtle side effects). Anyway, I think we still should at least BUG_ON on
that.

> Maybe my old patch was not enough and this kind of junks are remaining in
> the original code.

Should I incorporate it into the patch. I think that a separate one
would be better for readability.

---
>From e7a897a42b526620eb4afada2d036e1c9ff9e62a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 28 Feb 2011 10:43:12 +0100
Subject: [PATCH] page_cgroup array is never stored on reserved pages

KAMEZAWA Hiroyuki noted that free_pages_cgroup doesn't have to check for
PageReserved because we never store the array on reserved pages
(neither alloc_pages_exact nor vmalloc use those pages).

So we can replace the check by a BUG_ON.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/page_cgroup.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index eae3cd2..dd5f789 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -125,10 +125,10 @@ static void free_page_cgroup(void *addr)
 		vfree(addr);
 	} else {
 		struct page *page = virt_to_page(addr);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			size_t table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-			free_pages_exact(addr, table_size);
-		}
+		size_t table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+
+		BUG_ON(PageReserved(page));
+		free_pages_exact(addr, table_size);
 	}
 }
 
-- 
1.7.2.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
