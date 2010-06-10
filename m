Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0FJGAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:00:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55904 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab0FJGAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:00:32 -0400
Date: Wed, 9 Jun 2010 22:58:57 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>, Al Viro <viro@ftp.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100610055857.GB30672@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Al Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Nick Piggin <npiggin@suse.de>
References: <20100610044234.GD26335@laptop>
 <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C107F73.01C9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Joel Becker <joel.becker@oracle.com>

Al, can you carry this atop the truncate sequence code?

Joel

On Thu, Jun 10, 2010 at 01:08:05PM +0800, Tao Ma wrote:
> Let ocfs2 use the new truncate sequence. The changes include:
> 1. Use truncate_setsize directly since we don't implement our
>    own ->truncate and what we need is "update i_size and
>    truncate_pagecache" which truncate_setsize now does.
> 2. For direct write, ocfs2 actually don't allow write to pass
>    i_size(see ocfs2_prepare_inode_for_write), so we don't have
>    a chance to increase i_size. So remove the bogus check.
> 
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Tao Ma <tao.ma@oracle.com>
> ---
>  fs/ocfs2/file.c |   32 ++++++--------------------------
>  1 files changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
> index 1fb0985..8b5447e 100644
> --- a/fs/ocfs2/file.c
> +++ b/fs/ocfs2/file.c
> @@ -987,7 +987,7 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  		if (status)
>  			goto bail_unlock;
>  
> -		if (i_size_read(inode) > attr->ia_size) {
> +		if (inode->i_size > attr->ia_size) {
>  			if (ocfs2_should_order_data(inode)) {
>  				status = ocfs2_begin_ordered_truncate(inode,
>  								      attr->ia_size);
> @@ -1052,22 +1052,13 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
>  	}
>  
>  	/*
> -	 * This will intentionally not wind up calling truncate_setsize(),
> -	 * since all the work for a size change has been done above.
> -	 * Otherwise, we could get into problems with truncate as
> -	 * ip_alloc_sem is used there to protect against i_size
> -	 * changes.
> -	 *
> -	 * XXX: this means the conditional below can probably be removed.
> +	 * Since all the work for a size change has been done above.
> +	 * Call truncate_setsize directly to change size and truncate
> +	 * pagecache.
>  	 */
>  	if ((attr->ia_valid & ATTR_SIZE) &&
> -	    attr->ia_size != i_size_read(inode)) {
> -		status = vmtruncate(inode, attr->ia_size);
> -		if (status) {
> -			mlog_errno(status);
> -			goto bail_commit;
> -		}
> -	}
> +	    attr->ia_size != inode->i_size)
> +		truncate_setsize(inode, attr->ia_size);
>  
>  	setattr_copy(inode, attr);
>  	mark_inode_dirty(inode);
> @@ -2122,17 +2113,6 @@ relock:
>  		written = generic_file_direct_write(iocb, iov, &nr_segs, *ppos,
>  						    ppos, count, ocount);
>  		if (written < 0) {
> -			/*
> -			 * direct write may have instantiated a few
> -			 * blocks outside i_size. Trim these off again.
> -			 * Don't need i_size_read because we hold i_mutex.
> -			 *
> -			 * XXX(truncate): this looks buggy because ocfs2 did not
> -			 * actually implement ->truncate.  Take a look at
> -			 * the new truncate sequence and update this accordingly
> -			 */
> -			if (*ppos + count > inode->i_size)
> -				truncate_setsize(inode, inode->i_size);
>  			ret = written;
>  			goto out_dio;
>  		}
> -- 
> 1.5.5
> 

-- 

"If you took all of the grains of sand in the world, and lined
 them up end to end in a row, you'd be working for the government!"
	- Mr. Interesting

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
