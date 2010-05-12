Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab0ELXQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:16:21 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47893 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab0ELXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references; q=dns; s=
	drama; b=MPTdGfGy/3WFB4FPHaZxz9ALKCxBvpTq4sfJR+aKe6MqH/KeIUai1KE
	YN7m7kz8/pqAYz3vJsrQJbQQkrlnfw0xoqrerSmYW75Xy/CnGjqj0g/tvo4oGqbE
	0hbyizPFxPHn/lvH8FBRgEqilAnM64dUnVNNp3VL+ue1D106dn68=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 1/8] ceph: all allocation functions should get gfp_mask
Date: Wed, 12 May 2010 16:23:33 -0700
Message-Id: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
References: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is essential, as for the rados block device we'll need
to run in different contexts that would need flags that
are other than GFP_NOFS.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/caps.c       |    2 +-
 fs/ceph/file.c       |   10 +++++-----
 fs/ceph/mds_client.c |   11 ++++++-----
 fs/ceph/messenger.c  |   10 +++++-----
 fs/ceph/messenger.h  |    2 +-
 fs/ceph/mon_client.c |   15 ++++++++-------
 fs/ceph/msgpool.c    |    4 ++--
 fs/ceph/osd_client.c |    8 ++++----
 8 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5c87f37..d06948b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -932,7 +932,7 @@ static int send_cap_msg(struct ceph_mds_session *session,
 	     seq, issue_seq, mseq, follows, size, max_size,
 	     xattr_version, xattrs_buf ? (int)xattrs_buf->vec.iov_len : 0);
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc));
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPS, sizeof(*fc), GFP_NOFS);
 	if (!msg)
 		return -ENOMEM;
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4024a5d..ef8f9e9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -316,16 +316,16 @@ void ceph_release_page_vector(struct page **pages, int num_pages)
 /*
  * allocate a vector new pages
  */
-static struct page **alloc_page_vector(int num_pages)
+struct page **ceph_alloc_page_vector(int num_pages, gfp_t flags)
 {
 	struct page **pages;
 	int i;
 
-	pages = kmalloc(sizeof(*pages) * num_pages, GFP_NOFS);
+	pages = kmalloc(sizeof(*pages) * num_pages, flags);
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 	for (i = 0; i < num_pages; i++) {
-		pages[i] = __page_cache_alloc(GFP_NOFS);
+		pages[i] = __page_cache_alloc(flags);
 		if (pages[i] == NULL) {
 			ceph_release_page_vector(pages, i);
 			return ERR_PTR(-ENOMEM);
@@ -539,7 +539,7 @@ static ssize_t ceph_sync_read(struct file *file, char __user *data,
 		 * in sequence.
 		 */
 	} else {
-		pages = alloc_page_vector(num_pages);
+		pages = ceph_alloc_page_vector(num_pages, GFP_NOFS);
 	}
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
@@ -666,7 +666,7 @@ more:
 		 */
 		truncate_inode_pages_range(inode->i_mapping, pos, pos+len);
 	} else {
-		pages = alloc_page_vector(num_pages);
+		pages = ceph_alloc_page_vector(num_pages, GFP_NOFS);
 		if (IS_ERR(pages)) {
 			ret = PTR_ERR(pages);
 			goto out;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ab63799..cb42974 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -664,7 +664,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
 	struct ceph_msg *msg;
 	struct ceph_mds_session_head *h;
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h));
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS);
 	if (!msg) {
 		pr_err("create_session_msg ENOMEM creating msg\n");
 		return NULL;
@@ -1087,7 +1087,8 @@ static int add_cap_releases(struct ceph_mds_client *mdsc,
 
 	while (session->s_num_cap_releases < session->s_nr_caps + extra) {
 		spin_unlock(&session->s_cap_lock);
-		msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPRELEASE, PAGE_CACHE_SIZE);
+		msg = ceph_msg_new(CEPH_MSG_CLIENT_CAPRELEASE, PAGE_CACHE_SIZE,
+				   GFP_NOFS);
 		if (!msg)
 			goto out_unlocked;
 		dout("add_cap_releases %p msg %p now %d\n", session, msg,
@@ -1489,7 +1490,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 	if (req->r_old_dentry_drop)
 		len += req->r_old_dentry->d_name.len;
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_REQUEST, len);
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_REQUEST, len, GFP_NOFS);
 	if (!msg) {
 		msg = ERR_PTR(-ENOMEM);
 		goto out_free2;
@@ -2216,7 +2217,7 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
 		goto fail_nopagelist;
 	ceph_pagelist_init(pagelist);
 
-	reply = ceph_msg_new(CEPH_MSG_CLIENT_RECONNECT, 0);
+	reply = ceph_msg_new(CEPH_MSG_CLIENT_RECONNECT, 0, GFP_NOFS);
 	if (!reply)
 		goto fail_nomsg;
 
@@ -2508,7 +2509,7 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
 	dnamelen = dentry->d_name.len;
 	len += dnamelen;
 
-	msg = ceph_msg_new(CEPH_MSG_CLIENT_LEASE, len);
+	msg = ceph_msg_new(CEPH_MSG_CLIENT_LEASE, len, GFP_NOFS);
 	if (!msg)
 		return;
 	lease = msg->front.iov_base;
diff --git a/fs/ceph/messenger.c b/fs/ceph/messenger.c
index dbaad57..d60c489 100644
--- a/fs/ceph/messenger.c
+++ b/fs/ceph/messenger.c
@@ -2049,11 +2049,11 @@ void ceph_con_keepalive(struct ceph_connection *con)
  * construct a new message with given type, size
  * the new msg has a ref count of 1.
  */
-struct ceph_msg *ceph_msg_new(int type, int front_len)
+struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags)
 {
 	struct ceph_msg *m;
 
-	m = kmalloc(sizeof(*m), GFP_NOFS);
+	m = kmalloc(sizeof(*m), flags);
 	if (m == NULL)
 		goto out;
 	kref_init(&m->kref);
@@ -2076,11 +2076,11 @@ struct ceph_msg *ceph_msg_new(int type, int front_len)
 	/* front */
 	if (front_len) {
 		if (front_len > PAGE_CACHE_SIZE) {
-			m->front.iov_base = __vmalloc(front_len, GFP_NOFS,
+			m->front.iov_base = __vmalloc(front_len, flags,
 						      PAGE_KERNEL);
 			m->front_is_vmalloc = true;
 		} else {
-			m->front.iov_base = kmalloc(front_len, GFP_NOFS);
+			m->front.iov_base = kmalloc(front_len, flags);
 		}
 		if (m->front.iov_base == NULL) {
 			pr_err("msg_new can't allocate %d bytes\n",
@@ -2155,7 +2155,7 @@ static struct ceph_msg *ceph_alloc_msg(struct ceph_connection *con,
 	}
 	if (!msg) {
 		*skip = 0;
-		msg = ceph_msg_new(type, front_len);
+		msg = ceph_msg_new(type, front_len, GFP_NOFS);
 		if (!msg) {
 			pr_err("unable to allocate msg type %d len %d\n",
 			       type, front_len);
diff --git a/fs/ceph/messenger.h b/fs/ceph/messenger.h
index 9f0a540..fe24e6f 100644
--- a/fs/ceph/messenger.h
+++ b/fs/ceph/messenger.h
@@ -232,7 +232,7 @@ extern void ceph_con_keepalive(struct ceph_connection *con);
 extern struct ceph_connection *ceph_con_get(struct ceph_connection *con);
 extern void ceph_con_put(struct ceph_connection *con);
 
-extern struct ceph_msg *ceph_msg_new(int type, int front_len);
+extern struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags);
 extern void ceph_msg_kfree(struct ceph_msg *m);
 
 
diff --git a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
index cfce412..a52d68c 100644
--- a/fs/ceph/mon_client.c
+++ b/fs/ceph/mon_client.c
@@ -190,7 +190,7 @@ static void __send_subscribe(struct ceph_mon_client *monc)
 		struct ceph_mon_subscribe_item *i;
 		void *p, *end;
 
-		msg = ceph_msg_new(CEPH_MSG_MON_SUBSCRIBE, 96);
+		msg = ceph_msg_new(CEPH_MSG_MON_SUBSCRIBE, 96, GFP_NOFS);
 		if (!msg)
 			return;
 
@@ -490,10 +490,10 @@ int ceph_monc_do_statfs(struct ceph_mon_client *monc, struct ceph_statfs *buf)
 	init_completion(&req->completion);
 
 	err = -ENOMEM;
-	req->request = ceph_msg_new(CEPH_MSG_STATFS, sizeof(*h));
+	req->request = ceph_msg_new(CEPH_MSG_STATFS, sizeof(*h), GFP_NOFS);
 	if (!req->request)
 		goto out;
-	req->reply = ceph_msg_new(CEPH_MSG_STATFS_REPLY, 1024);
+	req->reply = ceph_msg_new(CEPH_MSG_STATFS_REPLY, 1024, GFP_NOFS);
 	if (!req->reply)
 		goto out;
 
@@ -632,15 +632,16 @@ int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl)
 	/* msg pools */
 	err = -ENOMEM;
 	monc->m_subscribe_ack = ceph_msg_new(CEPH_MSG_MON_SUBSCRIBE_ACK,
-				     sizeof(struct ceph_mon_subscribe_ack));
+				     sizeof(struct ceph_mon_subscribe_ack),
+				     GFP_NOFS);
 	if (!monc->m_subscribe_ack)
 		goto out_monmap;
 
-	monc->m_auth_reply = ceph_msg_new(CEPH_MSG_AUTH_REPLY, 4096);
+	monc->m_auth_reply = ceph_msg_new(CEPH_MSG_AUTH_REPLY, 4096, GFP_NOFS);
 	if (!monc->m_auth_reply)
 		goto out_subscribe_ack;
 
-	monc->m_auth = ceph_msg_new(CEPH_MSG_AUTH, 4096);
+	monc->m_auth = ceph_msg_new(CEPH_MSG_AUTH, 4096, GFP_NOFS);
 	monc->pending_auth = 0;
 	if (!monc->m_auth)
 		goto out_auth_reply;
@@ -815,7 +816,7 @@ static struct ceph_msg *mon_alloc_msg(struct ceph_connection *con,
 	case CEPH_MSG_MON_MAP:
 	case CEPH_MSG_MDS_MAP:
 	case CEPH_MSG_OSD_MAP:
-		m = ceph_msg_new(type, front_len);
+		m = ceph_msg_new(type, front_len, GFP_NOFS);
 		break;
 	}
 
diff --git a/fs/ceph/msgpool.c b/fs/ceph/msgpool.c
index 50fe5cc..dd65a64 100644
--- a/fs/ceph/msgpool.c
+++ b/fs/ceph/msgpool.c
@@ -12,7 +12,7 @@ static void *alloc_fn(gfp_t gfp_mask, void *arg)
 	struct ceph_msgpool *pool = arg;
 	void *p;
 
-	p = ceph_msg_new(0, pool->front_len);
+	p = ceph_msg_new(0, pool->front_len, gfp_mask);
 	if (!p)
 		pr_err("msgpool %s alloc failed\n", pool->name);
 	return p;
@@ -48,7 +48,7 @@ struct ceph_msg *ceph_msgpool_get(struct ceph_msgpool *pool,
 		WARN_ON(1);
 
 		/* try to alloc a fresh message */
-		return ceph_msg_new(0, front_len);
+		return ceph_msg_new(0, front_len, GFP_NOFS);
 	}
 
 	return mempool_alloc(pool->pool, GFP_NOFS);
diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index 642fe57..edb8e85 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -164,7 +164,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 		msg = ceph_msgpool_get(&osdc->msgpool_op_reply, 0);
 	else
 		msg = ceph_msg_new(CEPH_MSG_OSD_OPREPLY,
-				   OSD_OPREPLY_FRONT_LEN);
+				   OSD_OPREPLY_FRONT_LEN, GFP_NOFS);
 	if (!msg) {
 		ceph_osdc_put_request(req);
 		return NULL;
@@ -178,7 +178,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	if (use_mempool)
 		msg = ceph_msgpool_get(&osdc->msgpool_op, 0);
 	else
-		msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size);
+		msg = ceph_msg_new(CEPH_MSG_OSD_OP, msg_size, GFP_NOFS);
 	if (!msg) {
 		ceph_osdc_put_request(req);
 		return NULL;
@@ -1381,7 +1381,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	if (front > req->r_reply->front.iov_len) {
 		pr_warning("get_reply front %d > preallocated %d\n",
 			   front, (int)req->r_reply->front.iov_len);
-		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front);
+		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front, GFP_NOFS);
 		if (!m)
 			goto out;
 		ceph_msg_put(req->r_reply);
@@ -1424,7 +1424,7 @@ static struct ceph_msg *alloc_msg(struct ceph_connection *con,
 
 	switch (type) {
 	case CEPH_MSG_OSD_MAP:
-		return ceph_msg_new(type, front);
+		return ceph_msg_new(type, front, GFP_NOFS);
 	case CEPH_MSG_OSD_OPREPLY:
 		return get_reply(con, hdr, skip);
 	default:
-- 
1.5.6.5

