Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab1BWVqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:46:17 -0500
Received: from kroah.org ([198.145.64.141]:59315 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab1BWVqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:46:14 -0500
Date: Wed, 23 Feb 2011 13:26:44 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Message-ID: <20110223212644.GC23766@kroah.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:19:55PM -0800, Haiyang Zhang wrote:
> The patch fixed the code depending on the exact order of fields in the
> struct vmbus_driver_context, so the unused field drv_ctx can be removed,
> and drv_obj doesn't have to be the second field in this structure.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/blkvsc_drv.c  |    2 ++
>  drivers/staging/hv/netvsc_drv.c  |    2 ++
>  drivers/staging/hv/storvsc_drv.c |    2 ++
>  drivers/staging/hv/vmbus.h       |    2 +-
>  drivers/staging/hv/vmbus_drv.c   |   14 +-------------
>  5 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 36a0adb..293ab8e 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -177,6 +177,8 @@ static int blkvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
>  	struct driver_context *drv_ctx = &g_blkvsc_drv.drv_ctx;
>  	int ret;
>  
> +	drv_ctx->hv_drv = &storvsc_drv_obj->base;
> +
>  	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
>  
>  	/* Callback to client driver to complete the initialization */
> diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
> index 03f9740..364b6c7 100644
> --- a/drivers/staging/hv/netvsc_drv.c
> +++ b/drivers/staging/hv/netvsc_drv.c
> @@ -500,6 +500,8 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
>  	struct driver_context *drv_ctx = &g_netvsc_drv.drv_ctx;
>  	int ret;
>  
> +	drv_ctx->hv_drv = &net_drv_obj->base;
> +
>  	net_drv_obj->ring_buf_size = ring_size * PAGE_SIZE;
>  	net_drv_obj->recv_cb = netvsc_recv_callback;
>  	net_drv_obj->link_status_change = netvsc_linkstatus_callback;
> diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
> index a8427ff..33acee5 100644
> --- a/drivers/staging/hv/storvsc_drv.c
> +++ b/drivers/staging/hv/storvsc_drv.c
> @@ -140,6 +140,8 @@ static int storvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
>  	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv.drv_obj;
>  	struct driver_context *drv_ctx = &g_storvsc_drv.drv_ctx;
>  
> +	drv_ctx->hv_drv = &storvsc_drv_obj->base;
> +
>  	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
>  
>  	/* Callback to client driver to complete the initialization */
> diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h
> index 42f2adb..fd9d00f 100644
> --- a/drivers/staging/hv/vmbus.h
> +++ b/drivers/staging/hv/vmbus.h
> @@ -30,8 +30,8 @@
>  
>  struct driver_context {
>  	struct hv_guid class_id;
> -
>  	struct device_driver driver;
> +	struct hv_driver *hv_drv;

If you have a pointer to hv_driver, why do you need a full 'struct
device_driver' here?  That sounds really wrong.

Actually, having 'struct device_driver' within a structure called
"driver_context" seems wrong, this should be what 'struct hv_driver'
really is, right?

So no, I can't take this patch, as it isn't solving the root problem
here.

thanks,

greg k-h
