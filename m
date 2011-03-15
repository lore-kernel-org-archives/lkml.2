Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1COIzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 04:55:00 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47639 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab1COIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 04:53:27 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: oliver@neukum.org, jwjstone@fastmail.fm,
        Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 04/16] [media] vp7045: get rid of on-stack dma buffers
Date: Tue, 15 Mar 2011 09:43:36 +0100
Message-Id: <1300178655-24832-4-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1300178655-24832-1-git-send-email-florian@mickler.org>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
 <1300178655-24832-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_control_msg initiates (and waits for completion of) a dma transfer using
the supplied buffer. That buffer thus has to be seperately allocated on
the heap.

In lib/dma_debug.c the function check_for_stack even warns about it:
	WARNING: at lib/dma-debug.c:866 check_for_stack

Note: This change is tested to compile only, as I don't have the hardware.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp7045.c |   41 ++++++++++++++++++++++++++---------
 1 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index ab0ab3c..17478ec 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -28,9 +28,9 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen, u8 *in, int inlen, int msec)
 {
 	int ret = 0;
-	u8 inbuf[12] = { 0 }, outbuf[20] = { 0 };
+	u8 *buf = d->priv;
 
-	outbuf[0] = cmd;
+	buf[0] = cmd;
 
 	if (outlen > 19)
 		outlen = 19;
@@ -39,10 +39,10 @@ int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen, u8 *in,
 		inlen = 11;
 
 	if (out != NULL && outlen > 0)
-		memcpy(&outbuf[1], out, outlen);
+		memcpy(&buf[1], out, outlen);
 
 	deb_xfer("out buffer: ");
-	debug_dump(outbuf,outlen+1,deb_xfer);
+	debug_dump(buf, outlen+1, deb_xfer);
 
 	if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
 		return ret;
@@ -50,7 +50,7 @@ int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen, u8 *in,
 	if (usb_control_msg(d->udev,
 			usb_sndctrlpipe(d->udev,0),
 			TH_COMMAND_OUT, USB_TYPE_VENDOR | USB_DIR_OUT, 0, 0,
-			outbuf, 20, 2000) != 20) {
+			buf, 20, 2000) != 20) {
 		err("USB control message 'out' went wrong.");
 		ret = -EIO;
 		goto unlock;
@@ -61,17 +61,17 @@ int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen, u8 *in,
 	if (usb_control_msg(d->udev,
 			usb_rcvctrlpipe(d->udev,0),
 			TH_COMMAND_IN, USB_TYPE_VENDOR | USB_DIR_IN, 0, 0,
-			inbuf, 12, 2000) != 12) {
+			buf, 12, 2000) != 12) {
 		err("USB control message 'in' went wrong.");
 		ret = -EIO;
 		goto unlock;
 	}
 
 	deb_xfer("in buffer: ");
-	debug_dump(inbuf,12,deb_xfer);
+	debug_dump(buf, 12, deb_xfer);
 
 	if (in != NULL && inlen > 0)
-		memcpy(in,&inbuf[1],inlen);
+		memcpy(in, &buf[1], inlen);
 
 unlock:
 	mutex_unlock(&d->usb_mutex);
@@ -222,8 +222,26 @@ static struct dvb_usb_device_properties vp7045_properties;
 static int vp7045_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf, &vp7045_properties,
-				   THIS_MODULE, NULL, adapter_nr);
+	struct dvb_usb_device *d;
+	int ret = dvb_usb_device_init(intf, &vp7045_properties,
+				   THIS_MODULE, &d, adapter_nr);
+	if (ret)
+		return ret;
+
+	d->priv = kmalloc(20, GFP_KERNEL);
+	if (!d->priv) {
+		dvb_usb_device_exit(intf);
+		return -ENOMEM;
+	}
+
+	return ret;
+}
+
+static void vp7045_usb_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	kfree(d->priv);
+	dvb_usb_device_exit(intf);
 }
 
 static struct usb_device_id vp7045_usb_table [] = {
@@ -238,6 +256,7 @@ MODULE_DEVICE_TABLE(usb, vp7045_usb_table);
 static struct dvb_usb_device_properties vp7045_properties = {
 	.usb_ctrl = CYPRESS_FX2,
 	.firmware = "dvb-usb-vp7045-01.fw",
+	.size_of_priv = sizeof(u8 *),
 
 	.num_adapters = 1,
 	.adapter = {
@@ -284,7 +303,7 @@ static struct dvb_usb_device_properties vp7045_properties = {
 static struct usb_driver vp7045_usb_driver = {
 	.name		= "dvb_usb_vp7045",
 	.probe		= vp7045_usb_probe,
-	.disconnect = dvb_usb_device_exit,
+	.disconnect	= vp7045_usb_disconnect,
 	.id_table	= vp7045_usb_table,
 };
 
-- 
1.7.4.rc3

