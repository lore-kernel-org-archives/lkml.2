Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1DDQ5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:57:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab1DDQ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:57:48 -0400
Subject: [PATCH 1/3] usb: Fix qcserial memory leak on rmmod
From: Steven Hardy <shardy@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Aristeu Rozanski <aris@redhat.com>,
        mjg@redhat.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D91C1EB.5060604@ru.mvista.com>
References: <1301321186.4397.13.camel@shardy.csb>
	 <20110328142148.GA19521@suse.de> <20110328221636.GA8195@shardy.csb>
	 <4D91C1EB.5060604@ru.mvista.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 17:57:37 +0100
Message-ID: <1301936257.4891.20.camel@shardy.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qcprobe function allocates serial->private but this is never freed, this
patch adds a new function qc_release() which frees serial->private, after
calling usb_wwan_release

Signed-off-by: Steven Hardy <shardy@redhat.com>
---
Repost of qcserial patches posted last week, hopefully addresses review 
comments and email-patch-format issues

 drivers/usb/serial/qcserial.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 8858201..6e3b933 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -205,6 +205,18 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
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
@@ -222,7 +234,7 @@ static struct usb_serial_driver qcdevice = {
 	.chars_in_buffer     = usb_wwan_chars_in_buffer,
 	.attach		     = usb_wwan_startup,
 	.disconnect	     = usb_wwan_disconnect,
-	.release	     = usb_wwan_release,
+	.release	     = qc_release,
 #ifdef CONFIG_PM
 	.suspend	     = usb_wwan_suspend,
 	.resume		     = usb_wwan_resume,
-- 
1.7.1



