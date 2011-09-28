Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab1I1XYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:24:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab1I1WlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.648595302@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Mickler <florian@mickler.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [079/244] [media] vp7045: fix buffer setup
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Florian Mickler <florian@mickler.org>

commit fc61ccd35fd59d5362d37c8bf9c0526c85086c84 upstream.

dvb_usb_device_init calls the frontend_attach method of this driver which
uses vp7045_usb_ob. In order to have a buffer ready in vp7045_usb_op, it has to
be allocated before that happens.

Luckily we can use the whole private data as the buffer as it gets separately
allocated on the heap via kzalloc in dvb_usb_device_init and is thus apt for
use via usb_control_msg.

This fixes a
	BUG: unable to handle kernel paging request at 0000000000001e78

reported by Tino Keitel and diagnosed by Dan Carpenter.

Tested-by: Tino Keitel <tino.keitel@tikei.de>
Signed-off-by: Florian Mickler <florian@mickler.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/dvb-usb/vp7045.c |   26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -224,26 +224,8 @@ static struct dvb_usb_device_properties
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
@@ -258,7 +240,7 @@ MODULE_DEVICE_TABLE(usb, vp7045_usb_tabl
 static struct dvb_usb_device_properties vp7045_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-vp7045-01.fw",
-	.size_of_priv = sizeof(u8 *),
+	.size_of_priv = 20,
 
 	.num_adapters = 1,
 	.adapter = {
@@ -305,7 +287,7 @@ static struct dvb_usb_device_properties
 static struct usb_driver vp7045_usb_driver = {
 	.name		= "dvb_usb_vp7045",
 	.probe		= vp7045_usb_probe,
-	.disconnect	= vp7045_usb_disconnect,
+	.disconnect	= dvb_usb_device_exit,
 	.id_table	= vp7045_usb_table,
 };
 


