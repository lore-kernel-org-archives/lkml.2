Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab0JHH1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:27:53 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51532 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab0JHH1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:27:51 -0400
Date: Fri, 8 Oct 2010 03:27:49 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: rework icount to be a locked variable
Message-ID: <20101008072749.GB7831@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-10-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> index 2953e9f..9f04478 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1964,8 +1964,14 @@ void btrfs_add_delayed_iput(struct inode *inode)
>  	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
>  	struct delayed_iput *delayed;
>  
> -	if (atomic_add_unless(&inode->i_count, -1, 1))
> +	/* XXX: filesystems should not play refcount games like this */
> +	spin_lock(&inode->i_lock);
> +	if (inode->i_ref > 1) {
> +		inode->i_ref--;
> +		spin_unlock(&inode->i_lock);
>  		return;
> +	}
> +	spin_unlock(&inode->i_lock);

Yeah, all that i_count/i_ref mess in btrfs needs some serious work.
Chris?

> +
> +/*
> + * inode_lock must be held
> + */
> +void iref_locked(struct inode *inode)
> +{
> +	inode->i_ref++;
> +}
>  EXPORT_SYMBOL_GPL(iref_locked);

I'm a big fan of _GPL exports, but adding this for a trivial counter
increment seems a bit weird. 

>  int iref_read(struct inode *inode)
>  {
> -	return atomic_read(&inode->i_count);
> +	int ref;
> +
> +	spin_lock(&inode->i_lock);
> +	ref = inode->i_ref;
> +	spin_unlock(&inode->i_lock);
> +	return ref;
>  }

There's no need to lock a normal 32-bit variable for readers.

> +		inode->i_ref--;
> +		if (inode->i_ref == 0) {

		if (--inode->i_ref == 0) {

might be a bit more idiomatic.

