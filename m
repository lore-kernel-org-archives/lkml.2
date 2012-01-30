Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2A3UU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:20:27 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:39601 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2A3UUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:20:25 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 15:20:25 EST
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, jirislaby@gmail.com
Subject: [PATCH 2/5] USB: serial, use tty_standard_install
Date: Mon, 30 Jan 2012 21:14:29 +0100
Message-Id: <1327954472-26594-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But before that we need to reorder the calls so that we don't need to
lower the reference counts if usb_autopm_get_interface fails.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/usb/serial/usb-serial.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 611b206..1e30cc9 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -214,15 +214,14 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (!try_module_get(serial->type->driver.owner))
 		goto error_module_get;
 
-	/* perform the standard setup */
-	retval = tty_init_termios(tty);
-	if (retval)
-		goto error_init_termios;
-
 	retval = usb_autopm_get_interface(serial->interface);
 	if (retval)
 		goto error_get_interface;
 
+	retval = tty_standard_install(driver, tty);
+	if (retval)
+		goto error_init_termios;
+
 	mutex_unlock(&serial->disc_mutex);
 
 	/* allow the driver to update the settings */
@@ -231,14 +230,11 @@ static int serial_install(struct tty_driver *driver, struct tty_struct *tty)
 
 	tty->driver_data = port;
 
-	/* Final install (we use the default method) */
-	tty_driver_kref_get(driver);
-	tty->count++;
-	driver->ttys[idx] = tty;
 	return retval;
 
- error_get_interface:
  error_init_termios:
+	usb_autopm_put_interface(serial->interface);
+ error_get_interface:
 	module_put(serial->type->driver.owner);
  error_module_get:
  error_no_port:
-- 
1.7.8.3


