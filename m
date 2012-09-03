Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab2ICONf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab2ICONe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:13:34 -0400
Date: Mon, 3 Sep 2012 17:14:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: sjur.brandeland@stericsson.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org,
        "Guzman Lugo, Fernadndo" <fernando.lugo@ti.com>,
        virtualization@lists.linux-foundation.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH] virtio: Don't access device data after unregistration.
Message-ID: <20120903141445.GA5054@redhat.com>
References: <1346680242-5717-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346680242-5717-1-git-send-email-sjur.brandeland@stericsson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 03:50:42PM +0200, sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Fix panic in virtio.c when CONFIG_DEBUG_SLAB is set.

What's the root cause of the panic?


> Use device_del() and put_device() instead of
> device_unregister(), and access device data before
> calling put_device().

Why does this help? Does device_unregister free the
device so dev->index access crashes?
If yes virtio_pci_remove will crash too
as it accesses the device after the
call to unregister_virtio_device so the
fix won't be effective.

> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: Guzman Lugo, Fernadndo <fernando.lugo@ti.com>
> cc: Michael S. Tsirkin <mst@redhat.com>
> cc: virtualization@lists.linux-foundation.org
> cc: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  drivers/virtio/virtio.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index c3b3f7f..71eacd1 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -225,8 +225,9 @@ EXPORT_SYMBOL_GPL(register_virtio_device);
>  
>  void unregister_virtio_device(struct virtio_device *dev)
>  {
> -	device_unregister(&dev->dev);
> +	device_del(&dev->dev);
>  	ida_simple_remove(&virtio_index_ida, dev->index);
> +	put_device(&dev->dev);
>  }
>  EXPORT_SYMBOL_GPL(unregister_virtio_device);
>  
> -- 
> 1.7.5.4
