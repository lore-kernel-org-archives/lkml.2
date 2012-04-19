Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765Ab2DSV03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:26:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656Ab2DSVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:16:38 -0400
Message-Id: <20120419210821.588058028@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Chen Peter <B29397@freescale.com>,
        Chen Peter <peter.chen@freescale.com>
Subject: [ 34/68] USB: dont ignore suspend errors for root hubs
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit cd4376e23a59a2adf3084cb5f4a523e6d5fd4e49 upstream.

This patch (as1532) fixes a mistake in the USB suspend code.  When the
system is going to sleep, we should ignore errors in powering down USB
devices, because they don't really matter.  The devices will go to low
power anyway when the entire USB bus gets suspended (except for
SuperSpeed devices; maybe they will need special treatment later).

However we should not ignore errors in suspending root hubs,
especially if the error indicates that the suspend raced with a wakeup
request.  Doing so might leave the bus powered on while the system was
supposed to be asleep, or it might cause the suspend of the root hub's
parent controller device to fail, or it might cause a wakeup request
to be ignored.

The patch fixes the problem by ignoring errors only when the device in
question is not a root hub.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Chen Peter <B29397@freescale.com>
Tested-by: Chen Peter <peter.chen@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1198,8 +1198,13 @@ static int usb_suspend_both(struct usb_d
 	if (status == 0) {
 		status = usb_suspend_device(udev, msg);
 
-		/* Again, ignore errors during system sleep transitions */
-		if (!PMSG_IS_AUTO(msg))
+		/*
+		 * Ignore errors from non-root-hub devices during
+		 * system sleep transitions.  For the most part,
+		 * these devices should go to low power anyway when
+		 * the entire bus is suspended.
+		 */
+		if (udev->parent && !PMSG_IS_AUTO(msg))
 			status = 0;
 	}
 


