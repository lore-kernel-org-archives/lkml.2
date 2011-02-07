Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1BGTWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:22:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58321 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1BGTWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:22:11 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: linux-raid <linux-raid@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc: axboe@kernel.dk, neilb@suse.de
Subject: [PATCH] md_make_request: don't touch the bio after calling make_request
Date: Mon, 07 Feb 2011 14:21:48 -0500
Message-Id: <1297106377-sup-9409@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D504654.0155:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

md_make_request was calling bio_sectors() for part_stat_add
after it was calling the make_request function.  This is
bad because the make_request function can free the bio and
because the bi_size field can change around.

The fix here was suggested by Jens Axboe.  It saves the
sector count before the make_request call.  I hit this
with CONFIG_DEBUG_PAGEALLOC turned on while trying to break
his pretty fusionio card.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
---
 drivers/md/md.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b76cfc8..a7d3c3c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -287,6 +287,7 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
 	mddev_t *mddev = q->queuedata;
 	int rv;
 	int cpu;
+	unsigned int sectors;
 
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
@@ -311,12 +312,16 @@ static int md_make_request(struct request_queue *q, struct bio *bio)
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
-- 
1.7.1.1
