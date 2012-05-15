Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965453Ab2EOCSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:18:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:49214 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894Ab2EOCQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:30 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 037/179] dm table: reject devices without request fns
Date: Mon, 14 May 2012 22:12:13 -0400
Message-ID: <1337048075-6132-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/dm-table.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4a83321..ebb3864 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -352,6 +352,7 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
+	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	sector_t dev_size =
@@ -360,6 +361,22 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
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
 
-- 
1.7.9.6

