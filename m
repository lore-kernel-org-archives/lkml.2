Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab0IFHvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 03:51:31 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:26450 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0IFHvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 03:51:23 -0400
Message-ID: <4C849D78.9040202@bfs.de>
Date: Mon, 06 Sep 2010 09:51:20 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        David Cross <david.cross@cypress.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] staging: westbridge: improve error path
References: <1283711573-7460-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1283711573-7460-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Kulikov Vasiliy schrieb:
> From: Vasiliy Kulikov <segooon@gmail.com>
> 
> kmalloc() may fail, check for it.
> Allocated memory is not freed.
> Use IS_ERR() instead of strict checking.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I couldn't compile this driver at all, so it is not tested.
> 
>  .../staging/westbridge/astoria/gadget/cyasgadget.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/westbridge/astoria/gadget/cyasgadget.c b/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
> index ced239d..48080b3 100644
> --- a/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
> +++ b/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
> @@ -1123,6 +1123,8 @@ static int cyasgadget_ioctl(
>  
>  		/* better use fixed size buff*/
>  		alloc_filename = kmalloc(k_d.name_length + 1, GFP_KERNEL);
> +		if (alloc_filename == NULL)
> +			return -ENOMEM;
>  
>  		/* get the filename */
>  		if (copy_from_user(alloc_filename, k_d.file_name,
> @@ -1132,12 +1134,13 @@ static int cyasgadget_ioctl(
>  				"copy file name from user space failed\n",
>  				__func__);
>  			#endif
> +			kfree(alloc_filename);
>  			return -EFAULT;
>  		}
>  
>  		file_to_allocate = filp_open(alloc_filename, O_RDWR, 0);
>  
> -		if ((int)file_to_allocate != 0xfffffffe) {
> +		if (!IS_ERR(file_to_allocate)) {
>  
>  			struct address_space *mapping =
>  				file_to_allocate->f_mapping;
> @@ -1379,6 +1382,7 @@ static int cyasgadget_ioctl(
>  				__func__, alloc_filename);
>  		} /* end if (file_to_allocate)*/
>  		#endif
> +		kfree(alloc_filename);
>  initsoj_safe_exit:
>  			ret_stat = 0;
>  			retval = __put_user(ret_stat,
> @@ -1410,12 +1414,15 @@ initsoj_safe_exit:
>  				return -EFAULT;
>  
>  		map_filename = kmalloc(k_d.name_length + 1, GFP_KERNEL);
> +		if (map_filename == NULL)
> +			return -ENOMEM;
>  		if (copy_from_user(map_filename, k_d.file_name,
>  			k_d.name_length + 1)) {
>  			#ifndef WESTBRIDGE_NDEBUG
>  			cy_as_hal_print_message("%s: copy file name from "
>  				"user space failed\n", __func__);
>  			#endif
> +			kfree(map_filename);
>  			return -EFAULT;
>  		}

the indention should be fixed also.

re,
 wh



> @@ -1561,6 +1568,7 @@ initsoj_safe_exit:
>  					__func__, map_filename);
>  		}
>  		#endif
> +		kfree(map_filename);
>  
>  		ret_stat = 0;
>  		retval = __put_user(ret_stat, (uint32_t __user *)
