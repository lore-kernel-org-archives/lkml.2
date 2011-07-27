Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1G0Vtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:51500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab1G0VtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32274884"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: stern@rowland.harvard.edu, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [84/99] USB: don't let errors prevent system sleep
Message-Id: <20110727214923.CA5502403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 0af212ba8f123c2eba151af7726c34a50b127962 upstream.

This patch (as1464) implements the recommended policy that most errors
during suspend or hibernation should not prevent the system from going
to sleep.  In particular, failure to suspend a USB driver or a USB
device should not prevent the sleep from succeeding:

Failure to suspend a device won't matter, because the device will
automatically go into suspend mode when the USB bus stops carrying
packets.  (This might be less true for USB-3.0 devices, but let's not
worry about them now.)

Failure of a driver to suspend might lead to trouble later on when the
system wakes up, but it isn't sufficient reason to prevent the system
from going to sleep.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/core/driver.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/core/driver.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/core/driver.c
+++ linux-2.6.35.y/drivers/usb/core/driver.c
@@ -1189,13 +1189,22 @@ static int usb_suspend_both(struct usb_d
 		for (i = n - 1; i >= 0; --i) {
 			intf = udev->actconfig->interface[i];
 			status = usb_suspend_interface(udev, intf, msg);
+
+			/* Ignore errors during system sleep transitions */
+			if (!(msg.event & PM_EVENT_AUTO))
+				status = 0;
 			if (status != 0)
 				break;
 		}
 	}
-	if (status == 0)
+	if (status == 0) {
 		status = usb_suspend_device(udev, msg);
 
+		/* Again, ignore errors during system sleep transitions */
+		if (!(msg.event & PM_EVENT_AUTO))
+			status = 0;
+	}
+
 	/* If the suspend failed, resume interfaces that did get suspended */
 	if (status != 0) {
 		msg.event ^= (PM_EVENT_SUSPEND | PM_EVENT_RESUME);
