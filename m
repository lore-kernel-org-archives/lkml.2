Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab0LMVBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:01:49 -0500
Received: from mx2.netapp.com ([216.240.18.37]:27972 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0LMVBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:01:47 -0500
X-IronPort-AV: E=Sophos;i="4.59,337,1288594800"; 
   d="scan'208";a="494421510"
Subject: Re: [PATCH 31/35] nfs: dont change wbc->nr_to_write in
 write_inode()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101213150330.076517282@intel.com>
References: <20101213144646.341970461@intel.com>
	 <20101213150330.076517282@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Mon, 13 Dec 2010 16:01:44 -0500
Message-ID: <1292274104.8795.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 13 Dec 2010 21:01:46.0412 (UTC) FILETIME=[F3E536C0:01CB9B08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 22:47 +0800, Wu Fengguang wrote:
> plain text document attachment
> (writeback-nfs-commit-remove-nr_to_write.patch)
> It's introduced in commit 420e3646 ("NFS: Reduce the number of
> unnecessary COMMIT calls") and seems not necessary.
> 
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/nfs/write.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> --- linux-next.orig/fs/nfs/write.c	2010-12-13 21:46:21.000000000 +0800
> +++ linux-next/fs/nfs/write.c	2010-12-13 21:46:22.000000000 +0800
> @@ -1557,15 +1557,8 @@ static int nfs_commit_unstable_pages(str
>  	}
>  
>  	ret = nfs_commit_inode(inode, flags);
> -	if (ret >= 0) {
> -		if (wbc->sync_mode == WB_SYNC_NONE) {
> -			if (ret < wbc->nr_to_write)
> -				wbc->nr_to_write -= ret;
> -			else
> -				wbc->nr_to_write = 0;
> -		}
> +	if (ret >= 0)
>  		return 0;
> -	}
>  out_mark_dirty:
>  	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
>  	return ret;

It is there in order to tell the VM that it has succeeded in freeing up
a certain number of pages. Otherwise, we end up cycling forever in
writeback_sb_inodes() & friends with the latter not realising that they
have made progress.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

