Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab2KZRFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2KZRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 095/270] libceph: transition socket state prior to actual connect
Date: Mon, 26 Nov 2012 14:56:25 -0200
Message-Id: <1353949160-26803-96-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 89a86be0ce20022f6ede8bccec078dbb3d63caaa upstream.

Once we call ->connect(), we are racing against the actual
connection, and a subsequent transition from CONNECTING ->
CONNECTED.  Set the state to CONNECTING before that, under the
protection of the mutex, to avoid the race.

This was introduced in 928443cd9644e7cfd46f687dbeffda2d1a357ff9,
with the original socket state code.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index ff12d32..c52d587 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -321,6 +321,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 
 	dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
 
+	con_sock_state_connecting(con);
 	ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
@@ -336,8 +337,6 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 		return ret;
 	}
 	con->sock = sock;
-	con_sock_state_connecting(con);
-
 	return 0;
 }
 
-- 
1.7.9.5

