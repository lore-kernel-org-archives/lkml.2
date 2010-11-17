Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249Ab0KQSyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935075Ab0KQSyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:54:12 -0500
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias
From: Eric Paris <eparis@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sds@tycho.nsa.gov, selinux@tycho.nsa.gov
In-Reply-To: <1290016263-1637-1-git-send-email-josef@redhat.com>
References: <1290016263-1637-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 13:54:08 -0500
Message-ID: <1290020048.14282.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 12:51 -0500, Josef Bacik wrote:
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
> security_d_instantiate.  With this patch I'm no longer seeing these errant
> -EACCESS return values.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Adding a couple of people to the CC just to make sure they notice this
patch.

-Eric

> ---
>  fs/dcache.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 23702a9..890a59e 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1201,6 +1201,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
>  	spin_unlock(&tmp->d_lock);
>  
>  	spin_unlock(&dcache_lock);
> +	security_d_instantiate(tmp, inode);
>  	return tmp;
>  
>   out_iput:


