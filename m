Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab2KZRHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:07:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab2KZRHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:07:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 118/270] libceph: allow sock transition from CONNECTING to CLOSED
Date: Mon, 26 Nov 2012 14:56:48 -0200
Message-Id: <1353949160-26803-119-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit fbb85a478f6d4cce6942f1c25c6a68ec5b1e7e7f upstream.

It is possible to close a socket that is in the OPENING state.  For
example, it can happen if ceph_con_close() is called on the con before
the TCP connection is established.  con_work() will come around and shut
down the socket.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 5adf786..16814d1 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -48,17 +48,17 @@
  *       |        ----------------------
  *       |                              \
  *       + con_sock_state_closed()       \
- *       |\                               \
- *       | \                               \
- *       |  -----------                     \
- *       |  | CLOSING |  socket event;       \
- *       |  -----------  await close          \
- *       |       ^                            |
- *       |       |                            |
- *       |       + con_sock_state_closing()   |
- *       |      / \                           |
- *       |     /   ---------------            |
- *       |    /                   \           v
+ *       |+---------------------------    \
+ *       | \                          \    \
+ *       |  -----------                \    \
+ *       |  | CLOSING |  socket event;  \    \
+ *       |  -----------  await close     \    \
+ *       |       ^                        \   |
+ *       |       |                         \  |
+ *       |       + con_sock_state_closing() \ |
+ *       |      / \                         | |
+ *       |     /   ---------------          | |
+ *       |    /                   \         v v
  *       |   /                    --------------
  *       |  /    -----------------| CONNECTING |  socket created, TCP
  *       |  |   /                 --------------  connect initiated
@@ -241,7 +241,8 @@ static void con_sock_state_closed(struct ceph_connection *con)
 
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CLOSED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CONNECTED &&
-			old_state != CON_SOCK_STATE_CLOSING))
+		    old_state != CON_SOCK_STATE_CLOSING &&
+		    old_state != CON_SOCK_STATE_CONNECTING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
 }
 
-- 
1.7.9.5

