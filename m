Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2BVBs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:48:26 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45648 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2BVBsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:48:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.129.105 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 36/36] block: make blk-throttle preserve the issuing task on delayed bios
Date: Tue, 21 Feb 2012 17:47:03 -0800
Message-Id: <1329875223-5102-37-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1329875223-5102-1-git-send-email-tj@kernel.org>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make blk-throttle call bio_associate_current() on bios being delayed
such that they get issued to block layer with the original io_context.
This allows stacking blk-throttle and cfq-iosched propio policies.
bios will always be issued with the correct ioc and blkcg whether it
gets delayed by blk-throttle or not.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 08b7ab2..4ba1418 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -894,6 +894,9 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 		goto out;
 	}
 
+	/* bio_associate_current() needs ioc, try creating */
+	create_io_context(GFP_ATOMIC, q->node);
+
 	/*
 	 * A throtl_grp pointer retrieved under rcu can be used to access
 	 * basic fields like stats and io rates. If a group has no rules,
@@ -958,6 +961,7 @@ queue_bio:
 			tg->io_disp[rw], tg->iops[rw],
 			tg->nr_queued[READ], tg->nr_queued[WRITE]);
 
+	bio_associate_current(bio);
 	throtl_add_bio_tg(q->td, tg, bio);
 	throttled = true;
 
-- 
1.7.7.3

