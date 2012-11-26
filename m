Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2KZRyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:54:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2KZRHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 124/270] libceph: (re)initialize bio_iter on start of message receive
Date: Mon, 26 Nov 2012 14:56:54 -0200
Message-Id: <1353949160-26803-125-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit a4107026976f06c9a6ce8cc84a763564ee39d901 upstream.

Previously, we were opportunistically initializing the bio_iter if it
appeared to be uninitialized in the middle of the read path.  The problem
is that a sequence like:

 - start reading message
 - initialize bio_iter
 - read half a message
 - messenger fault, reconnect
 - restart reading message
 - ** bio_iter now non-NULL, not reinitialized **
 - read past end of bio, crash

Instead, initialize the bio_iter unconditionally when we allocate/claim
the message for read.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index e65b15d..f1bd3bb 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1872,6 +1872,11 @@ static int read_partial_message(struct ceph_connection *con)
 		else
 			con->in_msg_pos.page_pos = 0;
 		con->in_msg_pos.data_pos = 0;
+
+#ifdef CONFIG_BLOCK
+		if (m->bio)
+			init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
+#endif
 	}
 
 	/* front */
@@ -1888,10 +1893,6 @@ static int read_partial_message(struct ceph_connection *con)
 		if (ret <= 0)
 			return ret;
 	}
-#ifdef CONFIG_BLOCK
-	if (m->bio && !m->bio_iter)
-		init_bio_iter(m->bio, &m->bio_iter, &m->bio_seg);
-#endif
 
 	/* (page) data */
 	while (con->in_msg_pos.data_pos < data_len) {
@@ -1902,7 +1903,7 @@ static int read_partial_message(struct ceph_connection *con)
 				return ret;
 #ifdef CONFIG_BLOCK
 		} else if (m->bio) {
-
+			BUG_ON(!m->bio_iter);
 			ret = read_partial_message_bio(con,
 						 &m->bio_iter, &m->bio_seg,
 						 data_len, do_datacrc);
-- 
1.7.9.5

