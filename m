Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab2FTTHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:07:19 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:64710 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2FTTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:07:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-160.messagelabs.com!1340218690!7278405!213
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/8] staging: comedi: vmk80xx: refactor init code
Date: Wed, 20 Jun 2012 12:01:57 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206201201.57889.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the usb driver probe/disconnect and comedi driver attach/
detach to follow the style of the other comedi driver types to
improve maintainability.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/vmk80xx.c | 79 +++++++++++++++-----------------
 1 file changed, 37 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 14fb50a..94010fc 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -64,37 +64,11 @@ Changelog:
 
 #include "../comedidev.h"
 
-#define BOARDNAME "vmk80xx"
-
-MODULE_AUTHOR("Manuel Gebele <forensixs@gmx.de>");
-MODULE_DESCRIPTION("Velleman USB Board Low-Level Driver");
-MODULE_SUPPORTED_DEVICE("K8055/K8061 aka VM110/VM140");
-MODULE_VERSION("0.8.01");
-MODULE_LICENSE("GPL");
-
 enum {
 	DEVICE_VMK8055,
 	DEVICE_VMK8061
 };
 
-static const struct usb_device_id vmk80xx_id_table[] = {
-	{USB_DEVICE(0x10cf, 0x5500), .driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x5501), .driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x5502), .driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x5503), .driver_info = DEVICE_VMK8055},
-	{USB_DEVICE(0x10cf, 0x8061), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8062), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8063), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8064), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8065), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8066), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8067), .driver_info = DEVICE_VMK8061},
-	{USB_DEVICE(0x10cf, 0x8068), .driver_info = DEVICE_VMK8061},
-	{}			/* terminating entry */
-};
-
-MODULE_DEVICE_TABLE(usb, vmk80xx_id_table);
-
 #define VMK8055_DI_REG          0x00
 #define VMK8055_DO_REG          0x01
 #define VMK8055_AO1_REG         0x02
@@ -232,8 +206,6 @@ static struct vmk80xx_usb vmb[VMK80XX_MAX_BOARDS];
 
 static DEFINE_MUTEX(glb_mutex);
 
-static struct comedi_driver vmk80xx_driver;	/* see below for initializer */
-
 static void vmk80xx_tx_callback(struct urb *urb)
 {
 	struct vmk80xx_usb *dev = urb->context;
@@ -1267,8 +1239,16 @@ static void vmk80xx_detach(struct comedi_device *dev)
 	}
 }
 
-static int vmk80xx_probe(struct usb_interface *intf,
-			 const struct usb_device_id *id)
+static struct comedi_driver vmk80xx_driver = {
+	.module		= THIS_MODULE,
+	.driver_name	= "vmk80xx",
+	.attach		= vmk80xx_attach,
+	.detach		= vmk80xx_detach,
+	.attach_usb	= vmk80xx_attach_usb,
+};
+
+static int vmk80xx_usb_probe(struct usb_interface *intf,
+			     const struct usb_device_id *id)
 {
 	int i;
 	struct vmk80xx_usb *dev;
@@ -1419,7 +1399,7 @@ error:
 	return -ENODEV;
 }
 
-static void vmk80xx_disconnect(struct usb_interface *intf)
+static void vmk80xx_usb_disconnect(struct usb_interface *intf)
 {
 	struct vmk80xx_usb *dev = usb_get_intfdata(intf);
 
@@ -1447,20 +1427,35 @@ static void vmk80xx_disconnect(struct usb_interface *intf)
 	mutex_unlock(&glb_mutex);
 }
 
+static const struct usb_device_id vmk80xx_usb_id_table[] = {
+	{ USB_DEVICE(0x10cf, 0x5500), .driver_info = DEVICE_VMK8055 },
+	{ USB_DEVICE(0x10cf, 0x5501), .driver_info = DEVICE_VMK8055 },
+	{ USB_DEVICE(0x10cf, 0x5502), .driver_info = DEVICE_VMK8055 },
+	{ USB_DEVICE(0x10cf, 0x5503), .driver_info = DEVICE_VMK8055 },
+	{ USB_DEVICE(0x10cf, 0x8061), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8062), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8063), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8064), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8065), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8066), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8067), .driver_info = DEVICE_VMK8061 },
+	{ USB_DEVICE(0x10cf, 0x8068), .driver_info = DEVICE_VMK8061 },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, vmk80xx_usb_id_table);
+
 /* TODO: Add support for suspend, resume, pre_reset,
  * post_reset and flush */
 static struct usb_driver vmk80xx_usb_driver = {
 	.name		= "vmk80xx",
-	.probe		= vmk80xx_probe,
-	.disconnect	= vmk80xx_disconnect,
-	.id_table	= vmk80xx_id_table
-};
-
-static struct comedi_driver vmk80xx_driver = {
-	.module		= THIS_MODULE,
-	.driver_name	= "vmk80xx",
-	.attach		= vmk80xx_attach,
-	.detach		= vmk80xx_detach,
-	.attach_usb	= vmk80xx_attach_usb,
+	.probe		= vmk80xx_usb_probe,
+	.disconnect	= vmk80xx_usb_disconnect,
+	.id_table	= vmk80xx_usb_id_table,
 };
 module_comedi_usb_driver(vmk80xx_driver, vmk80xx_usb_driver);
+
+MODULE_AUTHOR("Manuel Gebele <forensixs@gmx.de>");
+MODULE_DESCRIPTION("Velleman USB Board Low-Level Driver");
+MODULE_SUPPORTED_DEVICE("K8055/K8061 aka VM110/VM140");
+MODULE_VERSION("0.8.01");
+MODULE_LICENSE("GPL");
-- 
1.7.11

