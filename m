Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352Ab0JVS42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:28 -0400
Received: from kroah.org ([198.145.64.141]:34076 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759311Ab0JVS4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:30 2010
Message-Id: <20101022185230.582791070@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [036/103] V4L/DVB: Dont identify PV SBTVD Hybrid as a DibCom device
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 3bfb317f97cfddbbec67bbe8e35ad38af3507397 upstream.

As reported by Carlos, Prolink Pixelview SBTVD Hybrid is based on
Conexant cx231xx + Fujitsu 86A20S demodulator. However, both shares
the same USB ID. So, we need to use USB bcdDevice, in order to
properly discover what's the board.

We know for sure that bcd 0x100 is used for a dib0700 device, while
bcd 0x4001 is used for a cx23102 device. This patch reserves two ranges,
the first one from 0x0000-0x3f00 for dib0700, and the second from
0x4000-0x4fff for cx231xx devices.

This may need fixes in the future, as we get access to other devices.

Thanks-to: Carlos Americo Domiciano <c_domiciano@yahoo.com.br>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    2 +-
 drivers/media/video/cx231xx/Makefile        |    1 +
 drivers/media/video/cx231xx/cx231xx-cards.c |    3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -2081,7 +2081,7 @@ struct usb_device_id dib0700_usb_id_tabl
 /* 60 */{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_XXS_2) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XPVR) },
 	{ USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_STK807XP) },
-	{ USB_DEVICE(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD) },
+	{ USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x000, 0x3f00) },
 	{ USB_DEVICE(USB_VID_EVOLUTEPC, USB_PID_TVWAY_PLUS) },
 /* 65 */{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV73ESE) },
 	{ USB_DEVICE(USB_VID_PINNACLE,	USB_PID_PINNACLE_PCTV282E) },
--- a/drivers/media/video/cx231xx/Makefile
+++ b/drivers/media/video/cx231xx/Makefile
@@ -11,4 +11,5 @@ EXTRA_CFLAGS += -Idrivers/media/video
 EXTRA_CFLAGS += -Idrivers/media/common/tuners
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb
 
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -32,6 +32,7 @@
 #include <media/v4l2-chip-ident.h>
 
 #include <media/cx25840.h>
+#include "dvb-usb-ids.h"
 #include "xc5000.h"
 
 #include "cx231xx.h"
@@ -175,6 +176,8 @@ struct usb_device_id cx231xx_id_table[]
 	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
 	{USB_DEVICE(0x0572, 0x58A1),
 	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+	{USB_DEVICE_VER(USB_VID_PIXELVIEW, USB_PID_PIXELVIEW_SBTVD, 0x4000,0x4fff),
+	 .driver_info = CX231XX_BOARD_UNKNOWN},
 	{},
 };
 


