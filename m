Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0LQUpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:45:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab0LQUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:45:46 -0500
Message-ID: <4D0BCBF0.7060909@sandeen.net>
Date: Fri, 17 Dec 2010 14:45:36 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-fsdevel@vger.kernel.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        bfields@fieldses.org
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias V2
References: <1290131575-2489-1-git-send-email-josef@redhat.com>
In-Reply-To: <1290131575-2489-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 07:52 PM, Josef Bacik wrote:
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
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Thanks, this fixes xfsdump too, see also:

https://bugzilla.redhat.com/show_bug.cgi?id=662344
Bug 662344 - broken SELinux AVCs on XFS partition when running xfsdump

(xfsdump uses the open by handle library from xfsprogs)

-Eric

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

