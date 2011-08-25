Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab1HYFQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:16:34 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53897
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab1HYFQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:16:32 -0400
Date: Thu, 25 Aug 2011 01:16:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com
Subject: Re: [PATCH 4/5] xfs: use fs netlink interface for ENOSPC conditions
Message-ID: <20110825051631.GB1869@infradead.org>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com>
 <1313669906-14931-5-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313669906-14931-5-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	xfs_rw_iunlock(ip, iolock);
> +	if (unlikely(-ENOSPC == ret))
> +		fs_nl_send_warning(inode->i_sb->s_dev, FS_NL_ENOSPC_WARN);

I'd remove the nl from both the name and the constants.  In the end what
matters is the warning, and netlink just is an implementation detail.

> index 9a72dda..dd167a0 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1731,6 +1731,7 @@ init_xfs_fs(void)
>  	error = register_filesystem(&xfs_fs_type);
>  	if (error)
>  		goto out_sysctl_unregister;
> +	init_fs_nl_family();

Why do we have to call this from the filesystem?  Shouldn't we
initialize it once from the VFS?



Also any chance you could include the quota netlink warnings into the
framework?  Any callers is also going to be interestested in quota
warnings, not just enospc.  Also the xfs project quota code returns
ENOSPC if over the project quota and needs to be handled either way.
Adding another new category inbetween user/group quotas and plain ENOSPC
for it would be nice.
