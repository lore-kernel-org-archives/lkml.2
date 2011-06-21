Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1FUSIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 14:08:39 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:33746 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757275Ab1FUSIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 14:08:35 -0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@mns.spb.ru>
Subject: [PATCH] uvcvideo: Add FIX_BANDWIDTH quirk to HP Webcam found on HP Mini 5103 netbook
Date: Tue, 21 Jun 2011 22:07:43 +0400
Message-Id: <1308679663-11431-1-git-send-email-kirr@mns.spb.ru>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The camera there identifeis itself as being manufactured by Cheng Uei
Precision Industry Co., Ltd (Foxlink), and product is titled as "HP
Webcam [2 MP Fixed]".

I was trying to get 2 USB video capture devices to work simultaneously,
and noticed that the above mentioned webcam always requires packet size
= 3072 bytes per micro frame (~= 23.4 MB/s isoc bandwidth), which is far
more than enough to get standard NTSC 640x480x2x30 = ~17.6 MB/s isoc
bandwidth.

As there are alt interfaces with smaller MxPS

    T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480  MxCh= 0
    D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
    P:  Vendor=05c8 ProdID=0403 Rev= 1.06
    S:  Manufacturer=Foxlink
    S:  Product=HP Webcam [2 MP Fixed]
    S:  SerialNumber=200909240102
    C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
    A:  FirstIf#= 0 IfCount= 2 Cls=0e(video) Sub=03 Prot=00
    I:* If#= 0 Alt= 0 #EPs= 1 Cls=0e(video) Sub=01 Prot=00 Driver=uvcvideo
    E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=4ms
    I:* If#= 1 Alt= 0 #EPs= 0 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    I:  If#= 1 Alt= 1 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS= 128 Ivl=125us
    I:  If#= 1 Alt= 2 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS= 512 Ivl=125us
    I:  If#= 1 Alt= 3 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=1024 Ivl=125us
    I:  If#= 1 Alt= 4 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=1536 Ivl=125us
    I:  If#= 1 Alt= 5 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=2048 Ivl=125us
    I:  If#= 1 Alt= 6 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=2688 Ivl=125us
    I:  If#= 1 Alt= 7 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
    E:  Ad=81(I) Atr=05(Isoc) MxPS=3072 Ivl=125us

UVC_QUIRK_FIX_BANDWIDTH helps here and NTSC video can be served with
MxPS=2688 i.e. 20.5 MB/s isoc bandwidth.

In terms of microframe time allocation, before the quirk NTSC video
required 60 usecs / microframe and 53 usecs / microframe after.


P.S. Now with tweaked ehci-hcd to allow up to 90% isoc bandwith (instead of
allowed for high speed 80%) I can capture two video sources -- PAL 720x576
YUV422 @25fps + NTSC 640x480 YUV422 @30fps simultaneously. Hooray!

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index b6eae48..f633700 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2130,6 +2130,15 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceProtocol	= 0,
 	  .driver_info 		= UVC_QUIRK_PROBE_MINMAX
 				| UVC_QUIRK_BUILTIN_ISIGHT },
+	/* Foxlink ("HP Webcam" on HP Mini 5103) */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x05c8,
+	  .idProduct		= 0x0403,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_FIX_BANDWIDTH },
 	/* Genesys Logic USB 2.0 PC Camera */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
1.7.6.rc1

