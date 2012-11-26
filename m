Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158Ab2KZRHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47598 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933134Ab2KZRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:46 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 127/270] libceph: fix fault locking; close socket on lossy fault
Date: Mon, 26 Nov 2012 14:56:57 -0200
Message-Id: <1353949160-26803-128-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 3b5ede07b55b52c3be27749d183d87257d032065 upstream.

If we fault on a lossy connection, we should still close the socket
immediately, and do so under the con mutex.

We should also take the con mutex before printing out the state bits in
the debug output.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 07204f1..9aaf539 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2330,22 +2330,23 @@ fault:
  */
 static void ceph_fault(struct ceph_connection *con)
 {
+	mutex_lock(&con->mutex);
+
 	pr_err("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
 	       ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
 	dout("fault %p state %lu to peer %s\n",
 	     con, con->state, ceph_pr_addr(&con->peer_addr.in_addr));
 
-	if (test_bit(LOSSYTX, &con->flags)) {
-		dout("fault on LOSSYTX channel\n");
-		goto out;
-	}
-
-	mutex_lock(&con->mutex);
 	if (test_bit(CLOSED, &con->state))
 		goto out_unlock;
 
 	con_close_socket(con);
 
+	if (test_bit(LOSSYTX, &con->flags)) {
+		dout("fault on LOSSYTX channel\n");
+		goto out_unlock;
+	}
+
 	if (con->in_msg) {
 		BUG_ON(con->in_msg->con != con);
 		con->in_msg->con = NULL;
@@ -2392,7 +2393,6 @@ static void ceph_fault(struct ceph_connection *con)
 
 out_unlock:
 	mutex_unlock(&con->mutex);
-out:
 	/*
 	 * in case we faulted due to authentication, invalidate our
 	 * current tickets so that we can get new ones.
-- 
1.7.9.5

