Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab0ELXSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:18:10 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:47901 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab0ELXQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=hq.newdream.net; h=from:to
	:cc:subject:date:message-id:in-reply-to:references:in-reply-to
	:references; q=dns; s=drama; b=EA61MhVVEhZIc/KhFo8nVD5zjuwEziJx0
	Nxwqc2js+e3oiVbeY8yijke0nZ9cplSPJB1z4mOLxATXyGBx1evGCqr+PhH7MRSZ
	laDzS6MM8JdMT0uKWSGqQX+aHaYN23E/jIm4Df3ziSUJIrdg+8A4UFsivFskGFYo
	UCyzh7ljXM=
From: Yehuda Sadeh <yehuda@hq.newdream.net>
To: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, sage@newdream.net,
       Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH 3/8] ceph: message layer can send/receive data in bio
Date: Wed, 12 May 2010 16:23:35 -0700
Message-Id: <ab64b3cde0fe00bdd53758ded5b18a872be81efb.1273705398.git.yehuda@hq.newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
References: <1273706621-12822-1-git-send-email-yehuda@hq.newdream.net>
In-Reply-To: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
References: <ccf96c67246e67d3d9bd73d47777411cbfbb5cf0.1273705398.git.yehuda@hq.newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This capability is being added so that we wouldn't
need to copy the data from the rados block device.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 fs/ceph/messenger.c  |  177 +++++++++++++++++++++++++++++++++++++++++--------
 fs/ceph/messenger.h  |    3 +
 fs/ceph/osd_client.c |   14 ++++-
 fs/ceph/osd_client.h |    4 +-
 4 files changed, 166 insertions(+), 32 deletions(-)

diff --git a/fs/ceph/messenger.c b/fs/ceph/messenger.c
index d60c489..e4871d9 100644
--- a/fs/ceph/messenger.c
+++ b/fs/ceph/messenger.c
@@ -8,6 +8,8 @@
 #include <linux/net.h>
 #include <linux/socket.h>
 #include <linux/string.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
 #include <net/tcp.h>
 
 #include "super.h"
@@ -537,8 +539,11 @@ static void prepare_write_message(struct ceph_connection *con)
 	if (le32_to_cpu(m->hdr.data_len) > 0) {
 		/* initialize page iterator */
 		con->out_msg_pos.page = 0;
-		con->out_msg_pos.page_pos =
-			le16_to_cpu(m->hdr.data_off) & ~PAGE_MASK;
+		if (m->pages)
+			con->out_msg_pos.page_pos =
+				le16_to_cpu(m->hdr.data_off) & ~PAGE_MASK;
+		else
+			con->out_msg_pos.page_pos = 0;
 		con->out_msg_pos.data_pos = 0;
 		con->out_msg_pos.did_page_crc = 0;
 		con->out_more = 1;  /* data + footer will follow */
@@ -720,6 +725,29 @@ out:
 	return ret;  /* done! */
 }
 
+static void init_bio_iter(struct bio *bio, struct bio **iter, int *seg)
+{
+	if (!bio) {
+		*iter = NULL;
+		*seg = 0;
+		return;
+	}
+	*iter = bio;
+	*seg = bio->bi_idx;
+}
+
+static void iter_bio_next(struct bio **bio_iter, int *seg)
+{
+	if (*bio_iter == NULL)
+		return;
+
+	BUG_ON(*seg >= (*bio_iter)->bi_vcnt);
+
+	(*seg)++;
+	if (*seg == (*bio_iter)->bi_vcnt)
+		init_bio_iter((*bio_iter)->bi_next, bio_iter, seg);
+}
+
 /*
  * Write as much message data payload as we can.  If we finish, queue
  * up the footer.
@@ -734,14 +762,20 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 	size_t len;
 	int crc = con->msgr->nocrc;
 	int ret;
+	int page_shift;
 
 	dout("write_partial_msg_pages %p msg %p page %d/%d offset %d\n",
 	     con, con->out_msg, con->out_msg_pos.page, con->out_msg->nr_pages,
 	     con->out_msg_pos.page_pos);
 
-	while (con->out_msg_pos.page < con->out_msg->nr_pages) {
+	if (msg->bio && !msg->bio_iter)
+		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bio_seg);
+
+
+	while (data_len - con->out_msg_pos.data_pos > 0) {
 		struct page *page = NULL;
 		void *kaddr = NULL;
+		int max_write;
 
 		/*
 		 * if we are calculating the data crc (the default), we need
@@ -752,18 +786,29 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 			page = msg->pages[con->out_msg_pos.page];
 			if (crc)
 				kaddr = kmap(page);
+			max_write = PAGE_SIZE;
 		} else if (msg->pagelist) {
 			page = list_first_entry(&msg->pagelist->head,
 						struct page, lru);
 			if (crc)
 				kaddr = kmap(page);
+			max_write = PAGE_SIZE;
+		} else if (msg->bio) {
+			struct bio_vec *bv;
+
+			bv = bio_iovec_idx(msg->bio_iter, msg->bio_seg);
+			page = bv->bv_page;
+			page_shift = bv->bv_offset;
+			if (crc)
+				kaddr = kmap(page) + page_shift;
+			max_write = bv->bv_len;
 		} else {
 			page = con->msgr->zero_page;
 			if (crc)
 				kaddr = page_address(con->msgr->zero_page);
 		}
-		len = min((int)(PAGE_SIZE - con->out_msg_pos.page_pos),
-			  (int)(data_len - con->out_msg_pos.data_pos));
+		len = min_t(int, max_write - con->out_msg_pos.page_pos,
+			    data_len - con->out_msg_pos.data_pos);
 		if (crc && !con->out_msg_pos.did_page_crc) {
 			void *base = kaddr + con->out_msg_pos.page_pos;
 			u32 tmpcrc = le32_to_cpu(con->out_msg->footer.data_crc);
@@ -775,11 +820,12 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 		}
 
 		ret = kernel_sendpage(con->sock, page,
-				      con->out_msg_pos.page_pos, len,
+				      con->out_msg_pos.page_pos + page_shift,
+				      len,
 				      MSG_DONTWAIT | MSG_NOSIGNAL |
 				      MSG_MORE);
 
-		if (crc && (msg->pages || msg->pagelist))
+		if (crc && (msg->pages || msg->pagelist || msg->bio))
 			kunmap(page);
 
 		if (ret <= 0)
@@ -794,6 +840,8 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 			if (msg->pagelist)
 				list_move_tail(&page->lru,
 					       &msg->pagelist->head);
+			if (msg->bio)
+				iter_bio_next(&msg->bio_iter, &msg->bio_seg);
 		}
 	}
 
@@ -1299,8 +1347,7 @@ static int read_partial_message_section(struct ceph_connection *con,
 					struct kvec *section, unsigned int sec_len,
 					u32 *crc)
 {
-	int left;
-	int ret;
+	int ret, left;
 
 	BUG_ON(!section);
 
@@ -1323,13 +1370,81 @@ static int read_partial_message_section(struct ceph_connection *con,
 static struct ceph_msg *ceph_alloc_msg(struct ceph_connection *con,
 				struct ceph_msg_header *hdr,
 				int *skip);
+
+
+static int read_partial_message_pages(struct ceph_connection *con,
+				      struct page **pages,
+				      unsigned data_len, int datacrc)
+{
+	void *p;
+	int ret;
+	int left;
+
+	left = min((int)(data_len - con->in_msg_pos.data_pos),
+		   (int)(PAGE_SIZE - con->in_msg_pos.page_pos));
+	/* (page) data */
+	BUG_ON(pages == NULL);
+	p = kmap(pages[con->in_msg_pos.page]);
+	ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
+			       left);
+	if (ret > 0 && datacrc)
+		con->in_data_crc =
+			crc32c(con->in_data_crc,
+				  p + con->in_msg_pos.page_pos, ret);
+	kunmap(pages[con->in_msg_pos.page]);
+	if (ret <= 0)
+		return ret;
+	con->in_msg_pos.data_pos += ret;
+	con->in_msg_pos.page_pos += ret;
+	if (con->in_msg_pos.page_pos == PAGE_SIZE) {
+		con->in_msg_pos.page_pos = 0;
+		con->in_msg_pos.page++;
+	}
+
+	return ret;
+}
+
+static int read_partial_message_bio(struct ceph_connection *con,
+				    struct bio **bio_iter, int *bio_seg,
+				    unsigned data_len, int datacrc)
+{
+	struct bio_vec *bv = bio_iovec_idx(*bio_iter, *bio_seg);
+	void *p;
+	int ret, left;
+
+	if (IS_ERR(bv))
+		return PTR_ERR(bv);
+
+	left = min((int)(data_len - con->in_msg_pos.data_pos),
+		   (int)(bv->bv_len - con->in_msg_pos.page_pos));
+
+	p = kmap(bv->bv_page) + bv->bv_offset;
+
+	ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
+			       left);
+	if (ret > 0 && datacrc)
+		con->in_data_crc =
+			crc32c(con->in_data_crc,
+				  p + con->in_msg_pos.page_pos, ret);
+	kunmap(bv->bv_page);
+	if (ret <= 0)
+		return ret;
+	con->in_msg_pos.data_pos += ret;
+	con->in_msg_pos.page_pos += ret;
+	if (con->in_msg_pos.page_pos == bv->bv_len) {
+		con->in_msg_pos.page_pos = 0;
+		iter_bio_next(bio_iter, bio_seg);
+	}
+
+	return ret;
+}
+
 /*
  * read (part of) a message.
  */
 static int read_partial_message(struct ceph_connection *con)
 {
 	struct ceph_msg *m = con->in_msg;
-	void *p;
 	int ret;
 	int to, left;
 	unsigned front_len, middle_len, data_len, data_off;
@@ -1393,7 +1508,10 @@ static int read_partial_message(struct ceph_connection *con)
 			m->middle->vec.iov_len = 0;
 
 		con->in_msg_pos.page = 0;
-		con->in_msg_pos.page_pos = data_off & ~PAGE_MASK;
+		if (m->pages)
+			con->in_msg_pos.page_pos = data_off & ~PAGE_MASK;
+		else
+			con->in_msg_pos.page_pos = 0;
 		con->in_msg_pos.data_pos = 0;
 	}
 
@@ -1410,27 +1528,25 @@ static int read_partial_message(struct ceph_connection *con)
 		if (ret <= 0)
 			return ret;
 	}
+	if (m->bio && !m->bio_iter)
+		init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
 
 	/* (page) data */
 	while (con->in_msg_pos.data_pos < data_len) {
-		left = min((int)(data_len - con->in_msg_pos.data_pos),
-			   (int)(PAGE_SIZE - con->in_msg_pos.page_pos));
-		BUG_ON(m->pages == NULL);
-		p = kmap(m->pages[con->in_msg_pos.page]);
-		ret = ceph_tcp_recvmsg(con->sock, p + con->in_msg_pos.page_pos,
-				       left);
-		if (ret > 0 && datacrc)
-			con->in_data_crc =
-				crc32c(con->in_data_crc,
-					  p + con->in_msg_pos.page_pos, ret);
-		kunmap(m->pages[con->in_msg_pos.page]);
-		if (ret <= 0)
-			return ret;
-		con->in_msg_pos.data_pos += ret;
-		con->in_msg_pos.page_pos += ret;
-		if (con->in_msg_pos.page_pos == PAGE_SIZE) {
-			con->in_msg_pos.page_pos = 0;
-			con->in_msg_pos.page++;
+		if (m->pages) {
+			ret = read_partial_message_pages(con, m->pages,
+						 data_len, datacrc);
+			if (ret <= 0)
+				return ret;
+		} else if (m->bio) {
+
+			ret = read_partial_message_bio(con,
+						 &m->bio_iter, &m->bio_seg,
+						 data_len, datacrc);
+			if (ret <= 0)
+				return ret;
+		} else {
+			BUG_ON(1);
 		}
 	}
 
@@ -2099,6 +2215,9 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags)
 	m->nr_pages = 0;
 	m->pages = NULL;
 	m->pagelist = NULL;
+	m->bio = NULL;
+	m->bio_iter = NULL;
+	m->bio_seg = 0;
 
 	dout("ceph_msg_new %p front %d\n", m, front_len);
 	return m;
diff --git a/fs/ceph/messenger.h b/fs/ceph/messenger.h
index fe24e6f..1f5bb9d 100644
--- a/fs/ceph/messenger.h
+++ b/fs/ceph/messenger.h
@@ -84,6 +84,9 @@ struct ceph_msg {
 	struct ceph_pagelist *pagelist; /* instead of pages */
 	struct list_head list_head;
 	struct kref kref;
+	struct bio  *bio;		/* instead of pages/pagelist */
+	struct bio  *bio_iter;		/* bio iterator */
+	int bio_seg;			/* current bio segment */
 	bool front_is_vmalloc;
 	bool more_to_follow;
 	int front_max;
diff --git a/fs/ceph/osd_client.c b/fs/ceph/osd_client.c
index 278c6fe..e5bb5d5 100644
--- a/fs/ceph/osd_client.c
+++ b/fs/ceph/osd_client.c
@@ -6,6 +6,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/bio.h>
 
 #include "super.h"
 #include "osd_client.h"
@@ -111,6 +112,8 @@ void ceph_osdc_release_request(struct kref *kref)
 	if (req->r_own_pages)
 		ceph_release_page_vector(req->r_pages,
 					 req->r_num_pages);
+	if (req->r_bio)
+		bio_put(req->r_bio);
 	ceph_put_snap_context(req->r_snapc);
 	if (req->r_mempool)
 		mempool_free(req, req->r_osdc->req_mempool);
@@ -124,7 +127,8 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       int do_sync,
 					       bool use_mempool,
 					       gfp_t gfp_flags,
-					       struct page **pages)
+					       struct page **pages,
+					       struct bio *bio)
 {
 	struct ceph_osd_request *req;
 	struct ceph_msg *msg;
@@ -189,6 +193,10 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 
 	req->r_request = msg;
 	req->r_pages = pages;
+	if (bio) {
+		req->r_bio = bio;
+		bio_get(req->r_bio);
+	}
 
 	return req;
 }
@@ -290,7 +298,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 		ceph_osdc_alloc_request(osdc, flags,
 					 snapc, do_sync,
 					 use_mempool,
-					 GFP_NOFS, NULL);
+					 GFP_NOFS, NULL, NULL);
 	if (IS_ERR(req))
 		return req;
 
@@ -1156,6 +1164,7 @@ int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 
 	req->r_request->pages = req->r_pages;
 	req->r_request->nr_pages = req->r_num_pages;
+	req->r_request->bio = req->r_bio;
 
 	register_request(osdc, req);
 
@@ -1474,6 +1483,7 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 		}
 		m->pages = req->r_pages;
 		m->nr_pages = req->r_num_pages;
+		m->bio = req->r_bio;
 	}
 	*skip = 0;
 	req->r_con_filling_msg = ceph_con_get(con);
diff --git a/fs/ceph/osd_client.h b/fs/ceph/osd_client.h
index 0b6b697..76aa63e 100644
--- a/fs/ceph/osd_client.h
+++ b/fs/ceph/osd_client.h
@@ -79,6 +79,7 @@ struct ceph_osd_request {
 	struct page     **r_pages;            /* pages for data payload */
 	int               r_pages_from_pool;
 	int               r_own_pages;        /* if true, i own page list */
+	struct bio       *r_bio;	      /* instead of pages */
 };
 
 struct ceph_osd_client {
@@ -129,7 +130,8 @@ extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *
 					       int do_sync,
 					       bool use_mempool,
 					       gfp_t gfp_flags,
-					       struct page **pages);
+					       struct page **pages,
+					       struct bio *bio);
 
 extern void ceph_osdc_build_request(struct ceph_osd_request *req,
 			    u64 off, u64 *plen,
-- 
1.5.6.5

