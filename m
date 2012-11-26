Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab2KZRH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47602 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab2KZRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 128/270] libceph: move msgr clear_standby under con mutex protection
Date: Mon, 26 Nov 2012 14:56:58 -0200
Message-Id: <1353949160-26803-129-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 00650931e52e97fe64096bec167f5a6780dfd94a upstream.

Avoid dropping and retaking con->mutex in the ceph_con_send() case by
leaving locking up to the caller.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 9aaf539..1a3cb4a 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2441,12 +2441,10 @@ static void clear_standby(struct ceph_connection *con)
 {
 	/* come back from STANDBY? */
 	if (test_and_clear_bit(STANDBY, &con->state)) {
-		mutex_lock(&con->mutex);
 		dout("clear_standby %p and ++connect_seq\n", con);
 		con->connect_seq++;
 		WARN_ON(test_bit(WRITE_PENDING, &con->flags));
 		WARN_ON(test_bit(KEEPALIVE_PENDING, &con->flags));
-		mutex_unlock(&con->mutex);
 	}
 }
 
@@ -2483,11 +2481,12 @@ void ceph_con_send(struct ceph_connection *con, struct ceph_msg *msg)
 	     le32_to_cpu(msg->hdr.front_len),
 	     le32_to_cpu(msg->hdr.middle_len),
 	     le32_to_cpu(msg->hdr.data_len));
+
+	clear_standby(con);
 	mutex_unlock(&con->mutex);
 
 	/* if there wasn't anything waiting to send before, queue
 	 * new work */
-	clear_standby(con);
 	if (test_and_set_bit(WRITE_PENDING, &con->flags) == 0)
 		queue_con(con);
 }
@@ -2574,7 +2573,9 @@ void ceph_msg_revoke_incoming(struct ceph_msg *msg)
 void ceph_con_keepalive(struct ceph_connection *con)
 {
 	dout("con_keepalive %p\n", con);
+	mutex_lock(&con->mutex);
 	clear_standby(con);
+	mutex_unlock(&con->mutex);
 	if (test_and_set_bit(KEEPALIVE_PENDING, &con->flags) == 0 &&
 	    test_and_set_bit(WRITE_PENDING, &con->flags) == 0)
 		queue_con(con);
-- 
1.7.9.5

