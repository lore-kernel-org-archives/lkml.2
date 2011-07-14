Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1GNINd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:13:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62337 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1GNINb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:13:31 -0400
X-IronPort-AV: E=Sophos;i="4.65,528,1304294400"; 
   d="scan'208";a="6774995"
Subject: Re: [PATCH resubmit] xen-blkfront: Don't send closing 
 notification to backend in blkfront_closing()
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Joe Jin <joe.jin@oracle.com>
CC: Daniel Stodden <Daniel.Stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        "Greg Marsden" <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <4E1CEB34.5090907@oracle.com>
References: <4E1CEB34.5090907@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 14 Jul 2011 09:13:29 +0100
Message-ID: <1310631209.634.444.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 01:47 +0100, Joe Jin wrote:
> When we do block device attach/detach test with below steps, umount hang and the
> guest unable to shutdown:
> 
> 1. start guest with the latest kernel.
> 2. attach new block device by xm block-attach in Dom0
> 3. mount new disk in guest
> 4. execute xm block-detach to detach the block device in dom0 until timeout
> 5. try to unmount the disk in guest, umount hung. at here, any IOs to the 
>    device will hang.
> 
> Checking the code found when 'xm block-detach' set backend device's state to
> 'XenbusStateClosing', frontend received the notification and blkfront_closing()
> be called, at the moment, the disk still using by guest, so frontend refused
> to close. In the blkfront_closing(), frontend send a notification to backend
> said that the its state switched to 'Closing', when backend got the
> event, it will disconnect from real device, at here any IO request will
> be stuck, even tried to release the disk by umount.
> 
> Per our test, below patch fix this issue.

It's worth mentioning here that the change to xbdev->state is picked up
in blkif_release() when the device is closed and the disconnect happens
at that point instead.

I'm wondering if we might not be better off deferring the disconnect on
the backend side until the frontend enters XenbusStateClosed instead of
doing it in closing.

Ian

> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Annie Li <annie.li@oracle.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: stable@kernel.org
> 
> ---
>  xen-blkfront.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index b536a9c..f6d8ac2 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1088,7 +1088,7 @@ blkfront_closing(struct blkfront_info *info)
>  	if (bdev->bd_openers) {
>  		xenbus_dev_error(xbdev, -EBUSY,
>  				 "Device in use; refusing to close");
> -		xenbus_switch_state(xbdev, XenbusStateClosing);
> +		xbdev->state = XenbusStateClosing;
>  	} else {
>  		xlvbd_release_gendisk(info);
>  		xenbus_frontend_closed(xbdev);


