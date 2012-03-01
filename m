Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965016Ab2CAVe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:34:58 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21999 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab2CAVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:34:57 -0500
Date: Thu, 1 Mar 2012 22:33:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH] mpi: Avoid using freed pointer in mpi_lshift_limbs()
In-Reply-To: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1203012232480.19443@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202062104440.20117@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ping?

On Mon, 6 Feb 2012, Jesper Juhl wrote:

> At the start of the function we assign 'a->d' to 'ap'. Then we use the
> RESIZE_IF_NEEDED macro on 'a' - this may free 'a->d' and replace it
> with newly allocaetd storage. In that case, we'll be operating on
> freed memory further down in the function when we index into 'ap[]'.
> Since we don't actually need 'ap' until after the use of the
> RESIZE_IF_NEEDED macro we can just delay the assignment to it until
> after we've potentially resized, thus avoiding the issue.
> 
> While I was there anyway I also changed the integer variable 'n' to be
> const. It might as well be since we only assign to it once and use it
> as a constant, and then the compiler will tell us if we ever assign to
> it in the future.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  lib/mpi/mpi-bit.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
>  only compile tested.
> 
> diff --git a/lib/mpi/mpi-bit.c b/lib/mpi/mpi-bit.c
> index 2f52662..0c50536 100644
> --- a/lib/mpi/mpi-bit.c
> +++ b/lib/mpi/mpi-bit.c
> @@ -177,8 +177,8 @@ int mpi_rshift(MPI x, MPI a, unsigned n)
>   */
>  int mpi_lshift_limbs(MPI a, unsigned int count)
>  {
> -	mpi_ptr_t ap = a->d;
> -	int n = a->nlimbs;
> +	const int n = a->nlimbs;
> +	mpi_ptr_t ap;
>  	int i;
>  
>  	if (!count || !n)
> @@ -187,6 +187,7 @@ int mpi_lshift_limbs(MPI a, unsigned int count)
>  	if (RESIZE_IF_NEEDED(a, n + count) < 0)
>  		return -ENOMEM;
>  
> +	ap = a->d;
>  	for (i = n - 1; i >= 0; i--)
>  		ap[i + count] = ap[i];
>  	for (i = 0; i < count; i++)
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

