Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2E1DpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:45:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52078 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753900Ab2E1D3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:30 -0400
Message-Id: <20120528031210.757569840@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 057/117] USB: cdc-wdm: cannot use dev_printk when device is gone
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/class/cdc-wdm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -496,7 +496,9 @@
 	struct wdm_device *desc = file->private_data;
 
 	wait_event(desc->wait, !test_bit(WDM_IN_USE, &desc->flags));
-	if (desc->werr < 0)
+
+	/* cannot dereference desc->intf if WDM_DISCONNECTING */
+	if (desc->werr < 0 && !test_bit(WDM_DISCONNECTING, &desc->flags))
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
 
@@ -586,12 +588,13 @@
 	mutex_unlock(&desc->wlock);
 
 	if (!desc->count) {
-		dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
-		kill_urbs(desc);
 		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
+			dev_dbg(&desc->intf->dev, "wdm_release: cleanup");
+			kill_urbs(desc);
 			desc->intf->needs_remote_wakeup = 0;
 		} else {
-			dev_dbg(&desc->intf->dev, "%s: device gone - cleaning up\n", __func__);
+			/* must avoid dev_printk here as desc->intf is invalid */
+			pr_debug(KBUILD_MODNAME " %s: device gone - cleaning up\n", __func__);
 			cleanup(desc);
 		}
 	}


