Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab2B1JIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:08:43 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:60727 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab2B1JIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:08:39 -0500
Message-ID: <4F4C998D.4000805@mediatek.com>
Date: Tue, 28 Feb 2012 17:08:29 +0800
From: Meng Zhang <meng.zhang@mediatek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: mdharm-usb@one-eyed-alien.net, phil@ipom.com, stern@rowland.harvard.edu
CC: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] USB: Mass Storage: Add MediaTek MT6276M device entry
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from: Meng Zhang <meng.zhang@mediatek.com>

1. Add entrys for mediatek MT6276M in unusual_devs.h

2. Add init function for mediatek MT6276M to switch to COM port mode

3. usb-devices outputs after running with this patch:
T:  Bus=02 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#= 48 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0e8d ProdID=00a1 Rev=02.00
S:  Manufacturer=MediaTek Inc
S:  Product=Product
C:  #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=02 Prot=01 Driver=option
I:  If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
I:  If#= 2 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=00 Driver=option

4. patch based on branch:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git


Signed-off-by: Meng Zhang <meng.zhang@mediatek.com>
---

  drivers/usb/storage/initializers.c |   27 +++++++++++++++++++++++++++
  drivers/usb/storage/initializers.h |    3 +++
  drivers/usb/storage/unusual_devs.h |    9 +++++++++
  3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/initializers.c 
b/drivers/usb/storage/initializers.c
index 105d900..44985a1 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -104,3 +104,30 @@ int usb_stor_huawei_e220_init(struct us_data *us)
  	US_DEBUGP("Huawei mode set result is %d\n", result);
  	return 0;
  }
+
+/* switch MediaTek MT6276M to COM port mode */
+int usb_stor_mediatek_mt6276m_init(struct us_data *us)
+{
+	const unsigned char rezero_msg[] = {
+	  0x55, 0x53, 0x42, 0x43, 0x78, 0x56, 0x34, 0x12,
+	  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0xf0,
+	  0x01, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+	char *buffer;
+	int result;
+
+	US_DEBUGP("Initializing mediatek USB device...\n");
+
+	buffer = kzalloc(32, GFP_KERNEL);
+	if (buffer == NULL)
+		return USB_STOR_TRANSPORT_ERROR;
+
+	memcpy(buffer, rezero_msg, sizeof(rezero_msg));
+	result = usb_stor_bulk_transfer_buf(us,
+			us->send_bulk_pipe,
+			buffer, sizeof(rezero_msg), NULL);
+	
+	kfree(buffer);
+	return result;
+}
diff --git a/drivers/usb/storage/initializers.h 
b/drivers/usb/storage/initializers.h
index 529327f..6c9337f 100644
--- a/drivers/usb/storage/initializers.h
+++ b/drivers/usb/storage/initializers.h
@@ -48,3 +48,6 @@ int usb_stor_ucr61s2b_init(struct us_data *us);

  /* This places the HUAWEI E220 devices in multi-port mode */
  int usb_stor_huawei_e220_init(struct us_data *us);
+
+/* switch MediaTek MT6276M to COM port mode */
+int usb_stor_mediatek_mt6276m_init(struct us_data *us);
diff --git a/drivers/usb/storage/unusual_devs.h 
b/drivers/usb/storage/unusual_devs.h
index 856ad92..574c291 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1356,6 +1356,15 @@ UNUSUAL_DEV( 0x0e21, 0x0520, 0x0100, 0x0100,
  		USB_SC_DEVICE, USB_PR_BULK, NULL,
  		US_FL_NEED_OVERRIDE ),

+/* Reported by Meng Zhang <meng.zhang@mediatek.com>
+ * switch mediatek USB devices into COM port mode
+ */
+UNUSUAL_DEV(0x0e8d, 0x0002, 0x0000, 0x0300,
+		"MediaTek Inc.",
+		"MT6276M",
+		USB_SC_DEVICE, USB_PR_DEVICE,
+		usb_stor_mediatek_mt6276m_init, 0),
+
  /* Submitted by Antoine Mairesse <antoine.mairesse@free.fr> */
  UNUSUAL_DEV( 0x0ed1, 0x6660, 0x0100, 0x0300,
  		"USB",
