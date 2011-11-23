Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1KWKic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:38:32 -0500
Received: from verein.lst.de ([213.95.11.211]:60613 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1KWKia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:38:30 -0500
Date: Wed, 23 Nov 2011 11:38:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/2] fs: wire up .truncate_range and .fallocate
Message-ID: <20111123103829.GA23168@lst.de>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com> <1322038412-29013-2-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322038412-29013-2-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 04:53:31PM +0800, Cong Wang wrote:
> +int vmtruncate_file_range(struct file *file, struct inode *inode,
> +		     loff_t lstart, loff_t lend)

We can always get the inode from file->f_path.dentry->d_inode, thus
passing both of them doesn't make much sense.

> +	if (!file->f_op->fallocate)
>  		return -ENOSYS;
>  
>  	mutex_lock(&inode->i_mutex);
>  	inode_dio_wait(inode);
>  	unmap_mapping_range(mapping, holebegin, holelen, 1);
> -	inode->i_op->truncate_range(inode, lstart, lend);
> +	mutex_unlock(&inode->i_mutex);
> +
> +	err = do_fallocate(file, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE,
> +		     holebegin, holelen);
> +	if (err)
> +		return err;
> +
> +	mutex_lock(&inode->i_mutex);
>  	/* unmap again to remove racily COWed private pages */
>  	unmap_mapping_range(mapping, holebegin, holelen, 1);
>  	mutex_unlock(&inode->i_mutex);

I suspect this should be turned inside out, just we do for normal
truncate.  That is instead of keeping vmtruncate(_file)_range we
should have a truncate_pagecache_range do to the actual zapping,
closely mirroring what we do for truncate.  In the best case we'd
even implement the regular truncate ones on top of the range version.

It also seems like all fallocate implementaions for far got away
without the unmap_mapping_range, so either people didn't test them
hard enough, or tmpfs doesn't need it either.  I fear the former
is true.

