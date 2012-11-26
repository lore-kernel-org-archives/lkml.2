Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2KZSHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:07:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47376 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab2KZREY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 075/270] libceph: kill bad_proto ceph connection op
Date: Mon, 26 Nov 2012 14:56:05 -0200
Message-Id: <1353949160-26803-76-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 6384bb8b8e88a9c6bf2ae0d9517c2c0199177c34 upstream.

No code sets a bad_proto method in its ceph connection operations
vector, so just get rid of it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/ceph/messenger.h |    3 ---
 net/ceph/messenger.c           |    5 -----
 2 files changed, 8 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 6a1dc80..ce7a483 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -31,9 +31,6 @@ struct ceph_connection_operations {
 	int (*verify_authorizer_reply) (struct ceph_connection *con, int len);
 	int (*invalidate_authorizer)(struct ceph_connection *con);
 
-	/* protocol version mismatch */
-	void (*bad_proto) (struct ceph_connection *con);
-
 	/* there was some error on the socket (disconnect, whatever) */
 	void (*fault) (struct ceph_connection *con);
 
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index ad2eaad..18f69a8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1360,11 +1360,6 @@ static void fail_protocol(struct ceph_connection *con)
 {
 	reset_connection(con);
 	set_bit(CLOSED, &con->state);  /* in case there's queued work */
-
-	mutex_unlock(&con->mutex);
-	if (con->ops->bad_proto)
-		con->ops->bad_proto(con);
-	mutex_lock(&con->mutex);
 }
 
 static int process_connect(struct ceph_connection *con)
-- 
1.7.9.5

