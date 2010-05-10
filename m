Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933554Ab0EJXqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:46:25 -0400
Received: from kroah.org ([198.145.64.141]:32874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300Ab0EJWvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:51:39 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:17 2010
Message-Id: <20100510223317.734024705@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:31:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [006/117] md/raid5: fix previous patch.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 6e3b96ed610e5a1838e62ddae9fa0c3463f235fa upstream.

Previous patch changes stripe and chunk_number to sector_t but
mistakenly did not update all of the divisions to use sector_dev().

This patch changes all the those divisions (actually the '%' operator)
to sector_div.

Signed-off-by: NeilBrown <neilb@suse.de>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1649,7 +1649,7 @@ static sector_t raid5_compute_sector(rai
 				     int previous, int *dd_idx,
 				     struct stripe_head *sh)
 {
-	sector_t stripe;
+	sector_t stripe, stripe2;
 	sector_t chunk_number;
 	unsigned int chunk_offset;
 	int pd_idx, qd_idx;
@@ -1676,7 +1676,7 @@ static sector_t raid5_compute_sector(rai
 	 */
 	stripe = chunk_number;
 	*dd_idx = sector_div(stripe, data_disks);
-
+	stripe2 = stripe;
 	/*
 	 * Select the parity disk based on the user selected algorithm.
 	 */
@@ -1688,21 +1688,21 @@ static sector_t raid5_compute_sector(rai
 	case 5:
 		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
-			pd_idx = data_disks - stripe % raid_disks;
+			pd_idx = data_disks - sector_div(stripe2, raid_disks);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_div(stripe2, raid_disks);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
-			pd_idx = data_disks - stripe % raid_disks;
+			pd_idx = data_disks - sector_div(stripe2, raid_disks);
 			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_div(stripe2, raid_disks);
 			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
 			break;
 		case ALGORITHM_PARITY_0:
@@ -1722,7 +1722,7 @@ static sector_t raid5_compute_sector(rai
 
 		switch (algorithm) {
 		case ALGORITHM_LEFT_ASYMMETRIC:
-			pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1731,7 +1731,7 @@ static sector_t raid5_compute_sector(rai
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_RIGHT_ASYMMETRIC:
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_div(stripe2, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1740,12 +1740,12 @@ static sector_t raid5_compute_sector(rai
 				(*dd_idx) += 2; /* D D P Q D */
 			break;
 		case ALGORITHM_LEFT_SYMMETRIC:
-			pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
 			qd_idx = (pd_idx + 1) % raid_disks;
 			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
 			break;
 		case ALGORITHM_RIGHT_SYMMETRIC:
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_div(stripe2, raid_disks);
 			qd_idx = (pd_idx + 1) % raid_disks;
 			*dd_idx = (pd_idx + 2 + *dd_idx) % raid_disks;
 			break;
@@ -1764,7 +1764,7 @@ static sector_t raid5_compute_sector(rai
 			/* Exactly the same as RIGHT_ASYMMETRIC, but or
 			 * of blocks for computing Q is different.
 			 */
-			pd_idx = stripe % raid_disks;
+			pd_idx = sector_div(stripe2, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1779,7 +1779,8 @@ static sector_t raid5_compute_sector(rai
 			 * D D D P Q  rather than
 			 * Q D D D P
 			 */
-			pd_idx = raid_disks - 1 - ((stripe + 1) % raid_disks);
+			stripe2 += 1;
+			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
 			qd_idx = pd_idx + 1;
 			if (pd_idx == raid_disks-1) {
 				(*dd_idx)++;	/* Q D D D P */
@@ -1791,7 +1792,7 @@ static sector_t raid5_compute_sector(rai
 
 		case ALGORITHM_ROTATING_N_CONTINUE:
 			/* Same as left_symmetric but Q is before P */
-			pd_idx = raid_disks - 1 - (stripe % raid_disks);
+			pd_idx = raid_disks - 1 - sector_div(stripe2, raid_disks);
 			qd_idx = (pd_idx + raid_disks - 1) % raid_disks;
 			*dd_idx = (pd_idx + 1 + *dd_idx) % raid_disks;
 			ddf_layout = 1;
@@ -1799,27 +1800,27 @@ static sector_t raid5_compute_sector(rai
 
 		case ALGORITHM_LEFT_ASYMMETRIC_6:
 			/* RAID5 left_asymmetric, with Q on last device */
-			pd_idx = data_disks - stripe % (raid_disks-1);
+			pd_idx = data_disks - sector_div(stripe2, raid_disks-1);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			qd_idx = raid_disks - 1;
 			break;
 
 		case ALGORITHM_RIGHT_ASYMMETRIC_6:
-			pd_idx = stripe % (raid_disks-1);
+			pd_idx = sector_div(stripe2, raid_disks-1);
 			if (*dd_idx >= pd_idx)
 				(*dd_idx)++;
 			qd_idx = raid_disks - 1;
 			break;
 
 		case ALGORITHM_LEFT_SYMMETRIC_6:
-			pd_idx = data_disks - stripe % (raid_disks-1);
+			pd_idx = data_disks - sector_div(stripe2, raid_disks-1);
 			*dd_idx = (pd_idx + 1 + *dd_idx) % (raid_disks-1);
 			qd_idx = raid_disks - 1;
 			break;
 
 		case ALGORITHM_RIGHT_SYMMETRIC_6:
-			pd_idx = stripe % (raid_disks-1);
+			pd_idx = sector_div(stripe2, raid_disks-1);
 			*dd_idx = (pd_idx + 1 + *dd_idx) % (raid_disks-1);
 			qd_idx = raid_disks - 1;
 			break;


