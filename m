Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638Ab2I1Uly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:41:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50951 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759595Ab2I1UlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:41:15 -0400
X-Sasl-enc: 8BdI7oK0yE8rRi8IE4Lp7Mkyh16cXFf8scsxD3bAk40P 1348864875
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neil Brown <neilb@suse.de>
Subject: [ 043/127] md: Dont truncate size at 4TB for RAID0 and Linear
Date: Fri, 28 Sep 2012 13:33:36 -0700
Message-Id: <20120928203050.896493268@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1096,8 +1096,11 @@ static int super_90_load(mdk_rdev_t *rde
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
@@ -1379,7 +1382,7 @@ super_90_rdev_size_change(mdk_rdev_t *rd
 	/* Limit to 4TB as metadata cannot record more than that.
 	 * 4TB == 2^32 KB, or 2*2^32 sectors.
 	 */
-	if (num_sectors >= (2ULL << 32))
+	if (num_sectors >= (2ULL << 32) && rdev->mddev->level >= 1)
 		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);


