Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1BFXq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:29 -0500
Received: from 1wt.eu ([62.212.114.60]:60326 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab1BFXq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:27 -0500
Message-Id: <20110206232252.997683635@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Willy Tarreau <w@1wt.eu>
Subject: [PATCH 11/23] md: fix bug with re-adding of partially recovered device.
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1a855a0606653d2d82506281e2c686bacb4b2f45 upstream.

With v0.90 metadata, a hot-spare does not become a full member of the
array until recovery is complete.  So if we re-add such a device to
the array, we know that all of it is as up-to-date as the event count
would suggest, and so it a bitmap-based recovery is possible.

However with v1.x metadata, the hot-spare immediately becomes a full
member of the array, but it record how much of the device has been
recovered.  If the array is stopped and re-assembled recovery starts
from this point.

When such a device is hot-added to an array we currently lose the 'how
much is recovered' information and incorrectly included it as a full
in-sync member (after bitmap-based fixup).
This is wrong and unsafe and could corrupt data.

So be more careful about setting saved_raid_disk - which is what
guides the re-adding of devices back into an array.
The new code matches the code in slot_store which does a similar
thing, which is encouraging.

This is suitable for any -stable kernel.

Reported-by: "Dailey, Nate" <Nate.Dailey@stratus.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/md/md.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/drivers/md/md.c
===================================================================
--- longterm-2.6.27.orig/drivers/md/md.c	2011-01-29 11:19:14.697066081 +0100
+++ longterm-2.6.27/drivers/md/md.c	2011-01-29 11:27:14.692063986 +0100
@@ -4300,7 +4300,7 @@
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		/* set save_raid_disk if appropriate */
+		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
 			    info->raid_disk < mddev->raid_disks)
@@ -4310,7 +4310,10 @@
 		} else
 			super_types[mddev->major_version].
 				validate_super(mddev, rdev);
-		rdev->saved_raid_disk = rdev->raid_disk;
+		if (test_bit(In_sync, &rdev->flags))
+			rdev->saved_raid_disk = rdev->raid_disk;
+		else
+			rdev->saved_raid_disk = -1;
 
 		clear_bit(In_sync, &rdev->flags); /* just to be sure */
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))


