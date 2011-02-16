Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab1BPAgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:36:06 -0500
Received: from kroah.org ([198.145.64.141]:49648 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab1BPAYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:47 2011
Message-Id: <20110216001447.130518784@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Mason <chris.mason@oracle.com>, NeilBrown <neilb@suse.de>
Subject: [220/272] md_make_request: dont touch the bio after calling make_request
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Mason <chris.mason@oracle.com>

commit e91ece5590b3c728624ab57043fc7a05069c604a upstream.

md_make_request was calling bio_sectors() for part_stat_add
after it was calling the make_request function.  This is
bad because the make_request function can free the bio and
because the bi_size field can change around.

The fix here was suggested by Jens Axboe.  It saves the
sector count before the make_request call.  I hit this
with CONFIG_DEBUG_PAGEALLOC turned on while trying to break
his pretty fusionio card.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -287,6 +287,7 @@ static int md_make_request(struct reques
 	mddev_t *mddev = q->queuedata;
 	int rv;
 	int cpu;
+	unsigned int sectors;
 
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
@@ -311,12 +312,16 @@ static int md_make_request(struct reques
 	atomic_inc(&mddev->active_io);
 	rcu_read_unlock();
 
+	/*
+	 * save the sectors now since our bio can
+	 * go away inside make_request
+	 */
+	sectors = bio_sectors(bio);
 	rv = mddev->pers->make_request(mddev, bio);
 
 	cpu = part_stat_lock();
 	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
-		      bio_sectors(bio));
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw], sectors);
 	part_stat_unlock();
 
 	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)


