Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030828Ab2HQDdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:33:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46773 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030648Ab2HQD07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:26:59 -0400
Message-Id: <20120817030245.918729084@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:02:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/37] rtlwifi: rtl8192cu: Change buffer allocation for synchronous reads
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 3ce4d85b76010525adedcc2555fa164bf706a2f3 upstream.

In commit a7959c1, the USB part of rtlwifi was switched to convert
_usb_read_sync() to using a preallocated buffer rather than one
that has been acquired using kmalloc. Although this routine is named
as though it were synchronous, there seem to be simultaneous users,
and the selection of the index to the data buffer is not multi-user
safe. This situation is addressed by adding a new spinlock. The routine
cannot sleep, thus a mutex is not allowed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rtlwifi/usb.c  |   14 +++++++++++---
 drivers/net/wireless/rtlwifi/wifi.h |    1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -120,15 +120,19 @@ static u32 _usb_read_sync(struct rtl_pri
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	__le32 *data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
+	__le32 *data;
+	unsigned long flags;
 
+	spin_lock_irqsave(&rtlpriv->locks.usb_lock, flags);
+	if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
+		rtlpriv->usb_data_index = 0;
+	data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
+	spin_unlock_irqrestore(&rtlpriv->locks.usb_lock, flags);
 	request = REALTEK_USB_VENQT_CMD_REQ;
 	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
 
 	wvalue = (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
-		rtlpriv->usb_data_index = 0;
 	return le32_to_cpu(*data);
 }
 
@@ -909,6 +913,10 @@ int __devinit rtl_usb_probe(struct usb_i
 				    GFP_KERNEL);
 	if (!rtlpriv->usb_data)
 		return -ENOMEM;
+
+	/* this spin lock must be initialized early */
+	spin_lock_init(&rtlpriv->locks.usb_lock);
+
 	rtlpriv->usb_data_index = 0;
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev = interface_to_usbdev(intf);
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1550,6 +1550,7 @@ struct rtl_locks {
 	spinlock_t rf_lock;
 	spinlock_t lps_lock;
 	spinlock_t waitq_lock;
+	spinlock_t usb_lock;
 
 	/*Dual mac*/
 	spinlock_t cck_and_rw_pagea_lock;


