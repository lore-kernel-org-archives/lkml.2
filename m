Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab1EaPxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:53:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37778 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab1EaPx3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:29 -0400
MIME-Version: 1.0
Message-ID: <ba74b4e5-500e-4662-ade0-c0b714b8f570@default>
Date: Tue, 31 May 2011 08:49:02 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chris.mason@oracle.com
Subject: RE: [PATCH 1/14] mm: invalidate_mapping_pages flush cleancache
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils
 alpine.LSU.2.00.1105301733500.5482@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1105301733500.5482@sister.anvils>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DE50ED4.00F8:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Hugh Dickins [mailto:hughd@google.com]
> Sent: Monday, May 30, 2011 6:36 PM
> To: Andrew Morton
> Cc: Dan Magenheimer; linux-kernel@vger.kernel.org; linux-mm@kvack.org
> Subject: [PATCH 1/14] mm: invalidate_mapping_pages flush cleancache
> 
> truncate_inode_pages_range() and invalidate_inode_pages2_range()
> call cleancache_flush_inode(mapping) before and after: shouldn't
> invalidate_mapping_pages() be doing the same?
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
> ---
>  mm/truncate.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux.orig/mm/truncate.c	2011-05-30 13:56:10.416798124 -0700
> +++ linux/mm/truncate.c	2011-05-30 14:08:46.612547848 -0700
> @@ -333,6 +333,7 @@ unsigned long invalidate_mapping_pages(s
>  	unsigned long count = 0;
>  	int i;
> 
> +	cleancache_flush_inode(mapping);
>  	pagevec_init(&pvec, 0);
>  	while (next <= end &&
>  			pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
> @@ -373,6 +374,7 @@ unsigned long invalidate_mapping_pages(s
>  		mem_cgroup_uncharge_end();
>  		cond_resched();
>  	}
> +	cleancache_flush_inode(mapping);
>  	return count;
>  }
>  EXPORT_SYMBOL(invalidate_mapping_pages);

Hi Hugh --

I don't claim to be an expert on VFS, and so I have cc'ed
Chris Mason who originally placed the cleancache hooks
in VFS, but I think this patch is unnecessary.  Instead
of flushing ALL of the cleancache pages belonging to
the inode with cleancache_flush_inode, the existing code
eventually calls __delete_from_page_cache on EACH page
that is being invalidated. And since __delete_from_page_cache
calls cleancache_flush_page, only that subset of pages
in the mapping that invalidate_mapping_pages() would
invalidate (which, from the comment above the routine
indicates, is only *unlocked* pages) is removed from
cleancache.

However, there may be some path through VFS I am missing
or something else subtle I am misunderstanding so please
clarify if either is true.

Thanks,
Dan
---
Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)

