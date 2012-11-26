Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab2KZRpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:45:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933415Ab2KZRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 156/270] usb: Don't enable LPM if the exit latency is zero.
Date: Mon, 26 Nov 2012 14:57:26 -0200
Message-Id: <1353949160-26803-157-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit ae8963adb4ad8c5f2a89ca1d99fb7bb721e7599f upstream.

Some USB 3.0 devices signal that they don't implement Link PM by having
all zeroes in the U1/U2 exit latencies in their SuperSpeed BOS
descriptor.  Don found that a Western Digital device he has experiences
transfer errors when LPM is enabled.  The lsusb shows the U1/U2 exit
latencies are set to zero:

Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
      Latency Tolerance Messages (LTM) Supported
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat           0 micro seconds
    bU2DevExitLat           0 micro seconds

The fix is to not enable LPM for a particular link state if we find its
corresponding exit latency is zero.

This patch should be backported to kernels as old as 3.5, that contain
the commit 1ea7e0e8e3d0f50901d335ea4178ab2aa8c88201 "USB: Add support to
enable/disable USB3 link states."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/hub.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 70223d5..209815a 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3294,6 +3294,16 @@ static void usb_enable_link_state(struct usb_hcd *hcd, struct usb_device *udev,
 		enum usb3_link_state state)
 {
 	int timeout;
+	__u8 u1_mel = udev->bos->ss_cap->bU1devExitLat;
+	__le16 u2_mel = udev->bos->ss_cap->bU2DevExitLat;
+
+	/* If the device says it doesn't have *any* exit latency to come out of
+	 * U1 or U2, it's probably lying.  Assume it doesn't implement that link
+	 * state.
+	 */
+	if ((state == USB3_LPM_U1 && u1_mel == 0) ||
+			(state == USB3_LPM_U2 && u2_mel == 0))
+		return;
 
 	/* We allow the host controller to set the U1/U2 timeout internally
 	 * first, so that it can change its schedule to account for the
-- 
1.7.9.5

