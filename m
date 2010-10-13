Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0JMLl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 07:41:28 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51318 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab0JMLl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 07:41:27 -0400
Date: Wed, 13 Oct 2010 07:41:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/18] fs: Introduce per-bucket inode hash locks
Message-ID: <20101013114126.GE19456@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-10-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  #include <linux/mount.h>
>  #include <linux/async.h>
>  #include <linux/posix_acl.h>
> +#include <linux/bit_spinlock.h>

list_bl.h already includes bit_spinlock.h, so you shouldn't actually
need it here.

> @@ -2154,7 +2154,7 @@ static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
>  		 */
>  		static DEFINE_SPINLOCK(lock);
>  		spin_lock(&lock);
> -		if (hlist_unhashed(&inode->i_hash))
> +		if (inode_unhashed(inode))
>  			__insert_inode_hash(inode,
>  					    inode->i_ino + inode->i_generation);
>  		spin_unlock(&lock);

That's some amazingly ugly code.  Just keeping the hash bucket lock
over the inode_unhashed check and the insert would remove the need for
the weird local spinlock.  But that's probably best left for a later
patch.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

