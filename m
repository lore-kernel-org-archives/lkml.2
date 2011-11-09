Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935316Ab1KJDb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:31:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934631Ab1KJDbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:21 2011
Message-Id: <20111109212721.507384433@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [208/262] USB: Update last_busy time after autosuspend fails
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit b2c0a863e14676fa5760c6d828fd373288e2f64a upstream.

Originally, the runtime PM core would send an idle notification
whenever a suspend attempt failed.  The idle callback routine could
then schedule a delayed suspend for some time later.

However this behavior was changed by commit
f71648d73c1650b8b4aceb3856bebbde6daa3b86 (PM / Runtime: Remove idle
notification after failing suspend).  No notifications were sent, and
there was no clear mechanism to retry failed suspends.

This caused problems for the usbhid driver, because it fails
autosuspend attempts as long as a key is being held down.  A companion
patch changes the PM core's behavior, but we also need to change the
USB core.  In particular, this patch (as1493) updates the device's
last_busy time when an autosuspend fails, so that the PM core will
retry the autosuspend in the future when the delay time expires
again.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Henrik Rydberg <rydberg@euromail.se>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/driver.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1668,6 +1668,11 @@ int usb_runtime_suspend(struct device *d
 		return -EAGAIN;
 
 	status = usb_suspend_both(udev, PMSG_AUTO_SUSPEND);
+
+	/* Allow a retry if autosuspend failed temporarily */
+	if (status == -EAGAIN || status == -EBUSY)
+		usb_mark_last_busy(udev);
+
 	/* The PM core reacts badly unless the return code is 0,
 	 * -EAGAIN, or -EBUSY, so always return -EBUSY on an error.
 	 */


