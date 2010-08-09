Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0HIPUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:20:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35735 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab0HIPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:20:13 -0400
Date: Mon, 9 Aug 2010 17:20:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/3] usb gadget: don't save bind callback in struct
	usb_composite_driver
Message-ID: <20100809152010.GE27747@pengutronix.de>
References: <3decda614c6d8732c018417558d74ed942e76c82.1281359651.git.m.nazarewicz@samsung.com> <e465429de034460cdc6eff4e3502d2be83264f82.1281359651.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e465429de034460cdc6eff4e3502d2be83264f82.1281359651.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michał,

On Mon, Aug 09, 2010 at 03:33:49PM +0200, Michal Nazarewicz wrote:
> The bind function is most of the time only called at init time so there
> is no need to save a pointer to it in the composite driver structure.
> 
> This fixes many section mismatches reported by modpost.
> 
> Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/usb/gadget/audio.c        |    3 +--
>  drivers/usb/gadget/cdc2.c         |    3 +--
>  drivers/usb/gadget/composite.c    |   19 +++++++++++++------
>  drivers/usb/gadget/ether.c        |    3 +--
>  drivers/usb/gadget/g_ffs.c        |    3 +--
>  drivers/usb/gadget/hid.c          |    3 +--
>  drivers/usb/gadget/mass_storage.c |    3 +--
>  drivers/usb/gadget/multi.c        |    3 +--
>  drivers/usb/gadget/serial.c       |    3 +--
>  drivers/usb/gadget/webcam.c       |    3 +--
>  drivers/usb/gadget/zero.c         |    3 +--
>  include/linux/usb/composite.h     |   15 +++------------
>  12 files changed, 26 insertions(+), 38 deletions(-)
> 
> This replaces Uwe's patch which used __refdata for instances of struct
> usb_composite_driver.  This patch replaces usb_composite_register() with
> usb_composite_probe() in similar fashion to other two Uwe's patches.
> 
> diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
> index a62af7b..5a65fbb 100644
> --- a/drivers/usb/gadget/audio.c
> +++ b/drivers/usb/gadget/audio.c
> @@ -166,13 +166,12 @@ static struct usb_composite_driver audio_driver = {
>  	.name		= "g_audio",
>  	.dev		= &device_desc,
>  	.strings	= audio_strings,
> -	.bind		= audio_bind,
>  	.unbind		= __exit_p(audio_unbind),
>  };
>  
>  static int __init init(void)
>  {
> -	return usb_composite_register(&audio_driver);
> +	return usb_composite_probe(&audio_driver, audio_bind);
>  }
>  module_init(init);
>  
> diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
> index 928137d..1f2a9b1 100644
> --- a/drivers/usb/gadget/cdc2.c
> +++ b/drivers/usb/gadget/cdc2.c
> @@ -245,7 +245,6 @@ static struct usb_composite_driver cdc_driver = {
>  	.name		= "g_cdc",
>  	.dev		= &device_desc,
>  	.strings	= dev_strings,
> -	.bind		= cdc_bind,
>  	.unbind		= __exit_p(cdc_unbind),
>  };
>  
> @@ -255,7 +254,7 @@ MODULE_LICENSE("GPL");
>  
>  static int __init init(void)
>  {
> -	return usb_composite_register(&cdc_driver);
> +	return usb_composite_probe(&cdc_driver, cdc_bind);
>  }
>  module_init(init);
>  
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index 4590c6a..3cafda7 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -39,6 +39,7 @@
>  #define USB_BUFSIZ	1024
>  
>  static struct usb_composite_driver *composite;
> +static int (*composite_gadget_bind)(struct usb_composite_dev *cdev);
This can be __initdata, can't it?

I thought about usb_composite_drivers, too, and wondered if it would be
sensible to change the additional argument of usb_gadget_probe_driver to
struct usb_gadget_probe_data *probe_data.  Then you could do the
following

	struct usb_composite_probe_data {
		struct usb_gadget_probe_data usb_probe_data;
		int (*composite_gadget_bind)(struct usb_composite_dev *);
	}

and in composite_bind use container_of to get the gadget_bind function.

Maybe that's overengineered though.  As there is already a dependency on
a global variable (i.e. composite) your patch doesn't make it much
worse.  Just my 0.02€.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
