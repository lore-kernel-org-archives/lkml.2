Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0IEScv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 14:32:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60131 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0IEScs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 14:32:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sfYN6PbkxZ+eCIvAlPCYqqLOeVsPKi1HiV5p/uFqIsLw9mTQOJWvG7W+UF4xuibjVi
         mFRjKczO9ynYSLfHiBhxRGC6VL3Up7O4g/tZ32qCmKDbn6Tc+cUDgTlt69D6AjFOs7nh
         JUKWx+CbFeGVRIqq6/Cq14cORPGxQPVX4nRZc=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Vasiliy Kulikov <segooon@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Julia Lawall <julia@diku.dk>, Ben Hutchings <ben@decadent.org.uk>,
        Mike Gilks <mike.kernel@gilksonline.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] staging: rtl8192u: improve error path
Date: Sun,  5 Sep 2010 22:32:41 +0400
Message-Id: <1283711561-7332-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>

Functions alloc_ieee80211 and register_netdev may fail. Check for it.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 I couldn't compile this driver at all, so it is not tested.

 drivers/staging/rtl8192u/r8192U_core.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1ff7850..b6d429c 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -5793,10 +5793,12 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 	struct net_device *dev = NULL;
 	struct r8192_priv *priv= NULL;
 	struct usb_device *udev = interface_to_usbdev(intf);
+	int ret;
 	RT_TRACE(COMP_INIT, "Oops: i'm coming\n");
 
 	dev = alloc_ieee80211(sizeof(struct r8192_priv));
-
+	if (dev == NULL)
+		return -ENOMEM;
 
 	usb_set_intfdata(intf, dev);
 	SET_NETDEV_DEV(dev, &intf->dev);
@@ -5826,12 +5828,16 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 	RT_TRACE(COMP_INIT, "Driver probe completed1\n");
 	if(rtl8192_init(dev)!=0){
 		RT_TRACE(COMP_ERR, "Initialization failed");
+		ret = -ENODEV;
 		goto fail;
 	}
 	netif_carrier_off(dev);
 	netif_stop_queue(dev);
 
-	register_netdev(dev);
+	ret = register_netdev(dev);
+	if (ret)
+		goto fail2;
+
 	RT_TRACE(COMP_INIT, "dev name=======> %s\n",dev->name);
 	rtl8192_proc_init_one(dev);
 
@@ -5839,13 +5845,20 @@ static int __devinit rtl8192_usb_probe(struct usb_interface *intf,
 	RT_TRACE(COMP_INIT, "Driver probe completed\n");
 	return 0;
 
-
+fail2:
+	rtl8192_down(dev);
+	if (priv->pFirmware) {
+		kfree(priv->pFirmware);
+		priv->pFirmware = NULL;
+	}
+	rtl8192_usb_deleteendpoints(dev);
+	destroy_workqueue(priv->priv_wq);
+	mdelay(10);
 fail:
 	free_ieee80211(dev);
 
 	RT_TRACE(COMP_ERR, "wlan driver load failed\n");
-	return -ENODEV;
-
+	return ret;
 }
 
 //detach all the work and timer structure declared or inititialize in r8192U_init function.
-- 
1.7.0.4

