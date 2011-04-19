Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1DSUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:20:33 -0400
Received: from kroah.org ([198.145.64.141]:35718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab1DSURl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201049.503992462@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Hardy <shardy@redhat.com>
Subject: [59/70] usb: Fix qcserial memory leak on rmmod
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Hardy <shardy@redhat.com>

commit 10c9ab15d6aee153968d150c05b3ee3df89673de upstream.

qcprobe function allocates serial->private but this is never freed, this
patch adds a new function qc_release() which frees serial->private, after
calling usb_wwan_release

Signed-off-by: Steven Hardy <shardy@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/qcserial.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -205,6 +205,18 @@ static int qcprobe(struct usb_serial *se
 	return retval;
 }
 
+static void qc_release(struct usb_serial *serial)
+{
+	struct usb_wwan_intf_private *priv = usb_get_serial_data(serial);
+
+	dbg("%s", __func__);
+
+	/* Call usb_wwan release & free the private data allocated in qcprobe */
+	usb_wwan_release(serial);
+	usb_set_serial_data(serial, NULL);
+	kfree(priv);
+}
+
 static struct usb_serial_driver qcdevice = {
 	.driver = {
 		.owner     = THIS_MODULE,
@@ -222,7 +234,7 @@ static struct usb_serial_driver qcdevice
 	.chars_in_buffer     = usb_wwan_chars_in_buffer,
 	.attach		     = usb_wwan_startup,
 	.disconnect	     = usb_wwan_disconnect,
-	.release	     = usb_wwan_release,
+	.release	     = qc_release,
 #ifdef CONFIG_PM
 	.suspend	     = usb_wwan_suspend,
 	.resume		     = usb_wwan_resume,


