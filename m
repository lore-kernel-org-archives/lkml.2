Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab2KVWgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:36:25 -0500
Received: from mail.kernel.org ([198.145.19.201]:49005 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab2KVSds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 124/171] libceph: SOCK_CLOSED is a flag, not a state
Date: Wed, 21 Nov 2012 16:41:10 -0800
Message-Id: <20121122004045.794702722@linuxfoundation.org>
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

(cherry picked from commit a8d00e3cdef4c1c4f194414b72b24cd995439a05)

The following commit changed it so SOCK_CLOSED bit was stored in
a connection's new "flags" field rather than its "state" field.

    libceph: start separating connection flags from state
    commit 928443cd

That bit is used in con_close_socket() to protect against setting an
error message more than once in the socket event handler function.

Unfortunately, the field being operated on in that function was not
updated to be "flags" as it should have been.  This fixes that
error.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/messenger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -397,11 +397,11 @@ static int con_close_socket(struct ceph_
 	dout("con_close_socket on %p sock %p\n", con, con->sock);
 	if (!con->sock)
 		return 0;
-	set_bit(SOCK_CLOSED, &con->state);
+	set_bit(SOCK_CLOSED, &con->flags);
 	rc = con->sock->ops->shutdown(con->sock, SHUT_RDWR);
 	sock_release(con->sock);
 	con->sock = NULL;
-	clear_bit(SOCK_CLOSED, &con->state);
+	clear_bit(SOCK_CLOSED, &con->flags);
 	con_sock_state_closed(con);
 	return rc;
 }


