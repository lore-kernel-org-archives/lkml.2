Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab2KVVui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:50:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:49609 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab2KVSkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>
Subject: [ 137/171] libceph: allow sock transition from CONNECTING to CLOSED
Date: Wed, 21 Nov 2012 16:41:23 -0800
Message-Id: <20121122004047.106723746@linuxfoundation.org>
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

(cherry picked from commit fbb85a478f6d4cce6942f1c25c6a68ec5b1e7e7f)

It is possible to close a socket that is in the OPENING state.  For
example, it can happen if ceph_con_close() is called on the con before
the TCP connection is established.  con_work() will come around and shut
down the socket.

Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

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
@@ -241,7 +241,8 @@ static void con_sock_state_closed(struct
 
 	old_state = atomic_xchg(&con->sock_state, CON_SOCK_STATE_CLOSED);
 	if (WARN_ON(old_state != CON_SOCK_STATE_CONNECTED &&
-			old_state != CON_SOCK_STATE_CLOSING))
+		    old_state != CON_SOCK_STATE_CLOSING &&
+		    old_state != CON_SOCK_STATE_CONNECTING))
 		printk("%s: unexpected old state %d\n", __func__, old_state);
 }
 


