Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2GIOxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:53:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38098 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab2GIOh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:57 -0400
Message-Id: <20120709143118.888711072@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:31 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, majianpeng <majianpeng@gmail.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 15/48] md/raid5: Do not add data_offset before call to is_badblock
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 6c0544e255dd6582a9899572e120fb55d9f672a4 upstream.

In chunk_aligned_read() we are adding data_offset before calling
is_badblock.  But is_badblock also adds data_offset, so that is bad.

So move the addition of data_offset to after the call to
is_badblock.

This bug was introduced by commit 31c176ecdf3563140e639
     md/raid5: avoid reading from known bad blocks.
which first appeared in 3.0.  So that patch is suitable for any
-stable kernel from 3.0.y onwards.  However it will need minor
revision for most of those (as the comment didn't appear until
recently).

Signed-off-by: majianpeng <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
[bwh: Backported to 3.2: ignored missing comment]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid5.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3621,7 +3621,6 @@ static int chunk_aligned_read(struct mdd
 		raid_bio->bi_next = (void*)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
-		align_bi->bi_sector += rdev->data_offset;
 
 		if (!bio_fits_rdev(align_bi) ||
 		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
@@ -3632,6 +3631,9 @@ static int chunk_aligned_read(struct mdd
 			return 0;
 		}
 
+		/* No reshape active, so we can trust rdev->data_offset */
+		align_bi->bi_sector += rdev->data_offset;
+
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,


