Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216Ab0ELVfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:35:01 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:50356 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab0ELVex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:34:53 -0400
Date: Wed, 12 May 2010 16:33:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm,migration: Avoid race between shift_arg_pages() and
 rmap_walk() during migration by not migrating temporary stacks
In-Reply-To: <20100512125427.d1b170ba.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1005121627020.1273@router.home>
References: <20100511085752.GM26611@csn.ul.ie> <20100512092239.2120.A69D9226@jp.fujitsu.com> <20100512125427.d1b170ba.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Still think this special casing is not that good.

One can also disable migration by providing a migration function that
always fails. One such function exists in mm/migrate.c:

/* Always fail migration. Used for mappings that are not movable */
int fail_migrate_page(struct address_space *mapping,
                        struct page *newpage, struct page *page)
{
        return -EIO;
}
EXPORT_SYMBOL(fail_migrate_page);


The migration function is specified in

vma->vm_ops->migrate

If that is set to fail_migrate_page() then the pages in the vma will never
be migrated. XFS uses it f.e. to avoid page migration:

STATIC int
xfs_mapping_buftarg(
        xfs_buftarg_t           *btp,
        struct block_device     *bdev)
{
        struct backing_dev_info *bdi;
        struct inode            *inode;
        struct address_space    *mapping;
        static const struct address_space_operations mapping_aops = {
                .sync_page = block_sync_page,
                .migratepage = fail_migrate_page,
        };



Would it not be possible to do something similar for the temporary stack?
