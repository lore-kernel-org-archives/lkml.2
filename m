Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab2IBQvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 12:51:36 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33564 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab2IBQvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 12:51:35 -0400
Date: Sun, 2 Sep 2012 12:51:31 -0400
From: Kevin McKinney <klmckinney1@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, ldv-project@ispras.ru,
        linux-kernel@vger.kernel.org, klmckinney1@gmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: bcm: fix error handling in bcm_init()
Message-ID: <20120902165130.GA3952@gmail.com>
References: <1346535456-28941-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346535456-28941-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 02, 2012 at 01:37:36AM +0400, Alexey Khoroshilov wrote:
> bcm_init() does not have proper error handling of usb_register().
> The patch implements one.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/bcm/InterfaceInit.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/bcm/InterfaceInit.c b/drivers/staging/bcm/InterfaceInit.c
> index 8f85de6..0049890 100644
> --- a/drivers/staging/bcm/InterfaceInit.c
> +++ b/drivers/staging/bcm/InterfaceInit.c
> @@ -669,6 +669,8 @@ struct class *bcm_class;
>  
>  static __init int bcm_init(void)
>  {
> +	int retval;
> +
>  	printk(KERN_INFO "%s: %s, %s\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
>  	printk(KERN_INFO "%s\n", DRV_COPYRIGHT);
>  
> @@ -678,7 +680,15 @@ static __init int bcm_init(void)
>  		return PTR_ERR(bcm_class);
>  	}
>  
> -	return usb_register(&usbbcm_driver);
> +	retval = usb_register(&usbbcm_driver);
> +	if (retval < 0) {
> +		printk(KERN_ERR DRV_NAME ": could not register usb driver\n");
> +		goto out_class;
> +	}
> +	return 0;
> +out_class:
> +	class_destroy(bcm_class);
> +	return retval;
>  }
>  
Hi Alexey,

Instead of using a goto statement, can we just: (1) destory the class and (2) return retval within the if statement? i.e:

if (retval < 0) {
	printk(KERN_ERR DRV_NAME ": could not register usb driver\n");
	+class_destroy(bcm_class);
	+return retval;
}

goto statements are very useful and handy when a function exits from multiple locations because they provide a 
common exit point. The compiler will translate this into a "jump" instruction. However in this case I am not sure
it is simplifying our logic because we only have one usage. lets just call the two lines of code directly within the
if statement.

In addition, while you are in this code can you replace the "printk" statements with the preferred "pr_info" in a separate patch?  

Thanks,
Kevin
