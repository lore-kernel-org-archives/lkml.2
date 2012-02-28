Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965099Ab2B1B1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:27:55 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab2B1BLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.197.71 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.204368871@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 43/72] USB: Set hub depth after USB3 hub reset
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elric Fu <elricfu1@gmail.com>

commit a45aa3b30583e7d54e7cf4fbcd0aa699348a6e5c upstream.

The superspeed device attached to a USB 3.0 hub(such as VIA's)
doesn't respond the address device command after resume. The
root cause is the superspeed hub will miss the Hub Depth value
that is used as an offset into the route string to locate the
bits it uses to determine the downstream port number after
reset, and all packets can't be routed to the device attached
to the superspeed hub.

Hub driver sends a Set Hub Depth request to the superspeed hub
except for USB 3.0 root hub when the hub is initialized and
doesn't send the request again after reset due to the resume
process. So moving the code that sends the Set Hub Depth request
to the superspeed hub from hub_configure() to hub_activate()
is to cover those situations include initialization and reset.

The patch should be backported to kernels as old as 2.6.39.

Signed-off-by: Elric Fu <elricfu1@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -705,10 +705,26 @@ static void hub_activate(struct usb_hub
 	if (type == HUB_INIT3)
 		goto init3;
 
-	/* After a resume, port power should still be on.
+	/* The superspeed hub except for root hub has to use Hub Depth
+	 * value as an offset into the route string to locate the bits
+	 * it uses to determine the downstream port number. So hub driver
+	 * should send a set hub depth request to superspeed hub after
+	 * the superspeed hub is set configuration in initialization or
+	 * reset procedure.
+	 *
+	 * After a resume, port power should still be on.
 	 * For any other type of activation, turn it on.
 	 */
 	if (type != HUB_RESUME) {
+		if (hdev->parent && hub_is_superspeed(hdev)) {
+			ret = usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
+					HUB_SET_DEPTH, USB_RT_HUB,
+					hdev->level - 1, 0, NULL, 0,
+					USB_CTRL_SET_TIMEOUT);
+			if (ret < 0)
+				dev_err(hub->intfdev,
+						"set hub depth failed\n");
+		}
 
 		/* Speed up system boot by using a delayed_work for the
 		 * hub's initial power-up delays.  This is pretty awkward
@@ -987,18 +1003,6 @@ static int hub_configure(struct usb_hub
 		goto fail;
 	}
 
-	if (hub_is_superspeed(hdev) && (hdev->parent != NULL)) {
-		ret = usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
-				HUB_SET_DEPTH, USB_RT_HUB,
-				hdev->level - 1, 0, NULL, 0,
-				USB_CTRL_SET_TIMEOUT);
-
-		if (ret < 0) {
-			message = "can't set hub depth";
-			goto fail;
-		}
-	}
-
 	/* Request the entire hub descriptor.
 	 * hub->descriptor can handle USB_MAXCHILDREN ports,
 	 * but the hub can/will return fewer bytes here.


