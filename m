Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1AEXGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:41 -0500
Received: from kroah.org ([198.145.64.141]:50799 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1AEXGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:32 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:25 2011
Message-Id: <20110105230325.781267069@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [23/49] md: fix bug with re-adding of partially recovered device.
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/md/md.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4802,7 +4802,7 @@ static int add_new_disk(mddev_t * mddev,
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		/* set save_raid_disk if appropriate */
+		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
 			    info->raid_disk < mddev->raid_disks)
@@ -4812,7 +4812,10 @@ static int add_new_disk(mddev_t * mddev,
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


