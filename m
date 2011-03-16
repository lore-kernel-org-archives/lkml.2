Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab1CPUWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CPUWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:22:04 -0400
Date: Wed, 16 Mar 2011 16:21:24 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mustafa Mesanovic <mume@linux.vnet.ibm.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Cc: cotte@de.ibm.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        ehrhardt@linux.vnet.ibm.com, dm-devel@redhat.com,
        akpm@linux-foundation.org
Subject: [PATCH v4] dm stripe: implement merge method
Message-ID: <20110316202124.GA2132@redhat.com>
References: <201012271219.56476.mume@linux.vnet.ibm.com>
 <20101227225459.5a5150ab@notabene.brown>
 <201012271323.13406.mume@linux.vnet.ibm.com>
 <4D74AEF9.7050108@linux.vnet.ibm.com>
 <20110308022158.GA663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110308022158.GA663@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>

When the stripe target's underlying devices provide a merge_bvec_fn
(like all DM devices do via dm_merge_bvec) it is important to call down
to them when building a biovec that doesn't span a stripe boundary.

Without the merge method, a striped DM device stacked on DM devices
would cause bios with a single page to be submitted.  The small bios
that were built resulted in unnecessary overhead that hurt performance.

This change really helps filesystems (e.g. XFS and now ext4) which take
care to assemble larger bios.  By implementing stripe_merge(), DM and the
stripe target no longer undermine the filesystem's work by only allowing
a single page per bio.  Buffered IO sees the biggest improvement
(particularly uncached reads, buffered writes to a lesser degree).  This
is especially so for more capable "enterprise" storage LUNs.

The performance improvement has been measured to be ~12-35% -- when a
reasonable chunk_size is used (e.g. 64K) in conjunction with a stripe
count that is a power of 2.

In contrast, the performance penalty is ~5-7% for the pathological worst
case stripe configuration (small chunk_size with a stripe count that is
not a power of 2).  The reason for this is that stripe_map_sector() is
now called once for every call to dm_merge_bvec().  stripe_map_sector()
will use slower division if stripe count isn't a power of 2.

Signed-off-by: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-stripe.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index dddfa14..3d80cf0 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -396,9 +396,29 @@ static void stripe_io_hints(struct dm_target *ti,
 	blk_limits_io_opt(limits, chunk_size * sc->stripes);
 }
 
+static int stripe_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			struct bio_vec *biovec, int max_size)
+{
+	struct stripe_c *sc = ti->private;
+	sector_t bvm_sector = bvm->bi_sector;
+	uint32_t stripe;
+	struct request_queue *q;
+
+	stripe_map_sector(sc, bvm_sector, &stripe, &bvm_sector);
+
+	q = bdev_get_queue(sc->stripe[stripe].dev->bdev);
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = sc->stripe[stripe].dev->bdev;
+	bvm->bi_sector = sc->stripe[stripe].physical_start + bvm_sector;
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
 static struct target_type stripe_target = {
 	.name   = "striped",
-	.version = {1, 3, 1},
+	.version = {1, 4, 0},
 	.module = THIS_MODULE,
 	.ctr    = stripe_ctr,
 	.dtr    = stripe_dtr,
@@ -407,6 +427,7 @@ static struct target_type stripe_target = {
 	.status = stripe_status,
 	.iterate_devices = stripe_iterate_devices,
 	.io_hints = stripe_io_hints,
+	.merge  = stripe_merge,
 };
 
 int __init dm_stripe_init(void)
