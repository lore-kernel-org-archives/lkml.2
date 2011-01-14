Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1ANRAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:00:18 -0500
Received: from emroute3.ornl.gov ([160.91.4.110]:58892 "EHLO emroute3.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab1ANRAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:00:12 -0500
X-Greylist: delayed 833 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 12:00:12 EST
Date: Fri, 14 Jan 2011 11:46:18 -0500
From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH v2 alt 1] fs/direct-io.c: don't try to allocate more than
 BIO_MAX_PAGES in a bio
In-reply-to: <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Message-id: <1295023578.24487.15.camel@lap75545.ornl.gov>
Organization: Oak Ridge National Laboratory
MIME-version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
References: <1294977946.21790.20.camel@obelisk.thedillows.org>
 <x498vynbl4e.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using devices that support max_segments > BIO_MAX_PAGES (256),
direct IO tries to allocate a bio with more pages than allowed, which
leads to an oops in dio_bio_alloc(). Clamp the request to the supported
maximum, and return an error to catch future cases.
    
Signed-off-by: David Dillow <dillowda@ornl.gov>
--
On Fri, 2011-01-14 at 09:44 -0500, Jeff Moyer wrote:
> David Dillow <dillowda@ornl.gov> writes:
> > dio_bio_alloc() doesn't check the result of bio_alloc(), so it
> > dereferences a NULL pointer. bio_alloc(GFP_KERNEL, ...) doesn't fail
> > unless it gets called for an invalid number of pages, so it seems a bit
> > like overkill to check for failure in dio_bio_alloc(), though it would
> > have saved me some time tracking this down.
> 
> We should always be checking return values.  Mind respinning the patch
> to include that?

Here's the first alternate, that just checks the return value. I think I
prefer the other one, though.


diff --git a/fs/direct-io.c b/fs/direct-io.c
index 85882f6..9fdbf99 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -332,6 +332,8 @@ dio_bio_alloc(struct dio *dio, struct block_device *bdev,
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
+	if (!bio)
+		return -ENOMEM;
 
 	bio->bi_bdev = bdev;
 	bio->bi_sector = first_sector;
@@ -583,6 +585,7 @@ static int dio_new_bio(struct dio *dio, sector_t start_sector)
 		goto out;
 	sector = start_sector << (dio->blkbits - 9);
 	nr_pages = min(dio->pages_in_io, bio_get_nr_vecs(dio->map_bh.b_bdev));
+	nr_pages = min(nr_pages, BIO_MAX_PAGES);
 	BUG_ON(nr_pages <= 0);
 	ret = dio_bio_alloc(dio, dio->map_bh.b_bdev, sector, nr_pages);
 	dio->boundary = 0;




