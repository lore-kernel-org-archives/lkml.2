Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2E1DeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:34:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52137 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981Ab2E1D3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:48 -0400
Message-Id: <20120528031217.505851170@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 106/117] rtlwifi: Preallocate USB read buffers and eliminate kalloc in read routine
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit a7959c1394d4126a70a53b914ce4105f5173d0aa upstream.

The current version of rtlwifi for USB operations uses kmalloc to
acquire a 32-bit buffer for each read of the device. When
_usb_read_sync() is called with the rcu_lock held, the result is
a "sleeping function called from invalid context" BUG. This is
reported for two cases in https://bugzilla.kernel.org/show_bug.cgi?id=42775.
The first case has the lock originating from within rtlwifi and could
be fixed by rearranging the locking; however, the second originates from
within mac80211. The kmalloc() call is removed from _usb_read_sync()
by creating a ring buffer pointer in the private area and
allocating the buffer data in the probe routine.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[This version will apply to 3.2 and earlier. - Larry]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -113,46 +113,38 @@
 	return status;
 }
 
-static u32 _usb_read_sync(struct usb_device *udev, u32 addr, u16 len)
+static u32 _usb_read_sync(struct rtl_priv *rtlpriv, u32 addr, u16 len)
 {
+	struct device *dev = rtlpriv->io.dev;
+	struct usb_device *udev = to_usb_device(dev);
 	u8 request;
 	u16 wvalue;
 	u16 index;
-	u32 *data;
-	u32 ret;
+	__le32 *data = &rtlpriv->usb_data[rtlpriv->usb_data_index];
 
-	data = kmalloc(sizeof(u32), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
 	request = REALTEK_USB_VENQT_CMD_REQ;
 	index = REALTEK_USB_VENQT_CMD_IDX; /* n/a */
 
 	wvalue = (u16)addr;
 	_usbctrl_vendorreq_sync_read(udev, request, wvalue, index, data, len);
-	ret = *data;
-	kfree(data);
-	return ret;
+	if (++rtlpriv->usb_data_index >= RTL_USB_MAX_RX_COUNT)
+		rtlpriv->usb_data_index = 0;
+	return le32_to_cpu(*data);
 }
 
 static u8 _usb_read8_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev = rtlpriv->io.dev;
-
-	return (u8)_usb_read_sync(to_usb_device(dev), addr, 1);
+	return (u8)_usb_read_sync(rtlpriv, addr, 1);
 }
 
 static u16 _usb_read16_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev = rtlpriv->io.dev;
-
-	return (u16)_usb_read_sync(to_usb_device(dev), addr, 2);
+	return (u16)_usb_read_sync(rtlpriv, addr, 2);
 }
 
 static u32 _usb_read32_sync(struct rtl_priv *rtlpriv, u32 addr)
 {
-	struct device *dev = rtlpriv->io.dev;
-
-	return _usb_read_sync(to_usb_device(dev), addr, 4);
+	return _usb_read_sync(rtlpriv, addr, 4);
 }
 
 static void _usb_write_async(struct usb_device *udev, u32 addr, u32 val,
@@ -913,6 +905,11 @@
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
+	rtlpriv->usb_data = kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
+				    GFP_KERNEL);
+	if (!rtlpriv->usb_data)
+		return -ENOMEM;
+	rtlpriv->usb_data_index = 0;
 	SET_IEEE80211_DEV(hw, &intf->dev);
 	udev = interface_to_usbdev(intf);
 	usb_get_dev(udev);
@@ -990,6 +987,7 @@
 	/* rtl_deinit_rfkill(hw); */
 	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
+	kfree(rtlpriv->usb_data);
 	rtlpriv->cfg->ops->deinit_sw_leds(hw);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 	_rtl_usb_io_handler_release(hw);
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -63,7 +63,7 @@
 #define AC_MAX					4
 #define QOS_QUEUE_NUM				4
 #define RTL_MAC80211_NUM_QUEUE			5
-
+#define RTL_USB_MAX_RX_COUNT			100
 #define QBSS_LOAD_SIZE				5
 #define MAX_WMMELE_LENGTH			64
 
@@ -1621,6 +1621,10 @@
 	   interface or hardware */
 	unsigned long status;
 
+	/* data buffer pointer for USB reads */
+	__le32 *usb_data;
+	int usb_data_index;
+
 	/*This must be the last item so
 	   that it points to the data allocated
 	   beyond  this structure like:


