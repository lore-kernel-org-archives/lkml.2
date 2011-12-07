Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab1LGQqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:46:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933303Ab1LGQVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:21:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:17 2011
Message-Id: <20111207161217.159939453@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:11:31 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [029/104] SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 24ca9a847791fd53d9b217330b15f3c285827a18 upstream.

By returning '0' instead of 'EAGAIN' when the tests in xs_nospace() fail
to find evidence of socket congestion, we are making the RPC engine believe
that the message was incorrectly sent and so it disconnects the socket
instead of just retrying.

The bug appears to have been introduced by commit
5e3771ce2d6a69e10fcc870cdf226d121d868491 (SUNRPC: Ensure that xs_nospace
return values are propagated).

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/xprtsock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -496,7 +496,7 @@ static int xs_nospace(struct rpc_task *t
 	struct rpc_rqst *req = task->tk_rqstp;
 	struct rpc_xprt *xprt = req->rq_xprt;
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
-	int ret = 0;
+	int ret = -EAGAIN;
 
 	dprintk("RPC: %5u xmit incomplete (%u left of %u)\n",
 			task->tk_pid, req->rq_slen - req->rq_bytes_sent,
@@ -508,7 +508,6 @@ static int xs_nospace(struct rpc_task *t
 	/* Don't race with disconnect */
 	if (xprt_connected(xprt)) {
 		if (test_bit(SOCK_ASYNC_NOSPACE, &transport->sock->flags)) {
-			ret = -EAGAIN;
 			/*
 			 * Notify TCP that we're limited by the application
 			 * window size


