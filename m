Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab1HYUnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:43:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34869 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab1HYUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:43:32 -0400
X-Sasl-enc: yCUT1UYDhIom+tVNpcYCXl1uO1v1uA7f5O22rBN+iPgh 1314305011
Date: Thu, 25 Aug 2011 13:43:13 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 06/59] Staging: hv: blkvsc: Use the newly introduced
 vmbus ID in the blockvsc driver
Message-ID: <20110825204313.GA3432@kroah.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-6-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314290965-2698-6-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 09:48:32AM -0700, K. Y. Srinivasan wrote:
> Use the newly introduced vmbus ID in the blockvsc driver. Also, do
> the associated cleanup.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/blkvsc_drv.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
> index 018b293..9b99387 100644
> --- a/drivers/staging/hv/blkvsc_drv.c
> +++ b/drivers/staging/hv/blkvsc_drv.c
> @@ -111,14 +111,6 @@ struct block_device_context {
>  
>  static const char *drv_name = "blkvsc";
>  
> -/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
> -static const uuid_le dev_type = {
> -	.b = {
> -		0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> -		0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> -	}
> -};
> -
>  /*
>   * There is a circular dependency involving blkvsc_request_completion()
>   * and blkvsc_do_request().
> @@ -802,10 +794,24 @@ static void blkvsc_request(struct request_queue *queue)
>  	}
>  }
>  
> +static const struct hv_vmbus_device_id id_table[] = {
> +	{
> +		/* IDE guid */
> +		.guid = {
> +			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> +			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> +		}
> +	},
> +	{
> +		.guid = { }
> +	},
> +};
>  
> +MODULE_DEVICE_TABLE(vmbus, id_table);
>  
>  /* The one and only one */
>  static  struct hv_driver blkvsc_drv = {
> +	.id_table = id_table,
>  	.probe =  blkvsc_probe,
>  	.remove =  blkvsc_remove,
>  	.shutdown = blkvsc_shutdown,
> @@ -829,7 +835,6 @@ static int blkvsc_drv_init(void)
>  
>  	BUILD_BUG_ON(sizeof(sector_t) != 8);
>  
> -	memcpy(&drv->dev_type, &dev_type, sizeof(uuid_le));

If I'm not mistaken, the driver just broke now and will not bind
properly to this device, right?

Ick, oh well, I'll plod on and hope that you fix this issue up in a
later patch, but note that this might make 'git bisect' cause problems
if someone lands in the middle of this series with things broken
(run-time, not build time).

Sorry, I should have caught that first time through this series, I
didn't realize it until right now when I tried it.

greg k-h
