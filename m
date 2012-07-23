Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2GWSSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:18:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566Ab2GWSRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:17:54 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] dlm: fix missing dir remove
Date: Mon, 23 Jul 2012 13:17:47 -0500
Message-Id: <1343067467-24308-7-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know exactly how, but in some cases, a dir
record is not removed, or a new one is created when
it shouldn't be.  The result is that the dir node
lookup returns a master node where the rsb does not
exist.  In this case, The master node will repeatedly
return -EBADR for requests, and the lock requests will
be stuck.

Until all possible ways for this to happen can be
eliminated, a simple and effective way to recover from
this situation is for the supposed master node to send
a standard remove message to the dir node when it
receives a request for a resource it has no rsb for.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lock.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index 04e3f15..b569507 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4000,12 +4000,70 @@ static int validate_message(struct dlm_lkb *lkb, struct dlm_message *ms)
 	return error;
 }
 
+static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
+{
+	char name[DLM_RESNAME_MAXLEN + 1];
+	struct dlm_message *ms;
+	struct dlm_mhandle *mh;
+	struct dlm_rsb *r;
+	uint32_t hash, b;
+	int rv, dir_nodeid;
+
+	memset(name, 0, sizeof(name));
+	memcpy(name, ms_name, len);
+
+	hash = jhash(name, len, 0);
+	b = hash & (ls->ls_rsbtbl_size - 1);
+
+	dir_nodeid = dlm_hash2nodeid(ls, hash);
+
+	log_error(ls, "send_repeat_remove dir %d %s", dir_nodeid, name);
+
+	spin_lock(&ls->ls_rsbtbl[b].lock);
+	rv = dlm_search_rsb_tree(&ls->ls_rsbtbl[b].keep, name, len, &r);
+	if (!rv) {
+		spin_unlock(&ls->ls_rsbtbl[b].lock);
+		log_error(ls, "repeat_remove on keep %s", name);
+		return;
+	}
+
+	rv = dlm_search_rsb_tree(&ls->ls_rsbtbl[b].toss, name, len, &r);
+	if (!rv) {
+		spin_unlock(&ls->ls_rsbtbl[b].lock);
+		log_error(ls, "repeat_remove on toss %s", name);
+		return;
+	}
+
+	/* use ls->remove_name2 to avoid conflict with shrink? */
+
+	spin_lock(&ls->ls_remove_spin);
+	ls->ls_remove_len = len;
+	memcpy(ls->ls_remove_name, name, DLM_RESNAME_MAXLEN);
+	spin_unlock(&ls->ls_remove_spin);
+	spin_unlock(&ls->ls_rsbtbl[b].lock);
+
+	rv = _create_message(ls, sizeof(struct dlm_message) + len,
+			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
+	if (rv)
+		return;
+
+	memcpy(ms->m_extra, name, len);
+	ms->m_hash = hash;
+
+	send_message(mh, ms);
+
+	spin_lock(&ls->ls_remove_spin);
+	ls->ls_remove_len = 0;
+	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
+	spin_unlock(&ls->ls_remove_spin);
+}
+
 static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 {
 	struct dlm_lkb *lkb;
 	struct dlm_rsb *r;
 	int from_nodeid;
-	int error, namelen;
+	int error, namelen = 0;
 
 	from_nodeid = ms->m_header.h_nodeid;
 
@@ -4073,13 +4131,21 @@ static int receive_request(struct dlm_ls *ls, struct dlm_message *ms)
 	   delayed in being sent/arriving/being processed on the dir node.
 	   Another node would repeatedly lookup up the master, and the dir
 	   node would continue returning our nodeid until our send_remove
-	   took effect. */
+	   took effect.
+
+	   We send another remove message in case our previous send_remove
+	   was lost/ignored/missed somehow. */
 
 	if (error != -ENOTBLK) {
 		log_limit(ls, "receive_request %x from %d %d",
 			  ms->m_lkid, from_nodeid, error);
 	}
 
+	if (namelen && error == -EBADR) {
+		send_repeat_remove(ls, ms->m_extra, namelen);
+		msleep(1000);
+	}
+
 	setup_stub_lkb(ls, ms);
 	send_request_reply(&ls->ls_stub_rsb, &ls->ls_stub_lkb, error);
 	return error;
-- 
1.7.10.1.362.g242cab3

