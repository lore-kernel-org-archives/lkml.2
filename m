Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2KSPOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:14:34 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36904 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2KSPOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:14:32 -0500
Date: Mon, 19 Nov 2012 20:44:24 +0530
From: Arpith Easow Alexander <arpith99@gmail.com>
To: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        gregkh@linuxfoundation.org, hsweeten@visionengravers.com,
        dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] Staging: comedi: drivers: replaced printk with dev_dbg
Message-ID: <20121119151419.GA4807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the vmk80xx.c file that replaces the printk with dev_dbg.
This fixes the warnings found by the checkpatch.pl tool.

Signed-off-by: Arpith Easow Alexander <arpith99@gmail.com>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index df277aa..6eb5361 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -131,10 +131,10 @@ static int dbgcm = 1;
 static int dbgcm;
 #endif
 
-#define dbgcm(fmt, arg...)                     \
+#define dbgcm(dev, fmt, arg...)                     \
 do {                                           \
 	if (dbgcm)                             \
-		printk(KERN_DEBUG fmt, ##arg); \
+		dev_dbg(dev, fmt, ##arg); \
 } while (0)
 
 enum vmk80xx_model {
@@ -213,8 +213,9 @@ static void vmk80xx_tx_callback(struct urb *urb)
 
 	if (stat && !(stat == -ENOENT
 		      || stat == -ECONNRESET || stat == -ESHUTDOWN))
-		dbgcm("comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
-		      __func__, stat);
+		dbgcm(&(dev->udev->dev),
+			"comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
+			__func__, stat);
 
 	if (!test_bit(TRANS_OUT_BUSY, &dev->flags))
 		return;
@@ -237,7 +238,8 @@ static void vmk80xx_rx_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		break;
 	default:
-		dbgcm("comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
+		dbgcm(&(dev->udev->dev),
+		      "comedi#: vmk80xx: %s - nonzero urb status (%d)\n",
 		      __func__, stat);
 		goto resubmit;
 	}
@@ -1371,14 +1373,16 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	if (dev->board.model == VMK8061_MODEL) {
 		vmk80xx_read_eeprom(dev, IC3_VERSION);
-		printk(KERN_INFO "comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
+		dev_dbg(&(dev->udev->dev),
+			"comedi#: vmk80xx: %s\n", dev->fw.ic3_vers);
 
 		if (vmk80xx_check_data_link(dev)) {
 			vmk80xx_read_eeprom(dev, IC6_VERSION);
-			printk(KERN_INFO "comedi#: vmk80xx: %s\n",
+			dev_dbg(&(dev->udev->dev), "comedi#: vmk80xx: %s\n",
 			       dev->fw.ic6_vers);
 		} else {
-			dbgcm("comedi#: vmk80xx: no conn. to CPU\n");
+			dbgcm(&(dev->udev->dev),
+				"comedi#: vmk80xx: no conn. to CPU\n");
 		}
 	}
 
@@ -1387,8 +1391,9 @@ static int vmk80xx_usb_probe(struct usb_interface *intf,
 
 	dev->probed = 1;
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now attached\n",
-	       dev->count, dev->board.name);
+	dev_dbg(&(dev->udev->dev),
+		"comedi#: vmk80xx: board #%d [%s] now attached\n",
+		dev->count, dev->board.name);
 
 	mutex_unlock(&glb_mutex);
 
@@ -1422,8 +1427,9 @@ static void vmk80xx_usb_disconnect(struct usb_interface *intf)
 	kfree(dev->usb_rx_buf);
 	kfree(dev->usb_tx_buf);
 
-	printk(KERN_INFO "comedi#: vmk80xx: board #%d [%s] now detached\n",
-	       dev->count, dev->board.name);
+	dev_dbg(&(dev->udev->dev),
+		"comedi#: vmk80xx: board #%d [%s] now detached\n",
+		dev->count, dev->board.name);
 
 	up(&dev->limit_sem);
 	mutex_unlock(&glb_mutex);
-- 
1.7.9.5

