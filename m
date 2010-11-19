Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab0KSWf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:35:56 -0500
Received: from fieldses.org ([174.143.236.118]:48034 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab0KSWfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:35:53 -0500
Date: Fri, 19 Nov 2010 17:35:52 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias V2
Message-ID: <20101119223552.GB12783@fieldses.org>
References: <1290131575-2489-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290131575-2489-1-git-send-email-josef@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 08:52:55PM -0500, Josef Bacik wrote:
> While trying to track down some NFS problems with BTRFS, I kept noticing I was
> getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
> figure out that it was SELinux that was giving me grief, with the following
> denial
> 
> type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
> comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
> tcontext=system_u:object_r:unlabeled_t:s0 tclass=file
> 
> Turns out this is because in d_obtain_alias if we can't find an alias we create
> one and do all the normal instantiation stuff, but we don't do the
> security_d_instantiate.
> 
> Usually we are protected from getting a hashed dentry that hasn't yet run
> security_d_instantiate() by the parent's i_mutex, but obviously this isn't an
> option there, so in order to deal with the case that a second thread comes in
> and finds our new dentry before we get to run security_d_instantiate(), we go
> ahead and call it if we find a dentry already.  Eric assures me that this is ok
> as the code checks to see if the dentry has been initialized already so calling
> security_d_instantiate() against the same dentry multiple times is ok.  With
> this patch I'm no longer getting errant -EACCESS values.

Thanks, I can't see any reason that wouldn't work.

--b.

> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2:
> -added second security_d_instantiate() call
> 
>  fs/dcache.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 23702a9..119d489 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1201,9 +1201,12 @@ struct dentry *d_obtain_alias(struct inode *inode)
>  	spin_unlock(&tmp->d_lock);
>  
>  	spin_unlock(&dcache_lock);
> +	security_d_instantiate(tmp, inode);
>  	return tmp;
>  
>   out_iput:
> +	if (res && !IS_ERR(res))
> +		security_d_instantiate(res, inode);
>  	iput(inode);
>  	return res;
>  }
> -- 
> 1.6.6.1
> 
