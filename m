Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0FALOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 07:14:40 -0400
Received: from bamako.nerim.net ([62.4.17.28]:52455 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0FALOi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 07:14:38 -0400
Date: Tue, 1 Jun 2010 13:14:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <julia@diku.dk>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 11/27] drivers/i2c: Use memdup_user
Message-ID: <20100601131435.5904351c@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.1005221021270.13021@ask.diku.dk>
References: <Pine.LNX.4.64.1005221021270.13021@ask.diku.dk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sat, 22 May 2010 10:21:45 +0200 (CEST), Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Use memdup_user when user data is immediately copied into the allocated
> region.  Note that in the second case, the ++i is no longer necessary, as
> the last value is already freed if needed by the call to memdup_user.
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
>  drivers/i2c/i2c-dev.c |   22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index e0694e4..03e9ef8 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -167,13 +167,9 @@ static ssize_t i2cdev_write(struct file *file, const char __user *buf,
>  	if (count > 8192)
>  		count = 8192;
>  
> -	tmp = kmalloc(count, GFP_KERNEL);
> -	if (tmp == NULL)
> -		return -ENOMEM;
> -	if (copy_from_user(tmp, buf, count)) {
> -		kfree(tmp);
> -		return -EFAULT;
> -	}
> +	tmp = memdup_user(buf, count);
> +	if (IS_ERR(tmp))
> +		return PTR_ERR(tmp);
>  
>  	pr_debug("i2c-dev: i2c-%d writing %zu bytes.\n",
>  		iminor(file->f_path.dentry->d_inode), count);
> @@ -247,15 +243,9 @@ static noinline int i2cdev_ioctl_rdrw(struct i2c_client *client,
>  			break;
>  		}
>  		data_ptrs[i] = (u8 __user *)rdwr_pa[i].buf;
> -		rdwr_pa[i].buf = kmalloc(rdwr_pa[i].len, GFP_KERNEL);
> -		if (rdwr_pa[i].buf == NULL) {
> -			res = -ENOMEM;
> -			break;
> -		}
> -		if (copy_from_user(rdwr_pa[i].buf, data_ptrs[i],
> -				   rdwr_pa[i].len)) {
> -				++i; /* Needs to be kfreed too */
> -				res = -EFAULT;
> +		rdwr_pa[i].buf = memdup_user(data_ptrs[i], rdwr_pa[i].len);
> +		if (IS_ERR(rdwr_pa[i].buf)) {
> +			res = PTR_ERR(rdwr_pa[i].buf);
>  			break;
>  		}
>  	}

Applied, thanks.

-- 
Jean Delvare
