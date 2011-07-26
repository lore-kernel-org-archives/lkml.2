Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1GZO4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:56:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43623 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1GZO4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:56:13 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: [PATCH] usb_storage: Don't freeze in usb-stor-scan
Date: Tue, 26 Jul 2011 09:56:07 -0500
Message-Id: <1311692167-14658-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scanning cannot be run during suspend or hibernation, but if
usb-stor-scan freezes another thread waiting on scanning to
complete may fail to freeze.

However, if usb-stor-scan is left freezable without ever actually
freezing then the freezer will wait on it to exit, and threads
waiting for scanning to finish will no longer be blocked. One
problem with this approach is that usb-stor-scan has a delay to
wait for devices to settle (which is currently the only point where
it can freeze). To work around this we can request that the freezer
send a fake signal when freezing, then use interruptible sleep to
wake the thread early when freezing happens.

To make this happen, the following changes are made to
usb-stor-scan:

 * Use set_freezable_with_signal() instead of set_freezable() to
   request a fake signal when freezing

 * Use wait_event_interruptible_timeout() instead of
   wait_event_freezable_timeout() to avoid freezing

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/storage/usb.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 0ca0958..c325e69 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -831,12 +831,22 @@ static int usb_stor_scan_thread(void * __us)
 
 	dev_dbg(dev, "device found\n");
 
-	set_freezable();
-	/* Wait for the timeout to expire or for a disconnect */
+	set_freezable_with_signal();
+	/*
+	 * Wait for the timeout to expire or for a disconnect
+	 *
+	 * We can't freeze in this thread or we risk causing khubd to
+	 * fail to freeze, but we can't be non-freezable either. Nor can
+	 * khubd freeze while waiting for scanning to complete as it may
+	 * hold the device lock, causing a hang when suspending devices.
+	 * So we request a fake signal when freezing and use
+	 * interruptible sleep to kick us out of our wait early when
+	 * freezing happens.
+	 */
 	if (delay_use > 0) {
 		dev_dbg(dev, "waiting for device to settle "
 				"before scanning\n");
-		wait_event_freezable_timeout(us->delay_wait,
+		wait_event_interruptible_timeout(us->delay_wait,
 				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
 				delay_use * HZ);
 	}
-- 
1.7.4.1

