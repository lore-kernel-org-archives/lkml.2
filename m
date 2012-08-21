Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2HUWxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:53:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:22293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2HUWxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:53:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,804,1336374000"; 
   d="scan'208";a="189542485"
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
In-Reply-To: <20120821132129.GC6960@linux.intel.com>
References: <1345251998.13492.235.camel@schen9-DESK>
	 <1345480982.13492.239.camel@schen9-DESK>
	 <20120821132129.GC6960@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Aug 2012 15:53:01 -0700
Message-ID: <1345589581.13492.259.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 09:21 -0400, Matthew Wilcox wrote:

> 
> The only clunky bit would seem to be this bit:
> 
> >  		if (page_mapped(page) && mapping) {
> > -			switch (try_to_unmap(page, TTU_UNMAP)) {
> > +			switch (try_to_unmap(page, TTU_UNMAP,
> > +						mmap_mutex_locked)) {
> 
> Which I think has to look like this:
> 
> 		if (page_mapped(page) && mapping) {
> -			switch (try_to_unmap(page, TTU_UNMAP)) {
> +			int result;
> +			if (i_mmap_mutex)
> +				result = __try_to_unmap(page, TTU_UNMAP);
> +			else
> +				result = try_to_unmap(page, TTU_UNMAP);
> +			switch (result) {
> 

I think

-			switch (try_to_unmap(page, TTU_UNMAP)) {
+ 			switch (__try_to_unmap(page, TTU_UNMAP)) {

should be enough when your changes are adopted.  Because if the page
mmap mutex needs to be locked, we will have locked it here before
__try_to_unmap gets used.  

+               if (needs_page_mmap_mutex(page) &&
+                               i_mmap_mutex != &page->mapping->i_mmap_mutex) {
+                       if (i_mmap_mutex)
+                               mutex_unlock(i_mmap_mutex);
+                       i_mmap_mutex = &page->mapping->i_mmap_mutex;
+                       mutex_lock(i_mmap_mutex);
+               }


Tim

