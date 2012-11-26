Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab2KZR2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:28:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933932Ab2KZRNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 223/270] Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
Date: Mon, 26 Nov 2012 14:58:33 -0200
Message-Id: <1353949160-26803-224-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b9d2bb2ee537424a7f855e1f93eed44eb9ee0854 upstream.

This reverts commit 55420c24a0d4d1fce70ca713f84aa00b6b74a70e.
Now that we clear the connected flag when entering TCP_CLOSE_WAIT,
the deadlock described in this commit is no longer possible.
Instead, the resulting call to xs_tcp_shutdown() can interfere
with pending reconnection attempts.

Reported-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Chris Perl <chris.perl@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/xprtsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 683f990b..a3f1990 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -737,10 +737,10 @@ static int xs_tcp_send_request(struct rpc_task *task)
 		dprintk("RPC:       sendmsg returned unrecognized error %d\n",
 			-status);
 	case -ECONNRESET:
-	case -EPIPE:
 		xs_tcp_shutdown(xprt);
 	case -ECONNREFUSED:
 	case -ENOTCONN:
+	case -EPIPE:
 		clear_bit(SOCK_ASYNC_NOSPACE, &transport->sock->flags);
 	}
 
-- 
1.7.9.5

