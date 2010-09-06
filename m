Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0IFQ5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:57:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39586 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab0IFQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:57:39 -0400
To: NeilBrown <neilb@suse.de>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <20100906005028.20775.47191.stgit@localhost.localdomain> (message
	from NeilBrown on Mon, 06 Sep 2010 10:50:28 +1000)
Subject: Re: [PATCH 01/10] ovl: small optimisation for ovl_lookup
References: <20100906004829.20775.68828.stgit@localhost.localdomain> <20100906005028.20775.47191.stgit@localhost.localdomain>
Message-Id: <E1Osf0g-0005it-BZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 18:57:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Sep 2010, NeilBrown wrote:
> If we find a non-directory in the upper layer, there is no point
> performing a lookup in the lower layer as whatever is found will just
> be ignored anyway.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  fs/overlayfs/overlayfs.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
> index 0fe3944..0ddfeec 100644
> --- a/fs/overlayfs/overlayfs.c
> +++ b/fs/overlayfs/overlayfs.c
> @@ -495,7 +495,8 @@ static struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  				dput(upperdentry);
>  				upperdentry = NULL;
>  				ue->opaque = true;
> -			}
> +			} else if (!S_ISDIR(upperdentry->d_inode->i_mode))
> +				ue->opaque = true;

Setting opaque unconditionally, without checking whether the lower
file exists or not, means on unlink we'll create a whiteout even when
not necessary.

Thanks,
Miklos
