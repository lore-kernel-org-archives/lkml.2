Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1FMOs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:48:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35607 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab1FMOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PfA9S5PtOp//4Aedj7y8Vmk6PvjtpUteEuIAmbQpaYhzcXf0fDvD05tpS5iS6kq6Mk
         909/UHo8D/9cfShMed74K4Ab4OppIyYAxKrXV3tilnk2+GCBTx+psfWMJfNEzM3LTYQN
         EbapWPBPrGhncMepBVCl3nHygTEe+a/DTiCzY=
From: Namhyung Kim <namhyung@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] md/raid5: fix FUA request handling in ops_run_io()
Date: Mon, 13 Jun 2011 23:48:23 +0900
Message-Id: <1307976504-10215-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
References: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e9c7469bb4f5 ("md: implment REQ_FLUSH/FUA support")
introduced R5_WantFUA flag and set rw to WRITE_FUA in that case.
However remaining code still checks whether rw is exactly same
as WRITE or not, so FUAed-write ends up with being treated as
READ. Fix it.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fa6ac70dc72f..026452bbb030 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -514,7 +514,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw == WRITE)
+		if (rw & WRITE)
 			bi->bi_end_io = raid5_end_write_request;
 		else
 			bi->bi_end_io = raid5_end_read_request;
@@ -548,13 +548,13 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_size = STRIPE_SIZE;
 			bi->bi_next = NULL;
-			if (rw == WRITE &&
+			if (rw & WRITE &&
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
1.7.5.2

