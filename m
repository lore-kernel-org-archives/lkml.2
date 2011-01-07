Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab1AGJWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:22:19 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45834 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab1AGJWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:22:15 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jesper Juhl <jj@chaosbits.net>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: Mem leak in btrfs_get_acl()
In-Reply-To: <alpine.LNX.2.00.1101062242320.13988@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101062242320.13988@swampdragon.chaosbits.net>
User-Agent: Notmuch/0.5-32-gf6c60cc (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Fri, 07 Jan 2011 14:52:10 +0530
Message-ID: <87vd21kr0d.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 22:45:21 +0100 (CET), Jesper Juhl <jj@chaosbits.net> wrote:
> 
> It seems to me that we leak the memory allocated to 'value' in 
> btrfs_get_acl() if the call to posix_acl_from_xattr() fails.
> Here's a patch that attempts to correct that problem.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

I posted a similar patch long time back.  But never got picked up

http://article.gmane.org/gmane.comp.file-systems.btrfs/6164

Message-id:"1279547924-25141-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com"

> ---
>  acl.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
>   compile tested only.
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 2222d16..6d1410e 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -60,8 +60,10 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>  		size = __btrfs_getxattr(inode, name, value, size);
>  		if (size > 0) {
>  			acl = posix_acl_from_xattr(value, size);
> -			if (IS_ERR(acl))
> +			if (IS_ERR(acl)) {
> +				kfree(value);
>  				return acl;
> +			}
>  			set_cached_acl(inode, type, acl);
>  		}
>  		kfree(value);
> 
> 


-aneesh
