Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0HKXt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:49:58 -0400
Received: from kroah.org ([198.145.64.141]:57521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130Ab0HKXtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:49:55 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:46:25 2010
Message-Id: <20100811234625.266596539@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:45:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [04/11] md/raid10: fix deadlock with unaligned read during resync
In-Reply-To: <20100811234809.GA676@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 51e9ac77035a3dfcb6fc0a88a0d80b6f99b5edb1 upstream.

If the 'bio_split' path in raid10-read is used while
resync/recovery is happening it is possible to deadlock.
Fix this be elevating ->nr_waiting for the duration of both
parts of the split request.

This fixes a bug that has been present since 2.6.22
but has only started manifesting recently for unknown reasons.
It is suitable for and -stable since then.

Reported-by:  Justin Bronder <jsbronder@gentoo.org>
Tested-by:  Justin Bronder <jsbronder@gentoo.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid10.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -818,11 +818,29 @@ static int make_request(struct request_q
 		 */
 		bp = bio_split(bio, bio_split_pool,
 			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+
+		/* Each of these 'make_request' calls will call 'wait_barrier'.
+		 * If the first succeeds but the second blocks due to the resync
+		 * thread raising the barrier, we will deadlock because the
+		 * IO to the underlying device will be queued in generic_make_request
+		 * and will never complete, so will never reduce nr_pending.
+		 * So increment nr_waiting here so no new raise_barriers will
+		 * succeed, and so the second wait_barrier cannot block.
+		 */
+		spin_lock_irq(&conf->resync_lock);
+		conf->nr_waiting++;
+		spin_unlock_irq(&conf->resync_lock);
+
 		if (make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (make_request(q, &bp->bio2))
 			generic_make_request(&bp->bio2);
 
+		spin_lock_irq(&conf->resync_lock);
+		conf->nr_waiting--;
+		wake_up(&conf->wait_barrier);
+		spin_unlock_irq(&conf->resync_lock);
+
 		bio_pair_release(bp);
 		return 0;
 	bad_map:


