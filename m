Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1G0Vsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:46879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab1G0Vs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826303"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: mbroz@redhat.com, snitzer@redhat.com, agk@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [27/99] dm table: reject devices without request fns
Message-Id: <20110727214825.C7C382403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Milan Broz <mbroz@redhat.com>

commit f4808ca99a203f20b4475601748e44b25a65bdec upstream.

This patch adds a check that a block device has a request function
defined before it is used.  Otherwise, misconfiguration can cause an oops.

Because we are allowing devices with zero size e.g. an offline multipath
device as in commit 2cd54d9bedb79a97f014e86c0da393416b264eb3
("dm: allow offline devices") there needs to be an additional check
to ensure devices are initialised.  Some block devices, like a loop
device without a backing file, exist but have no request function.

Reproducer is trivial: dm-mirror on unbound loop device
(no backing file on loop devices)

dmsetup create x --table "0 8 mirror core 2 8 sync 2 /dev/loop0 0 /dev/loop1 0"

and mirror resync will immediatelly cause OOps.

BUG: unable to handle kernel NULL pointer dereference at   (null)
 ? generic_make_request+0x2bd/0x590
 ? kmem_cache_alloc+0xad/0x190
 submit_bio+0x53/0xe0
 ? bio_add_page+0x3b/0x50
 dispatch_io+0x1ca/0x210 [dm_mod]
 ? read_callback+0x0/0xd0 [dm_mirror]
 dm_io+0xbb/0x290 [dm_mod]
 do_mirror+0x1e0/0x748 [dm_mirror]

Signed-off-by: Milan Broz <mbroz@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/dm-table.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6.35.y/drivers/md/dm-table.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/dm-table.c
+++ linux-2.6.35.y/drivers/md/dm-table.c
@@ -352,6 +352,7 @@ static void close_dev(struct dm_dev_inte
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
+	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	sector_t dev_size =
@@ -360,6 +361,22 @@ static int device_area_is_invalid(struct
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
+	/*
+	 * Some devices exist without request functions,
+	 * such as loop devices not yet bound to backing files.
+	 * Forbid the use of such devices.
+	 */
+	q = bdev_get_queue(bdev);
+	if (!q || !q->make_request_fn) {
+		DMWARN("%s: %s is not yet initialised: "
+		       "start=%llu, len=%llu, dev_size=%llu",
+		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       (unsigned long long)start,
+		       (unsigned long long)len,
+		       (unsigned long long)dev_size);
+		return 1;
+	}
+
 	if (!dev_size)
 		return 0;
 
