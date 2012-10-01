Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab2JARTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:19:23 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:48984 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab2JARTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:19:22 -0400
X-IronPort-AV: E=Sophos;i="4.80,517,1344211200"; 
   d="scan'208";a="209912237"
Message-ID: <5069D097.60606@citrix.com>
Date: Mon, 1 Oct 2012 18:19:19 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] xen-blkfront: handle backend CLOSED without CLOSING
References: <1348243464-15903-1-git-send-email-david.vrabel@citrix.com> <1348243464-15903-3-git-send-email-david.vrabel@citrix.com> <5061EFB2.1080407@citrix.com>
In-Reply-To: <5061EFB2.1080407@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/09/12 18:53, David Vrabel wrote:
> On 21/09/12 17:04, David Vrabel wrote:
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> Backend drivers shouldn't transistion to CLOSED unless the frontend is
>> CLOSED.  If a backend does transition to CLOSED too soon then the
>> frontend may not see the CLOSING state and will not properly shutdown.
>>
>> So, treat an unexpected backend CLOSED state the same as CLOSING.
> 
> Didn't handle the frontend block device being mounted. Updated patch here.

Konrad, can you ack this updated patch if you're happy with it.

Thanks.

David

> 8<---------------------------------
> xen-blkfront: handle backend CLOSED without CLOSING
> 
> Backend drivers shouldn't transistion to CLOSED unless the frontend is
> CLOSED.  If a backend does transition to CLOSED too soon then the
> frontend may not see the CLOSING state and will not properly shutdown.
> 
> So, treat an unexpected backend CLOSED state the same as CLOSING.
> 
> If the backend is CLOSED then the frontend can't talk to it so go to
> CLOSED immediately without waiting for the block device to be closed
> or unmounted.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  drivers/block/xen-blkfront.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index 2c2d2e5..c1f5f38 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1143,7 +1143,8 @@ static int blkfront_resume(struct xenbus_device *dev)
>  }
>  
>  static void
> -blkfront_closing(struct blkfront_info *info)
> +blkfront_closing(struct blkfront_info *info,
> +		 enum xenbus_state backend_state)
>  {
>  	struct xenbus_device *xbdev = info->xbdev;
>  	struct block_device *bdev = NULL;
> @@ -1167,7 +1168,8 @@ blkfront_closing(struct blkfront_info *info)
>  
>  	mutex_lock(&bdev->bd_mutex);
>  
> -	if (bdev->bd_openers) {
> +	/* If the backend is already CLOSED, close now. */
> +	if (bdev->bd_openers && backend_state != XenbusStateClosed) {
>  		xenbus_dev_error(xbdev, -EBUSY,
>  				 "Device in use; refusing to close");
>  		xenbus_switch_state(xbdev, XenbusStateClosing);
> @@ -1340,15 +1342,18 @@ static void blkback_changed(struct xenbus_device *dev,
>  	case XenbusStateReconfiguring:
>  	case XenbusStateReconfigured:
>  	case XenbusStateUnknown:
> -	case XenbusStateClosed:
>  		break;
>  
>  	case XenbusStateConnected:
>  		blkfront_connect(info);
>  		break;
>  
> +	case XenbusStateClosed:
> +		if (dev->state == XenbusStateClosed)
> +			break;
> +		/* Missed the backend's Closing state -- fallthrough */
>  	case XenbusStateClosing:
> -		blkfront_closing(info);
> +		blkfront_closing(info, backend_state);
>  		break;
>  	}
>  }
