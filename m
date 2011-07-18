Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1GRQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 12:28:25 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45247 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab1GRQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 12:28:24 -0400
Date: Mon, 18 Jul 2011 11:28:18 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: [PATCH] usb_storage: make usb-stor-scan task non-freezable
Message-ID: <20110718162818.GC19552@thinkpad-t410>
Mail-Followup-To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is in response to a consistently reproducible
failure to freeze tasks prior to restoring a hibernation image on a
Toshiba NB505 netbook. This machine has a built-in USB card reader.
Since the usb-stor-scan task is freezable but the code in
quiesce_and_remove_host() that waits for scanning to complete is not,
khubd can fail to freeze when processing the disconnect for the card
reader.

It seems that both should either be freezable or not freezable. Since
there doesn't currently seem to be any freezable way to wait on a
completion, I started with the simpler approach of making usb-stor-scan
non-freezable. If it would be preferable to make both freezable I can
take that approach instead.

Thanks,
Seth


>From 27e456c0d6512ba599f7560139555374a45342be Mon Sep 17 00:00:00 2001
From: Seth Forshee <seth.forshee@canonical.com>
Date: Wed, 13 Jul 2011 23:02:48 -0500
Subject: [PATCH] usb_storage: make usb-stor-scan task non-freezable

The usb-stor-scan task is freezable, but the code in
quiesce_and_remove_host() that waits for scanning to complete is
not. This can cause task freezing to fail, which is happening
consistently on at least one model of netbook with a built-in USB
card reader when freezing tasks prior to restoring a hibernation
image.

This patch makes the usb-stor-scan task non-freezable to prevent
this from happening. Tested across 200 S4 cycles without a single
failure to freeze tasks.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/usb/storage/usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 0ca0958..f59fc90 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -831,12 +831,11 @@ static int usb_stor_scan_thread(void * __us)
 
 	dev_dbg(dev, "device found\n");
 
-	set_freezable();
 	/* Wait for the timeout to expire or for a disconnect */
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

