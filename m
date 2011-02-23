Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1BWVqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:46:48 -0500
Received: from kroah.org ([198.145.64.141]:59322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab1BWVqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:46:15 -0500
Date: Wed, 23 Feb 2011 13:27:38 -0800
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: [PATCH 2/4] staging: hv: Fix the code depending on struct
 netvsc_driver_context data order
Message-ID: <20110223212738.GD23766@kroah.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 12:19:56PM -0800, Haiyang Zhang wrote:
> The patch fixed the code depending on the exact order of fields in the
> struct netvsc_driver_context. Now, we use container_of() instead of type
> casting from the first field to the container struct.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> 
> ---
>  drivers/staging/hv/netvsc_drv.c |   14 ++++++--------
>  1 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
> index 364b6c7..c78624c 100644
> --- a/drivers/staging/hv/netvsc_drv.c
> +++ b/drivers/staging/hv/netvsc_drv.c
> @@ -49,8 +49,6 @@ struct net_device_context {
>  };
>  
>  struct netvsc_driver_context {
> -	/* !! These must be the first 2 fields !! */
> -	/* Which is a bug FIXME! */
>  	struct driver_context drv_ctx;
>  	struct netvsc_driver drv_obj;
>  };
> @@ -137,8 +135,8 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
>  	struct net_device_context *net_device_ctx = netdev_priv(net);
>  	struct driver_context *driver_ctx =
>  	    driver_to_driver_context(net_device_ctx->device_ctx->device.driver);
> -	struct netvsc_driver_context *net_drv_ctx =
> -		(struct netvsc_driver_context *)driver_ctx;
> +	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
> +		struct netvsc_driver_context, drv_ctx);
>  	struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
>  	struct hv_netvsc_packet *packet;
>  	int ret;
> @@ -342,8 +340,8 @@ static int netvsc_probe(struct device *device)
>  {
>  	struct driver_context *driver_ctx =
>  		driver_to_driver_context(device->driver);
> -	struct netvsc_driver_context *net_drv_ctx =
> -		(struct netvsc_driver_context *)driver_ctx;
> +	struct netvsc_driver_context *net_drv_ctx = container_of(driver_ctx,
> +		struct netvsc_driver_context, drv_ctx);

container_of calls should be turned into either a macro, or an inline
function, to make them smaller and easier to understand what is going
on.  Do that and you will solve the line-length problems as well.

Please do that here.

thanks,

greg k-h
