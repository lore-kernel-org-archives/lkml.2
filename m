Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab2KZRGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab2KZRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:16 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 103/270] libceph: move init of bio_iter
Date: Mon, 26 Nov 2012 14:56:33 -0200
Message-Id: <1353949160-26803-104-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 572c588edadaa3da3992bd8a0fed830bbcc861f8 upstream.

If a message has a non-null bio pointer, its bio_iter field is
initialized in write_partial_msg_pages() if this has not been done
already.  This is really a one-time setup operation for sending a
message's (bio) data, so move that initialization code into
prepare_write_message_data() which serves that purpose.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5e8dbc0d..b83c963 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -603,6 +603,10 @@ static void prepare_write_message_data(struct ceph_connection *con)
 		con->out_msg_pos.page_pos = msg->page_alignment;
 	else
 		con->out_msg_pos.page_pos = 0;
+#ifdef CONFIG_BLOCK
+	if (msg->bio && !msg->bio_iter)
+		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bio_seg);
+#endif
 	con->out_msg_pos.data_pos = 0;
 	con->out_msg_pos.did_page_crc = false;
 	con->out_more = 1;  /* data + footer will follow */
@@ -942,11 +946,6 @@ static int write_partial_msg_pages(struct ceph_connection *con)
 	     con, msg, con->out_msg_pos.page, msg->nr_pages,
 	     con->out_msg_pos.page_pos);
 
-#ifdef CONFIG_BLOCK
-	if (msg->bio && !msg->bio_iter)
-		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bio_seg);
-#endif
-
 	while (data_len > con->out_msg_pos.data_pos) {
 		struct page *page = NULL;
 		int max_write = PAGE_SIZE;
-- 
1.7.9.5

