Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1IGTO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:14:57 -0400
Received: from mx2.netapp.com ([216.240.18.37]:3183 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab1IGTO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:14:56 -0400
X-IronPort-AV: E=Sophos;i="4.68,347,1312182000"; 
   d="scan'208";a="579643742"
Subject: Re: [PATCH 00/18] IO-less dirty throttling v11
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Andrea Righi <arighi@develer.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Sep 2011 15:14:46 -0400
In-Reply-To: <20110907133211.GA28442@localhost>
References: <20110904015305.367445271@intel.com>
	 <20110907133211.GA28442@localhost>
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Message-ID: <1315422886.4160.11.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-OriginalArrivalTime: 07 Sep 2011 19:14:46.0913 (UTC) FILETIME=[68486710:01CC6D92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 21:32 +0800, Wu Fengguang wrote: 
> > Finally, the complete IO-less balance_dirty_pages(). NFS is observed to perform
> > better or worse depending on the memory size. Otherwise the added patches can
> > address all known regressions.
> 
> I find that the NFS performance regressions on large memory system can
> be fixed by this patch. It tries to make the progress more smooth by
> reasonably reducing the commit size.
> 
> Thanks,
> Fengguang
> ---
> Subject: nfs: limit the commit size to reduce fluctuations
> Date: Thu Dec 16 13:22:43 CST 2010
> 
> Limit the commit size to half the dirty control scope, so that the
> arrival of one commit will not knock the overall dirty pages off the
> scope.
> 
> Also limit the commit size to one second worth of data. This will
> obviously help make the pipeline run more smoothly.
> 
> Also change "<=" to "<": if an inode has only one dirty page in the end,
> it should be committed. I wonder why the "<=" didn't cause a bug...
> 
> CC: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/nfs/write.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> After patch, there are still drop offs from the control scope,
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/balance_dirty_pages-pages.png
> 
> due to bursty arrival of commits:
> 
> http://www.kernel.org/pub/linux/kernel/people/wfg/writeback/dirty-throttling-v6/NFS/nfs-1dd-1M-8p-2945M-20%25-2.6.38-rc6-dt6+-2011-02-22-21-09/nfs-commit.png
> 
> --- linux-next.orig/fs/nfs/write.c	2011-09-07 21:29:15.000000000 +0800
> +++ linux-next/fs/nfs/write.c	2011-09-07 21:29:32.000000000 +0800
> @@ -1543,10 +1543,14 @@ static int nfs_commit_unstable_pages(str
>  	int ret = 0;
>  
>  	if (wbc->sync_mode == WB_SYNC_NONE) {
> +		unsigned long bw = MIN_WRITEBACK_PAGES +
> +			NFS_SERVER(inode)->backing_dev_info.avg_write_bandwidth;
> +
>  		/* Don't commit yet if this is a non-blocking flush and there
> -		 * are a lot of outstanding writes for this mapping.
> +		 * are a lot of outstanding writes for this mapping, until
> +		 * collected enough pages to commit.
>  		 */
> -		if (nfsi->ncommit <= (nfsi->npages >> 1))
> +		if (nfsi->ncommit < min(nfsi->npages / DIRTY_SCOPE, bw))
>  			goto out_mark_dirty;
>  
>  		/* don't wait for the COMMIT response */

So what goes into the 'avg_write_bandwidth' variable that makes it a
good measure above (why 1 second of data instead of 10 seconds or
1ms, ...)? What is the 'DIRTY_SCOPE' value?

IOW: what new black magic are we introducing above and why is it so
obviously better than what we have (yes, I see you have graphs, but that
is just measuring _one_ NFS setup and workload).

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

