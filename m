Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2ISB0d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:26:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab2ISB0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:26:31 -0400
Date: Tue, 18 Sep 2012 22:26:23 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [ 117/135] NFS: return error from decode_getfh in decode open
Message-ID: <20120919012623.GA17910@herton-Z68MA-D2H-B3>
References: <20120917003625.784119135@decadent.org.uk>
 <20120917003642.413673073@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917003642.413673073@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 01:38:22AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> I'm not sure whether my expansion of the fix is correct here.
> 
> ------------------
> 
> From: Weston Andros Adamson <dros@netapp.com>
> 
> commit 01913b49cf1dc6409a07dd2a4cc6af2e77f3c410 upstream.
> 
> If decode_getfh failed, nfs4_xdr_dec_open would return 0 since the last
> decode_* call must have succeeded.
> 
> Signed-off-by: Weston Andros Adamson <dros@netapp.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> [bwh: Backported to 3.2: this function makes two more function calls
>  (no longer present in mainline) with the same issue, so fix them up
>  similarly.]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  fs/nfs/nfs4xdr.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- a/fs/nfs/nfs4xdr.c
> +++ b/fs/nfs/nfs4xdr.c
> @@ -6113,12 +6113,15 @@ static int nfs4_xdr_dec_open(struct rpc_
>  	status = decode_open(xdr, res);
>  	if (status)
>  		goto out;
> -	if (decode_getfh(xdr, &res->fh) != 0)
> +	status = decode_getfh(xdr, &res->fh);
> +	if (status)
>  		goto out;
> -	if (decode_getfattr(xdr, res->f_attr, res->server,
> -				!RPC_IS_ASYNC(rqstp->rq_task)) != 0)
> +	status = decode_getfattr(xdr, res->f_attr, res->server,
> +				 !RPC_IS_ASYNC(rqstp->rq_task));

I'm also not sure about the expansion of the fix here, not knowing very
much about nfs. It seems that the code in some cases want to discard the
status from decode_getfattr, for example nfs4_xdr_dec_rename is one case
which does the same. Is it ok to return the status of decode_getfattr on
nfs4_xdr_dec_open here? Or should it remain like it was before?

> +	if (status)
>  		goto out;
> -	if (decode_restorefh(xdr) != 0)
> +	status = decode_restorefh(xdr);
> +	if (status)
>  		goto out;
>  	decode_getfattr(xdr, res->dir_attr, res->server,
>  			!RPC_IS_ASYNC(rqstp->rq_task));

-- 
[]'s
Herton
