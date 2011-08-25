Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab1HYI6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 04:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab1HYI6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 04:58:38 -0400
Date: Thu, 25 Aug 2011 10:58:25 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Christoph Hellwig <hch@infradead.org>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        xfs@oss.sgi.com
Subject: Re: [PATCH 4/5] xfs: use fs netlink interface for ENOSPC
 conditions
In-Reply-To: <20110825051631.GB1869@infradead.org>
Message-ID: <alpine.LFD.2.00.1108251052490.4105@dhcp-27-109.brq.redhat.com>
References: <1313669906-14931-1-git-send-email-lczerner@redhat.com> <1313669906-14931-5-git-send-email-lczerner@redhat.com> <20110825051631.GB1869@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Christoph Hellwig wrote:

> >  	xfs_rw_iunlock(ip, iolock);
> > +	if (unlikely(-ENOSPC == ret))
> > +		fs_nl_send_warning(inode->i_sb->s_dev, FS_NL_ENOSPC_WARN);
> 
> I'd remove the nl from both the name and the constants.  In the end what
> matters is the warning, and netlink just is an implementation detail.

That makes sense, I'll change that.

> 
> > index 9a72dda..dd167a0 100644
> > --- a/fs/xfs/linux-2.6/xfs_super.c
> > +++ b/fs/xfs/linux-2.6/xfs_super.c
> > @@ -1731,6 +1731,7 @@ init_xfs_fs(void)
> >  	error = register_filesystem(&xfs_fs_type);
> >  	if (error)
> >  		goto out_sysctl_unregister;
> > +	init_fs_nl_family();
> 
> Why do we have to call this from the filesystem?  Shouldn't we
> initialize it once from the VFS?

That's probably better than initialization in every file system. It
would also mean that the interface will be initializes even if there is
no user of it on the kernel side, but that should not be a problem I
guess.

> 
> 
> 
> Also any chance you could include the quota netlink warnings into the
> framework?  Any callers is also going to be interestested in quota
> warnings, not just enospc.  Also the xfs project quota code returns
> ENOSPC if over the project quota and needs to be handled either way.
> Adding another new category inbetween user/group quotas and plain ENOSPC
> for it would be nice.

That's the plan. I want to merge quota notification into this interface
as well (rather than having separate netlink interface
fs/quota/netlink.c). So, I'll try to do that in the next version of the
patches.

Thanks!
-Lukas
