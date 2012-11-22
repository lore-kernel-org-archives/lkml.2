Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885Ab2KVV33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:29:29 -0500
Received: from mail.kernel.org ([198.145.19.201]:49604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab2KVSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 117/171] libceph: drop ceph_con_get/put helpers and nref member
Date: Wed, 21 Nov 2012 16:41:03 -0800
Message-Id: <20121122004045.096368181@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit d59315ca8c0de00df9b363f94a2641a30961ca1c)

These are no longer used.  Every ceph_connection instance is embedded in
another structure, and refcounts manipulated via the get/put ops.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ceph/messenger.h |    1 -
 net/ceph/messenger.c           |   28 +---------------------------
 2 files changed, 1 insertion(+), 28 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -135,7 +135,6 @@ struct ceph_msg_pos {
  */
 struct ceph_connection {
 	void *private;
-	atomic_t nref;
 
 	const struct ceph_connection_operations *ops;
 
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -501,30 +501,6 @@ bool ceph_con_opened(struct ceph_connect
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
@@ -535,7 +511,6 @@ void ceph_con_init(struct ceph_connectio
 	memset(con, 0, sizeof(*con));
 	con->private = private;
 	con->ops = ops;
-	atomic_set(&con->nref, 1);
 	con->msgr = msgr;
 
 	con_sock_state_init(con);
@@ -1951,8 +1926,7 @@ static int try_write(struct ceph_connect
 {
 	int ret = 1;
 
-	dout("try_write start %p state %lu nref %d\n", con, con->state,
-	     atomic_read(&con->nref));
+	dout("try_write start %p state %lu\n", con, con->state);
 
 more:
 	dout("try_write out_kvec_bytes %d\n", con->out_kvec_bytes);


