Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2JGXan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:30:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754577Ab2JGXXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:08 -0400
Message-Id: <20121007225841.217361103@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 047/108] dm table: clear add_random unless all devices have it set
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit c3c4555edd10dbc0b388a0125b9c50de5e79af05 upstream.

Always clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
have it set. Otherwise devices with predictable characteristics may
contribute entropy.

QUEUE_FLAG_ADD_RANDOM specifies whether or not queue IO timings
contribute to the random pool.

For bio-based targets this flag is always 0 because such devices have no
real queue.

For request-based devices this flag was always set to 1 by default.

Now set it according to the flags on underlying devices. If there is at
least one device which should not contribute, set the flag to zero: If a
device, such as fast SSD storage, is not suitable for supplying entropy,
a request-based queue stacked over it will not be either.

Because the checking logic is exactly same as for the rotational flag,
share the iteration function with device_is_nonrot().

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-table.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index f900690..77b90ae 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1354,17 +1354,25 @@ static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
 	return q && blk_queue_nonrot(q);
 }
 
-static bool dm_table_is_nonrot(struct dm_table *t)
+static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !blk_queue_add_random(q);
+}
+
+static bool dm_table_all_devices_attribute(struct dm_table *t,
+					   iterate_devices_callout_fn func)
 {
 	struct dm_target *ti;
 	unsigned i = 0;
 
-	/* Ensure that all underlying device are non-rotational. */
 	while (i < dm_table_get_num_targets(t)) {
 		ti = dm_table_get_target(t, i++);
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_is_nonrot, NULL))
+		    !ti->type->iterate_devices(ti, func, NULL))
 			return 0;
 	}
 
@@ -1396,7 +1404,8 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_discard_zeroes_data(t))
 		q->limits.discard_zeroes_data = 0;
 
-	if (dm_table_is_nonrot(t))
+	/* Ensure that all underlying devices are non-rotational. */
+	if (dm_table_all_devices_attribute(t, device_is_nonrot))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
@@ -1404,6 +1413,15 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	dm_table_set_integrity(t);
 
 	/*
+	 * Determine whether or not this queue's I/O timings contribute
+	 * to the entropy pool, Only request-based targets use this.
+	 * Clear QUEUE_FLAG_ADD_RANDOM if any underlying device does not
+	 * have it set.
+	 */
+	if (blk_queue_add_random(q) && dm_table_all_devices_attribute(t, device_is_not_random))
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
+
+	/*
 	 * QUEUE_FLAG_STACKABLE must be set after all queue settings are
 	 * visible to other CPUs because, once the flag is set, incoming bios
 	 * are processed by request-based dm, which refers to the queue


