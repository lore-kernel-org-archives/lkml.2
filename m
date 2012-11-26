Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab2KZR7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:59:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47498 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932873Ab2KZRGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:19 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 104/270] libceph: don't use bio_iter as a flag
Date: Mon, 26 Nov 2012 14:56:34 -0200
Message-Id: <1353949160-26803-105-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit abdaa6a849af1d63153682c11f5bbb22dacb1f6b upstream.

Recently a bug was fixed in which the bio_iter field in a ceph
message was not being properly re-initialized when a message got
re-transmitted:
    commit 43643528cce60ca184fe8197efa8e8da7c89a037
    Author: Yan, Zheng <zheng.z.yan@intel.com>
    rbd: Clear ceph_msg->bio_iter for retransmitted message

We are now only initializing the bio_iter field when we are about to
start to write message data (in prepare_write_message_data()),
rather than every time we are attempting to write any portion of the
message data (in write_partial_msg_pages()).  This means we no
longer need to use the msg->bio_iter field as a flag.

So just don't do that any more.  Trust prepare_write_message_data()
to ensure msg->bio_iter is properly initialized, every time we are
about to begin writing (or re-writing) a message's bio data.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b83c963..d47305a 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -604,7 +604,7 @@ static void prepare_write_message_data(struct ceph_connection *con)
 	else
 		con->out_msg_pos.page_pos = 0;
 #ifdef CONFIG_BLOCK
-	if (msg->bio && !msg->bio_iter)
+	if (msg->bio)
 		init_bio_iter(msg->bio, &msg->bio_iter, &msg->bio_seg);
 #endif
 	con->out_msg_pos.data_pos = 0;
@@ -672,10 +672,6 @@ static void prepare_write_message(struct ceph_connection *con)
 		m->hdr.seq = cpu_to_le64(++con->out_seq);
 		m->needs_out_seq = false;
 	}
-#ifdef CONFIG_BLOCK
-	else
-		m->bio_iter = NULL;
-#endif
 
 	dout("prepare_write_message %p seq %lld type %d len %d+%d+%d %d pgs\n",
 	     m, con->out_seq, le16_to_cpu(m->hdr.type),
-- 
1.7.9.5

