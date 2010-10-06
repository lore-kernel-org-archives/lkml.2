Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab0JFQvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 12:51:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34330 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab0JFQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 12:51:13 -0400
To: Andy Whitcroft <apw@canonical.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <20101006122940.GC19733@agent57> (message from Andy Whitcroft on
	Wed, 6 Oct 2010 13:29:40 +0100)
Subject: Re: overlayfs: BUG in ovl_whiteout
References: <20101001180702.GD2832@shadowen.org>
 <E1P2hGO-0001kL-Gw@pomaz-ex.szeredi.hu>
 <20101004173343.GA19733@agent57>
 <E1P2rSX-0002hz-Lj@pomaz-ex.szeredi.hu> <20101006122940.GC19733@agent57>
Message-Id: <E1P3XCv-0007E8-S1@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 06 Oct 2010 18:51:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Andy Whitcroft wrote:
> On Mon, Oct 04, 2010 at 10:16:29PM +0200, Miklos Szeredi wrote:
> > 
> > OK, my guess is that it's a 'rename to self' which was not properly
> > implemented.
> > 
> > Does the following patch make a difference?
> 
> That one panic'd immediatly.  Seems that we can have missmatched lowers
> as well.  I applied the below over the top, and that seems to pass
> testing without tripping the WARN_ON.
> 
> -apw
> 
> commit 03375858c62f617846b5dc4968fe8178eda51a7c
> Author: Andy Whitcroft <apw@canonical.com>
> Date:   Tue Oct 5 14:54:08 2010 +0100
> 
>     overlayfs: handle missing lower inodes in ovl_is_same_inode
>     
>     Signed-off-by: Andy Whitcroft <apw@canonical.com>

OK, that's because d1 or d2 is negative, otherwise either the upper or
the lower dentry _must_ exist.  In the version I committed to the
overlayfs.v3 branch vfs_is_same_inode() checks whether the dentries
are positive and only calls ->is_same_inode() if they are.

Can you please try pull from that branch and check if it's still buggy
without your patch?

Thanks,
Miklos



> 
> diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
> index c10cc7b..f596222 100644
> --- a/fs/overlayfs/overlayfs.c
> +++ b/fs/overlayfs/overlayfs.c
> @@ -1964,19 +1964,25 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
>  
>  static bool ovl_is_same_inode(struct dentry *d1, struct dentry *d2)
>  {
> -	struct dentry *upperd1;
> -	struct dentry *upperd2;
> +	struct dentry *od1;
> +	struct dentry *od2;
>  
> -	upperd1 = ovl_dentry_upper(d1);
> -	upperd2 = ovl_dentry_upper(d2);
> +	od1 = ovl_dentry_upper(d1);
> +	od2 = ovl_dentry_upper(d2);
>  
> -	if (upperd1 && upperd2)
> -		return vfs_is_same_inode(upperd1, upperd2);
> +	if (od1 && od2)
> +		return vfs_is_same_inode(od1, od2);
>  
> -	if (upperd1 || upperd2)
> +	if (od1 || od2)
>  		return false;
>  
> -	return vfs_is_same_inode(ovl_dentry_lower(d1), ovl_dentry_lower(d2));
> +	od1 = ovl_dentry_lower(d1);
> +	od2 = ovl_dentry_lower(d2);
> +
> +	if (od1 && od2)
> +		return vfs_is_same_inode(od1, od2);
> +
> +	return false;
>  }
>  
>  static const struct super_operations ovl_super_operations = {
> 
