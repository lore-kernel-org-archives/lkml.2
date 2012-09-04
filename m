Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2IDWyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:54:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:57984 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab2IDWyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:54:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,369,1344236400"; 
   d="scan'208";a="188922157"
Subject: Re: [RFC PATCH 2/2] mm: Batch page_check_references in
 shrink_page_list sharing the same i_mmap_mutex
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@intel.com>
In-Reply-To: <1346772077.13492.267.camel@schen9-DESK>
References: <1345251998.13492.235.camel@schen9-DESK>
	 <1345480982.13492.239.camel@schen9-DESK>
	 <20120821132129.GC6960@linux.intel.com>
	 <1345596500.13492.264.camel@schen9-DESK>
	 <1346772077.13492.267.camel@schen9-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Sep 2012 15:54:19 -0700
Message-ID: <1346799259.13492.272.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-04 at 08:21 -0700, Tim Chen wrote:
> On Tue, 2012-08-21 at 17:48 -0700, Tim Chen wrote:
> 
> > 
> > Thanks to Matthew's suggestions on improving the patch. Here's the
> > updated version.  It seems to be sane when I booted my machine up.  I
> > will put it through more testing when I get a chance.
> > 
> > Tim
> > 
> 
> Matthew,
> 
> The new patch seems to be causing some of the workloads with mmaped file
> read to seg fault.  Will need to dig further to find out why.
> 
> Tim
> 

Okay, the problem seems to be the code below.  It is too restrictive and
causes some cases where the mutex needs to be taken in try_to_unmap_file
to be missed.

> > +int needs_page_mmap_mutex(struct page *page)
> > +{
> > +	return page->mapping && page_mapped(page) && page_rmapping(page) &&
> > +		!PageKsm(page) && !PageAnon(page);
> > +}
> > +

Changing the check to the following fixes the problem:

@@ -873,8 +873,7 @@ static int page_referenced_file(struct page *page,
 
 int needs_page_mmap_mutex(struct page *page)
 {
-       return page->mapping && page_mapped(page) && page_rmapping(page) &&
-               !PageKsm(page) && !PageAnon(page);
+       return page->mapping && !PageKsm(page) && !PageAnon(page);
 }

I'll do more testing and generate a second version of the patch set with the fixes.

Tim



