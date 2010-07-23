Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0GWQZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:25:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab0GWQZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:25:09 -0400
Date: Fri, 23 Jul 2010 18:24:43 +0200
From: Jan Kara <jack@suse.cz>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] FS_IOC_SYNCFS
Message-ID: <20100723162443.GA20540@quack.suse.cz>
References: <Pine.LNX.4.64.1007201004380.6477@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007201004380.6477@cobra.newdream.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20-07-10 16:48:26, Sage Weil wrote:
> As far as I can see, currently the only way to sync a single file system 
> (and not _all_ mounted file systems) is via the BLKFLSBUF ioctl, which 
> will sync_filesystem() and then invalidate_bdev().  If you _just_ want to 
> sync, though, the invalidate_bdev() is unnecessary and potentially 
> counter-productive.
> 
> Would it be reasonable to add a simple call like so?  Then you could
> 
> 	fd = open("/path/for/some/mount", O_RDONLY);
> 	ioctl(fd, FS_IOC_SYNCFS);
> 	close(fd);
> 
> or something along those lines.
  Looks reasonable to me...

								Honza

> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 2d140a7..0bc9f7a 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -593,6 +593,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>  	case FS_IOC_FIEMAP:
>  		return ioctl_fiemap(filp, arg);
>  
> +	case FS_IOC_SYNCFS:
> +		return sync_filesystem(filp->f_dentry->d_sb);
> +
>  	case FIGETBSZ:
>  	{
>  		struct inode *inode = filp->f_path.dentry->d_inode;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 471e1ff..4a84d78 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -321,6 +321,7 @@ struct inodes_stat_t {
>  #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
>  #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
>  #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
> +#define FS_IOC_SYNCFS                   _IO('S', 12)
>  #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
>  #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
>  #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
