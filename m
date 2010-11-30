Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0K3Q4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:56:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0K3Qz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:55:59 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com, jmoyer@redhat.com, oleg@redhat.com, jmarchan@redhat.com
Subject: [PATCH 2/2] blk-throttle: Correct the placement of smp_rmb()
Date: Tue, 30 Nov 2010 11:55:57 -0500
Message-Id: <1291136157-2732-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
References: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o I was discussing what are the variable being updated without spin lock and
  why do we need barriers and Oleg pointed out that location of smp_rmb()
  should be between read of td->limits_changed and tg->limits_changed. This
  patch fixes it.

o Following is one possible sequence of events. Say cpu0 is executing
  throtl_update_blkio_group_read_bps() and cpu1 is executing
  throtl_process_limit_change().

 cpu0                                                cpu1

 tg->limits_changed = true;
 smp_mb__before_atomic_inc();
 atomic_inc(&td->limits_changed);

                                     if (!atomic_read(&td->limits_changed))
                                             return;

                                     if (tg->limits_changed)
                                             do_something;

 If cpu0 has updated tg->limits_changed and td->limits_changed, we want to
 make sure that if update to td->limits_changed is visible on cpu1, then
 update to tg->limits_changed should also be visible.

 Oleg pointed out to ensure that we need to insert an smp_rmb() between
 td->limits_changed read and tg->limits_changed read.

o I had erroneously put smp_rmb() before atomic_read(&td->limits_changed).
  This patch fixes it.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 2d134b7..381b09b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -725,26 +725,21 @@ static void throtl_process_limit_change(struct throtl_data *td)
 	struct throtl_grp *tg;
 	struct hlist_node *pos, *n;
 
-	/*
-	 * Make sure atomic_inc() effects from
-	 * throtl_update_blkio_group_read_bps(), group of functions are
-	 * visible.
-	 * Is this required or smp_mb__after_atomic_inc() was suffcient
-	 * after the atomic_inc().
-	 */
-	smp_rmb();
 	if (!atomic_read(&td->limits_changed))
 		return;
 
 	throtl_log(td, "limit changed =%d", atomic_read(&td->limits_changed));
 
-	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
-		/*
-		 * Do I need an smp_rmb() here to make sure tg->limits_changed
-		 * update is visible. I am relying on smp_rmb() at the
-		 * beginning of function and not putting a new one here.
-		 */
+	/*
+	 * Make sure updates from throtl_update_blkio_group_read_bps() group
+	 * of functions to tg->limits_changed are visible. We do not
+	 * want update td->limits_changed to be visible but update to
+	 * tg->limits_changed not being visible yet on this cpu. Hence
+	 * the read barrier.
+	 */
+	smp_rmb();
 
+	hlist_for_each_entry_safe(tg, pos, n, &td->tg_list, tg_node) {
 		if (throtl_tg_on_rr(tg) && tg->limits_changed) {
 			throtl_log_tg(td, tg, "limit change rbps=%llu wbps=%llu"
 				" riops=%u wiops=%u", tg->bps[READ],
-- 
1.7.2.3

