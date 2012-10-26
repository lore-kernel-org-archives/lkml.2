Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2JZAXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:23:39 -0400
Received: from mail.kernel.org ([198.145.19.201]:53629 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab2JZAHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 48/85] usb: Send Set SEL before enabling parent U1/U2 timeout.
Date: Thu, 25 Oct 2012 17:06:06 -0700
Message-Id: <20121026000035.944012966@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 65a95b75bc5afa7bbb844e222481044c1c4767eb upstream.

The Set SEL control transfer tells a device the exit latencies
associated with a device-initated U1 or U2 exit.  Since a parent hub may
initiate a transition to U1 soon after a downstream port's U1 timeout is
set, we need to make sure the device receives the Set SEL transfer
before the parent hub timeout is set.

This patch should be backported to kernels as old as 3.5, that contain
the commit 1ea7e0e8e3d0f50901d335ea4178ab2aa8c88201 "USB: Add support to
enable/disable USB3 link states."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3258,16 +3258,6 @@ static int usb_set_device_initiated_lpm(
 
 	if (enable) {
 		/*
-		 * First, let the device know about the exit latencies
-		 * associated with the link state we're about to enable.
-		 */
-		ret = usb_req_set_sel(udev, state);
-		if (ret < 0) {
-			dev_warn(&udev->dev, "Set SEL for device-initiated "
-					"%s failed.\n", usb3_lpm_names[state]);
-			return -EBUSY;
-		}
-		/*
 		 * Now send the control transfer to enable device-initiated LPM
 		 * for either U1 or U2.
 		 */
@@ -3352,7 +3342,7 @@ static int usb_set_lpm_timeout(struct us
 static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 		enum usb3_link_state state)
 {
-	int timeout;
+	int timeout, ret;
 	__u8 u1_mel = udev->bos->ss_cap->bU1devExitLat;
 	__le16 u2_mel = udev->bos->ss_cap->bU2DevExitLat;
 
@@ -3364,6 +3354,17 @@ static void usb_enable_link_state(struct
 			(state == USB3_LPM_U2 && u2_mel == 0))
 		return;
 
+	/*
+	 * First, let the device know about the exit latencies
+	 * associated with the link state we're about to enable.
+	 */
+	ret = usb_req_set_sel(udev, state);
+	if (ret < 0) {
+		dev_warn(&udev->dev, "Set SEL for device-initiated %s failed.\n",
+				usb3_lpm_names[state]);
+		return;
+	}
+
 	/* We allow the host controller to set the U1/U2 timeout internally
 	 * first, so that it can change its schedule to account for the
 	 * additional latency to send data to a device in a lower power


