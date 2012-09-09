Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab2IIUUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:20:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab2IIUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:20:03 -0400
Date: Mon, 10 Sep 2012 01:49:47 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio: console: fix error handling in init() function
Message-ID: <20120909201947.GF16985@amit.redhat.com>
References: <1346528977-23066-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346528977-23066-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On (Sat) 01 Sep 2012 [23:49:37], Alexey Khoroshilov wrote:
> If register_virtio_driver() fails, virtio-ports class is not destroyed.
> The patch adds error handling of register_virtio_driver().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/char/virtio_console.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index cdf2f54..060a672 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -1941,7 +1941,17 @@ static int __init init(void)
>  	INIT_LIST_HEAD(&pdrvdata.consoles);
>  	INIT_LIST_HEAD(&pdrvdata.portdevs);
>  
> -	return register_virtio_driver(&virtio_console);
> +	err = register_virtio_driver(&virtio_console);
> +	if (err < 0) {
> +		pr_err("Error %d registering virtio driver\n", err);
> +		goto free;
> +	}
> +	return 0;
> +free:
> +	if (pdrvdata.debugfs_dir)
> +		debugfs_remove_recursive(pdrvdata.debugfs_dir);
> +	class_destroy(pdrvdata.class);
> +	return err;
>  }
>  
>  static void __exit fini(void)

Patch looks good.

Acked-by: Amit Shah <amit.shah@redhat.com>

Rusty, please pick this up.

Thanks,
		Amit
