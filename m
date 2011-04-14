Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759327Ab1DNSIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:08:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:42166 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964970Ab1DNR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, NeilBrown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 175/209] md: fix bug with re-adding of partially recovered device.
Date: Thu, 14 Apr 2011 13:55:33 -0400
Message-Id: <1302803767-9715-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 92dbef5..cf511de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5008,7 +5008,7 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 				PTR_ERR(rdev));
 			return PTR_ERR(rdev);
 		}
-		/* set save_raid_disk if appropriate */
+		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
 			    info->raid_disk < mddev->raid_disks)
@@ -5018,7 +5018,10 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
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
-- 
1.7.4.4

