Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0EMAX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 20:23:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38980 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab0EMAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 20:23:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 13 May 2010 09:19:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
Message-Id: <20100513091930.9b42e3b8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1005121627020.1273@router.home>
References: <20100511085752.GM26611@csn.ul.ie>
	<20100512092239.2120.A69D9226@jp.fujitsu.com>
	<20100512125427.d1b170ba.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1005121627020.1273@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 16:33:12 -0500 (CDT)
Christoph Lameter <cl@linux.com> wrote:

> 
> Still think this special casing is not that good.
> 
> One can also disable migration by providing a migration function that
> always fails. One such function exists in mm/migrate.c:
> 
> /* Always fail migration. Used for mappings that are not movable */
> int fail_migrate_page(struct address_space *mapping,
>                         struct page *newpage, struct page *page)
> {
>         return -EIO;
> }
> EXPORT_SYMBOL(fail_migrate_page);
> 
> 
> The migration function is specified in
> 
> vma->vm_ops->migrate
> 
> If that is set to fail_migrate_page() then the pages in the vma will never
> be migrated. XFS uses it f.e. to avoid page migration:
> 
> STATIC int
> xfs_mapping_buftarg(
>         xfs_buftarg_t           *btp,
>         struct block_device     *bdev)
> {
>         struct backing_dev_info *bdi;
>         struct inode            *inode;
>         struct address_space    *mapping;
>         static const struct address_space_operations mapping_aops = {
>                 .sync_page = block_sync_page,
>                 .migratepage = fail_migrate_page,
>         };
> 
> 
> 
> Would it not be possible to do something similar for the temporary stack?
> 

Problem here is unmap->remap. ->migratepage() function is used as

	unmap 
	   -> migratepage() 
	      -> failed 
		-> remap

Then, migratepage() itself is no help. We need some check-callback before unmap
or lock to wait for an event we can make remapping progress.

Thanks,
-Kame


