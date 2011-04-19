Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1DSD3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:29:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:60234 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab1DSD3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:29:09 -0400
X-IronPort-AV: E=Sophos;i="4.64,236,1301900400"; 
   d="scan'208";a="542236968"
Subject: Re: [PATCH 6/6] NFS: return -EAGAIN when skipped commit in
 nfs_commit_unstable_pages()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
In-Reply-To: <20110419030532.902141228@intel.com>
References: <20110419030003.108796967@intel.com>
	 <20110419030532.902141228@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Mon, 18 Apr 2011 23:29:07 -0400
Message-ID: <1303183747.5417.11.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 19 Apr 2011 03:29:08.0550 (UTC) FILETIME=[F1568660:01CBFE41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 11:00 +0800, Wu Fengguang wrote:
> plain text document attachment (nfs-fix-write_inode-retval.patch)
> It's probably not sane to return success while redirtying the inode at
> the same time in ->write_inode().
> 
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/nfs/write.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next.orig/fs/nfs/write.c	2011-04-19 10:18:16.000000000 +0800
> +++ linux-next/fs/nfs/write.c	2011-04-19 10:18:32.000000000 +0800
> @@ -1519,7 +1519,7 @@ static int nfs_commit_unstable_pages(str
>  {
>  	struct nfs_inode *nfsi = NFS_I(inode);
>  	int flags = FLUSH_SYNC;
> -	int ret = 0;
> +	int ret = -EAGAIN;
>  
>  	if (wbc->sync_mode == WB_SYNC_NONE) {
>  		/* Don't commit yet if this is a non-blocking flush and there
> 
> 

Hi Fengguang,

I don't understand the purpose of this patch...

Currently, the value of 'ret' only affects the case where the commit
exits early due to this being a non-blocking flush where we have not yet
written back enough pages to make it worth our while to send a commit.

In essence, this really only matters for the cases where someone calls
'write_inode_now' (not used by anybody calling into the NFS client) and
'sync_inode', which is only called by nfs_wb_all (with sync_mode =
WB_SYNC_ALL).

So can you please elaborate on the possible use cases for this change?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

