Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab0ESMvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:51:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63358 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0ESMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uhd0iwvXuLQq6JfeOTV4btnTShS5+K1q6zpYCUY30wWQQtv5Q0zLzy+idsIA/ZeBRE
         WGvuN095kmhHfXR9szoObg8LGPsM6KEvtyABy+Ukw/ku53ld/vyQu6mzEHxpkF6x3S9F
         h7oTxwsp6PQdPGqw1Gwugj1Szr+cu0RxQB4bk=
Date: Wed, 19 May 2010 14:51:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] logfs: kill BKL
Message-ID: <20100519125148.GB1213@nowhere>
References: <alpine.LFD.2.00.1004271359180.3318@localhost> <201004271738.50505.arnd@arndb.de> <20100427201247.GE5586@nowhere> <201004272230.07545.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201004272230.07545.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 10:30:06PM +0200, Arnd Bergmann wrote:
> logfs does not need the BKL, so use ->unlocked_ioctl instead
> of ->ioctl in file operations.
> ---
> On Tuesday 27 April 2010 22:12:52 Frederic Weisbecker wrote:
> > 
> > I've applied this series in bkl/ioctl, it passed allyesconfig in sparc.
> > I will apply the others from you and John tomorrow or so (and will enjoy
> > my part as well). Jörn, please queue this patch if you want to, as you prefer,
> > we can host it as well if necessary.
> 
> I believe that this is the one that Jörn would prefer to go in. I hope I
> got it right by editing the patch.



Jörn, any news about this patch? If you're fine with it,
could you queue it for .35 ?

Thanks.



> 
> diff --git a/fs/logfs/dir.c b/fs/logfs/dir.c
> index 2396a85..a801b5e 100644
> --- a/fs/logfs/dir.c
> +++ b/fs/logfs/dir.c
> @@ -821,7 +821,7 @@ const struct inode_operations logfs_dir_iops = {
>  };
>  const struct file_operations logfs_dir_fops = {
>  	.fsync		= logfs_fsync,
> -	.ioctl		= logfs_ioctl,
> +	.unlocked_ioctl	= logfs_ioctl,
>  	.readdir	= logfs_readdir,
>  	.read		= generic_read_dir,
>  };
> diff --git a/fs/logfs/file.c b/fs/logfs/file.c
> index 370f367..1dbc342 100644
> --- a/fs/logfs/file.c
> +++ b/fs/logfs/file.c
> @@ -171,9 +172,9 @@ static int logfs_releasepage(struct page *page, gfp_t only_xfs_uses_this)
>  }
>  
>  
> -int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -		unsigned long arg)
> +long logfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +	struct inode *inode = file->f_path.dentry->d_inode;
>  	struct logfs_inode *li = logfs_inode(inode);
>  	unsigned int oldflags, flags;
>  	int err;
> @@ -243,7 +255,7 @@ const struct file_operations logfs_reg_fops = {
>  	.aio_read	= generic_file_aio_read,
>  	.aio_write	= generic_file_aio_write,
>  	.fsync		= logfs_fsync,
> -	.ioctl		= logfs_ioctl,
> +	.unlocked_ioctl	= logfs_ioctl,
>  	.llseek		= generic_file_llseek,
>  	.mmap		= generic_file_readonly_mmap,
>  	.open		= generic_file_open,
> diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
> index 0a3df1a..8432c51 100644
> --- a/fs/logfs/logfs.h
> +++ b/fs/logfs/logfs.h
> @@ -501,8 +501,8 @@ extern const struct inode_operations logfs_reg_iops;
>  extern const struct file_operations logfs_reg_fops;
>  extern const struct address_space_operations logfs_reg_aops;
>  int logfs_readpage(struct file *file, struct page *page);
> -int logfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -		unsigned long arg);
> +long logfs_ioctl(struct file *file, unsigned int cmd,
> +		 unsigned long arg);
>  int logfs_fsync(struct file *file, struct dentry *dentry, int datasync);
>  
>  /* gc.c */

