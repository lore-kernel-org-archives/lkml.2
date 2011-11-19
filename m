Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab1KSUvL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 15:51:11 -0500
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:53485 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab1KSUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 15:51:09 -0500
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Michal Nazarewicz <mpn@google.com>
Subject: Re: [PATCH 1/3] usb: udc: Fix gadget driver's speed check in various UDC drivers
Date: Sat, 19 Nov 2011 21:50:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Felipe Balbi <balbi@ti.com>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Anatolij Gustschin <agust@denx.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ben Dooks <ben@simtec.co.uk>, Thomas Abraham <thomas.ab@samsung.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1111161624570.3443-100000@iolanthe.rowland.org> <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
In-Reply-To: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111192150.48288.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Am Samstag 19 November 2011, 18:26:25 schrieb Michal Nazarewicz:
> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Several UDC drivers had a gadget driver's speed sanity check of the
> form of:
> 
> 	driver->speed != USB_SPEED_HIGH
> 
> or:
> 
> 	driver->speed != USB_SPEED_HIGH && driver->speed != USB_SPEED_FULL
> 
> As more and more gadget drivers support USB SuperSpeed, driver->speed
> may be set to USB_SPEED_SUPER and UDC driver should handle such gadget
> correctly.  The above checks however fail to recognise USB_SPEED_SUPER
> as a valid speed.
> 
> This commit changes the two checks to:
> 
> 	driver->speed < USB_SPEED_HIGH
> 
> or:
> 
> 	driver->speed < USB_SPEED_FULL
> 
> respectively.
> 
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Reported-by: Alan Stern <stern@rowland.harvard.edu>
> ---
> 
> I had no way of testing those changes but it appears that those UDC
> drivers check gadget driver's speed only on the entry point and then
> nothing is really dependent on it.
> 
> The only thing that makes me wonder a little is that
> USB_SPEED_WIRELESS will be allowed by the above checks and I'm not
> entirely sure if that's desired (even though that's probably not an
> issue right now).
> 
> Nonetheless, this patch needs to get merged to 3.2 as without it
> file_storage won't work on UDC drivers this patch updates.
> 
> The next two patches that follow this one are replacements for
> [291a72f8: usb: gadget: replace usb_gadget::is_dualspeed with
> max_speed] and [d93bb846: usb: gadget: rename usb_gadget_driver::speed
> to max_speed] from Felipe's gadget tree, which did not apply correctly
> on top of this patch.
> 
> The whole series is based on Greg's for-linus tree.
> 
>  drivers/usb/gadget/amd5536udc.c   |    2 +-
>  drivers/usb/gadget/fsl_qe_udc.c   |    3 +--
>  drivers/usb/gadget/fsl_udc_core.c |    3 +--
>  drivers/usb/gadget/m66592-udc.c   |    2 +-
>  drivers/usb/gadget/net2280.c      |    2 +-
>  drivers/usb/gadget/r8a66597-udc.c |    2 +-
>  drivers/usb/gadget/s3c-hsotg.c    |    4 +---
>  drivers/usb/gadget/s3c-hsudc.c    |    3 +--
>  drivers/usb/musb/musb_gadget.c    |    2 +-
>  9 files changed, 9 insertions(+), 14 deletions(-)
 
[...]

> diff --git a/drivers/usb/gadget/s3c-hsudc.c
> b/drivers/usb/gadget/s3c-hsudc.c index 8d54f89..20a553b 100644
> --- a/drivers/usb/gadget/s3c-hsudc.c
> +++ b/drivers/usb/gadget/s3c-hsudc.c
> @@ -1142,8 +1142,7 @@ static int s3c_hsudc_start(struct usb_gadget_driver
> *driver, int ret;
> 
>  	if (!driver
> -		|| (driver->speed != USB_SPEED_FULL &&
> -			driver->speed != USB_SPEED_HIGH)
> +		|| driver->speed < USB_SPEED_FULL
> 
>  		|| !bind
>  		|| !driver->unbind || !driver->disconnect || !driver->setup)
> 
>  		return -EINVAL;

For s3c-hsudc on a S3C2416 based device

Tested-by: Heiko Stuebner <heiko@sntech.de>


[...]

Heiko
