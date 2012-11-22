Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2KVWqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:46:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:49013 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2KVSdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 146/171] libceph: fix fault locking; close socket on lossy fault
Date: Wed, 21 Nov 2012 16:41:32 -0800
Message-Id: <20121122004047.999308758@linuxfoundation.org>
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

(cherry picked from commit 3b5ede07b55b52c3be27749d183d87257d032065)

If we fault on a lossy connection, we should still close the socket
immediately, and do so under the con mutex.

We should also take the con mutex before printing out the state bits in
the debug output.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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
@@ -2392,7 +2393,6 @@ static void ceph_fault(struct ceph_conne
 
 out_unlock:
 	mutex_unlock(&con->mutex);
-out:
 	/*
 	 * in case we faulted due to authentication, invalidate our
 	 * current tickets so that we can get new ones.


