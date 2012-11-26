Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2KZRGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab2KZRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:04 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 100/270] libceph: encapsulate advancing msg page
Date: Mon, 26 Nov 2012 14:56:30 -0200
Message-Id: <1353949160-26803-101-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 84ca8fc87fcf4ab97bb8acdb59bf97bb4820cb14 upstream.

In write_partial_msg_pages(), once all the data from a page has been
sent we advance to the next one.  Put the code that takes care of
this into its own function.

While modifying write_partial_msg_pages(), make its local variable
"in_trail" be Boolean, and use the local variable "msg" (which is
just the connection's current out_msg pointer) consistently.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   58 +++++++++++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index c7efb92..434809c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -891,6 +891,33 @@ static void iter_bio_next(struct bio **bio_iter, int *seg)
 }
 #endif
 
+static void out_msg_pos_next(struct ceph_connection *con, struct page *page,
+			size_t len, size_t sent, bool in_trail)
+{
+	struct ceph_msg *msg = con->out_msg;
+
+	BUG_ON(!msg);
+	BUG_ON(!sent);
+
+	con->out_msg_pos.data_pos += sent;
+	con->out_msg_pos.page_pos += sent;
+	if (sent == len) {
+		con->out_msg_pos.page_pos = 0;
+		con->out_msg_pos.page++;
+		con->out_msg_pos.did_page_crc = false;
+		if (in_trail)
+			list_move_tail(&page->lru,
+				       &msg->trail->head);
+		else if (msg->pagelist)
+			list_move_tail(&page->lru,
+				       &msg->pagelist->head);
+#ifdef CONFIG_BLOCK
+		else if (msg->bio)
+			iter_bio_next(&msg->bio_iter, &msg->bio_seg);
+#endif
+	}
+}
+
 /*
  * Write as much message data payload as we can.  If we finish, queue
  * up the footer.
@@ -906,11 +933,11 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 	bool do_datacrc = !con->msgr->nocrc;
 	int ret;
 	int total_max_write;
-	int in_trail = 0;
+	bool in_trail = false;
 	size_t trail_len = (msg->trail ? msg->trail->length : 0);
 
 	dout("write_partial_msg_pages %p msg %p page %d/%d offset %d\n",
-	     con, con->out_msg, con->out_msg_pos.page, con->out_msg->nr_pages,
+	     con, msg, con->out_msg_pos.page, msg->nr_pages,
 	     con->out_msg_pos.page_pos);
 
 #ifdef CONFIG_BLOCK
@@ -934,13 +961,12 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 
 		/* have we reached the trail part of the data? */
 		if (con->out_msg_pos.data_pos >= data_len - trail_len) {
-			in_trail = 1;
+			in_trail = true;
 
 			total_max_write = data_len - con->out_msg_pos.data_pos;
 
 			page = list_first_entry(&msg->trail->head,
 						struct page, lru);
-			max_write = PAGE_SIZE;
 		} else if (msg->pages) {
 			page = msg->pages[con->out_msg_pos.page];
 		} else if (msg->pagelist) {
@@ -964,14 +990,14 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 		if (do_datacrc && !con->out_msg_pos.did_page_crc) {
 			void *base;
 			u32 crc;
-			u32 tmpcrc = le32_to_cpu(con->out_msg->footer.data_crc);
+			u32 tmpcrc = le32_to_cpu(msg->footer.data_crc);
 			char *kaddr;
 
 			kaddr = kmap(page);
 			BUG_ON(kaddr == NULL);
 			base = kaddr + con->out_msg_pos.page_pos + bio_offset;
 			crc = crc32c(tmpcrc, base, len);
-			con->out_msg->footer.data_crc = cpu_to_le32(crc);
+			msg->footer.data_crc = cpu_to_le32(crc);
 			con->out_msg_pos.did_page_crc = true;
 		}
 		ret = ceph_tcp_sendpage(con->sock, page,
@@ -984,30 +1010,14 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 		if (ret <= 0)
 			goto out;
 
-		con->out_msg_pos.data_pos += ret;
-		con->out_msg_pos.page_pos += ret;
-		if (ret == len) {
-			con->out_msg_pos.page_pos = 0;
-			con->out_msg_pos.page++;
-			con->out_msg_pos.did_page_crc = false;
-			if (in_trail)
-				list_move_tail(&page->lru,
-					       &msg->trail->head);
-			else if (msg->pagelist)
-				list_move_tail(&page->lru,
-					       &msg->pagelist->head);
-#ifdef CONFIG_BLOCK
-			else if (msg->bio)
-				iter_bio_next(&msg->bio_iter, &msg->bio_seg);
-#endif
-		}
+		out_msg_pos_next(con, page, len, (size_t) ret, in_trail);
 	}
 
 	dout("write_partial_msg_pages %p msg %p done\n", con, msg);
 
 	/* prepare and queue up footer, too */
 	if (!do_datacrc)
-		con->out_msg->footer.flags |= CEPH_MSG_FOOTER_NOCRC;
+		msg->footer.flags |= CEPH_MSG_FOOTER_NOCRC;
 	con_out_kvec_reset(con);
 	prepare_write_message_footer(con);
 	ret = 1;
-- 
1.7.9.5

