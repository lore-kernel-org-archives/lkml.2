Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2EUVSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:18:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759189Ab2EUVSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:18:46 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] dlm: improve error and debug messages
Date: Mon, 21 May 2012 16:18:37 -0500
Message-Id: <1337635120-19969-6-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change some existing error/debug messages to
collect more useful information, and add
some new error/debug messages to address
recently found problems.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c         |  241 ++++++++++++++++++++++++++++++++-----------------
 fs/dlm/lock.h         |    3 +-
 fs/dlm/recoverd.c     |    6 +-
 fs/dlm/requestqueue.c |    4 +-
 4 files changed, 164 insertions(+), 90 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 49926f1..f3ba703 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -160,11 +160,11 @@ static const int __quecvt_compat_matrix[8][8] = {
 
 void dlm_print_lkb(struct dlm_lkb *lkb)
 {
-	printk(KERN_ERR "lkb: nodeid %d id %x remid %x exflags %x flags %x\n"
-	       "     status %d rqmode %d grmode %d wait_type %d\n",
+	printk(KERN_ERR "lkb: nodeid %d id %x remid %x exflags %x flags %x "
+	       "sts %d rq %d gr %d wait_type %d wait_nodeid %d\n",
 	       lkb->lkb_nodeid, lkb->lkb_id, lkb->lkb_remid, lkb->lkb_exflags,
 	       lkb->lkb_flags, lkb->lkb_status, lkb->lkb_rqmode,
-	       lkb->lkb_grmode, lkb->lkb_wait_type);
+	       lkb->lkb_grmode, lkb->lkb_wait_type, lkb->lkb_wait_nodeid);
 }
 
 static void dlm_print_rsb(struct dlm_rsb *r)
@@ -589,6 +589,23 @@ static int find_rsb(struct dlm_ls *ls, char *name, int namelen,
 	return error;
 }
 
+static void dlm_dump_rsb_hash(struct dlm_ls *ls, uint32_t hash)
+{
+	struct rb_node *n;
+	struct dlm_rsb *r;
+	int i;
+
+	for (i = 0; i < ls->ls_rsbtbl_size; i++) {
+		spin_lock(&ls->ls_rsbtbl[i].lock);
+		for (n = rb_first(&ls->ls_rsbtbl[i].keep); n; n = rb_next(n)) {
+			r = rb_entry(n, struct dlm_rsb, res_hashnode);
+			if (r->res_hash == hash)
+				dlm_dump_rsb(r);
+		}
+		spin_unlock(&ls->ls_rsbtbl[i].lock);
+	}
+}
+
 /* This is only called to add a reference when the code already holds
    a valid reference to the rsb, so there's no need for locking. */
 
@@ -1067,8 +1084,9 @@ static int _remove_from_waiters(struct dlm_lkb *lkb, int mstype,
 		goto out_del;
 	}
 
-	log_error(ls, "remwait error %x reply %d flags %x no wait_type",
-		  lkb->lkb_id, mstype, lkb->lkb_flags);
+	log_error(ls, "remwait error %x remote %d %x msg %d flags %x no wait",
+		  lkb->lkb_id, ms ? ms->m_header.h_nodeid : 0, lkb->lkb_remid,
+		  mstype, lkb->lkb_flags);
 	return -1;
 
  out_del:
@@ -3375,7 +3393,7 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 	return error;
 }
 
-static void receive_request(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
@@ -3415,14 +3433,15 @@ static void receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 		error = 0;
 	if (error)
 		dlm_put_lkb(lkb);
-	return;
+	return 0;
 
  fail:
 	setup_stub_lkb(ls, ms);
 	send_request_reply(&ls->ls_stub_rsb, &ls->ls_stub_lkb, error);
+	return error;
 }
 
-static void receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
@@ -3432,6 +3451,14 @@ static void receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
 	if (error)
 		goto fail;
 
+	if (lkb->lkb_remid != ms->m_lkid) {
+		log_error(ls, "receive_convert %x remid %x remote %d %x",
+			  lkb->lkb_id, lkb->lkb_remid,
+			  ms->m_header.h_nodeid, ms->m_lkid);
+		error = -ENOENT;
+		goto fail;
+	}
+
 	r = lkb->lkb_resource;
 
 	hold_rsb(r);
@@ -3459,14 +3486,15 @@ static void receive_convert(struct dlm_ls *ls, struct dlm_message *ms)
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
-	return;
+	return 0;
 
  fail:
 	setup_stub_lkb(ls, ms);
 	send_convert_reply(&ls->ls_stub_rsb, &ls->ls_stub_lkb, error);
+	return error;
 }
 
-static void receive_unlock(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_unlock(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
@@ -3476,6 +3504,14 @@ static void receive_unlock(struct dlm_ls *ls, struct dlm_message *ms)
 	if (error)
 		goto fail;
 
+	if (lkb->lkb_remid != ms->m_lkid) {
+		log_error(ls, "receive_unlock %x remid %x remote %d %x",
+			  lkb->lkb_id, lkb->lkb_remid,
+			  ms->m_header.h_nodeid, ms->m_lkid);
+		error = -ENOENT;
+		goto fail;
+	}
+
 	r = lkb->lkb_resource;
 
 	hold_rsb(r);
@@ -3500,14 +3536,15 @@ static void receive_unlock(struct dlm_ls *ls, struct dlm_message *ms)
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
-	return;
+	return 0;
 
  fail:
 	setup_stub_lkb(ls, ms);
 	send_unlock_reply(&ls->ls_stub_rsb, &ls->ls_stub_lkb, error);
+	return error;
 }
 
-static void receive_cancel(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_cancel(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
@@ -3535,25 +3572,23 @@ static void receive_cancel(struct dlm_ls *ls, struct dlm_message *ms)
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
-	return;
+	return 0;
 
  fail:
 	setup_stub_lkb(ls, ms);
 	send_cancel_reply(&ls->ls_stub_rsb, &ls->ls_stub_lkb, error);
+	return error;
 }
 
-static void receive_grant(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_grant(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
 	int error;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
-	if (error) {
-		log_debug(ls, "receive_grant from %d no lkb %x",
-			  ms->m_header.h_nodeid, ms->m_remid);
-		return;
-	}
+	if (error)
+		return error;
 
 	r = lkb->lkb_resource;
 
@@ -3573,20 +3608,18 @@ static void receive_grant(struct dlm_ls *ls, struct dlm_message *ms)
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
+	return 0;
 }
 
-static void receive_bast(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_bast(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
 	int error;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
-	if (error) {
-		log_debug(ls, "receive_bast from %d no lkb %x",
-			  ms->m_header.h_nodeid, ms->m_remid);
-		return;
-	}
+	if (error)
+		return error;
 
 	r = lkb->lkb_resource;
 
@@ -3602,6 +3635,7 @@ static void receive_bast(struct dlm_ls *ls, struct dlm_message *ms)
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
+	return 0;
 }
 
 static void receive_lookup(struct dlm_ls *ls, struct dlm_message *ms)
@@ -3656,18 +3690,15 @@ static void receive_purge(struct dlm_ls *ls, struct dlm_message *ms)
 	do_purge(ls, ms->m_nodeid, ms->m_pid);
 }
 
-static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
 	int error, mstype, result;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
-	if (error) {
-		log_debug(ls, "receive_request_reply from %d no lkb %x",
-			  ms->m_header.h_nodeid, ms->m_remid);
-		return;
-	}
+	if (error)
+		return error;
 
 	r = lkb->lkb_resource;
 	hold_rsb(r);
@@ -3758,6 +3789,7 @@ static void receive_request_reply(struct dlm_ls *ls, struct dlm_message *ms)
 	unlock_rsb(r);
 	put_rsb(r);
 	dlm_put_lkb(lkb);
+	return 0;
 }
 
 static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
@@ -3796,8 +3828,11 @@ static void __receive_convert_reply(struct dlm_rsb *r, struct dlm_lkb *lkb,
 		break;
 
 	default:
-		log_error(r->res_ls, "receive_convert_reply %x error %d",
-			  lkb->lkb_id, ms->m_result);
+		log_error(r->res_ls, "receive_convert_reply %x remote %d %x %d",
+			  lkb->lkb_id, ms->m_header.h_nodeid, ms->m_lkid,
+			  ms->m_result);
+		dlm_print_rsb(r);
+		dlm_print_lkb(lkb);
 	}
 }
 
@@ -3824,20 +3859,18 @@ static void _receive_convert_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	put_rsb(r);
 }
 
-static void receive_convert_reply(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_convert_reply(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	int error;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
-	if (error) {
-		log_debug(ls, "receive_convert_reply from %d no lkb %x",
-			  ms->m_header.h_nodeid, ms->m_remid);
-		return;
-	}
+	if (error)
+		return error;
 
 	_receive_convert_reply(lkb, ms);
 	dlm_put_lkb(lkb);
+	return 0;
 }
 
 static void _receive_unlock_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
@@ -3876,20 +3909,18 @@ static void _receive_unlock_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	put_rsb(r);
 }
 
-static void receive_unlock_reply(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_unlock_reply(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	int error;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
-	if (error) {
-		log_debug(ls, "receive_unlock_reply from %d no lkb %x",
-			  ms->m_header.h_nodeid, ms->m_remid);
-		return;
-	}
+	if (error)
+		return error;
 
 	_receive_unlock_reply(lkb, ms);
 	dlm_put_lkb(lkb);
+	return 0;
 }
 
 static void _receive_cancel_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
@@ -3928,20 +3959,18 @@ static void _receive_cancel_reply(struct dlm_lkb *lkb, struct dlm_message *ms)
 	put_rsb(r);
 }
 
-static void receive_cancel_reply(struct dlm_ls *ls, struct dlm_message *ms)
+static int receive_cancel_reply(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	int error;
 
 	error = find_lkb(ls, ms->m_remid, &lkb);
-	if (error) {
-		log_debug(ls, "receive_cancel_reply from %d no lkb %x",
-			  ms->m_header.h_nodeid, ms->m_remid);
-		return;
-	}
+	if (error)
+		return error;
 
 	_receive_cancel_reply(lkb, ms);
 	dlm_put_lkb(lkb);
+	return 0;
 }
 
 static void receive_lookup_reply(struct dlm_ls *ls, struct dlm_message *ms)
@@ -3952,7 +3981,7 @@ static void receive_lookup_reply(struct dlm_ls *ls, struct dlm_message *ms)
 
 	error = find_lkb(ls, ms->m_lkid, &lkb);
 	if (error) {
-		log_error(ls, "receive_lookup_reply no lkb");
+		log_error(ls, "receive_lookup_reply no lkid %x", ms->m_lkid);
 		return;
 	}
 
@@ -3996,8 +4025,11 @@ static void receive_lookup_reply(struct dlm_ls *ls, struct dlm_message *ms)
 	dlm_put_lkb(lkb);
 }
 
-static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms)
+static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms,
+			     uint32_t saved_seq)
 {
+	int error = 0, noent = 0;
+
 	if (!dlm_is_member(ls, ms->m_header.h_nodeid)) {
 		log_debug(ls, "ignore non-member message %d from %d %x %x %d",
 			  ms->m_type, ms->m_header.h_nodeid, ms->m_lkid,
@@ -4010,47 +4042,50 @@ static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms)
 	/* messages sent to a master node */
 
 	case DLM_MSG_REQUEST:
-		receive_request(ls, ms);
+		error = receive_request(ls, ms);
 		break;
 
 	case DLM_MSG_CONVERT:
-		receive_convert(ls, ms);
+		error = receive_convert(ls, ms);
 		break;
 
 	case DLM_MSG_UNLOCK:
-		receive_unlock(ls, ms);
+		error = receive_unlock(ls, ms);
 		break;
 
 	case DLM_MSG_CANCEL:
-		receive_cancel(ls, ms);
+		noent = 1;
+		error = receive_cancel(ls, ms);
 		break;
 
 	/* messages sent from a master node (replies to above) */
 
 	case DLM_MSG_REQUEST_REPLY:
-		receive_request_reply(ls, ms);
+		error = receive_request_reply(ls, ms);
 		break;
 
 	case DLM_MSG_CONVERT_REPLY:
-		receive_convert_reply(ls, ms);
+		error = receive_convert_reply(ls, ms);
 		break;
 
 	case DLM_MSG_UNLOCK_REPLY:
-		receive_unlock_reply(ls, ms);
+		error = receive_unlock_reply(ls, ms);
 		break;
 
 	case DLM_MSG_CANCEL_REPLY:
-		receive_cancel_reply(ls, ms);
+		error = receive_cancel_reply(ls, ms);
 		break;
 
 	/* messages sent from a master node (only two types of async msg) */
 
 	case DLM_MSG_GRANT:
-		receive_grant(ls, ms);
+		noent = 1;
+		error = receive_grant(ls, ms);
 		break;
 
 	case DLM_MSG_BAST:
-		receive_bast(ls, ms);
+		noent = 1;
+		error = receive_bast(ls, ms);
 		break;
 
 	/* messages sent to a dir node */
@@ -4078,6 +4113,30 @@ static void _receive_message(struct dlm_ls *ls, struct dlm_message *ms)
 	default:
 		log_error(ls, "unknown message type %d", ms->m_type);
 	}
+
+	/*
+	 * When checking for ENOENT, we're checking the result of
+	 * find_lkb(m_remid):
+	 *
+	 * The lock id referenced in the message wasn't found.  This may
+	 * happen in normal usage for the async messages and cancel, so
+	 * only use log_debug for them.
+	 *
+	 * Other errors are expected and normal.
+	 */
+
+	if (error == -ENOENT && noent) {
+		log_debug(ls, "receive %d no %x remote %d %x seq %u",
+			  ms->m_type, ms->m_remid, ms->m_header.h_nodeid,
+			  ms->m_lkid, saved_seq);
+	} else if (error == -ENOENT) {
+		log_error(ls, "receive %d no %x remote %d %x seq %u",
+			  ms->m_type, ms->m_remid, ms->m_header.h_nodeid,
+			  ms->m_lkid, saved_seq);
+
+		if (ms->m_type == DLM_MSG_CONVERT)
+			dlm_dump_rsb_hash(ls, ms->m_hash);
+	}
 }
 
 /* If the lockspace is in recovery mode (locking stopped), then normal
@@ -4095,16 +4154,17 @@ static void dlm_receive_message(struct dlm_ls *ls, struct dlm_message *ms,
 		dlm_add_requestqueue(ls, nodeid, ms);
 	} else {
 		dlm_wait_requestqueue(ls);
-		_receive_message(ls, ms);
+		_receive_message(ls, ms, 0);
 	}
 }
 
 /* This is called by dlm_recoverd to process messages that were saved on
    the requestqueue. */
 
-void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms)
+void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms,
+			       uint32_t saved_seq)
 {
-	_receive_message(ls, ms);
+	_receive_message(ls, ms, saved_seq);
 }
 
 /* This is called by the midcomms layer when something is received for
@@ -4653,6 +4713,7 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
 	struct dlm_rsb *r;
 	struct dlm_lkb *lkb;
+	uint32_t remid = 0;
 	int error;
 
 	if (rl->rl_parent_lkid) {
@@ -4660,6 +4721,8 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 		goto out;
 	}
 
+	remid = le32_to_cpu(rl->rl_lkid);
+
 	error = find_rsb(ls, rl->rl_name, le16_to_cpu(rl->rl_namelen),
 			 R_MASTER, &r);
 	if (error)
@@ -4667,7 +4730,7 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 
 	lock_rsb(r);
 
-	lkb = search_remid(r, rc->rc_header.h_nodeid, le32_to_cpu(rl->rl_lkid));
+	lkb = search_remid(r, rc->rc_header.h_nodeid, remid);
 	if (lkb) {
 		error = -EEXIST;
 		goto out_remid;
@@ -4696,9 +4759,9 @@ int dlm_recover_master_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	unlock_rsb(r);
 	put_rsb(r);
  out:
-	if (error)
-		log_debug(ls, "recover_master_copy %d %x", error,
-			  le32_to_cpu(rl->rl_lkid));
+	if (error && error != -EEXIST)
+		log_debug(ls, "dlm_recover_master_copy remote %d %x error %d",
+			  rc->rc_header.h_nodeid, remid, error);
 	rl->rl_result = cpu_to_le32(error);
 	return error;
 }
@@ -4709,41 +4772,49 @@ int dlm_recover_process_copy(struct dlm_ls *ls, struct dlm_rcom *rc)
 	struct rcom_lock *rl = (struct rcom_lock *) rc->rc_buf;
 	struct dlm_rsb *r;
 	struct dlm_lkb *lkb;
-	int error;
+	uint32_t lkid, remid;
+	int error, result;
+
+	lkid = le32_to_cpu(rl->rl_lkid);
+	remid = le32_to_cpu(rl->rl_remid);
+	result = le32_to_cpu(rl->rl_result);
 
-	error = find_lkb(ls, le32_to_cpu(rl->rl_lkid), &lkb);
+	error = find_lkb(ls, lkid, &lkb);
 	if (error) {
-		log_error(ls, "recover_process_copy no lkid %x",
-				le32_to_cpu(rl->rl_lkid));
+		log_error(ls, "dlm_recover_process_copy no %x remote %d %x %d",
+			  lkid, rc->rc_header.h_nodeid, remid, result);
 		return error;
 	}
 
-	DLM_ASSERT(is_process_copy(lkb), dlm_print_lkb(lkb););
-
-	error = le32_to_cpu(rl->rl_result);
+	if (!is_process_copy(lkb)) {
+		log_error(ls, "dlm_recover_process_copy bad %x remote %d %x %d",
+			  lkid, rc->rc_header.h_nodeid, remid, result);
+		dlm_print_lkb(lkb);
+		return -EINVAL;
+	}
 
 	r = lkb->lkb_resource;
 	hold_rsb(r);
 	lock_rsb(r);
 
-	switch (error) {
+	switch (result) {
 	case -EBADR:
 		/* There's a chance the new master received our lock before
 		   dlm_recover_master_reply(), this wouldn't happen if we did
 		   a barrier between recover_masters and recover_locks. */
-		log_debug(ls, "master copy not ready %x r %lx %s", lkb->lkb_id,
-			  (unsigned long)r, r->res_name);
+
+		log_debug(ls, "dlm_recover_process_copy %x remote %d %x %d",
+			  lkid, rc->rc_header.h_nodeid, remid, result);
+	
 		dlm_send_rcom_lock(r, lkb);
 		goto out;
 	case -EEXIST:
-		log_debug(ls, "master copy exists %x", lkb->lkb_id);
-		/* fall through */
 	case 0:
-		lkb->lkb_remid = le32_to_cpu(rl->rl_remid);
+		lkb->lkb_remid = remid;
 		break;
 	default:
-		log_error(ls, "dlm_recover_process_copy unknown error %d %x",
-			  error, lkb->lkb_id);
+		log_error(ls, "dlm_recover_process_copy %x remote %d %x %d unk",
+			  lkid, rc->rc_header.h_nodeid, remid, result);
 	}
 
 	/* an ack for dlm_recover_locks() which waits for replies from
diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 1a25530..56e2bc6 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -15,7 +15,8 @@
 
 void dlm_dump_rsb(struct dlm_rsb *r);
 void dlm_print_lkb(struct dlm_lkb *lkb);
-void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms);
+void dlm_receive_message_saved(struct dlm_ls *ls, struct dlm_message *ms,
+			       uint32_t saved_seq);
 void dlm_receive_buffer(union dlm_packet *p, int nodeid);
 int dlm_modes_compat(int mode1, int mode2);
 void dlm_put_rsb(struct dlm_rsb *r);
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 3780caf..11351b5 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -54,7 +54,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 	unsigned long start;
 	int error, neg = 0;
 
-	log_debug(ls, "dlm_recover %llx", (unsigned long long)rv->seq);
+	log_debug(ls, "dlm_recover %llu", (unsigned long long)rv->seq);
 
 	mutex_lock(&ls->ls_recoverd_active);
 
@@ -227,7 +227,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
 	dlm_grant_after_purge(ls);
 
-	log_debug(ls, "dlm_recover %llx generation %u done: %u ms",
+	log_debug(ls, "dlm_recover %llu generation %u done: %u ms",
 		  (unsigned long long)rv->seq, ls->ls_generation,
 		  jiffies_to_msecs(jiffies - start));
 	mutex_unlock(&ls->ls_recoverd_active);
@@ -237,7 +237,7 @@ static int ls_recover(struct dlm_ls *ls, struct dlm_recover *rv)
 
  fail:
 	dlm_release_root_list(ls);
-	log_debug(ls, "dlm_recover %llx error %d",
+	log_debug(ls, "dlm_recover %llu error %d",
 		  (unsigned long long)rv->seq, error);
 	mutex_unlock(&ls->ls_recoverd_active);
 	return error;
diff --git a/fs/dlm/requestqueue.c b/fs/dlm/requestqueue.c
index a44fa22..d3191bf 100644
--- a/fs/dlm/requestqueue.c
+++ b/fs/dlm/requestqueue.c
@@ -19,6 +19,7 @@
 
 struct rq_entry {
 	struct list_head list;
+	uint32_t recover_seq;
 	int nodeid;
 	struct dlm_message request;
 };
@@ -41,6 +42,7 @@ void dlm_add_requestqueue(struct dlm_ls *ls, int nodeid, struct dlm_message *ms)
 		return;
 	}
 
+	e->recover_seq = ls->ls_recover_seq & 0xFFFFFFFF;
 	e->nodeid = nodeid;
 	memcpy(&e->request, ms, ms->m_header.h_length);
 
@@ -76,7 +78,7 @@ int dlm_process_requestqueue(struct dlm_ls *ls)
 		e = list_entry(ls->ls_requestqueue.next, struct rq_entry, list);
 		mutex_unlock(&ls->ls_requestqueue_mutex);
 
-		dlm_receive_message_saved(ls, &e->request);
+		dlm_receive_message_saved(ls, &e->request, e->recover_seq);
 
 		mutex_lock(&ls->ls_requestqueue_mutex);
 		list_del(&e->list);
-- 
1.7.10.1.362.g242cab3

