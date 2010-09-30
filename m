Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0I3Evv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 00:51:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702Ab0I3Evt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 00:51:49 -0400
Date: Wed, 29 Sep 2010 21:52:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/17] fs: icache atomic inodes_stat
Message-Id: <20100929215253.6fd944a2.akpm@linux-foundation.org>
In-Reply-To: <1285762729-17928-8-git-send-email-david@fromorbit.com>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-8-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 22:18:39 +1000 Dave Chinner <david@fromorbit.com> wrote:

> From: Nick Piggin <npiggin@suse.de>
> 
> The inode use statistics are currently protected by the inode_lock.
> Before we can remove the inode_lock, we need to protect these
> counters against races. Do this by converting them to atomic
> counters so they ar enot dependent on any lock at all.

typo

>
> ...
>
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -764,7 +764,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
>  	wb->last_old_flush = jiffies;
>  	nr_pages = global_page_state(NR_FILE_DIRTY) +
>  			global_page_state(NR_UNSTABLE_NFS) +
> -			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +			(atomic_read(&inodes_stat.nr_inodes) -
> +			atomic_read(&inodes_stat.nr_unused));

race bug.

>  	if (nr_pages) {
>  		struct wb_writeback_work work = {
> @@ -1144,7 +1145,8 @@ void writeback_inodes_sb(struct super_block *sb)
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
>  	work.nr_pages = nr_dirty + nr_unstable +
> -			(inodes_stat.nr_inodes - inodes_stat.nr_unused);
> +			(atomic_read(&inodes_stat.nr_inodes) -
> +			atomic_read(&inodes_stat.nr_unused));

and another.

OK, they aren't serious ones.  But known regressions shouldn't be snuck
into the kernel unchangelogged and uncommented :(

>  	bdi_queue_work(sb->s_bdi, &work);
>  	wait_for_completion(&done);
>
> ...
>
> -struct inodes_stat_t {
> -	int nr_inodes;
> -	int nr_unused;
> -	int dummy[5];		/* padding for sysctl ABI compatibility */
> -};
> -
> -
>  #define NR_FILE  8192	/* this can well be larger on a larger system */
>  
>  #define MAY_EXEC 1
> @@ -416,6 +409,12 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  			ssize_t bytes, void *private, int ret,
>  			bool is_async);
>  
> +struct inodes_stat_t {
> +	atomic_t nr_inodes;
> +	atomic_t nr_unused;
> +	int dummy[5];		/* padding for sysctl ABI compatibility */
> +};

OK, that's a hack.  The first two "ints" are copied out to userspace. 
This change assumes that sizeof(atomic_t)=4 and that an atomic_t has
the same layout, alignment and padding as an int.

Probably that's true in current kernels and with current architectures
but it's a hack and it's presumptive.

It shouldn't be snuck into the tree unchangelogged and uncommented.

(time passes)

OK, I see that all of this gets reverted later on.  Please update the
changelog so the next reviewer doesn't get fooled.

