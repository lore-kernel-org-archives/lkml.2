Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031366Ab2CITu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:50:57 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48521 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031349Ab2CITux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:53 -0500
Message-Id: <20120309190209.226686745@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 86/95] dm io: fix discard support
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit 0c535e0d6f463365c29623350dbd91642363c39b upstream.

This patch fixes a crash by recognising discards in dm_io.

Currently dm_mirror can send REQ_DISCARD bios if running over a
discard-enabled device and without support in dm_io the system
crashes badly.

BUG: unable to handle kernel paging request at 00800000
IP:  __bio_add_page.part.17+0xf5/0x1e0
...
 bio_add_page+0x56/0x70
 dispatch_io+0x1cf/0x240 [dm_mod]
 ? km_get_page+0x50/0x50 [dm_mod]
 ? vm_next_page+0x20/0x20 [dm_mod]
 ? mirror_flush+0x130/0x130 [dm_mirror]
 dm_io+0xdc/0x2b0 [dm_mod]
...

Introduced in 2.6.38-rc1 by commit 5fc2ffeabb9ee0fc0e71ff16b49f34f0ed3d05b4
(dm raid1: support discard).

Signed-off-by: Milan Broz <mbroz@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-io.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -296,6 +296,8 @@ static void do_region(int rw, unsigned r
 	unsigned offset;
 	unsigned num_bvecs;
 	sector_t remaining = where->count;
+	struct request_queue *q = bdev_get_queue(where->bdev);
+	sector_t discard_sectors;
 
 	/*
 	 * where->count may be zero if rw holds a flush and we need to
@@ -305,9 +307,12 @@ static void do_region(int rw, unsigned r
 		/*
 		 * Allocate a suitably sized-bio.
 		 */
-		num_bvecs = dm_sector_div_up(remaining,
-					     (PAGE_SIZE >> SECTOR_SHIFT));
-		num_bvecs = min_t(int, bio_get_nr_vecs(where->bdev), num_bvecs);
+		if (rw & REQ_DISCARD)
+			num_bvecs = 1;
+		else
+			num_bvecs = min_t(int, bio_get_nr_vecs(where->bdev),
+					  dm_sector_div_up(remaining, (PAGE_SIZE >> SECTOR_SHIFT)));
+
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, io->client->bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
@@ -315,10 +320,14 @@ static void do_region(int rw, unsigned r
 		bio->bi_destructor = dm_bio_destructor;
 		store_io_and_region_in_bio(bio, io, region);
 
-		/*
-		 * Try and add as many pages as possible.
-		 */
-		while (remaining) {
+		if (rw & REQ_DISCARD) {
+			discard_sectors = min_t(sector_t, q->limits.max_discard_sectors, remaining);
+			bio->bi_size = discard_sectors << SECTOR_SHIFT;
+			remaining -= discard_sectors;
+		} else while (remaining) {
+			/*
+			 * Try and add as many pages as possible.
+			 */
 			dp->get_page(dp, &page, &len, &offset);
 			len = min(len, to_bytes(remaining));
 			if (!bio_add_page(bio, page, len, offset))


