Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978Ab1KJE77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:59:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934577Ab1KJD3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.545671795@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Seth Forshee <seth.forshee@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [179/262] usb_storage: Dont freeze in usb-stor-scan
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit f02fe890ece7d695a5744b20525d45312382e6e4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/storage/usb.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -831,12 +831,22 @@ static int usb_stor_scan_thread(void * _
 
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


