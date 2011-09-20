Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1ITN5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab1ITN5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:57:14 -0400
Date: Tue, 20 Sep 2011 15:56:31 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>
Subject: Re: [patch 4/4] Btrfs: pass __GFP_WRITE for buffered write page
 allocations
Message-ID: <20110920135631.GB16338@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
 <1316526315-16801-5-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316526315-16801-5-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:45:15PM +0200, Johannes Weiner wrote:
> Tell the page allocator that pages allocated for a buffered write are
> expected to become dirty soon.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> ---
>  fs/btrfs/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e7872e4..ea1b892 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1084,7 +1084,7 @@ static noinline int prepare_pages(struct btrfs_root *root, struct file *file,
>  again:
>  	for (i = 0; i < num_pages; i++) {
>  		pages[i] = find_or_create_page(inode->i_mapping, index + i,
> -					       GFP_NOFS);
> +					       GFP_NOFS | __GFP_WRITE);

Btw and unrelated to this particular series, I think this should use
grab_cache_page_write_begin() in the first place.

Most grab_cache_page calls were replaced recently (a94733d "Btrfs: use
find_or_create_page instead of grab_cache_page") to be able to pass
GFP_NOFS, but the pages are now also no longer __GFP_HIGHMEM and
__GFP_MOVABLE, which irks both x86_32 and memory hotplug.

It might be better to change grab_cache_page instead to take a flags
argument that allows passing AOP_FLAG_NOFS and revert the sites back
to this helper?
