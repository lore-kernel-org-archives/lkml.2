Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab2KVVPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:15:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:49632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab2KVSkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 127/171] libceph: dont touch con state in con_close_socket()
Date: Wed, 21 Nov 2012 16:41:13 -0800
Message-Id: <20121122004046.091952405@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

(cherry picked from commit 456ea46865787283088b23a8a7f69244513b95f0)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -392,10 +392,16 @@ static int con_close_socket(struct ceph_
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


