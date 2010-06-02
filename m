Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab0FBJJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:09:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:56210 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab0FBJI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:08:57 -0400
Date: Wed, 2 Jun 2010 11:08:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/hid: introduce missing kfree
In-Reply-To: <Pine.LNX.4.64.1006011634560.12546@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.1006021108460.12271@pobox.suse.cz>
References: <Pine.LNX.4.64.1006011634560.12546@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kmalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...x...+> }
> (
> x->f1 = E
> |
>  (x->f1 == NULL || ...)
> |
>  f(...,x->f1,...)
> )
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/hid/hid-roccat.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
> index e05d48e..f6e80c7 100644
> --- a/drivers/hid/hid-roccat.c
> +++ b/drivers/hid/hid-roccat.c
> @@ -168,7 +168,7 @@ static int roccat_open(struct inode *inode, struct file *file)
>  		printk(KERN_EMERG "roccat device with minor %d doesn't exist\n",
>  				minor);
>  		error = -ENODEV;
> -		goto exit_unlock;
> +		goto exit_err;
>  	}
>  
>  	if (!device->open++) {
> @@ -178,7 +178,7 @@ static int roccat_open(struct inode *inode, struct file *file)
>  					PM_HINT_FULLON);
>  			if (error < 0) {
>  				--device->open;
> -				goto exit_unlock;
> +				goto exit_err;
>  			}
>  		}
>  		error = device->hid->ll_driver->open(device->hid);
> @@ -187,7 +187,7 @@ static int roccat_open(struct inode *inode, struct file *file)
>  				device->hid->ll_driver->power(device->hid,
>  						PM_HINT_NORMAL);
>  			--device->open;
> -			goto exit_unlock;
> +			goto exit_err;
>  		}
>  	}
>  
> @@ -202,6 +202,9 @@ exit_unlock:
>  	mutex_unlock(&device->readers_lock);
>  	mutex_unlock(&devices_lock);
>  	return error;
> +exit_err:
> +	kfree(reader);
> +	goto exit_unlock;
>  }
>  
>  static int roccat_release(struct inode *inode, struct file *file)

Applied, thank you Julia.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
