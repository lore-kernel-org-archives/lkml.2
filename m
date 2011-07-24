Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1GXLQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 07:16:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42256
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab1GXLQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 07:16:35 -0400
Date: Sun, 24 Jul 2011 07:16:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, viro@zeniv.linux.org.uk, jack@suse.cz,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] fs: push i_mutex and filemap_write_and_wait down into
 ->fsync() handlers
Message-ID: <20110724111625.GA12658@infradead.org>
References: <1309370716-12235-1-git-send-email-josef@redhat.com>
 <20110723180942.GA1616@x4.trippels.de>
 <4E2B2E88.8080006@redhat.com>
 <20110723203824.GB1652@x4.trippels.de>
 <20110723220212.GA1648@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723220212.GA1648@x4.trippels.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 12:02:12AM +0200, Markus Trippelsdorf wrote:
> The following patch fixes the problem for me:

Good catch, can you send it with a proper signoff and description?

> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index cca00f4..2e23e3d 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -881,11 +881,14 @@ xfs_file_aio_write(
>  	/* Handle various SYNC-type writes */
>  	if ((file->f_flags & O_DSYNC) || IS_SYNC(inode)) {
>  		loff_t end = pos + ret - 1;
> +		int error;
>  
>  		xfs_rw_iunlock(ip, iolock);
> -		ret = -xfs_file_fsync(file, pos, end,
> +		error = -xfs_file_fsync(file, pos, end,
>  				      (file->f_flags & __O_SYNC) ? 0 : 1);

In addition xfs_file_fsync actually returns a normal negative error,
but that bug already existed before the fsync prototype change.  If you
resend the patch, can you fix it as well?

>  		xfs_rw_ilock(ip, iolock);
> +		if (error)
> +			ret = error;
>  	}
