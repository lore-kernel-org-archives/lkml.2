Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab2HOTiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:38:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab2HOTiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:38:08 -0400
Date: Wed, 15 Aug 2012 21:38:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Subject: Re: [PATCH] HID: hidraw: improve error handling in hidraw_init()
In-Reply-To: <1345059105-26827-1-git-send-email-khoroshilov@ispras.ru>
Message-ID: <alpine.LNX.2.00.1208152137510.7026@pobox.suse.cz>
References: <1345059105-26827-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Alexey Khoroshilov wrote:

> Several improvements in error handling:
> - do not report success if alloc_chrdev_region() failed
> - check for error code of cdev_add()
> - use unregister_chrdev_region() instead of unregister_chrdev()
>   if class_create() failed
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/hid/hidraw.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 36fa77b..15e6660 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -549,21 +549,28 @@ int __init hidraw_init(void)
>  
>  	if (result < 0) {
>  		pr_warn("can't get major number\n");
> -		result = 0;
>  		goto out;
>  	}
>  
>  	hidraw_class = class_create(THIS_MODULE, "hidraw");
>  	if (IS_ERR(hidraw_class)) {
>  		result = PTR_ERR(hidraw_class);
> -		unregister_chrdev(hidraw_major, "hidraw");
> -		goto out;
> +		goto error_cdev;
>  	}
>  
>          cdev_init(&hidraw_cdev, &hidraw_ops);
> -        cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
> +	result = cdev_add(&hidraw_cdev, dev_id, HIDRAW_MAX_DEVICES);
> +	if (result < 0)
> +		goto error_class;
> +
>  out:
>  	return result;
> +
> +error_class:
> +	class_destroy(hidraw_class);
> +error_cdev:
> +	unregister_chrdev_region(dev_id, HIDRAW_MAX_DEVICES);
> +	goto out;
>  }
>  
>  void hidraw_exit(void)

Applied, thanks Alexey.

-- 
Jiri Kosina
SUSE Labs
