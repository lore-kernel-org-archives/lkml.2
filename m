Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0EJW5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:57:37 -0400
Received: from kroah.org ([198.145.64.141]:51566 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab0EJW5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:20 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:34 2010
Message-Id: <20100510223534.701279550@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [03/98] md/raid5: allow for more than 2^31 chunks.
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 35f2a591192d0a5d9f7fc696869c76f0b8e49c3d upstream.

With many large drives and small chunk sizes it is possible
to create a RAID5 with more than 2^31 chunks.  Make sure this
works.

Reported-by: Brett King <king.br@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1649,8 +1649,8 @@ static sector_t raid5_compute_sector(rai
 				     int previous, int *dd_idx,
 				     struct stripe_head *sh)
 {
-	long stripe;
-	unsigned long chunk_number;
+	sector_t stripe;
+	sector_t chunk_number;
 	unsigned int chunk_offset;
 	int pd_idx, qd_idx;
 	int ddf_layout = 0;
@@ -1670,17 +1670,12 @@ static sector_t raid5_compute_sector(rai
 	 */
 	chunk_offset = sector_div(r_sector, sectors_per_chunk);
 	chunk_number = r_sector;
-	BUG_ON(r_sector != chunk_number);
 
 	/*
 	 * Compute the stripe number
 	 */
-	stripe = chunk_number / data_disks;
-
-	/*
-	 * Compute the data disk and parity disk indexes inside the stripe
-	 */
-	*dd_idx = chunk_number % data_disks;
+	stripe = chunk_number;
+	*dd_idx = sector_div(stripe, data_disks);
 
 	/*
 	 * Select the parity disk based on the user selected algorithm.
@@ -1869,14 +1864,14 @@ static sector_t compute_blocknr(struct s
 				 : conf->algorithm;
 	sector_t stripe;
 	int chunk_offset;
-	int chunk_number, dummy1, dd_idx = i;
+	sector_t chunk_number;
+	int dummy1, dd_idx = i;
 	sector_t r_sector;
 	struct stripe_head sh2;
 
 
 	chunk_offset = sector_div(new_sector, sectors_per_chunk);
 	stripe = new_sector;
-	BUG_ON(new_sector != stripe);
 
 	if (i == sh->pd_idx)
 		return 0;
@@ -1969,7 +1964,7 @@ static sector_t compute_blocknr(struct s
 	}
 
 	chunk_number = stripe * data_disks + i;
-	r_sector = (sector_t)chunk_number * sectors_per_chunk + chunk_offset;
+	r_sector = chunk_number * sectors_per_chunk + chunk_offset;
 
 	check = raid5_compute_sector(conf, r_sector,
 				     previous, &dummy1, &sh2);


