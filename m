Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab2KVWAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:00:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:49611 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715Ab2KVSkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 122/171] libceph: move init of bio_iter
Date: Wed, 21 Nov 2012 16:41:08 -0800
Message-Id: <20121122004045.596085074@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit 572c588edadaa3da3992bd8a0fed830bbcc861f8)

If a message has a non-null bio pointer, its bio_iter field is
initialized in write_partial_msg_pages() if this has not been done
already.  This is really a one-time setup operation for sending a
message's (bio) data, so move that initialization code into
prepare_write_message_data() which serves that purpose.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -603,6 +603,10 @@ static void prepare_write_message_data(s
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
@@ -942,11 +946,6 @@ static int write_partial_msg_pages(struc
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


