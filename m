Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab2KZRJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:09:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab2KZRJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:41 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 157/270] usb: Send Set SEL before enabling parent U1/U2 timeout.
Date: Mon, 26 Nov 2012 14:57:27 -0200
Message-Id: <1353949160-26803-158-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 209815a..c16230b 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3199,16 +3199,6 @@ static int usb_set_device_initiated_lpm(struct usb_device *udev,
 
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
@@ -3293,7 +3283,7 @@ static int usb_set_lpm_timeout(struct usb_device *udev,
 static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 		enum usb3_link_state state)
 {
-	int timeout;
+	int timeout, ret;
 	__u8 u1_mel = udev->bos->ss_cap->bU1devExitLat;
 	__le16 u2_mel = udev->bos->ss_cap->bU2DevExitLat;
 
@@ -3305,6 +3295,17 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
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
-- 
1.7.9.5

