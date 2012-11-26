Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2KZRGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47477 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab2KZRF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 099/270] libceph: encapsulate out message data setup
Date: Mon, 26 Nov 2012 14:56:29 -0200
Message-Id: <1353949160-26803-100-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 739c905baa018c99003564ebc367d93aa44d4861 upstream.

Move the code that prepares to write the data portion of a message
into its own function.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 7329c8d..c7efb92 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -565,6 +565,24 @@ static void con_out_kvec_add(struct ceph_connection *con,
 	con->out_kvec_bytes += size;
 }
 
+static void prepare_write_message_data(struct ceph_connection *con)
+{
+	struct ceph_msg *msg = con->out_msg;
+
+	BUG_ON(!msg);
+	BUG_ON(!msg->hdr.data_len);
+
+	/* initialize page iterator */
+	con->out_msg_pos.page = 0;
+	if (msg->pages)
+		con->out_msg_pos.page_pos = msg->page_alignment;
+	else
+		con->out_msg_pos.page_pos = 0;
+	con->out_msg_pos.data_pos = 0;
+	con->out_msg_pos.did_page_crc = false;
+	con->out_more = 1;  /* data + footer will follow */
+}
+
 /*
  * Prepare footer for currently outgoing message, and finish things
  * off.  Assumes out_kvec* are already valid.. we just add on to the end.
@@ -657,26 +675,17 @@ static void prepare_write_message(struct ceph_connection *con)
 		con->out_msg->footer.middle_crc = cpu_to_le32(crc);
 	} else
 		con->out_msg->footer.middle_crc = 0;
-	con->out_msg->footer.data_crc = 0;
-	dout("prepare_write_message front_crc %u data_crc %u\n",
+	dout("%s front_crc %u middle_crc %u\n", __func__,
 	     le32_to_cpu(con->out_msg->footer.front_crc),
 	     le32_to_cpu(con->out_msg->footer.middle_crc));
 
 	/* is there a data payload? */
-	if (le32_to_cpu(m->hdr.data_len) > 0) {
-		/* initialize page iterator */
-		con->out_msg_pos.page = 0;
-		if (m->pages)
-			con->out_msg_pos.page_pos = m->page_alignment;
-		else
-			con->out_msg_pos.page_pos = 0;
-		con->out_msg_pos.data_pos = 0;
-		con->out_msg_pos.did_page_crc = false;
-		con->out_more = 1;  /* data + footer will follow */
-	} else {
+	con->out_msg->footer.data_crc = 0;
+	if (m->hdr.data_len)
+		prepare_write_message_data(con);
+	else
 		/* no, queue up footer too and be done */
 		prepare_write_message_footer(con);
-	}
 
 	set_bit(WRITE_PENDING, &con->flags);
 }
-- 
1.7.9.5

