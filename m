Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2KZRGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:06:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab2KZRGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:06:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 105/270] libceph: SOCK_CLOSED is a flag, not a state
Date: Mon, 26 Nov 2012 14:56:35 -0200
Message-Id: <1353949160-26803-106-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit a8d00e3cdef4c1c4f194414b72b24cd995439a05 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/messenger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d47305a..d0aca62 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -397,11 +397,11 @@ static int con_close_socket(struct ceph_connection *con)
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
-- 
1.7.9.5

