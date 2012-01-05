Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab2AEQpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:45:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932830Ab2AEQoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:25 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] dlm: move recovery barrier calls
Date: Thu,  5 Jan 2012 10:44:14 -0600
Message-Id: <1325781857-7938-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put all the calls to recovery barriers in the same function
to clarify where they each happen.  Should not change any behavior.
Also modify some recovery debug lines to make them consistent.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/dir.c      |    1 -
 fs/dlm/member.c   |    7 +------
 fs/dlm/recover.c  |    2 --
 fs/dlm/recoverd.c |   45 +++++++++++++++++++++++++++------------------
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/fs/dlm/dir.c b/fs/dlm/dir.c
index 7b84c1d..8364157 100644
--- a/fs/dlm/dir.c
+++ b/fs/dlm/dir.c
@@ -290,7 +290,6 @@ int dlm_recover_directory(struct dlm_ls *ls)
 
  out_status:
 	error = 0;
-	dlm_set_recover_status(ls, DLM_RS_DIR);
 	log_debug(ls, "dlm_recover_directory %d entries", count);
  out_free:
 	kfree(last_name);
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index b12532e..5ebd1df 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -251,7 +251,6 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 	ls->ls_low_nodeid = low;
 
 	make_member_array(ls);
-	dlm_set_recover_status(ls, DLM_RS_NODES);
 	*neg_out = neg;
 
 	error = ping_members(ls);
@@ -261,12 +260,8 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 		ls->ls_members_result = error;
 		complete(&ls->ls_members_done);
 	}
-	if (error)
-		goto out;
 
-	error = dlm_recover_members_wait(ls);
- out:
-	log_debug(ls, "total members %d error %d", ls->ls_num_nodes, error);
+	log_debug(ls, "dlm_recover_members %d nodes", ls->ls_num_nodes);
 	return error;
 }
 
diff --git a/fs/dlm/recover.c b/fs/dlm/recover.c
index 50467ce..81b2393 100644
--- a/fs/dlm/recover.c
+++ b/fs/dlm/recover.c
@@ -542,8 +542,6 @@ int dlm_recover_locks(struct dlm_ls *ls)
  out:
 	if (error)
 		recover_list_clear(ls);
-	else
-		dlm_set_recover_status(ls, DLM_RS_LOCKS);
 	return error;
 }
 
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 774da3c..5a9e1a4 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -54,7 +54,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	unsigned long start;
 	int error, neg = 0;
 
-	log_debug(ls, "recover %llx", (unsigned long long)rv->seq);
+	log_debug(ls, "dlm_recover %llx", (unsigned long long)rv->seq);
 
 	mutex_lock(&ls->ls_recoverd_active);
 
@@ -76,14 +76,22 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	/*
 	 * Add or remove nodes from the lockspace's ls_nodes list.
-	 * Also waits for all nodes to complete dlm_recover_members.
 	 */
 
 	error = dlm_recover_members(ls, rv, &neg);
 	if (error) {
-		log_debug(ls, "recover_members failed %d", error);
+		log_debug(ls, "dlm_recover_members error %d", error);
 		goto fail;
 	}
+
+	dlm_set_recover_status(ls, DLM_RS_NODES);
+
+	error = dlm_recover_members_wait(ls);
+	if (error) {
+		log_debug(ls, "dlm_recover_members_wait error %d", error);
+		goto fail;
+	}
+
 	start = jiffies;
 
 	/*
@@ -93,17 +101,15 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	error = dlm_recover_directory(ls);
 	if (error) {
-		log_debug(ls, "recover_directory failed %d", error);
+		log_debug(ls, "dlm_recover_directory error %d", error);
 		goto fail;
 	}
 
-	/*
-	 * Wait for all nodes to complete directory rebuild.
-	 */
+	dlm_set_recover_status(ls, DLM_RS_DIR);
 
 	error = dlm_recover_directory_wait(ls);
 	if (error) {
-		log_debug(ls, "recover_directory_wait failed %d", error);
+		log_debug(ls, "dlm_recover_directory_wait error %d", error);
 		goto fail;
 	}
 
@@ -133,7 +139,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 		error = dlm_recover_masters(ls);
 		if (error) {
-			log_debug(ls, "recover_masters failed %d", error);
+			log_debug(ls, "dlm_recover_masters error %d", error);
 			goto fail;
 		}
 
@@ -143,13 +149,15 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 		error = dlm_recover_locks(ls);
 		if (error) {
-			log_debug(ls, "recover_locks failed %d", error);
+			log_debug(ls, "dlm_recover_locks error %d", error);
 			goto fail;
 		}
 
+		dlm_set_recover_status(ls, DLM_RS_LOCKS);
+
 		error = dlm_recover_locks_wait(ls);
 		if (error) {
-			log_debug(ls, "recover_locks_wait failed %d", error);
+			log_debug(ls, "dlm_recover_locks_wait error %d", error);
 			goto fail;
 		}
 
@@ -170,7 +178,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 		error = dlm_recover_locks_wait(ls);
 		if (error) {
-			log_debug(ls, "recover_locks_wait failed %d", error);
+			log_debug(ls, "dlm_recover_locks_wait error %d", error);
 			goto fail;
 		}
 	}
@@ -186,9 +194,10 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	dlm_purge_requestqueue(ls);
 
 	dlm_set_recover_status(ls, DLM_RS_DONE);
+
 	error = dlm_recover_done_wait(ls);
 	if (error) {
-		log_debug(ls, "recover_done_wait failed %d", error);
+		log_debug(ls, "dlm_recover_done_wait error %d", error);
 		goto fail;
 	}
 
@@ -200,25 +209,25 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	error = enable_locking(ls, rv->seq);
 	if (error) {
-		log_debug(ls, "enable_locking failed %d", error);
+		log_debug(ls, "enable_locking error %d", error);
 		goto fail;
 	}
 
 	error = dlm_process_requestqueue(ls);
 	if (error) {
-		log_debug(ls, "process_requestqueue failed %d", error);
+		log_debug(ls, "dlm_process_requestqueue error %d", error);
 		goto fail;
 	}
 
 	error = dlm_recover_waiters_post(ls);
 	if (error) {
-		log_debug(ls, "recover_waiters_post failed %d", error);
+		log_debug(ls, "dlm_recover_waiters_post error %d", error);
 		goto fail;
 	}
 
 	dlm_grant_after_purge(ls);
 
-	log_debug(ls, "recover %llx done: %u ms",
+	log_debug(ls, "dlm_recover %llx done: %u ms",
 		  (unsigned long long)rv->seq,
 		  jiffies_to_msecs(jiffies - start));
 	mutex_unlock(&ls->ls_recoverd_active);
@@ -227,7 +236,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
  fail:
 	dlm_release_root_list(ls);
-	log_debug(ls, "recover %llx error %d",
+	log_debug(ls, "dlm_recover %llx error %d",
 		  (unsigned long long)rv->seq, error);
 	mutex_unlock(&ls->ls_recoverd_active);
 	return error;
-- 
1.7.6

