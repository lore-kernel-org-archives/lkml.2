Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965777Ab2E0BQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:16:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54259 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750Ab2E0BQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:31 -0400
Message-Id: <20120527002514.274369461@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:40 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 34/91] USB: cdc-wdm: cannot use dev_printk when device is gone
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 6b0b79d38806481c1c8fffa7c5842f3c83679a42 upstream.

We cannot dereference a removed USB interface for
dev_printk. Use pr_debug instead where necessary.

Flush errors are expected if device is unplugged and are
therefore best ingored at this point.

Move the kill_urbs() call in wdm_release with dev_dbg()
for the non disconnect, as we know it has already been
called if WDM_DISCONNECTING is set.  This does not
actually fix anything, but keeps the code more consistent.

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-wdm.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -530,7 +530,9 @@ static int wdm_flush(struct file *file,
 	struct wdm_device *desc = file->private_data;
 
 	wait_event(desc->wait, !test_bit(WDM_IN_USE, &desc->flags));
-	if (desc->werr < 0)
+
+	/* cannot dereference desc->intf if WDM_DISCONNECTING */
+	if (desc->werr < 0 && !test_bit(WDM_DISCONNECTING, &desc->flags))
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
 
@@ -621,12 +623,15 @@ static int wdm_release(struct inode *ino
 	mutex_unlock(&desc->wlock);
 
 	if (!desc->count) {
-		dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
-		kill_urbs(desc);
-		if (!test_bit(WDM_DISCONNECTING, &desc->flags))
+		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
+			dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
+			kill_urbs(desc);
 			desc->manage_power(desc->intf, 0);
-		else
+		} else {
+			/* must avoid dev_printk here as desc->intf is invalid */
+			pr_debug(KBUILD_MODNAME " %s: device gone - cleaning up\n", __func__);
 			cleanup(desc);
+		}
 	}
 	mutex_unlock(&wdm_mutex);
 	return 0;


