Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab1BNWKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:10:07 -0500
Received: from mx2.netapp.com ([216.240.18.37]:7444 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab1BNWKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:10:04 -0500
X-IronPort-AV: E=Sophos;i="4.60,470,1291622400"; 
   d="scan'208";a="518414451"
Subject: Re: [PATCH] NFS: Zap entire 'struct inode' in
 nfs_zap_caches_locked().
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1102142252540.4530@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102142252540.4530@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Mon, 14 Feb 2011 17:09:45 -0500
Message-ID: <1297721385.23841.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 14 Feb 2011 22:09:48.0960 (UTC) FILETIME=[E54EDA00:01CBCC93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 22:56 +0100, Jesper Juhl wrote: 
> nfs_zap_caches_locked() attempts to zero all of the 'struct inode' that's 
> passed in via the pointer variable 'inode'. Unfortunately it only manages 
> to zero the size of a 'pointer to struct inode'. Fix that.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
>  compile tested only
> 
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index 1cc600e..6c4236e 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -145,7 +145,7 @@ static void nfs_zap_caches_locked(struct inode *inode)
>  	nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
>  	nfsi->attrtimeo_timestamp = jiffies;
>  
> -	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
> +	memset(NFS_COOKIEVERF(inode), 0, sizeof(*NFS_COOKIEVERF(inode)));
>  	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
>  		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
>  	else

That's incorrect.

NFS_COOKIEVERF(inode) expands to NFS_I(inode)->cookieverf, and since
cookieverf is declared inside the struct nfs_inode as 

	u32	cookieverf[2];

the sizeof(NFS_I(inode)->cookieverf) should expand to the size of the
cookieverf array (i.e. 8 bytes).

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

