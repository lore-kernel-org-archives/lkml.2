Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab1EaVf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:35:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46571 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248Ab1EaVfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:35:55 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Christoph Hellwig <hch@tuxera.com>, Anton Salikhmetov <alexo@tuxera.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hfsplus: add missing call to bio_put()
Date: Tue, 31 May 2011 16:35:50 -0500
Message-Id: <1306877750-6613-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfsplus leaks bio objects by failing to call bio_put() on the bios
it allocates. Add the missing call to fix the leak.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Cc: <stable@kernel.org> # .38.x, .39.x
---
 fs/hfsplus/wrapper.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index 3031d81..4ac88ff 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -36,6 +36,7 @@ int hfsplus_submit_bio(struct block_device *bdev, sector_t sector,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct bio *bio;
+	int ret = 0;
 
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_sector = sector;
@@ -54,8 +55,10 @@ int hfsplus_submit_bio(struct block_device *bdev, sector_t sector,
 	wait_for_completion(&wait);
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
-		return -EIO;
-	return 0;
+		ret = -EIO;
+
+	bio_put(bio);
+	return ret;
 }
 
 static int hfsplus_read_mdb(void *bufptr, struct hfsplus_wd *wd)
-- 
1.7.4.1

