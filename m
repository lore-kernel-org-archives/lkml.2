Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1HJKGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 06:06:07 -0400
Received: from ist.d-labs.de ([213.239.218.44]:33827 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab1HJKGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 06:06:05 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: tino.keitel@tikei.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Florian Mickler <florian@mickler.org>,
        "v3.0.y" <stable@kernel.org>
Subject: [PATCH] [media] vp7045: fix buffer setup
Date: Wed, 10 Aug 2011 12:05:20 +0200
Message-Id: <1312970720-25694-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20110809200842.GA29662@mac.home>
References: <20110809200842.GA29662@mac.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dvb_usb_device_init calls the frontend_attach method of this driver which
uses vp7045_usb_ob. In order to have a buffer ready in vp7045_usb_op, it has to
be allocated before that happens.

Luckily we can use the whole private data as the buffer as it gets separately
allocated on the heap via kzalloc in dvb_usb_device_init and is thus apt for
use via usb_control_msg.

This fixes a
	BUG: unable to handle kernel paging request at 0000000000001e78

reported by Tino Keitel and diagnosed by Dan Carpenter.

References: https://bugzilla.kernel.org/show_bug.cgi?id=40062
Cc: v3.0.y <stable@kernel.org>
Tested-by: Tino Keitel <tino.keitel@tikei.de>
Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp7045.c |   26 ++++----------------------
 1 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index 3db89e3..536c16c 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -224,26 +224,8 @@ static struct dvb_usb_device_properties vp7045_properties;
 static int vp7045_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	struct dvb_usb_device *d;
-	int ret = dvb_usb_device_init(intf, &vp7045_properties,
-				   THIS_MODULE, &d, adapter_nr);
-	if (ret)
-		return ret;
-
-	d->priv = kmalloc(20, GFP_KERNEL);
-	if (!d->priv) {
-		dvb_usb_device_exit(intf);
-		return -ENOMEM;
-	}
-
-	return ret;
-}
-
-static void vp7045_usb_disconnect(struct usb_interface *intf)
-{
-	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	kfree(d->priv);
-	dvb_usb_device_exit(intf);
+	return dvb_usb_device_init(intf, &vp7045_properties,
+				   THIS_MODULE, NULL, adapter_nr);
 }
 
 static struct usb_device_id vp7045_usb_table [] = {
@@ -258,7 +240,7 @@ MODULE_DEVICE_TABLE(usb, vp7045_usb_table);
 static struct dvb_usb_device_properties vp7045_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-vp7045-01.fw",
-	.size_of_priv = sizeof(u8 *),
+	.size_of_priv = 20,
 
 	.num_adapters = 1,
 	.adapter = {
@@ -305,7 +287,7 @@ static struct dvb_usb_device_properties vp7045_properties = {
 static struct usb_driver vp7045_usb_driver = {
 	.name		= "dvb_usb_vp7045",
 	.probe		= vp7045_usb_probe,
-	.disconnect	= vp7045_usb_disconnect,
+	.disconnect	= dvb_usb_device_exit,
 	.id_table	= vp7045_usb_table,
 };
 
-- 
1.7.6

