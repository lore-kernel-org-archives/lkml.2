Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab0JVB40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:56:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:32911 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab0JVB4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:56:25 -0400
Date: Fri, 22 Oct 2010 02:56:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101022015622.GE19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287622186-1935-17-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:49:41AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently protect the per-inode state flags with the inode_lock.
> Using a global lock to protect per-object state is overkill when we
> coul duse a per-inode lock to protect the state.  Use the
> inode->i_lock for this, and wrap all the state changes and checks
> with the inode->i_lock.

> @@ -1424,22 +1449,30 @@ static void iput_final(struct inode *inode)
>  	if (!drop) {
>  		if (sb->s_flags & MS_ACTIVE) {
>  			inode->i_state |= I_REFERENCED;
> -			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> +			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
> +			    list_empty(&inode->i_lru)) {
> +				spin_unlock(&inode->i_lock);
>  				inode_lru_list_add(inode);
> +				return;

Sorry, that's broken.  Leaving aside leaking inode_lock here (you remove
taking it later anyway), this is racy.

Look: inode is hashed.  It's alive and well.  It just has no references outside
of the lists.  Right?  Now, what's to stop another CPU from
	a) looking it up in icache
	b) doing unlink()
	c) dropping the last reference
	d) freeing the sucker
... just as you are about to call inode_lru_list_add() here?

For paths in iput() where we do set I_FREEING/I_WILL_FREE it's perfectly
fine to drop all locks once that's done.  Inode is ours, nobody will pick
it and we are free to do as we wish.

For the path that leaves the inode alive and hashed - sorry, can't do.
AFAICS, unlike hash, wb and sb locks, lru lock should nest *inside*
->i_lock.  And yes, it means trylock in prune_icache(), with "put it in
the end of the list for one more spin" if we fail.  In that case it's
really cleaner that way.
