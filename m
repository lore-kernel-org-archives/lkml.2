Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab1C3V61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:58:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:13486 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933317Ab1C3VGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133008"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [70/275] md: fix regression with re-adding devices to arrays with no metadata
Message-Id: <20110330210507.5EBE33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/md.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c	2011-03-29 22:51:42.038647504 -0700
+++ linux-2.6.35.y/drivers/md/md.c	2011-03-29 23:54:36.691063594 -0700
@@ -5109,9 +5109,10 @@
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
