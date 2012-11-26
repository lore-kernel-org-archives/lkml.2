Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab2KZRwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:52:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47607 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab2KZRHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 129/270] libceph: move ceph_con_send() closed check under the con mutex
Date: Mon, 26 Nov 2012 14:56:59 -0200
Message-Id: <1353949160-26803-130-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit a59b55a602b6c741052d79c1e3643f8440cddd27 upstream.

Take the con mutex before checking whether the connection is closed to
avoid racing with someone else closing it.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 1a3cb4a..20e60a8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2453,22 +2453,20 @@ static void clear_standby(struct ceph_connection *con)
  */
 void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 {
-	if (test_bit(CLOSED, &con->state)) {
-		dout("con_send %p closed, dropping %p\n", con, msg);
-		ceph_msg_put(msg);
-		return;
-	}
-
 	/* set src+dst */
 	msg->hdr.src = con->msgr->inst.name;
-
 	BUG_ON(msg->front.iov_len != le32_to_cpu(msg->hdr.front_len));
-
 	msg->needs_out_seq = true;
 
-	/* queue */
 	mutex_lock(&con->mutex);
 
+	if (test_bit(CLOSED, &con->state)) {
+		dout("con_send %p closed, dropping %p\n", con, msg);
+		ceph_msg_put(msg);
+		mutex_unlock(&con->mutex);
+		return;
+	}
+
 	BUG_ON(msg->con != NULL);
 	msg->con = con->ops->get(con);
 	BUG_ON(msg->con == NULL);
-- 
1.7.9.5

