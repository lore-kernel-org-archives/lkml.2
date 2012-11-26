Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab2KZRGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab2KZRGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 108/270] libceph: don't touch con state in con_close_socket()
Date: Mon, 26 Nov 2012 14:56:38 -0200
Message-Id: <1353949160-26803-109-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 456ea46865787283088b23a8a7f69244513b95f0 upstream.

In con_close_socket(), a connection's SOCK_CLOSED flag gets set and
then cleared while its shutdown method is called and its reference
gets dropped.

Previously, that flag got set only if it had not already been set,
so setting it in con_close_socket() might have prevented additional
processing being done on a socket being shut down.  We no longer set
SOCK_CLOSED in the socket event routine conditionally, so setting
that bit here no longer provides whatever benefit it might have
provided before.

A race condition could still leave the SOCK_CLOSED bit set even
after we've issued the call to con_close_socket(), so we still clear
that bit after shutting the socket down.  Add a comment explaining
the reason for this.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index cd1aaa8..dfff350 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -392,10 +392,16 @@ static int con_close_socket(struct ceph_connection *con)
 	dout("con_close_socket on %p sock %p\n", con, con->sock);
 	if (!con->sock)
 		return 0;
-	set_bit(SOCK_CLOSED, &con->flags);
 	rc = con->sock->ops->shutdown(con->sock, SHUT_RDWR);
 	sock_release(con->sock);
 	con->sock = NULL;
+
+	/*
+	 * Forcibly clear the SOCK_CLOSE flag.  It gets set
+	 * independent of the connection mutex, and we could have
+	 * received a socket close event before we had the chance to
+	 * shut the socket down.
+	 */
 	clear_bit(SOCK_CLOSED, &con->flags);
 	con_sock_state_closed(con);
 	return rc;
-- 
1.7.9.5

