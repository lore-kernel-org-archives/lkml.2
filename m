Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0IVRWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:22:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0IVRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZlqNngEAArwTKNtEJ6Mbidy0RJNQR8ha+oSJAigsjaq/U2RDX4Q4IZVNNIsq2rP9J5
         l9ErxgZXIKMdCen/fDbT6MeZGTAPb2mPQqgn1SmkwpXB1gSvKRrI7w3CsAHKM3iL1Moo
         2CE0jrGYArykVfD4pahBmwhSe6A351i+mTl4M=
Date: Wed, 22 Sep 2010 19:22:31 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Re: [Bug] possible circular locking in reiserfs_unpack
Message-ID: <20100922172231.GA1924@del.dom.local>
References: <20100905113121.GA1876@del.dom.local>
 <20100908153730.5ad13f71.akpm@linux-foundation.org>
 <20100909015346.GA5999@nowhere>
 <4C88F566.7080600@gmail.com>
 <20100922134944.GA6549@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100922134944.GA6549@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 03:49:48PM +0200, Frederic Weisbecker wrote:
> 
> I can reproduce your first case, but not this one.
> 
> So, I hope you can give a try to the following fix,
> 
> Thanks!
> 

With this patch I don't have any lockdep warnings during lilo writes.

Well done, thanks!

Tested-by: Jarek Poplawski <jarkao2@gmail.com>

> 
> diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
> index f53505d..90a757b 100644
> --- a/fs/reiserfs/ioctl.c
> +++ b/fs/reiserfs/ioctl.c
> @@ -170,7 +170,7 @@ int reiserfs_prepare_write(struct file *f, struct page *page,
>  int reiserfs_unpack(struct inode *inode, struct file *filp)
>  {
>  	int retval = 0;
> -	int index;
> +	int index, depth;
>  	struct page *page;
>  	struct address_space *mapping;
>  	unsigned long write_from;
> @@ -185,11 +185,12 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
>  		return 0;
>  	}
>  
> +	depth = reiserfs_write_lock_once(inode->i_sb);
> +
>  	/* we need to make sure nobody is changing the file size beneath
>  	 ** us
>  	 */
> -	mutex_lock(&inode->i_mutex);
> -	reiserfs_write_lock(inode->i_sb);
> +	reiserfs_mutex_lock_safe(&inode->i_mutex, inode->i_sb);
>  
>  	write_from = inode->i_size & (blocksize - 1);
>  	/* if we are on a block boundary, we are already unpacked.  */
> @@ -224,6 +225,6 @@ int reiserfs_unpack(struct inode *inode, struct file *filp)
>  
>        out:
>  	mutex_unlock(&inode->i_mutex);
> -	reiserfs_write_unlock(inode->i_sb);
> +	reiserfs_write_unlock_once(inode->i_sb, depth);
>  	return retval;
>  }
> 
