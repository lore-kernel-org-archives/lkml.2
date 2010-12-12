Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab0LLXwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:52:17 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:49039 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab0LLXwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:52:13 -0500
/m: 
From: Richard Weinberger <richard@nod.at>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [64/223] hostfs: fix UML crash: remove f_spare from hostfs
Date: Mon, 13 Dec 2010 00:51:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: toralf.foerster@gmx.de, hch@lst.de, viro@zeniv.linux.org.uk,
        jdike@addtoit.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
References: <201012131244.547034648@firstfloor.org> <20101212234602.5DAB5B27BF@basil.firstfloor.org>
In-Reply-To: <20101212234602.5DAB5B27BF@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012130051.55692.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

Am Montag 13 Dezember 2010, 00:46:02 schrieb Andi Kleen:
> 2.6.35-longterm review patch.  If anyone has any objections, please let me
> know.

This patch is not needed on 2.6.35.
It makes only sense on >= 2.6.36.

Thanks,
//richard

> ------------------
> From: Richard Weinberger <richard@nod.at>
> 
> commit 1b627d5771312c92404b66f0a0b16f66036dd2e1 upstream.
> 
> 365b1818 ("add f_flags to struct statfs(64)") resized f_spare within
> struct statfs which caused a UML crash.  There is no need to copy f_spare.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Tested-by: Toralf Förster <toralf.foerster@gmx.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Jeff Dike <jdike@addtoit.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/hostfs/hostfs.h      |    3 +--
>  fs/hostfs/hostfs_kern.c |    2 +-
>  fs/hostfs/hostfs_user.c |    9 ++-------
>  3 files changed, 4 insertions(+), 10 deletions(-)
> 
> Index: linux/fs/hostfs/hostfs.h
> ===================================================================
> --- linux.orig/fs/hostfs/hostfs.h
> +++ linux/fs/hostfs/hostfs.h
> @@ -86,7 +86,6 @@ extern int rename_file(char *from, char
>  extern int do_statfs(char *root, long *bsize_out, long long *blocks_out,
>  		     long long *bfree_out, long long *bavail_out,
>  		     long long *files_out, long long *ffree_out,
> -		     void *fsid_out, int fsid_size, long *namelen_out,
> -		     long *spare_out);
> +		     void *fsid_out, int fsid_size, long *namelen_out);
> 
>  #endif
> Index: linux/fs/hostfs/hostfs_kern.c
> ===================================================================
> --- linux.orig/fs/hostfs/hostfs_kern.c
> +++ linux/fs/hostfs/hostfs_kern.c
> @@ -272,7 +272,7 @@ int hostfs_statfs(struct dentry *dentry,
>  	err = do_statfs(HOSTFS_I(dentry->d_sb->s_root->d_inode)->host_filename,
>  			&sf->f_bsize, &f_blocks, &f_bfree, &f_bavail, &f_files,
>  			&f_ffree, &sf->f_fsid, sizeof(sf->f_fsid),
> -			&sf->f_namelen, sf->f_spare);
> +			&sf->f_namelen);
>  	if (err)
>  		return err;
>  	sf->f_blocks = f_blocks;
> Index: linux/fs/hostfs/hostfs_user.c
> ===================================================================
> --- linux.orig/fs/hostfs/hostfs_user.c
> +++ linux/fs/hostfs/hostfs_user.c
> @@ -402,8 +402,7 @@ int rename_file(char *from, char *to)
>  int do_statfs(char *root, long *bsize_out, long long *blocks_out,
>  	      long long *bfree_out, long long *bavail_out,
>  	      long long *files_out, long long *ffree_out,
> -	      void *fsid_out, int fsid_size, long *namelen_out,
> -	      long *spare_out)
> +	      void *fsid_out, int fsid_size, long *namelen_out)
>  {
>  	struct statfs64 buf;
>  	int err;
> @@ -422,10 +421,6 @@ int do_statfs(char *root, long *bsize_ou
>  	       sizeof(buf.f_fsid) > fsid_size ? fsid_size :
>  	       sizeof(buf.f_fsid));
>  	*namelen_out = buf.f_namelen;
> -	spare_out[0] = buf.f_spare[0];
> -	spare_out[1] = buf.f_spare[1];
> -	spare_out[2] = buf.f_spare[2];
> -	spare_out[3] = buf.f_spare[3];
> -	spare_out[4] = buf.f_spare[4];
> +
>  	return 0;
>  }

