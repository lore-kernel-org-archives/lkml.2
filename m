Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab1C1Rdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1C1Rdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:33:50 -0400
Date: Mon, 28 Mar 2011 18:33:46 +0100
From: Steven Hardy <shardy@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: mjg@redhat.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH 1/3] Resend : Fix memory leak in qcserial driver
Message-ID: <20110328173345.GA7030@shardy.csb>
References: <1301321186.4397.13.camel@shardy.csb>
 <20110328142148.GA19521@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328142148.GA19521@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 07:21:48AM -0700, Greg KH wrote:
> On Mon, Mar 28, 2011 at 03:06:26PM +0100, Steven Hardy wrote:
> > Hi,
> > 
> > I've been experimenting with kmemleak and noticed a recurring leak warning whenever I load & unload the qcserial driver.
> > 
> > Inspection of the code seems to indicate the leak is the serial->private data allocated in the qcprobe() function, 
> > which is never freed (apart from in some of the qcprobe error paths) as far as I can tell.
> > 
> > The patch below fixes the following problems:
> 
> <snip>
> 
> Can you fix your email client to properly wrap your lines?

Apologies, was trying to avoid mangling the patch & ended up mangling the preamble instead, back to mutt now which will hopefully do the right thing! :)

> Also, as you do 3 different things here, can you break this into 3
> patches and resend them?

Done, please find patch 1 of 3 below:

The patch below fixes the following problem:
1 - Always free the serial->private data allocated in qcprobe, added a new function qc_release which frees the memory rather than relying on the usb_wwan_release function which does not.  Without this cleanup, we leak the memory allocated in qcprobe when the kfree(serial) happens in usb-serial.c::destroy_serial()

Please keep me on CC for any responses or review comments, since I'm not currently subscribed to LKML

Signed-off-by: Steve Hardy <shardy@redhat.com>


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
