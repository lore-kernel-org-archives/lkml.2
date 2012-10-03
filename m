Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab2JCPCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 11:02:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47736 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab2JCPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 11:02:00 -0400
Date: Wed, 3 Oct 2012 12:01:54 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alex Elder <aelder@sgi.com>, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [ 046/180] xfs: Fix possible memory corruption in xfs_readlink
Message-ID: <20121003150153.GA3222@herton-Z68MA-D2H-B3>
References: <6a854f579a99b4fe2efaca1057e8ae22@local>
 <20121001225159.562823590@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001225159.562823590@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:52:43AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> commit b52a360b2aa1c59ba9970fb0f52bbb093fcc7a24 upstream
> 
[...]
> @@ -564,13 +564,20 @@ xfs_readlink(
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  
> -	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFLNK);
> -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
> -
>  	pathlen = ip->i_d.di_size;
>  	if (!pathlen)
>  		goto out;
>  
> +	if (pathlen < 0 || pathlen > MAXPATHLEN) {
> +		xfs_fs_cmn_err(CE_ALERT, mp,
> +			 "%s: inode (%llu) bad symlink length (%lld)",
> +			 __func__, (unsigned long long) ip->i_ino,
> +			 (long long) pathlen);
> +		ASSERT(0);
> +		return XFS_ERROR(EFSCORRUPTED);

This needs a followup fix, commit 9b025eb3a89e041bab6698e3858706be2385d692
("xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()").
I think it should be also cherry-picked in this release.

> +	}
> +
> +
>  	if (ip->i_df.if_flags & XFS_IFINLINE) {
>  		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
>  		link[pathlen] = '\0';

-- 
[]'s
Herton
