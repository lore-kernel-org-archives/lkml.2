Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab1ANEhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 23:37:35 -0500
Received: from amavis-outgoing1.knology.net ([24.214.64.230]:45623 "EHLO
	amavis-outgoing1.knology.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab1ANEh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 23:37:29 -0500
X-Greylist: delayed 1900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 23:37:28 EST
Subject: fs/direct-io.c: don't try to allocate more than BIO_MAX_PAGES in a
 bio
From: David Dillow <dillowda@ornl.gov>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 23:05:46 -0500
Message-ID: <1294977946.21790.20.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using devices that support max_segments > BIO_MAX_PAGES (256),
direct IO tries to allocate a bio with more pages than allowed, which
leads to an oops in dio_bio_alloc(). Clamp that request to the supported
maximum.

Signed-off-by: David Dillow <dillowda@ornl.gov>
--
dio_bio_alloc() doesn't check the result of bio_alloc(), so it
dereferences a NULL pointer. bio_alloc(GFP_KERNEL, ...) doesn't fail
unless it gets called for an invalid number of pages, so it seems a bit
like overkill to check for failure in dio_bio_alloc(), though it would
have saved me some time tracking this down.


diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..9eb0553 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -583,6 +583,7 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
 		goto out;
 	sector = start_sector << (dio->blkbits - 9);
 	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
 	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
 	dio->boundary = 0;


