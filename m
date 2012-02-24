Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab2BXGXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 01:23:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50255 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab2BXGXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:23:16 -0500
Subject: Mimo 720 input 180 deg off, e2i Re: [PATCH] Input: usbtouchscreen:
 add support for Data Modul EasyTouch TP 72037
From: shawn <shawnlandden@gmail.com>
To: Viresh Kumar <viresh.kumar@st.com>, dmitry.torokhov@gmail.com,
        Florian Echtler <floe@butterbrot.org>
Cc: linux-input@vger.kernel.org, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, viresh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com, viresh.linux@gmail.com,
        bhavna.yadav@st.com, vincenzo.frascino@st.com, mirko.gardi@st.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1df92b173fb58c4b6d3091c3eb94d53bf03cfa9e.1330061754.git.viresh.kumar@st.com>
References: <1df92b173fb58c4b6d3091c3eb94d53bf03cfa9e.1330061754.git.viresh.kumar@st.com>
Content-Type: multipart/mixed; boundary="=-cDhA0ime3GChtNaqnC1C"
Date: Thu, 23 Feb 2012 22:23:03 -0800
Message-ID: <1330064583.2154.340.camel@ssd-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cDhA0ime3GChtNaqnC1C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

As I see you working on the same file I was working on----what would you
think about a module-wide option in usbtouchscreen.c to rotate input
handling by 180 degrees?

The mimo 720 uses the same e2i but seems to (at least in my unit) have
its inputs rotated 180 deg relative to that of the mimo 740

-Shawn Landden

On Fri, 2012-02-24 at 11:22 +0530, Viresh Kumar wrote: 
> From: Armando Visconti <armando.visconti@st.com>
> 
> The Data Modul TP 72037 EasyTouch controller is derived from EGALAX
> controller and is capable of detecting dual contacts. Packets can be 5
> bytes or 10 bytes long, depending whether one or two contacts are
> detected. Format is same as EGALAX touch controller, but with x and y
> coordinates inverted.
> 
> Signed-off-by: Armando Visconti <armando.visconti@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/input/touchscreen/Kconfig          |    9 ++++
>  drivers/input/touchscreen/usbtouchscreen.c |   59 ++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index 2b21a70..2acf16f 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -607,6 +607,7 @@ config TOUCHSCREEN_USB_COMPOSITE
>  	  - JASTEC USB Touch Controller/DigiTech DTR-02U
>  	  - Zytronic controllers
>  	  - Elo TouchSystems 2700 IntelliTouch
> +	  - EasyTouch USB Touch Controller from Data Modul
>  
>  	  Have a look at <http://linux.chapter7.ch/touchkit/> for
>  	  a usage description and the required user-space stuff.
> @@ -711,6 +712,14 @@ config TOUCHSCREEN_USB_NEXIO
>  	bool "NEXIO/iNexio device support" if EXPERT
>  	depends on TOUCHSCREEN_USB_COMPOSITE
>  
> +config TOUCHSCREEN_USB_EASYTOUCH
> +	default y
> +	bool "EasyTouch USB Touch controller device support" if EMBEDDED
> +	depends on TOUCHSCREEN_USB_COMPOSITE
> +	help
> +	  Say Y here if you have a EasyTouch USB Touch controller device support.
> +	  If unsure, say N.
> +
>  config TOUCHSCREEN_TOUCHIT213
>  	tristate "Sahara TouchIT-213 touchscreen"
>  	select SERIO
> diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
> index 3a5ebf4..39350cc 100644
> --- a/drivers/input/touchscreen/usbtouchscreen.c
> +++ b/drivers/input/touchscreen/usbtouchscreen.c
> @@ -17,6 +17,7 @@
>   *  - Zytronic capacitive touchscreen
>   *  - NEXIO/iNexio
>   *  - Elo TouchSystems 2700 IntelliTouch
> + *  - EasyTouch USB Dual/Multi touch controller from Data Modul
>   *
>   * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
>   * Copyright (C) by Todd E. Johnson (mtouchusb.c)
> @@ -140,6 +141,7 @@ enum {
>  	DEVTYPE_TC45USB,
>  	DEVTYPE_NEXIO,
>  	DEVTYPE_ELO,
> +	DEVTYPE_ETOUCH,
>  };
>  
>  #define USB_DEVICE_HID_CLASS(vend, prod) \
> @@ -245,6 +247,10 @@ static const struct usb_device_id usbtouch_devices[] = {
>  	{USB_DEVICE(0x04e7, 0x0020), .driver_info = DEVTYPE_ELO},
>  #endif
>  
> +#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
> +	{USB_DEVICE(0x7374, 0x0001), .driver_info = DEVTYPE_ETOUCH},
> +#endif
> +
>  	{}
>  };
>  
> @@ -326,6 +332,47 @@ static int egalax_get_pkt_len(unsigned char *buf, int len)
>  }
>  #endif
>  
> +/*****************************************************************************
> + * EasyTouch part
> + */
> +
> +#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
> +
> +#define EGALAX_PKT_TYPE_MASK		0xFE
> +#define EGALAX_PKT_TYPE_REPT		0x80
> +#define EGALAX_PKT_TYPE_REPT2		0xB0
> +#define EGALAX_PKT_TYPE_DIAG		0x0A
> +
> +static int etouch_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
> +{
> +	if ((pkt[0] & EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT &&
> +		(pkt[0] & EGALAX_PKT_TYPE_MASK) != EGALAX_PKT_TYPE_REPT2)
> +		return 0;
> +
> +	dev->x = ((pkt[1] & 0x1F) << 7) | (pkt[2] & 0x7F);
> +	dev->y = ((pkt[3] & 0x1F) << 7) | (pkt[4] & 0x7F);
> +	dev->touch = pkt[0] & 0x01;
> +
> +	return 1;
> +}
> +
> +static int etouch_get_pkt_len(unsigned char *buf, int len)
> +{
> +	switch (buf[0] & EGALAX_PKT_TYPE_MASK) {
> +	case EGALAX_PKT_TYPE_REPT:
> +	case EGALAX_PKT_TYPE_REPT2:
> +		return 5;
> +
> +	case EGALAX_PKT_TYPE_DIAG:
> +		if (len < 2)
> +			return -1;
> +
> +		return buf[1] + 2;
> +	}
> +
> +	return 0;
> +}
> +#endif
>  
>  /*****************************************************************************
>   * PanJit Part
> @@ -1175,6 +1222,18 @@ static struct usbtouch_device_info usbtouch_dev_info[] = {
>  		.exit		= nexio_exit,
>  	},
>  #endif
> +#ifdef CONFIG_TOUCHSCREEN_USB_EASYTOUCH
> +	[DEVTYPE_ETOUCH] = {
> +		.min_xc		= 0x0,
> +		.max_xc		= 0x07ff,
> +		.min_yc		= 0x0,
> +		.max_yc		= 0x07ff,
> +		.rept_size	= 16,
> +		.process_pkt	= usbtouch_process_multi,
> +		.get_pkt_len	= etouch_get_pkt_len,
> +		.read_data	= etouch_read_data,
> +	},
> +#endif
>  };
>  
> 


--=-cDhA0ime3GChtNaqnC1C
Content-Disposition: attachment; filename="0001-input-invert-e2i-touchscreen-180-degrees.patch"
Content-Type: text/x-patch; name="0001-input-invert-e2i-touchscreen-180-degrees.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 9eed7d30a560836a871d6a35c76a0ee3fc76d4a2 Mon Sep 17 00:00:00 2001
From: Shawn Landden <shawnlandden@gmail.com>
Date: Thu, 23 Feb 2012 13:53:51 -0800
Subject: [PATCH] input: invert e2i touchscreen 180 degrees

The Mimo 720 has its input rotated 180 degrees.

almost certainly brakes Mimo 730
---
 drivers/input/touchscreen/usbtouchscreen.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index 3a5ebf4..c328389 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -271,8 +271,8 @@ static int e2i_init(struct usbtouch_usb *usbtouch)
 static int e2i_read_data(struct usbtouch_usb *dev, unsigned char *pkt)
 {
 	int tmp = (pkt[0] << 8) | pkt[1];
-	dev->x  = (pkt[2] << 8) | pkt[3];
-	dev->y  = (pkt[4] << 8) | pkt[5];
+	dev->x  = 0x7fff - ((pkt[2] << 8) | pkt[3]);
+	dev->y  = 0x7fff - ((pkt[4] << 8) | pkt[5]);
 
 	tmp = tmp - 0xA000;
 	dev->touch = (tmp > 0);
-- 
1.7.5.4


--=-cDhA0ime3GChtNaqnC1C--

