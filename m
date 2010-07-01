Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab0GASNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:13:42 -0400
Received: from kroah.org ([198.145.64.141]:60036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914Ab0GASKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:48 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:28:57 2010
Message-Id: <20100701172857.134213426@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:26:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [08/23] md: Fix read balancing in RAID1 and RAID10 on drives > 2TB
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit af3a2cd6b8a479345786e7fe5e199ad2f6240e56 upstream.

read_balance uses a "unsigned long" for a sector number which
will get truncated beyond 2TB.
This will cause read-balancing to be non-optimal, and can cause
data to be read from the 'wrong' branch during a resync.  This has a
very small chance of returning wrong data.

Reported-by: Jordan Russell <jr-list-2010@quo.to>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid1.c  |    4 ++--
 drivers/md/raid10.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -413,7 +413,7 @@ static void raid1_end_write_request(stru
  */
 static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
-	const unsigned long this_sector = r1_bio->sector;
+	const sector_t this_sector = r1_bio->sector;
 	int new_disk = conf->last_used, disk = new_disk;
 	int wonly_disk = -1;
 	const int sectors = r1_bio->sectors;
@@ -429,7 +429,7 @@ static int read_balance(conf_t *conf, r1
  retry:
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
-		/* Choose the first operation device, for consistancy */
+		/* Choose the first operational device, for consistancy */
 		new_disk = 0;
 
 		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -490,7 +490,7 @@ static int raid10_mergeable_bvec(struct
  */
 static int read_balance(conf_t *conf, r10bio_t *r10_bio)
 {
-	const unsigned long this_sector = r10_bio->sector;
+	const sector_t this_sector = r10_bio->sector;
 	int disk, slot, nslot;
 	const int sectors = r10_bio->sectors;
 	sector_t new_distance, current_distance;


