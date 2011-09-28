Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1I1IPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:15:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab1I1IP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:15:29 -0400
Date: Wed, 28 Sep 2011 10:14:52 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [PATCH] vmscan: add barrier to prevent evictable page in
 unevictable list
Message-ID: <20110928081452.GC23535@redhat.com>
References: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317174330-2677-1-git-send-email-minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:45:30AM +0900, Minchan Kim wrote:
> When racing between putback_lru_page and shmem_unlock happens,
> progrom execution order is as follows, but clear_bit in processor #1
> could be reordered right before spin_unlock of processor #1.
> Then, the page would be stranded on the unevictable list.
> 
> spin_lock
> SetPageLRU
> spin_unlock
>                                 clear_bit(AS_UNEVICTABLE)
>                                 spin_lock
>                                 if PageLRU()
>                                         if !test_bit(AS_UNEVICTABLE)
>                                         	move evictable list
> smp_mb
> if !test_bit(AS_UNEVICTABLE)
>         move evictable list
>                                 spin_unlock
> 
> But, pagevec_lookup in scan_mapping_unevictable_pages has rcu_read_[un]lock so
> it could protect reordering before reaching test_bit(AS_UNEVICTABLE) on processor #1
> so this problem never happens. But it's a unexpected side effect and we should
> solve this problem properly.
> 
> This patch adds a barrier after mapping_clear_unevictable.
> 
> side-note: I didn't meet this problem but just found during review.
> 
> Cc: Johannes Weiner <jweiner@redhat.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/shmem.c  |    1 +
>  mm/vmscan.c |   11 ++++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 2d35772..22cb349 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1068,6 +1068,7 @@ int shmem_lock(struct file *file, int lock, struct user_struct *user)
>  		user_shm_unlock(inode->i_size, user);
>  		info->flags &= ~VM_LOCKED;
>  		mapping_clear_unevictable(file->f_mapping);
> +		smp_mb__after_clear_bit();
>  		scan_mapping_unevictable_pages(file->f_mapping);

I always get nervous when I see undocumented barriers.  Maybe add a
teensy tiny comment here?

	/*
	 * Ensure that a racing putback_lru_page() can see
	 * the pages of this mapping are evictable when we
	 * skip them due to !PageLRU during the scan.
	 */

Or something like that.  Otherwise, nice catch :-)

Acked-by: Johannes Weiner <jweiner@redhat.com>
