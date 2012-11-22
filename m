Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab2KVVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:19:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab2KVSkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 114/171] libceph: transition socket state prior to actual connect
Date: Wed, 21 Nov 2012 16:41:00 -0800
Message-Id: <20121122004044.798512330@linuxfoundation.org>
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

(cherry picked from commit 89a86be0ce20022f6ede8bccec078dbb3d63caaa)

Once we call ->connect(), we are racing against the actual
connection, and a subsequent transition from CONNECTING ->
CONNECTED.  Set the state to CONNECTING before that, under the
protection of the mutex, to avoid the race.

This was introduced in 928443cd9644e7cfd46f687dbeffda2d1a357ff9,
with the original socket state code.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -321,6 +321,7 @@ static int ceph_tcp_connect(struct ceph_
 
 	dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
 
+	con_sock_state_connecting(con);
 	ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
@@ -336,8 +337,6 @@ static int ceph_tcp_connect(struct ceph_
 		return ret;
 	}
 	con->sock = sock;
-	con_sock_state_connecting(con);
-
 	return 0;
 }
 


