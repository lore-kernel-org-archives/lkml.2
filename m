Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab2EUVVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759133Ab2EUVSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:45 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] dlm: fix waiter recovery
Date: Mon, 21 May 2012 16:18:34 -0500
Message-Id: <1337635120-19969-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An outstanding remote operation (an lkb on the "waiter"
list) could sometimes miss being resent during recovery.
The decision was based on the lkb_nodeid field, which
could have changed during an earlier aborted recovery,
so it no longer represents the actual remote destination.
The lkb_wait_nodeid is always the actual remote node,
so it is the best value to use.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |   43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 4c58d4a..3d35c59 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4187,15 +4187,19 @@ static void recover_convert_waiter(struct dlm_ls *ls, struct dlm_lkb *lkb,
 /* A waiting lkb needs recovery if the master node has failed, or
    the master node is changing (only when no directory is used) */
 
-static int waiter_needs_recovery(struct dlm_ls *ls, struct dlm_lkb *lkb)
+static int waiter_needs_recovery(struct dlm_ls *ls, struct dlm_lkb *lkb,
+				 int dir_nodeid)
 {
-	if (dlm_is_removed(ls, lkb->lkb_nodeid))
+	if (dlm_is_removed(ls, lkb->lkb_wait_nodeid))
 		return 1;
 
 	if (!dlm_no_directory(ls))
 		return 0;
 
-	if (dlm_dir_nodeid(lkb->lkb_resource) != lkb->lkb_nodeid)
+	if (dir_nodeid == dlm_our_nodeid())
+		return 1;
+
+	if (dir_nodeid != lkb->lkb_wait_nodeid)
 		return 1;
 
 	return 0;
@@ -4212,6 +4216,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 	struct dlm_lkb *lkb, *safe;
 	struct dlm_message *ms_stub;
 	int wait_type, stub_unlock_result, stub_cancel_result;
+	int dir_nodeid;
 
 	ms_stub = kmalloc(sizeof(struct dlm_message), GFP_KERNEL);
 	if (!ms_stub) {
@@ -4223,13 +4228,21 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 
 	list_for_each_entry_safe(lkb, safe, &ls->ls_waiters, lkb_wait_reply) {
 
+		dir_nodeid = dlm_dir_nodeid(lkb->lkb_resource);
+
 		/* exclude debug messages about unlocks because there can be so
 		   many and they aren't very interesting */
 
 		if (lkb->lkb_wait_type != DLM_MSG_UNLOCK) {
-			log_debug(ls, "recover_waiter %x nodeid %d "
-				  "msg %d to %d", lkb->lkb_id, lkb->lkb_nodeid,
-				  lkb->lkb_wait_type, lkb->lkb_wait_nodeid);
+			log_debug(ls, "waiter %x remote %x msg %d r_nodeid %d "
+				  "lkb_nodeid %d wait_nodeid %d dir_nodeid %d",
+				  lkb->lkb_id,
+				  lkb->lkb_remid,
+				  lkb->lkb_wait_type,
+				  lkb->lkb_resource->res_nodeid,
+				  lkb->lkb_nodeid,
+				  lkb->lkb_wait_nodeid,
+				  dir_nodeid);
 		}
 
 		/* all outstanding lookups, regardless of destination  will be
@@ -4240,7 +4253,7 @@ void dlm_recover_waiters_pre(struct dlm_ls *ls)
 			continue;
 		}
 
-		if (!waiter_needs_recovery(ls, lkb))
+		if (!waiter_needs_recovery(ls, lkb, dir_nodeid))
 			continue;
 
 		wait_type = lkb->lkb_wait_type;
@@ -4373,8 +4386,11 @@ int dlm_recover_waiters_post(struct dlm_ls *ls)
 		ou = is_overlap_unlock(lkb);
 		err = 0;
 
-		log_debug(ls, "recover_waiter %x nodeid %d msg %d r_nodeid %d",
-			  lkb->lkb_id, lkb->lkb_nodeid, mstype, r->res_nodeid);
+		log_debug(ls, "waiter %x remote %x msg %d r_nodeid %d "
+			  "lkb_nodeid %d wait_nodeid %d dir_nodeid %d "
+			  "overlap %d %d", lkb->lkb_id, lkb->lkb_remid, mstype,
+			  r->res_nodeid, lkb->lkb_nodeid, lkb->lkb_wait_nodeid,
+			  dlm_dir_nodeid(r), oc, ou);
 
 		/* At this point we assume that we won't get a reply to any
 		   previous op or overlap op on this lock.  First, do a big
@@ -4426,9 +4442,12 @@ int dlm_recover_waiters_post(struct dlm_ls *ls)
 			}
 		}
 
-		if (err)
-			log_error(ls, "recover_waiters_post %x %d %x %d %d",
-			  	  lkb->lkb_id, mstype, lkb->lkb_flags, oc, ou);
+		if (err) {
+			log_error(ls, "waiter %x msg %d r_nodeid %d "
+				  "dir_nodeid %d overlap %d %d",
+				  lkb->lkb_id, mstype, r->res_nodeid,
+				  dlm_dir_nodeid(r), oc, ou);
+		}
 		unlock_rsb(r);
 		put_rsb(r);
 		dlm_put_lkb(lkb);
-- 
1.7.10.1.362.g242cab3

