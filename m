Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab2J2WTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:19:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:47191 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761047Ab2J2Vgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Perl <chris.perl@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 017/101] Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
Date: Mon, 29 Oct 2012 14:34:30 -0700
Message-Id: <20121029213242.074763478@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xprtsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -736,10 +736,10 @@ static int xs_tcp_send_request(struct rp
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
 


