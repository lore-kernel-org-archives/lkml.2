Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751004Ab0J2E33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:29:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33089 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0J2E3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:29:22 -0400
Date: Fri, 29 Oct 2010 05:29:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] fs: protect inode->i_state with inode->i_lock
Message-ID: <20101029042919.GM19804@ZenIV.linux.org.uk>
References: <1288322620-8566-1-git-send-email-david@fromorbit.com>
 <1288322620-8566-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288322620-8566-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 02:23:33PM +1100, Dave Chinner wrote:
> @@ -293,9 +293,11 @@ static void inode_wait_for_writeback(struct inode *inode)
>  
>  	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
>  	 while (inode->i_state & I_SYNC) {
> +		spin_unlock(&inode->i_lock);

Minor annoyance, but...  Let's replace spaces with tab in that while.

> +		spin_unlock(&inode->i_lock);
> +
>  		pages_skipped = wbc->pages_skipped;
>  		writeback_single_inode(inode, wbc);

	Might make sense to lift locking i_lock into callers of
writeback_single_inode() (it has to grab the damn thing as soon as it's
called) and collapse it with spin_unlock() here.  Separate patch.

> +		spin_unlock(&inode->i_lock);
>  		/*
>  		 * If the inode was already on b_dirty/b_io/b_more_io, don't
>  		 * reposition it (that would break b_dirty time-ordering).

I'm not sure there's any point in dropping it here, actually.

> +	spin_lock(&inode->i_lock);
>  	inode->i_state = I_FREEING | I_CLEAR;
> +	spin_unlock(&inode->i_lock);

_Probably_ not needed here; we already had I_FREEING set by the time
we'd called that and no other thread will modify ->i_state of that
inode at that point.  Check for I_CLEAR will be later in the same
thread, so no barriers are needed.  Separate patch.

> @@ -552,8 +568,6 @@ int invalidate_inodes(struct super_block *sb)
>  		 */
>  		list_move(&inode->i_lru, &dispose);
>  		list_del_init(&inode->i_wb_list);
> -		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
>  	}
>  	spin_unlock(&inode_lock);

Ho-hum...

I'm not sure we need that list_del_init() here, actually, seeing that
I_FREEING is already set...  For later patch, anyway.

> @@ -917,10 +946,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
>  		/* We released the lock, so.. */
>  		old = find_inode_fast(sb, head, ino);
>  		if (!old) {
> +			spin_lock(&inode->i_lock);
>  			inode->i_ino = ino;
> +			inode->i_state = I_NEW;
> +			spin_unlock(&inode->i_lock);

Almost certainly not needed; nobody can find this inode at that point.

> + * wake_up_bit(&inode->i_state, __I_NEW) after removing from the hash list
> + * will DTRT.

Add that i_lock is not regained.
