Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2J1Xlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:41:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42007 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745Ab2J1X1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:45 -0400
Message-Id: <20121028231558.875385626@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Chris Perl <chris.perl@gmail.com>
Subject: [ 071/105] Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xprtsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 6e6967d..7e2dd0d 100644
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
 


