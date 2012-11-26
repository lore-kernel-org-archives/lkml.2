Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab2KZRpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:45:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414Ab2KZRJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 155/270] USB: Enable LPM after a failed probe.
Date: Mon, 26 Nov 2012 14:57:25 -0200
Message-Id: <1353949160-26803-156-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit d01f87c0ffa96cb44faa78710711eb6e974b891c upstream.

Before a driver is probed, we want to disable USB 3.0 Link Power
Management (LPM), in case the driver needs hub-initiated LPM disabled.
After the probe finishes, we want to attempt to re-enable LPM, order to
balance the LPM ref count.

When a probe fails (such as when libusual doesn't want to bind to a USB
3.0 mass storage device), make sure to balance the LPM ref counts by
re-enabling LPM.

This patch should be backported to kernels as old as 3.5, that contain
the commit 8306095fd2c1100e8244c09bf560f97aca5a311d "USB: Disable USB
3.0 LPM in critical sections."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/driver.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index f536aeb..da33079 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -371,6 +371,10 @@ static int usb_probe_interface(struct device *dev)
 	intf->condition = USB_INTERFACE_UNBOUND;
 	usb_cancel_queued_reset(intf);
 
+	/* If the LPM disable succeeded, balance the ref counts. */
+	if (!lpm_disable_error)
+		usb_unlocked_enable_lpm(udev);
+
 	/* Unbound interfaces are always runtime-PM-disabled and -suspended */
 	if (driver->supports_autosuspend)
 		pm_runtime_disable(dev);
-- 
1.7.9.5

