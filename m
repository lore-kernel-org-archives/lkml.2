Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab1DNSDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:03:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:42310 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965053Ab1DNR7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:02 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, NeilBrown <neilb@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 196/209] md: fix regression with re-adding devices to arrays with no metadata
Date: Thu, 14 Apr 2011 13:55:54 -0400
Message-Id: <1302803767-9715-83-git-send-email-paul.gortmaker@windriver.com>
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

commit bf572541ab44240163eaa2d486b06f306a31d45a upstream.

Commit 1a855a0606 (2.6.37-rc4) fixed a problem where devices were
re-added when they shouldn't be but caused a regression in a less
common case that means sometimes devices cannot be re-added when they
should be.

In particular, when re-adding a device to an array without metadata
we should always access the device, but after the above commit we
didn't.

This patch sets the In_sync flag in that case so that the re-add
succeeds.

This patch is suitable for any -stable kernel to which 1a855a0606 was
applied.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e56e35e..7db9ceb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5008,9 +5008,10 @@ static int add_new_disk(mddev_t * mddev, mdu_disk_info_t *info)
 		/* set saved_raid_disk if appropriate */
 		if (!mddev->persistent) {
 			if (info->state & (1<<MD_DISK_SYNC)  &&
-			    info->raid_disk < mddev->raid_disks)
+			    info->raid_disk < mddev->raid_disks) {
 				rdev->raid_disk = info->raid_disk;
-			else
+				set_bit(In_sync, &rdev->flags);
+			} else
 				rdev->raid_disk = -1;
 		} else
 			super_types[mddev->major_version].
-- 
1.7.4.4

