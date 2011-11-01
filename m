Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1KAAhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:37:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45713 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1KAAhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:37:32 -0400
Date: Mon, 31 Oct 2011 17:37:26 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH pm 1/2] usb_storage: don't use set_freezable_with_signal()
Message-ID: <20111101003726.GM18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of set_freezable_with_signal() is buggy and
tricky to get right.  usb-storage is the only user and its use can be
avoided trivially.

All usb-storage wants is to be able to sleep with timeout and get
woken up if freezing() becomes true.  This can be trivially
implemented by doing interruptible wait w/ freezing() included in the
wait condition.  There's no reason to use set_freezable_with_signal().

Perform interruptible wait on freezing() instead of using
set_freezable_with_signal(), which is scheduled for removal.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---

These two patches are on top of "freezer: fix various bugs and
simplify implementation, take#2" patchset[1] and are also available in
the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-kill-freezable_with_signal

If usb-storage ppl are okay with it, I think routing this through pm
would be the easiest.  Oh, and this definitely is for the next merge
window.

Thank you.

[1] http://thread.gmane.org/gmane.linux.kernel/1209247

 drivers/usb/storage/usb.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index c325e69..aa84b3d 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -831,7 +831,8 @@ static int usb_stor_scan_thread(void * __us)
 
 	dev_dbg(dev, "device found\n");
 
-	set_freezable_with_signal();
+	set_freezable();
+
 	/*
 	 * Wait for the timeout to expire or for a disconnect
 	 *
@@ -839,16 +840,16 @@ static int usb_stor_scan_thread(void * __us)
 	 * fail to freeze, but we can't be non-freezable either. Nor can
 	 * khubd freeze while waiting for scanning to complete as it may
 	 * hold the device lock, causing a hang when suspending devices.
-	 * So we request a fake signal when freezing and use
-	 * interruptible sleep to kick us out of our wait early when
-	 * freezing happens.
+	 * So instead of using wait_event_freezable(), explicitly test
+	 * for (DONT_SCAN || freezing) in interruptible wait and proceed
+	 * if any of DONT_SCAN, freezing or timeout has happened.
 	 */
 	if (delay_use > 0) {
 		dev_dbg(dev, "waiting for device to settle "
 				"before scanning\n");
 		wait_event_interruptible_timeout(us->delay_wait,
-				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
-				delay_use * HZ);
+				test_bit(US_FLIDX_DONT_SCAN, &us->dflags) ||
+				freezing(current), delay_use * HZ);
 	}
 
 	/* If the device is still connected, perform the scanning */
-- 
1.7.3.1

