Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904Ab0KRXnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:43:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab0KRXnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:43:33 -0500
Date: Fri, 19 Nov 2010 00:43:31 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@redhat.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com,
        cluster-devel@redhat.com, joel.becker@oracle.com, jack@suse.cz
Subject: Re: [PATCH 1/6] fs: add hole punching to fallocate
Message-ID: <20101118234331.GD5004@quack.suse.cz>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
 <1290044780-2902-2-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290044780-2902-2-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 17-11-10 20:46:15, Josef Bacik wrote:
> Hole punching has already been implemented by XFS and OCFS2, and has the
> potential to be implemented on both BTRFS and EXT4 so we need a generic way to
> get to this feature.  The simplest way in my mind is to add FALLOC_FL_PUNCH_HOLE
> to fallocate() since it already looks like the normal fallocate() operation.
> I've tested this patch with XFS and BTRFS to make sure XFS did what it's
> supposed to do and that BTRFS failed like it was supposed to.  Thank you,
  Looks nice now. Acked-by: Jan Kara <jack@suse.cz>

									Honza
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/open.c              |    7 ++++++-
>  include/linux/falloc.h |    1 +
>  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 4197b9e..5b6ef7e 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -223,7 +223,12 @@ int do_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  		return -EINVAL;
>  
>  	/* Return error if mode is not supported */
> -	if (mode && !(mode & FALLOC_FL_KEEP_SIZE))
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +		return -EOPNOTSUPP;
> +
> +	/* Punch hole must have keep size set */
> +	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
> +	    !(mode & FALLOC_FL_KEEP_SIZE))
>  		return -EOPNOTSUPP;
>  
>  	if (!(file->f_mode & FMODE_WRITE))
> diff --git a/include/linux/falloc.h b/include/linux/falloc.h
> index 3c15510..73e0b62 100644
> --- a/include/linux/falloc.h
> +++ b/include/linux/falloc.h
> @@ -2,6 +2,7 @@
>  #define _FALLOC_H_
>  
>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
> +#define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
>  
>  #ifdef __KERNEL__
>  
> -- 
> 1.6.6.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
