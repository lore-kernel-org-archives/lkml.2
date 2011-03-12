Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1CLWkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:40:18 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36427 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab1CLWkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=SnvNfFtKv50zPJc7qoVPJbdj5ybiso6MUwgyH/AAzih64KoYKc2IF4iYA6AGQ3SqKG
         730fTbEVhOG/CcqsHfyehy6raWpbudthUd4tbvV1ZL9mlJ+ztCNTxZJkoOqCUPkMdX2+
         GpCiKQ9dRC9NNHCQRmTbjlukb14S+mQKp98jA=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 3/3] USBNET: Use usbnet platform data if it is present
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:40:11 +0000
Message-ID: <20110312224011.27344.71472.stgit@otae.warmcat.com>
In-Reply-To: <20110312223643.27344.72406.stgit@otae.warmcat.com>
References: <20110312223643.27344.72406.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables usbnet to actually use the two features it now
supports via platform_data, if that has been set up by the board
definition file.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 drivers/net/usb/usbnet.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 95c41d5..5a5da74 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1293,6 +1293,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	int				status;
 	const char			*name;
 	struct usb_driver 	*driver = to_usb_driver(udev->dev.driver);
+	struct usbnet_platform_data	*pdata;
 
 	/* usbnet already took usb runtime pm, so have to enable the feature
 	 * for usb interface, otherwise usb_autopm_get_interface may return
@@ -1313,6 +1314,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	interface = udev->cur_altsetting;
 
 	usb_get_dev (xdev);
+	pdata = xdev->dev.platform_data;
 
 	status = -ENOMEM;
 
@@ -1348,7 +1350,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strcpy (net->name, "usb%d");
-	memcpy (net->dev_addr, node_id, sizeof node_id);
+	if (pdata && pdata->flags & USBNET_PLATDATA_FLAG__USE_MAC)
+		memcpy(net->dev_addr, pdata->mac, sizeof pdata->mac);
+	else
+		memcpy(net->dev_addr, node_id, sizeof node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
@@ -1372,11 +1377,17 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		if (status < 0)
 			goto out1;
 
-		// heuristic:  "usb%d" for links we know are two-host,
-		// else "eth%d" when there's reasonable doubt.  userspace
-		// can rename the link if it knows better.
-		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
-		    (net->dev_addr [0] & 0x02) == 0)
+		/*
+		 * heuristic:  "usb%d" for links we know are two-host,
+		 * else "eth%d" when there's reasonable doubt.  userspace
+		 * can rename the link if it knows better.  Async
+		 * platform_data can also override this if it knows better
+		 * based on knowledge of what this link is wired up to.
+		 */
+		if ((((dev->driver_info->flags & FLAG_ETHER) != 0 &&
+		    (net->dev_addr[0] & 0x02) == 0)) ||
+		    (pdata && pdata->flags &
+					USBNET_PLATDATA_FLAG__FORCE_ETH_IFNAME))
 			strcpy (net->name, "eth%d");
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)

