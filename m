Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1KWS7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:59:40 -0500
Received: from mail-yw0-f74.google.com ([209.85.213.74]:56569 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab1KWS7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:59:38 -0500
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
Date: Wed, 23 Nov 2011 10:53:32 -0800
Message-Id: <1322074412-10873-1-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't hold open_lock while calling tty_port_close_start, which takes
big_tty_mutex, because open_lock and big_tty_mutex are taken in the
opposite order when opening the device.

This means we need some other way of preventing the device state from
being freed before we're done cleaning up. Using the existing kref in
tty_port, we can let the TTY side and the USB side indenpendently signal
that they're done with the object, and free it when both are done.

Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
How about something along these lines? I haven't tested it yet, and in fact I'm
a bit worried about the possible lack of symmetry between the tty_port_get() in
acm_tty_open() and the tty_port_put() in acm_tty_cleanup(). Is there any better
way to do this?

 drivers/usb/class/cdc-acm.c |   42 ++++++++++++++++++++++--------------------
 1 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e8c564a..c09f3f7 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -62,9 +62,6 @@ static DEFINE_MUTEX(open_mutex);
 
 #define ACM_READY(acm)	(acm && acm->dev && acm->port.count)
 
-static const struct tty_port_operations acm_port_ops = {
-};
-
 /*
  * Functions for ACM control messages.
  */
@@ -501,6 +498,9 @@ static int acm_tty_open(struct tty_struct *tty, struct file *filp)
 	if (acm_submit_read_urbs(acm, GFP_KERNEL))
 		goto bail_out;
 
+	/* Get a reference for the TTY device. Released on the last close */
+	tty_port_get(&acm->port);
+
 	set_bit(ASYNCB_INITIALIZED, &acm->port.flags);
 	rv = tty_port_block_til_ready(&acm->port, tty, filp);
 
@@ -519,8 +519,9 @@ early_bail:
 	return -EIO;
 }
 
-static void acm_tty_unregister(struct acm *acm)
+static void acm_port_destruct(struct tty_port *port)
 {
+	struct acm *acm = container_of(port, struct acm, port);
 	int i;
 
 	tty_unregister_device(acm_tty_driver, acm->minor);
@@ -552,6 +553,12 @@ static void acm_port_down(struct acm *acm)
 	}
 }
 
+static void acm_tty_cleanup(struct tty_struct *tty)
+{
+	struct acm *acm = tty->driver_data;
+	tty_port_put(&acm->port);
+}
+
 static void acm_tty_hangup(struct tty_struct *tty)
 {
 	struct acm *acm = tty->driver_data;
@@ -567,19 +574,10 @@ static void acm_tty_close(struct tty_struct *tty, struct file *filp)
 
 	/* Perform the closing process and see if we need to do the hardware
 	   shutdown */
-	if (!acm)
-		return;
-
-	mutex_lock(&open_mutex);
 	if (tty_port_close_start(&acm->port, tty, filp) == 0) {
-		if (!acm->dev) {
-			tty_port_tty_set(&acm->port, NULL);
-			acm_tty_unregister(acm);
-			tty->driver_data = NULL;
-		}
-		mutex_unlock(&open_mutex);
 		return;
 	}
+	mutex_lock(&open_mutex);
 	acm_port_down(acm);
 	tty_port_close_end(&acm->port, tty);
 	tty_port_tty_set(&acm->port, NULL);
@@ -788,6 +786,10 @@ static void acm_tty_set_termios(struct tty_struct *tty,
 	}
 }
 
+static const struct tty_port_operations acm_port_ops = {
+	.destruct =		acm_port_destruct,
+};
+
 /*
  * USB probe and disconnect routines.
  */
@@ -1206,6 +1208,9 @@ skip_countries:
 
 	dev_info(&intf->dev, "ttyACM%d: USB ACM device\n", minor);
 
+	/* Grab a reference for the USB device. Released on disconnect */
+	tty_port_get(&acm->port);
+
 	acm_set_control(acm, acm->ctrlout);
 
 	acm->line.dwDTERate = cpu_to_le32(9600);
@@ -1287,18 +1292,14 @@ static void acm_disconnect(struct usb_interface *intf)
 		usb_driver_release_interface(&acm_driver, intf == acm->control ?
 					acm->data : acm->control);
 
-	if (acm->port.count == 0) {
-		acm_tty_unregister(acm);
-		mutex_unlock(&open_mutex);
-		return;
-	}
-
 	mutex_unlock(&open_mutex);
 	tty = tty_port_tty_get(&acm->port);
 	if (tty) {
 		tty_hangup(tty);
 		tty_kref_put(tty);
 	}
+
+	tty_port_put(&acm->port);
 }
 
 #ifdef CONFIG_PM
@@ -1596,6 +1597,7 @@ static struct usb_driver acm_driver = {
 static const struct tty_operations acm_ops = {
 	.open =			acm_tty_open,
 	.close =		acm_tty_close,
+	.cleanup =		acm_tty_cleanup,
 	.hangup =		acm_tty_hangup,
 	.write =		acm_tty_write,
 	.write_room =		acm_tty_write_room,
-- 
1.7.3.1

