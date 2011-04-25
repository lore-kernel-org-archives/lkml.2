Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab1DYUXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:12 -0400
Received: from 1wt.eu ([62.212.114.60]:33699 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1DYUXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:05 -0400
Message-Id: <20110425200234.208398621@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: NeilBrown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 028/173] md: fix regression with re-adding devices to arrays with no metadata
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4802,9 +4802,10 @@ static int add_new_disk(mddev_t * mddev,
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


