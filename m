Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab0FBMOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:14:44 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752162Ab0FBMOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:14:43 -0400
Date: Wed, 2 Jun 2010 14:14:42 +0200
From: Jan Kara <jack@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, adilger@sun.com,
       Linux-Ext4 <linux-ext4@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, agruen@suse.de
Subject: Re: [PATCH] ext3: fix non-update ctime when changing the file's
	permission by setfacl
Message-ID: <20100602121442.GA28648@atrey.karlin.mff.cuni.cz>
References: <4BFE2D38.2010501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFE2D38.2010501@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ext3 didn't update the ctime of the file when its permission was changed.
> 
> Steps to reproduce:
>  # touch aaa
>  # stat -c %Z aaa
>  1275289822
>  # setfacl -m  'u::x,g::x,o::x' aaa
>  # stat -c %Z aaa
>  1275289822				<- unchanged
> 
> But, according to the spec of the ctime, ext3 must update it.
  Yeah, good spotting. Thanks. Looking at various code, the bug was probably
cut-n-pasted to all the filesystems (except XFS)... Sigh. It would be nice to
handle this somehow generically in VFS but currently I don't see a way. So
probably I'll take filesystems one by one and fix them.

								Honza
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/ext3/acl.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/acl.c b/fs/ext3/acl.c
> index 01552ab..8a11fe2 100644
> --- a/fs/ext3/acl.c
> +++ b/fs/ext3/acl.c
> @@ -205,6 +205,7 @@ ext3_set_acl(handle_t *handle, struct inode *inode, int type,
>  					return error;
>  				else {
>  					inode->i_mode = mode;
> +					inode->i_ctime = CURRENT_TIME_SEC;
>  					ext3_mark_inode_dirty(handle, inode);
>  					if (error == 0)
>  						acl = NULL;
> -- 
> 1.6.5.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
