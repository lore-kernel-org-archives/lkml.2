Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab2E1DqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:46:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52048 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753865Ab2E1D32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:28 -0400
Message-Id: <20120528031211.291417478@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andiry Xu <andiry.xu@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 061/117] usbcore: enable USB2 LPM if port suspend fails
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index ec6c97d..c8e0704 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2499,6 +2499,10 @@ int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
 				NULL, 0,
 				USB_CTRL_SET_TIMEOUT);
 
+		/* Try to enable USB2 hardware LPM again */
+		if (udev->usb2_hw_lpm_capable == 1)
+			usb_set_usb2_hardware_lpm(udev, 1);
+
 		/* System sleep transitions should never fail */
 		if (!PMSG_IS_AUTO(msg))
 			status = 0;


