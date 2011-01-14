Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1ANUzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 15:55:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1ANUzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 15:55:23 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=FJNu8Eo-i-gA:10 a=kj9zAlcOel0A:10 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=yQdBAQUQAAAA:8 a=2C6YHBdLAAAA:8 a=xy5g1Cv50WogWj_j2uwA:9 a=xo6N8E-SZXd82LnSrzwA:7 a=pw_sc7lpiCeCthfi2X77IqQedYUA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mJMriH8CDpcA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 14 Jan 2011 14:54:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: florian.c.schilhabel@googlemail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: r8712u: Switch driver to use external
 firmware from linux-firmware
Message-ID: <4d30b7fa.j0xZq9/VwpVGxx/H%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/TODO       |    2 --
 drivers/staging/rtl8712/hal_init.c |   22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
index 2aa5deb..d8dfe5b 100644
--- a/drivers/staging/rtl8712/TODO
+++ b/drivers/staging/rtl8712/TODO
@@ -3,8 +3,6 @@ TODO:
 - switch to use LIB80211
 - switch to use MAC80211
 - checkpatch.pl fixes - only a few remain
-- switch from large inline firmware file to use the firmware interface
-  and add the file to the linux-firmware package.
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
 Larry Finger <Larry.Finger@lwfinger.net> and
diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 84be383..52ab2d5 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -31,7 +31,6 @@
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "rtl871x_byteorder.h"
-#include "farray.h"
 #include "usb_osintf.h"
 
 #define FWBUFF_ALIGN_SZ 512
@@ -40,11 +39,24 @@
 static u32 rtl871x_open_fw(struct _adapter *padapter, void **pphfwfile_hdl,
 		    const u8 **ppmappedfw)
 {
-	u32 len;
+	int rc;
+	const char firmware_file[] = "rtl8712u/rtl8712u.bin";
+	const struct firmware **praw = (const struct firmware **)
+				       (pphfwfile_hdl);
+	struct dvobj_priv *pdvobjpriv = (struct dvobj_priv *)
+					(&padapter->dvobjpriv);
+	struct usb_device *pusbdev = pdvobjpriv->pusbdev;
 
-	*ppmappedfw = f_array;
-	len = sizeof(f_array);
-	return len;
+	printk(KERN_INFO "r8712u: Loading firmware from \"%s\"\n",
+	       firmware_file);
+	rc = request_firmware(praw, firmware_file, &pusbdev->dev);
+	if (rc < 0) {
+		printk(KERN_ERR "r8712u: Unable to load firmware\n");
+		printk(KERN_ERR "r8712u: Install latest linux-firmware\n");
+		return 0;
+	}
+	*ppmappedfw = (u8 *)((*praw)->data);
+	return (*praw)->size;
 }
 
 static void fill_fwpriv(struct _adapter *padapter, struct fw_priv *pfwpriv)
-- 
1.7.1

