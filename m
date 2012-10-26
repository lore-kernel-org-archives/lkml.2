Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2JZAH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:07:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:53610 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab2JZAHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Don Zickus <dzickus@redhat.com>
Subject: [ 46/85] usb: Dont enable LPM if the exit latency is zero.
Date: Thu, 25 Oct 2012 17:06:04 -0700
Message-Id: <20121026000035.754622824@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3353,6 +3353,16 @@ static void usb_enable_link_state(struct
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


