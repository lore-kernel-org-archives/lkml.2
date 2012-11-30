Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2K3ANJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 19:13:09 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51449 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab2K3ANH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 19:13:07 -0500
Date: Fri, 30 Nov 2012 01:13:04 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Cong Ding <dinggnu@gmail.com>, h@local
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
Message-ID: <20121130001304.GB2590@local>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 05:40:00PM +0000, Cong Ding wrote:
> In version 1, I forgot to modify the same bug in the first loop.
> 
> we have to call kobject_put() to clean up the kobject after function
> kobject_init(), kobject_add(), or kobject_uevent() is called.

Yes, thanks. Incredible how that code looks like...
There's still another bug: The memory allocated with kzalloc is
never freed. More tomorrow, have to go to sleep now.

Thanks,
Hans

> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  drivers/uio/uio.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 5110f36..79774d3 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -291,10 +291,10 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>  		mem->map = map;
>  		ret = kobject_add(&map->kobj, idev->map_dir, "map%d", mi);
>  		if (ret)
> -			goto err_map;
> +			goto err_map_kobj;
>  		ret = kobject_uevent(&map->kobj, KOBJ_ADD);
>  		if (ret)
> -			goto err_map;
> +			goto err_map_kobj;
>  	}
>  
>  	for (pi = 0; pi < MAX_UIO_PORT_REGIONS; pi++) {
> @@ -317,23 +317,27 @@ static int uio_dev_add_attributes(struct uio_device *idev)
>  		ret = kobject_add(&portio->kobj, idev->portio_dir,
>  							"port%d", pi);
>  		if (ret)
> -			goto err_portio;
> +			goto err_portio_kobj;
>  		ret = kobject_uevent(&portio->kobj, KOBJ_ADD);
>  		if (ret)
> -			goto err_portio;
> +			goto err_portio_kobj;
>  	}
>  
>  	return 0;
>  
>  err_portio:
> -	for (pi--; pi >= 0; pi--) {
> +	pi--;
> +err_portio_kobj:
> +	for (; pi >= 0; pi--) {
>  		port = &idev->info->port[pi];
>  		portio = port->portio;
>  		kobject_put(&portio->kobj);
>  	}
>  	kobject_put(idev->portio_dir);
>  err_map:
> -	for (mi--; mi>=0; mi--) {
> +	mi--;
> +err_map_kobj:
> +	for (; mi >= 0; mi--) {
>  		mem = &idev->info->mem[mi];
>  		map = mem->map;
>  		kobject_put(&map->kobj);
> -- 
> 1.7.4.5
> 
> 
