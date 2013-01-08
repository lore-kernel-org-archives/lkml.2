Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3AHX6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:58:23 -0500
Received: from mail.windriver.com ([147.11.1.11]:63447 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab3AHXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:37:16 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: NeilBrown <neilb@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 14/77] md: Don't truncate size at 4TB for RAID0 and Linear
Date: Tue, 8 Jan 2013 18:34:53 -0500
Message-ID: <1357688156-25387-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 667a5313ecd7308d79629c0738b0db588b0b0a4e upstream.

commit 27a7b260f71439c40546b43588448faac01adb93
   md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

changed 0.90 metadata handling to truncated size to 4TB as that is
all that 0.90 can record.
However for RAID0 and Linear, 0.90 doesn't need to record the size, so
this truncation is not needed and causes working arrays to become too small.

So avoid the truncation for RAID0 and Linear

This bug was introduced in 3.1 and is suitable for any stable kernels
from then onwards.
As the offending commit was tagged for 'stable', any stable kernel
that it was applied to should also get this patch.  That includes
at least 2.6.32, 2.6.33 and 3.0. (Thanks to Ben Hutchings for
providing that list).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/md.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4788c82..d8e5adc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -985,8 +985,11 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 			ret = 0;
 	}
 	rdev->sectors = rdev->sb_start;
-	/* Limit to 4TB as metadata cannot record more than that */
-	if (rdev->sectors >= (2ULL << 32))
+	/* Limit to 4TB as metadata cannot record more than that.
+	 * (not needed for Linear and RAID0 as metadata doesn't
+	 * record this size)
+	 */
+	if (rdev->sectors >= (2ULL << 32) && sb->level >= 1)
 		rdev->sectors = (2ULL << 32) - 2;
 
 	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level >= 1)
@@ -1266,7 +1269,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	/* Limit to 4TB as metadata cannot record more than that.
 	 * 4TB == 2^32 KB, or 2*2^32 sectors.
 	 */
-	if (num_sectors >= (2ULL << 32))
+	if (num_sectors >= (2ULL << 32) && rdev->mddev->level >= 1)
 		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
-- 
1.7.12.1

