Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab2I1S60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965004Ab2I1S6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Neil Brown <neilb@suse.de>
Subject: [ 090/262] md: Dont truncate size at 4TB for RAID0 and Linear
Date: Fri, 28 Sep 2012 11:50:19 -0700
Message-Id: <20120928183008.741715364@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1157,8 +1157,11 @@ static int super_90_load(struct md_rdev
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
@@ -1449,7 +1452,7 @@ super_90_rdev_size_change(struct md_rdev
 	/* Limit to 4TB as metadata cannot record more than that.
 	 * 4TB == 2^32 KB, or 2*2^32 sectors.
 	 */
-	if (num_sectors >= (2ULL << 32))
+	if (num_sectors >= (2ULL << 32) && rdev->mddev->level >= 1)
 		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);


