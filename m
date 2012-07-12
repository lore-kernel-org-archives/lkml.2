Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162449Ab2GLWtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:49:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61447 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162352Ab2GLWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:45:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 178/187] md/raid5: Do not add data_offset before call to is_badblock
Date: Thu, 12 Jul 2012 15:35:34 -0700
Message-Id: <20120712191539.792176223@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid5.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3850,7 +3850,6 @@ static int chunk_aligned_read(struct mdd
 		raid_bio->bi_next = (void*)rdev;
 		align_bi->bi_bdev =  rdev->bdev;
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
-		align_bi->bi_sector += rdev->data_offset;
 
 		if (!bio_fits_rdev(align_bi) ||
 		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
@@ -3861,6 +3860,9 @@ static int chunk_aligned_read(struct mdd
 			return 0;
 		}
 
+		/* No reshape active, so we can trust rdev->data_offset */
+		align_bi->bi_sector += rdev->data_offset;
+
 		spin_lock_irq(&conf->device_lock);
 		wait_event_lock_irq(conf->wait_for_stripe,
 				    conf->quiesce == 0,


