Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab2JZAID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:08:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:53620 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2JZAHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:07:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 47/85] USB: Enable LPM after a failed probe.
Date: Thu, 25 Oct 2012 17:06:05 -0700
Message-Id: <20121026000035.851998438@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -372,6 +372,10 @@ static int usb_probe_interface(struct de
 	intf->condition = USB_INTERFACE_UNBOUND;
 	usb_cancel_queued_reset(intf);
 
+	/* If the LPM disable succeeded, balance the ref counts. */
+	if (!lpm_disable_error)
+		usb_unlocked_enable_lpm(udev);
+
 	/* Unbound interfaces are always runtime-PM-disabled and -suspended */
 	if (driver->supports_autosuspend)
 		pm_runtime_disable(dev);


