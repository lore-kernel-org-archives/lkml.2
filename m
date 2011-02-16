Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1BPXes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:34:48 -0500
Received: from fieldses.org ([174.143.236.118]:43404 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1BPXep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:34:45 -0500
Date: Wed, 16 Feb 2011 18:34:38 -0500
From: "J.Bruce Fields" <bfields@fieldses.org>
To: NeilBrown <neilb@suse.de>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: nfsd: non-standard errno: 925302784
Message-ID: <20110216233438.GD14534@fieldses.org>
References: <20110210042840.GF11496@MAIL.13thfloor.at>
 <20110210195520.1b91a1f9@notabene.brown>
 <20110216131252.631edb67@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216131252.631edb67@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 01:12:52PM +1100, NeilBrown wrote:
> 
> Hi Bruce,
>  I think you might have missed this (as it wasn't in your recent pull
>  request), so I'm resending it - this time as a proper patch.

Oog, yes, I did miss it, thanks for the reminder.  Added a note about
the source of the regression an applied, and I'll pass it along soon.

--b.

> 
> NeilBrown
> 
> From 32d4cb5580392a2806a1ed5d607ff1d2b49d369e Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 16 Feb 2011 13:08:35 +1100
> Subject: [PATCH] nfsd: correctly handle return value from nfsd_map_name_to_*
> 
> These functions return an nfs status, not a host_err.  So don't
> try to convert  before returning.
> 
> Reported-by: Herbert Poetzl <herbert@13thfloor.at>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  fs/nfsd/nfs4xdr.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 956629b..1275b86 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -317,8 +317,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
>  		READ_BUF(dummy32);
>  		len += (XDR_QUADLEN(dummy32) << 2);
>  		READMEM(buf, dummy32);
> -		if ((host_err = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
> -			goto out_nfserr;
> +		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
> +			return status;
>  		iattr->ia_valid |= ATTR_UID;
>  	}
>  	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
> @@ -328,8 +328,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
>  		READ_BUF(dummy32);
>  		len += (XDR_QUADLEN(dummy32) << 2);
>  		READMEM(buf, dummy32);
> -		if ((host_err = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
> -			goto out_nfserr;
> +		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
> +			return status;
>  		iattr->ia_valid |= ATTR_GID;
>  	}
>  	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {
> -- 
> 1.7.1
> 
