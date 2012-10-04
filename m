Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab2JDVur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:50:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56720 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055Ab2JDVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:23:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 03/52] dm table: clear add_random unless all devices have it set
Date: Thu,  4 Oct 2012 14:20:54 -0700
Message-Id: <20121004210635.774132814@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-table.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1351,17 +1351,25 @@ static int device_is_nonrot(struct dm_ta
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
 
@@ -1393,7 +1401,8 @@ void dm_table_set_restrictions(struct dm
 	if (!dm_table_discard_zeroes_data(t))
 		q->limits.discard_zeroes_data = 0;
 
-	if (dm_table_is_nonrot(t))
+	/* Ensure that all underlying devices are non-rotational. */
+	if (dm_table_all_devices_attribute(t, device_is_nonrot))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
@@ -1401,6 +1410,15 @@ void dm_table_set_restrictions(struct dm
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


