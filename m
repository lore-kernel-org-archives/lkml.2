Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab2E0BRj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:17:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422703Ab2E0BRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:23 -0400
Message-Id: <20120527002516.414079749@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:50 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [ 44/91] usb-serial: ftdi_sio: fix oops during autosuspend
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 5cbe61c5aff0a8ada691eb8b07dbfb55c303f640 upstream.

This patch (as1550) fixes a bug in the usb-serial core that affects
the ftdi_sio driver and most likely others as well.  The core
implements suspend and resume routines, but it doesn't store pointers
to those routines in the usb_driver structures that it registers,
even though it does set those drivers' supports_autosuspend flag.  The
end result is that when one of these devices is autosuspended, we try
to call through a NULL pointer.

The patch fixes the problem by setting the suspend and resume method
pointers to the appropriate routines in the USB serial core, along
with the supports_autosuspend field, in each driver as it is
registered.

This should be back-ported to all the stable kernels that have the new
usb_serial_register_drivers() interface.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Frank Schäfer <schaefer.frank@gmx.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/usb-serial.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1338,7 +1338,6 @@ static int usb_serial_register(struct us
 				driver->description);
 		return -EINVAL;
 	}
-	driver->usb_driver->supports_autosuspend = 1;
 
 	/* Add this device to our list of devices */
 	mutex_lock(&table_lock);
@@ -1373,7 +1372,7 @@ static void usb_serial_deregister(struct
  * @serial_drivers: NULL-terminated array of pointers to drivers to be registered
  *
  * Registers @udriver and all the drivers in the @serial_drivers array.
- * Automatically fills in the .no_dynamic_id field in @udriver and
+ * Automatically fills in the .no_dynamic_id and PM fields in @udriver and
  * the .usb_driver field in each serial driver.
  */
 int usb_serial_register_drivers(struct usb_driver *udriver,
@@ -1392,11 +1391,17 @@ int usb_serial_register_drivers(struct u
 	 * the serial drivers are registered, because the probe would
 	 * simply fail for lack of a matching serial driver.
 	 * Therefore save off udriver's id_table until we are all set.
+	 *
+	 * Suspend/resume support is implemented in the usb-serial core,
+	 * so fill in the PM-related fields in udriver.
 	 */
 	saved_id_table = udriver->id_table;
 	udriver->id_table = NULL;
 
 	udriver->no_dynamic_id = 1;
+	udriver->supports_autosuspend = 1;
+	udriver->suspend = usb_serial_suspend;
+	udriver->resume = usb_serial_resume;
 	rc = usb_register(udriver);
 	if (rc)
 		return rc;


