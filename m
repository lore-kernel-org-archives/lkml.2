Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab1CUKTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 06:19:39 -0400
Received: from ist.d-labs.de ([213.239.218.44]:44312 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1CUKTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 06:19:33 -0400
From: Florian Mickler <florian@mickler.org>
To: mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, pb@linuxtv.org,
        Florian Mickler <florian@mickler.org>
Subject: [PATCH 3/9] [media] vp702x: preallocate memory on device probe
Date: Mon, 21 Mar 2011 11:19:08 +0100
Message-Id: <1300702754-16376-4-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300702754-16376-1-git-send-email-florian@mickler.org>
References: <1300702754-16376-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sets up a buffer and a mutex protecting that buffer in
the struct vp702x_device_state.

The definition of struct vp702x_device_state is moved into the header
in order to use the buffer also in the frontend.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 drivers/media/dvb/dvb-usb/vp702x.c |   41 +++++++++++++++++++++++++++++------
 drivers/media/dvb/dvb-usb/vp702x.h |    8 +++++++
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x.c b/drivers/media/dvb/dvb-usb/vp702x.c
index 25536f9..569c93f 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.c
+++ b/drivers/media/dvb/dvb-usb/vp702x.c
@@ -15,6 +15,7 @@
  * see Documentation/dvb/README.dvb-usb for more information
  */
 #include "vp702x.h"
+#include <linux/mutex.h>
 
 /* debug */
 int dvb_usb_vp702x_debug;
@@ -29,10 +30,6 @@ struct vp702x_adapter_state {
 	u8  pid_filter_state;
 };
 
-struct vp702x_device_state {
-	u8 power_state;
-};
-
 /* check for mutex FIXME */
 int vp702x_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
 {
@@ -241,8 +238,38 @@ static struct dvb_usb_device_properties vp702x_properties;
 static int vp702x_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf, &vp702x_properties,
-				   THIS_MODULE, NULL, adapter_nr);
+	struct dvb_usb_device *d;
+	struct vp702x_device_state *st;
+	int ret;
+
+	ret = dvb_usb_device_init(intf, &vp702x_properties,
+				   THIS_MODULE, &d, adapter_nr);
+	if (ret)
+		goto out;
+
+	st = d->priv;
+	st->buf_len = 16;
+	st->buf = kmalloc(st->buf_len, GFP_KERNEL);
+	if (!st->buf) {
+		ret = -ENOMEM;
+		dvb_usb_device_exit(intf);
+		goto out;
+	}
+	mutex_init(&st->buf_mutex);
+
+out:
+	return ret;
+
+}
+
+static void vp702x_usb_disconnect(struct usb_interface *intf)
+{
+	struct dvb_usb_device *d = usb_get_intfdata(intf);
+	struct vp702x_device_state *st = d->priv;
+	mutex_lock(&st->buf_mutex);
+	kfree(st->buf);
+	mutex_unlock(&st->buf_mutex);
+	dvb_usb_device_exit(intf);
 }
 
 static struct usb_device_id vp702x_usb_table [] = {
@@ -309,7 +336,7 @@ static struct dvb_usb_device_properties vp702x_properties = {
 static struct usb_driver vp702x_usb_driver = {
 	.name		= "dvb_usb_vp702x",
 	.probe		= vp702x_usb_probe,
-	.disconnect	= dvb_usb_device_exit,
+	.disconnect	= vp702x_usb_disconnect,
 	.id_table	= vp702x_usb_table,
 };
 
diff --git a/drivers/media/dvb/dvb-usb/vp702x.h b/drivers/media/dvb/dvb-usb/vp702x.h
index c2f97f9..86960c6 100644
--- a/drivers/media/dvb/dvb-usb/vp702x.h
+++ b/drivers/media/dvb/dvb-usb/vp702x.h
@@ -98,6 +98,14 @@ extern int dvb_usb_vp702x_debug;
 #define RESET_TUNER		0xBE
 /* IN  i: 0, v: 0, no extra buffer */
 
+struct vp702x_device_state {
+	u8 power_state;
+	struct mutex buf_mutex;
+	int buf_len;
+	u8 *buf;
+};
+
+
 extern struct dvb_frontend * vp702x_fe_attach(struct dvb_usb_device *d);
 
 extern int vp702x_usb_inout_op(struct dvb_usb_device *d, u8 *o, int olen, u8 *i, int ilen, int msec);
-- 
1.7.4.1

