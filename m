Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab0E1R5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:57:49 -0400
Received: from relay2.sgi.com ([192.48.179.30]:55570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751121Ab0E1R5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:57:48 -0400
Subject: Re: [PATCH 11/17] fs/xfs/quota: Add missing mutex_unlock
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Julia Lawall <julia@diku.dk>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005261757050.23743@ask.diku.dk>
References: <Pine.LNX.4.64.1005261757050.23743@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 12:57:32 -0500
Message-ID: <1275069452.2302.5.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2010 17:57:32.0677 (UTC) FILETIME=[3F26DB50:01CAFE8F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 17:57 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Add a mutex_unlock missing on the error path.  The use of this lock is
> balanced elsewhere in the file.

Looks good.  I'll pull this one into the XFS tree.

Reviewed-by: Alex Elder <aelder@sgi.com>

> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * mutex_lock(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * mutex_unlock(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> The use of ENOMEM rather than -ENOMEM is also a bit odd.
> 
>  fs/xfs/quota/xfs_qm.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
> index 38e7641..2d8b7bc 100644
> --- a/fs/xfs/quota/xfs_qm.c
> +++ b/fs/xfs/quota/xfs_qm.c
> @@ -249,8 +249,10 @@ xfs_qm_hold_quotafs_ref(
>  
>  	if (!xfs_Gqm) {
>  		xfs_Gqm = xfs_Gqm_init();
> -		if (!xfs_Gqm)
> +		if (!xfs_Gqm) {
> +			mutex_unlock(&xfs_Gqm_lock);
>  			return ENOMEM;
> +		}
>  	}
>  
>  	/*



