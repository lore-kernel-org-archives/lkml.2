Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab2KZRGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47473 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2KZRF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:56 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 098/270] libceph: drop ceph_con_get/put helpers and nref member
Date: Mon, 26 Nov 2012 14:56:28 -0200
Message-Id: <1353949160-26803-99-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit d59315ca8c0de00df9b363f94a2641a30961ca1c upstream.

These are no longer used.  Every ceph_connection instance is embedded in
another structure, and refcounts manipulated via the get/put ops.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    1 -
 net/ceph/messenger.c           |   28 +---------------------------
 2 files changed, 1 insertion(+), 28 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 9c1f755..f624b75 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -135,7 +135,6 @@ struct ceph_msg_pos {
  */
 struct ceph_connection {
 	void *private;
-	atomic_t nref;
 
 	const struct ceph_connection_operations *ops;
 
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index ddb710c..7329c8d 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -501,30 +501,6 @@ bool ceph_con_opened(struct ceph_connection *con)
 }
 
 /*
- * generic get/put
- */
-struct ceph_connection *ceph_con_get(struct ceph_connection *con)
-{
-	int nref = __atomic_add_unless(&con->nref, 1, 0);
-
-	dout("con_get %p nref = %d -> %d\n", con, nref, nref + 1);
-
-	return nref ? con : NULL;
-}
-
-void ceph_con_put(struct ceph_connection *con)
-{
-	int nref = atomic_dec_return(&con->nref);
-
-	BUG_ON(nref < 0);
-	if (nref == 0) {
-		BUG_ON(con->sock);
-		kfree(con);
-	}
-	dout("con_put %p nref = %d -> %d\n", con, nref + 1, nref);
-}
-
-/*
  * initialize a new connection.
  */
 void ceph_con_init(struct ceph_connection *con, void *private,
@@ -535,7 +511,6 @@ void ceph_con_init(struct ceph_connection *con, void *private,
 	memset(con, 0, sizeof(*con));
 	con->private = private;
 	con->ops = ops;
-	atomic_set(&con->nref, 1);
 	con->msgr = msgr;
 
 	con_sock_state_init(con);
@@ -1951,8 +1926,7 @@ static int try_write(struct ceph_connection *con)
 {
 	int ret = 1;
 
-	dout("try_write start %p state %lu nref %d\n", con, con->state,
-	     atomic_read(&con->nref));
+	dout("try_write start %p state %lu\n", con, con->state);
 
 more:
 	dout("try_write out_kvec_bytes %d\n", con->out_kvec_bytes);
-- 
1.7.9.5

