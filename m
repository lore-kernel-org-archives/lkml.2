Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965958Ab2EODDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 23:03:18 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53204 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936Ab2EOCQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:16:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 066/179] md/raid5: fix FUA request handling in ops_run_io()
Date: Mon, 14 May 2012 22:12:42 -0400
Message-ID: <1337048075-6132-67-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/md/raid5.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index de7984d..dc3e4fc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -447,7 +447,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw == WRITE)
+		if (rw & WRITE)
 			bi->bi_end_io = raid5_end_write_request;
 		else
 			bi->bi_end_io = raid5_end_read_request;
@@ -481,13 +481,13 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
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
-- 
1.7.9.6

