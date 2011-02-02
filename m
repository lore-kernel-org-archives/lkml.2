Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab1BBAzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:55:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:54182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab1BBAot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028526"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [86/139] md: fix bug with re-adding of partially recovered device.
Message-Id: <20110202004443.C27473E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/md.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c
+++ linux-2.6.35.y/drivers/md/md.c
@@ -5109,7 +5109,7 @@ static int add_new_disk(mddev_t * mddev,
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		/* set save_raid_disk if appropriate */
+		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
 			    info->raid_disk < mddev->raid_disks)
@@ -5119,7 +5119,10 @@ static int add_new_disk(mddev_t * mddev,
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
