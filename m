Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030552Ab2CTQWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab2CTQWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:22:05 -0400
Date: Tue, 20 Mar 2012 12:21:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@fusionio.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk, martin.petersen@oracle.com
Subject: Re: [patch v2 2/6] blk: dont allow discard request merge temporarily
Message-ID: <20120320162157.GE17071@redhat.com>
References: <20120316073213.656519005@fusionio.com>
 <20120316073512.485027511@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316073512.485027511@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 03:32:15PM +0800, Shaohua Li wrote:
> Didn't allow discard request merge temporarily, as SCSI layer isn't ready
> for discard merge as Martin Petersen pointed out. This isn't fair for
> non-scsi device, but looks this is the only way I can do currently.
> 
> We should have the same issue before, but maybe because discard merge is
> very rare case. But now raid0/10 makes the merge quite possible, so we need
> disable it explicitly.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  include/linux/blkdev.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/include/linux/blkdev.h
> ===================================================================
> --- linux.orig/include/linux/blkdev.h	2012-03-14 09:20:06.787261188 +0800
> +++ linux/include/linux/blkdev.h	2012-03-14 09:20:47.797261248 +0800
> @@ -575,7 +575,7 @@ static inline void blk_clear_queue_full(
>   * it already be started by driver.
>   */
>  #define RQ_NOMERGE_FLAGS	\
> -	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
> +	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_DISCARD)
>  #define rq_mergeable(rq)	\
>  	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
>  	 (((rq)->cmd_flags & REQ_DISCARD) || \

I think you will need to do little more cleanup to make discard
unmergeable.

- Change rq_mergeable(rq)
- Change attempt_merge() and get rid of special conditions of allowing
  discard merge.

Martin had a bigger patch where he wanted to cleanup many discard specific
condition checks.

As you are just focusing on disabling merging for discard requests, you
might as well just pick the relevant pieces from the patch.

http://www.spinics.net/lists/linux-scsi/msg57779.html

Thanks
Vivek
