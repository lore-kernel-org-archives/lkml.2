Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab1DZGeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 02:34:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:33668 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489Ab1DZGeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 02:34:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="914422667"
Date: Tue, 26 Apr 2011 14:34:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Subject: Re: readahead and oom
Message-ID: <20110426063421.GC19717@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
 <20110426055521.GA18473@localhost>
 <BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
 <BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
 <20110426062535.GB19717@localhost>
 <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:29:15PM +0800, Dave Young wrote:
> On Tue, Apr 26, 2011 at 2:25 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Tue, Apr 26, 2011 at 02:07:17PM +0800, Dave Young wrote:
> >> On Tue, Apr 26, 2011 at 2:05 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> >> > On Tue, Apr 26, 2011 at 1:55 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> >> >> On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
> >> >>> Hi,
> >> >>>
> >> >>> When memory pressure is high, readahead could cause oom killing.
> >> >>> IMHO we should stop readaheading under such circumstances。If it's true
> >> >>> how to fix it?
> >> >>
> >> >> Good question. Before OOM there will be readahead thrashings, which
> >> >> can be addressed by this patch:
> >> >>
> >> >> http://lkml.org/lkml/2010/2/2/229
> >> >
> >> > Hi, I'm not clear about the patch, could be regard as below cases?
> >> > 1) readahead alloc fail due to low memory such as other large allocation
> >>
> >> For example vm balloon allocate lots of memory, then readahead could
> >> fail immediately and then oom
> >
> > If true, that would be the problem of vm balloon. It's not good to
> > consume lots of memory all of a sudden, which will likely impact lots
> > of kernel subsystems.
> >
> > btw readahead page allocations are completely optional. They are OK to
> > fail and in theory shall not trigger OOM on themselves. We may
> > consider passing __GFP_NORETRY for readahead page allocations.
> 
> Good idea, care to submit a patch?

Here it is :)

Thanks,
Fengguang
---
readahead: readahead page allocations is OK to fail

Pass __GFP_NORETRY for readahead page allocations.

readahead page allocations are completely optional. They are OK to
fail and in particular shall not trigger OOM on themselves.

Reported-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/pagemap.h |    5 +++++
 mm/readahead.c          |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- linux-next.orig/include/linux/pagemap.h	2011-04-26 14:27:46.000000000 +0800
+++ linux-next/include/linux/pagemap.h	2011-04-26 14:29:31.000000000 +0800
@@ -219,6 +219,11 @@ static inline struct page *page_cache_al
 	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD);
 }
 
+static inline struct page *page_cache_alloc_cold_noretry(struct address_space *x)
+{
+	return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD|__GFP_NORETRY);
+}
+
 typedef int filler_t(void *, struct page *);
 
 extern struct page * find_get_page(struct address_space *mapping,
--- linux-next.orig/mm/readahead.c	2011-04-26 14:27:02.000000000 +0800
+++ linux-next/mm/readahead.c	2011-04-26 14:27:24.000000000 +0800
@@ -180,7 +180,7 @@ __do_page_cache_readahead(struct address
 		if (page)
 			continue;
 
-		page = page_cache_alloc_cold(mapping);
+		page = page_cache_alloc_cold_noretry(mapping);
 		if (!page)
 			break;
 		page->index = page_offset;
