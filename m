Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265Ab2E0BLN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:11:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584Ab2E0BLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:11:03 -0400
Message-Id: <20120527010432.788259335@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:27 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 64/94] usbcore: enable USB2 LPM if port suspend fails
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andiry Xu <andiry.xu@gmail.com>

commit c3e751e4f4754793bb52bd5ae30e9cc027edbb12 upstream.

USB2 LPM is disabled when device begin to suspend and enabled after device
is resumed. That's because USB spec does not define the transition from
U1/U2 state to U3 state.

If usb_port_suspend() fails, usb_port_resume() is never called, and USB2 LPM
is disabled in this situation. Enable USB2 LPM if port suspend fails.

This patch should be backported to kernels as old as 3.2, that contain
the commit 65580b4321eb36f16ae8b5987bfa1bb948fc5112 "xHCI: set USB2
hardware LPM".

Signed-off-by: Andiry Xu <andiry.xu@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2419,6 +2419,10 @@ int usb_port_suspend(struct usb_device *
 				NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
 
+		/* Try to enable USB2 hardware LPM again */
+		if (udev->usb2_hw_lpm_capable == 1)
+			usb_set_usb2_hardware_lpm(udev, 1);
+
 		/* System sleep transitions should never fail */
 		if (!PMSG_IS_AUTO(msg))
 			status = 0;


