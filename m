Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2IIXje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:39:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51049 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755488Ab2IIXPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:15:49 -0400
Message-Id: <20120909224155.780107957@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:26 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 36/95] md: Dont truncate size at 4TB for RAID0 and Linear
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index fcd0987..3f6203a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1108,8 +1108,11 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
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
@@ -1400,7 +1403,7 @@ super_90_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 	/* Limit to 4TB as metadata cannot record more than that.
 	 * 4TB == 2^32 KB, or 2*2^32 sectors.
 	 */
-	if (num_sectors >= (2ULL << 32))
+	if (num_sectors >= (2ULL << 32) && rdev->mddev->level >= 1)
 		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);


