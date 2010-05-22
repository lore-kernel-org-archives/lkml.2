Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0EVJjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 05:39:52 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:51408 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab0EVJju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 05:39:50 -0400
Message-ID: <4BF7A65D.1070501@bfs.de>
Date: Sat, 22 May 2010 11:39:41 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
       Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 10/27] drivers/infiniband/core: Use memdup_user
References: <Pine.LNX.4.64.1005221021030.13021@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005221021030.13021@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> Use memdup_user when user data is immediately copied into the
> allocated region.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression from,to,size,flag;
> position p;
> identifier l1,l2;
> @@
> 
> -  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
> +  to = memdup_user(from,size);
>    if (
> -      to==NULL
> +      IS_ERR(to)
>                  || ...) {
>    <+... when != goto l1;
> -  -ENOMEM
> +  PTR_ERR(to)
>    ...+>
>    }
> -  if (copy_from_user(to, from, size) != 0) {
> -    <+... when != goto l2;
> -    -EFAULT
> -    ...+>
> -  }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/infiniband/core/ucm.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
> index 4647484..08f948d 100644
> --- a/drivers/infiniband/core/ucm.c
> +++ b/drivers/infiniband/core/ucm.c
> @@ -706,14 +706,9 @@ static int ib_ucm_alloc_data(const void **dest, u64 src, u32 len)
>  	if (!len)
>  		return 0;
>  
> -	data = kmalloc(len, GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
> -	if (copy_from_user(data, (void __user *)(unsigned long)src, len)) {
> -		kfree(data);
> -		return -EFAULT;
> -	}
> +	data = memdup_user((void __user *)(unsigned long)src, len);
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
>  
>  	*dest = data;
>  	return 0;
> --

This cast look strange, can it happen that (unsigned long)<(u64) ?
(is there a 32bit infiniband) ?

just my 2 cents,
 wh




