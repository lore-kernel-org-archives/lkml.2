Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1FPHD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:03:27 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49012 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab1FPHBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:53 -0400
X-Sasl-enc: FGsBlKVoe6pvp9UiLjNztBo+3DheQ2AL5gf+mrjrUn2/ 1308207712
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:37 2011
Message-Id: <20110616000237.398186525@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        NeilBrown <neilb@suse.de>
Subject: [86/89] md/raid5: fix FUA request handling in ops_run_io()
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Namhyung Kim <namhyung@gmail.com>

commit b062962edb086011e94ec4d9eb3f6a6d814f2a8f upstream.

Commit e9c7469bb4f5 ("md: implment REQ_FLUSH/FUA support")
introduced R5_WantFUA flag and set rw to WRITE_FUA in that case.
However remaining code still checks whether rw is exactly same
as WRITE or not, so FUAed-write ends up with being treated as
READ. Fix it.

This bug has been present since 2.6.37 and the fix is suitable for any
-stable kernel since then.  It is not clear why this has not caused
more problems.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/raid5.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -514,7 +514,7 @@ static void ops_run_io(struct stripe_hea
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw == WRITE)
+		if (rw & WRITE)
 			bi->bi_end_io = raid5_end_write_request;
 		else
 			bi->bi_end_io = raid5_end_read_request;
@@ -548,13 +548,13 @@ static void ops_run_io(struct stripe_hea
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
-			if (rw == WRITE &&
+			if ((rw & WRITE) &&
 			    test_bit(R5_ReWrite, &sh->dev[i].flags))
 				atomic_add(STRIPE_SECTORS,
 					&rdev->corrected_errors);
 			generic_make_request(bi);
 		} else {
-			if (rw == WRITE)
+			if (rw & WRITE)
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %ld on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);


